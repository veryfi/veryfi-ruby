# frozen_string_literal: true

require "json"

module Veryfi
  class Error
    def self.from_response(status, response)
      if response.empty?
        VeryfiError.new(format("%<code>d", code: status))
      else
        VeryfiError.new(format("%<code>d, %<message>s", code: status, message: response["error"]), response)
      end
    end

    class VeryfiError < StandardError
      attr_reader :message

      def initialize(message = "An error occurred", response = {})
        @message = if response.empty?
          message
        else
          JSON.pretty_generate(response)
        end
        super(message)
      end

      def to_s
        message
      end
    end
  end
end
