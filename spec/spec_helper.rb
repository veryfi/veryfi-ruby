# frozen_string_literal: true

require "bundler/setup"
require "veryfi"

require "pry"
require "rspec/its"
require "simplecov"
require "vcr"
require "webmock/rspec"

unless ENV["CI"]
  SimpleCov.start do
    require "simplecov-badge"

    SimpleCov::Formatter::BadgeFormatter.generate_groups = false
    SimpleCov::Formatter::BadgeFormatter.strength_foreground = false
    SimpleCov::Formatter::BadgeFormatter.timestamp = true

    # call SimpleCov::Formatter::BadgeFormatter after the normal HTMLFormatter
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::BadgeFormatter,
    ]
  end
end

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = false
end

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support", "**", "*.rb"))].sort.each { |f| require f }

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
