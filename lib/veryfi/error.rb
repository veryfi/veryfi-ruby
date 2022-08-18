# frozen_string_literal: true

module Veryfi
  class Error
    def self.from_response(response)
      raise VeryfiError, "" if response.empty?

      raise VeryfiError, response["error"]
    end

    class VeryfiError < StandardError
      def initialize(msg = "Veryfi Error")
        super(msg)
      end
    end
  end
end
