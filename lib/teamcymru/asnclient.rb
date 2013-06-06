require 'ipaddr'
require 'cache' # gem's name is ruby-cache
require 'structformatter'

module TeamCymru
	class ASNRecord < Struct.new(:asn, :ip, :cidr, :cc, :nic, :alloc, :data, :org)
		def to_s
			"#{self.asn.ljust(8)}| #{self.ip.ljust(17)}| #{self.cidr.ljust(20)}| #{self.cc.ljust(3)}| #{self.nic.ljust(9)}| #{self.alloc.ljust(11)}| #{self.data} | #{self.org}"
		end
		def ASNRecord::from_s(str)
			args = str.chomp.split(/\|/).map{|x| x.strip}
			if args.length == 7
				args.insert(6,'')
			elsif args.length == 5 # used for AS lookups
				args.insert(2,'')
				args.insert(2,'')
				args.insert(6,'')
			end
			ASNRecord.new(*args)
		end
		def cached=(cached)
			@cached = cached
		end
		def from_cache?
			@cached || false
		end
	end

	class ASNClient
		def initialize(server='whois.cymru.com', port=43)
			@server = server
			@port = port
			@cache = Cache.new(nil,nil,10000,24*60*60)
		end

		def lookup(iplines)
			t = TCPSocket.new(@server,@port)
			t.puts("begin")
			t.puts("verbose")
			t.readline
			oneshot = false
			if iplines.class == String
				iplines = [iplines]
				oneshot = true
			end
			recs = []
			iplines.each do |ipdata|
				ip,data = ipdata.split(/ /,2)
				rec = nil
				@cache.each_key do |cidr|
					if cidr.include?(ip)
						rec = @cache[cidr]
						rec.ip = ip
						rec.data = data
						rec.cached = true
						break
					end
				end
				unless rec
					t.puts(ipdata)
					t.flush
					l = t.readline
					rec = ASNRecord.from_s(l)
					cidr = IPAddr.new(rec.cidr) if rec.cidr != ''
					if cidr
						@cache[cidr] = rec
					end
				end
				recs << rec
			end
			t.puts("end")
			t.close
			return recs[0] if oneshot
			recs
		end
	end
end