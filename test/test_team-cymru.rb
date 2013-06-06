unless Kernel.respond_to?(:require_relative)
	module Kernel
		def require_relative(path)
			require File.join(File.dirname(caller[0]), path.to_str)
		end
	end
end

require_relative 'helper'
require 'configparser'

class TestTeamCymru < Test::Unit::TestCase
	def test_performs_ASN_queries
		c = TeamCymru::ASNClient.new
		res = c.lookup("130.207.244.251")
		assert_equal("2637    | 130.207.244.251  | 130.207.0.0/16      | US | arin     | 1988-10-10 |  | GEORGIA-TECH - Georgia Institute of Technology",res.to_s)
		assert(! res.from_cache?)
		# this should pull from cache
		res = c.lookup("130.207.244.252")
		assert_equal("2637    | 130.207.244.252  | 130.207.0.0/16      | US | arin     | 1988-10-10 |  | GEORGIA-TECH - Georgia Institute of Technology",res.to_s)
		assert(res.from_cache?)
	end
	
	def test_lookup_bogons
		c = TeamCymru::Bogon.new
		assert(c.bogon?("127.0.5.27"))
		assert(c.bogon?("2001:DB8:FEEB:DEEF::242"))
		assert(! c.bogon?("130.207.244.251"))
		assert(! c.bogon?("2a00:1450:8003::93"))
	end
	
	def test_lookup_malware_hashes
		c = TeamCymru::Malware.new
		hashes = ["7697561ccbbdd1661c25c86762117613","cbed16069043a0bf3c92fff9a99cccdc"]
		res = c.lookup(hashes)
		assert_equal("7697561ccbbdd1661c25c86762117613",res[0].hash)
		assert_equal(0,res[0].percent_detect)
		assert_equal("cbed16069043a0bf3c92fff9a99cccdc",res[1].hash)
		assert(res[1].percent_detect > 50)
	end
	
	def test_display_twitter_feed
		if(File.exists?("#{ENV['HOME']}/.teamcymru"))
			config = ConfigParser.new("#{ENV['HOME']}/.teamcymru")
			config = {
				:consumer_key => config['teamcymru']['consumer_key'],
				:consumer_secret => config['teamcymru']['consumer_secret'],
				:oauth_token => config['teamcymru']['oauth_token'],
				:oauth_token_secret => config['teamcymru']['oauth_token_secret']
			}
			c = TeamCymru::TwitterFeed.new(config)
			msg = c.messages[0]
			assert_equal(2, msg.length)
			assert_equal(Time, msg[0].class)
			assert_equal(String, msg[1].class)
			assert((Time.now - msg[0]) < (30*24*60*60))
		end
	end
end
