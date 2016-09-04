require File.expand_path('../../config/environment', __FILE__)
ENV['RAILS_ENV'] ||= 'test'

if ENV["HELL_ENABLED"] || ENV['CODECLIMATE_REPO_TOKEN']
  require 'simplecov'
  if ENV['CODECLIMATE_REPO_TOKEN']
    #require "codeclimate-test-reporter"
    SimpleCov.start CodeClimate::TestReporter.configuration.profile
    #CodeClimate::TestReporter.start
  else
    SimpleCov.start
  end
  SimpleCov.merge_timeout 3600
end

require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  FIXTURE_PATH = 'test/fixtures'.freeze
  fixtures :all

  def user_sign_in(user)
    session[:user_id] = user.id
  end

  def user_sign_out
    session[:user_id] = nil
  end

  def method_missing(m, *args, &block)
    if m =~ /^stub_/
      verb = m.to_s.split('_')
      method = verb[1].to_sym
      json_file = action = verb[2..-1].join('_')
      action = args[0][:as] if !!args[0] && !!args[0][:as]
      times = args[0][:times] if !!args[0] && !!args[0][:times]
      
      if defined?(WebMock) && !ENV['VCR']
        status = if !!args[0] && !!args[0][:status]
          args[0][:status]
        else
          200
        end
        
        options = if !!json = fixture("#{json_file}.json")
          {status: status, body: json}
        else
          {status: 404}
        end
        
        stub = stub_request(method, //).to_return(options)
      end
        
      if !!block
        VCR.use_cassette("#{action}_#{SecureRandom.hex(16)}") do
          yield.tap do |result|
            if !!stub
              assert_requested stub, times: times
              remove_request_stub stub 
            end
            return result
          end
        end
      end
      
      stub
    else
      super
    end
  end
private
  def fixture(fixture)
    if File.exist?(File.join(FIXTURE_PATH + '/files', fixture))
      File.open(File.join(FIXTURE_PATH + '/files', fixture), 'rb')
    end
  end
end
