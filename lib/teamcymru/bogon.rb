# Uses Team Cymru's DNS-based bogon lookup system to determine
# if a given IP is routed or not.
#
# Author::    Chris Lee (rubygems@chrislee.dhs.org)

require 'resolv'
module TeamCymru
	# This class implements the lookup of bogon via DNS
	class Bogon
		@@bogon = 'bogons.cymru.com'
		@@v4fullbogon = 'v4.fullbogons.cymru.com'
		@@v6fullbogon = 'v6.fullbogons.cymru.com'
		
		# tests if the given ip is a bogon
		# fullbogon flag selects which bogon list to use
		# see http://www.team-cymru.org/Services/Bogons/dns.html for more details
		def bogon?(ip,fullbogon=true)
			# detect if this is ipv4 or ipv6 or bad
			begin
				ip = IPAddr.new(ip)
				if ip.ipv6? and fullbogon
					label = ip.to_string.gsub(/:/,'').split(//).reverse.join(".")+"."+@@v6fullbogon
				elsif ip.ipv4? and fullbogon
					label = ip.to_s.split(/\./).reverse.join(".")+"."+@@v4fullbogon
				elsif ip.ipv4? and not fullbogon
					label = ip.to_s.split(/\./).reverse.join(".")+"."+@@bogon
				else
					puts "Unsupported combination: ipv4=#{ip.ipv4?} and fullbogon=#{fullbogon}"
					return false
				end
				addr = Resolv.getaddress(label)
				if addr
					return true
				else
					return false
				end
			rescue ArgumentError => e
				puts e
				return false
			rescue Resolv::ResolvError
				return false
			end
		end
		alias :lookup :bogon?
	end
end
