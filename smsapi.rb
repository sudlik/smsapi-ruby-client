#!/usr/bin/env ruby

require 'net/http'
require 'optparse'

module Smsapi
  class Client
    def initialize(username, passwordHash, test)
      @username = username
      @passwordHash = passwordHash
      @test = test
      @uri = URI('https://api.smsapi.pl/sms.do')
    end

    def sendSms(from, to, content)
      response = Net::HTTP.post_form(
        @uri,
        'username' => @username,
        'password' => @passwordHash,
        'from' => from,
        'to' => to,
        'message' => content,
        'test' => @test ? 1 : 0,
      )

      return response.body
    end
  end
end


if __FILE__ == $0
  options = {:from => nil}
  OptionParser.new do |opts|
    opts.banner = "Usage: smsapi.rb [options]"

    opts.on("-uUSERNAME", "--username=USERNAME", "Username") do |username|
      options[:username] = username
    end

    opts.on("-pPASSWORD_HASH", "--passwordHash=PASSWORD_HASH", "Password hash") do |passwordHash|
      options[:passwordHash] = passwordHash
    end

    opts.on("-fFROM", "--from=FROM", "From") do |from|
      options[:from] = from
    end

    opts.on("-tTO", "--to=TO", "To") do |to|
      options[:to] = to
    end

    opts.on("-mMESSAGE", "--message=MESSAGE", "Message") do |message|
      options[:message] = message
    end

    opts.on("-y", "--test", "Test") do |test|
      options[:test] = test
    end

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end.parse!

  client = Smsapi::Client.new(options[:username], options[:passwordHash], options[:test])

  puts client.sendSms(options[:from], options[:to], options[:message])
end
