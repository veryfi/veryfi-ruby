# frozen_string_literal: true

require "openssl"
require "base64"

module Veryfi
  class Signature
    attr_reader :secret, :params, :timestamp

    def initialize(secret, params, timestamp)
      @secret = secret
      @params = params
      @timestamp = timestamp
    end

    def to_base64
      Base64.encode64(digest).strip
    end

    # private

    def digest
      OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), secret, payload)
    end

    def payload
      "timestamp:#{timestamp}," + params.to_a.map { |i| "#{i[0]}:#{i[1]}" }.join(",")
    end
  end
end
