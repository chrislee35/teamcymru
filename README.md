# Teamcymru

The team-cymru gem connects to several of Team Cymru's public services: bogon lists, IP to ASN mappings, and malware hash checking.

## Installation

Add this line to your application's Gemfile:

    gem 'teamcymru'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teamcymru

## Usage

	require 'teamcymru'
	c = TeamCymru::ASNClient.new
	res = c.lookup("130.207.244.251").to_s => "2637    | 130.207.244.251  | 130.207.0.0/16      | US | arin     | 1988-10-10 |  | GEORGIA-TECH - Georgia Institute of Technology"

	c = TeamCymru::Bogon.new
	c.bogon?("127.0.4.1") => true

	c = TeamCymru::Malware.new
	c.lookup("cbed16069043a0bf3c92fff9a99cccdc") => MalwareResult instance, .hash will be the hash, .timestamp will be the result time, and .percent_detect will be the percent of AV that detects the sample

	c = TeamCymru::TwitterFeed.new
	c.messages.each do |date, tweet|
		puts date
		puts tweet
		puts
	end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
