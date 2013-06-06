require 'twitter'

module TeamCymru
	class TwitterFeed
		attr_reader :messages
		def initialize(config)
			@twitname = "teamcymru"
			@messages = []
			@client = Twitter::Client.new(config)
			@client.user_timeline(@twitname).each do |m|
				@messages << [m.created_at,m.text]
			end
		end
		
		def refresh
			@messages = []
			@client.user_timeline(@twitname).each do |m|
				@messages << [m.created_at,m.text]
			end
			@messages
		end
	end
end
