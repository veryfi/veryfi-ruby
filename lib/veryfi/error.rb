# frozen_string_literal: true

module Veryfi
  class Error
    def self.from_response(status, response)
      if response.empty?
        VeryfiError.new(format("%<code>d", code: status))
      else
        get_error(status, response)
      end
    end

    def self.get_error(status, response)
      details = []
      details = response["details"] if response.key?("details")
      case status
      when 400 then BadRequest.new(details)
      when 401 then UnauthorizedAccessToken.new(details)
      when 404 then ResourceNotFound.new(details)
      when 405 then UnexpectedHTTPMethod.new(details)
      when 409 then AccessLimitReached.new(details)
      when 500 then InternalError.new(details)
      else VeryfiError.new(format("%<code>d, %<message>s", code: status, message: response["error"]), details)
      end
    end

    class VeryfiError < StandardError
      attr_reader :details, :message

      def initialize(message = "An error occurred", details = [])
        @message = message
        @details = if details.empty?
          ""
        else
          "\n#{details.map { |val| val['msg']}.join("\n")}"
        end
        super(message)
      end

      def to_s
        "#{@message}#{@details}"
      end
    end

    class BadRequest < VeryfiError
      def initialize(details = [])
        super("400, Bad Request", details)
      end
    end

    class UnauthorizedAccessToken < VeryfiError
      def initialize(details = [])
        super("401, Unauthorized Access Token", details)
      end
    end

    class ResourceNotFound < VeryfiError
      def initialize(details = [])
        super("404, Resource not found", details)
      end
    end

    class UnexpectedHTTPMethod < VeryfiError
      def initialize(details = [])
        super("405, Unexpected HTTP Method", details)
      end
    end

    class AccessLimitReached < VeryfiError
      def initialize(details = [])
        super("409, Access Limit Reached", details)
      end
    end

    class InternalError < VeryfiError
      def initialize(details = [])
        super("500, Internal Server Error", details)
      end
    end
  end
end
