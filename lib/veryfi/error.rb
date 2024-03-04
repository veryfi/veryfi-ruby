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
      case status
      when 400 then BadRequest
      when 401 then UnauthorizedAccessToken
      when 404 then ResourceNotFound
      when 405 then UnexpectedHTTPMethod
      when 409 then AccessLimitReached
      when 500 then InternalError
      else VeryfiError.new(format("%<code>d, %<message>s", code: status, message: response["error"]))
      end
    end
    class BadRequest < VeryfiError
      def to_s
        "400, Bad Request"
      end
    end

    class UnauthorizedAccessToken < VeryfiError
      def to_s
        "401, Unauthorized Access Token"
      end
    end

    class ResourceNotFound < VeryfiError
      def to_s
        "404, Resource not found"
      end
    end

    class UnexpectedHTTPMethod < VeryfiError
      def to_s
        "405, Unexpected HTTP Method"
      end
    end

    class AccessLimitReached < VeryfiError
      def to_s
        "409, Access Limit Reached"
      end
    end

    class InternalError < VeryfiError
      def to_s
        "500, Internal Server Error"
      end
    end

    class VeryfiError < StandardError
    end
  end
end
