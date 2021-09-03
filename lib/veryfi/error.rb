# frozen_string_literal: true

module Veryfi
  class Error
    def self.from_response(response)
      case response.status
      when 400 then BadRequest
      when 401 then UnauthorizedAccessToken
      when 405 then UnexpectedHTTPMethod
      when 409 then AccessLimitReached
      else InternalError
      end
    end

    class BadRequest < StandardError
      def to_s
        "Bad Request"
      end
    end

    class UnauthorizedAccessToken < StandardError
      def to_s
        "Unauthorized Access Token"
      end
    end

    class UnexpectedHTTPMethod < StandardError
      def to_s
        "Unexpected HTTP Method"
      end
    end

    class AccessLimitReached < StandardError
      def to_s
        "Access Limit Reached"
      end
    end

    class InternalError < StandardError
      def to_s
        "Internal Server Error"
      end
    end
  end
end
