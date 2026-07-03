# frozen_string_literal: true

require "spec_helper"

RSpec.describe Veryfi do
  before { described_class.reset! }
  after  { described_class.reset! }

  describe ".configure" do
    it "yields a Configuration the caller can populate" do
      described_class.configure do |c|
        c.client_id     = "ci"
        c.client_secret = "cs"
        c.username      = "u"
        c.api_key       = "k"
      end

      expect(described_class.configuration.client_id).to eq("ci")
      expect(described_class.configuration.username).to eq("u")
    end

    it "returns the Configuration even without a block" do
      expect(described_class.configure).to be_a(Veryfi::Configuration)
    end

    it "exposes sensible defaults" do
      expect(described_class.configuration.base_url).to eq("https://api.veryfi.com/api/")
      expect(described_class.configuration.api_version).to eq("v8")
      expect(described_class.configuration.timeout).to eq(30)
    end
  end

  describe ".client" do
    before do
      described_class.configure do |c|
        c.client_id     = "ci"
        c.client_secret = "cs"
        c.username      = "u"
        c.api_key       = "k"
      end
    end

    it "returns a memoized Veryfi::Client built from the configuration" do
      expect(described_class.client).to be_a(Veryfi::Client)
      expect(described_class.client).to equal(described_class.client)
    end

    it "rebuilds the client when configuration changes" do
      first = described_class.client
      described_class.configure { |c| c.api_version = "v9" }
      second = described_class.client

      expect(second).not_to equal(first)
      expect(second.api_url).to end_with("v9")
    end
  end

  describe ".reset!" do
    it "clears memoized configuration and client" do
      described_class.configure do |c|
        c.client_id     = "ci"
        c.client_secret = "cs"
        c.username      = "u"
        c.api_key       = "k"
      end
      original_config = described_class.configuration

      described_class.reset!

      expect(described_class.configuration).not_to equal(original_config)
      expect(described_class.configuration.client_id).to be_nil
    end
  end
end
