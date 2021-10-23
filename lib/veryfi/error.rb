# frozen_string_literal: true

module Veryfi
  class Error < StandardError
    def self.from_response(response)
      case response.status
      when 400 then BadRequest
      when 401 then UnauthorizedAccessToken
      when 405 then UnexpectedHTTPMethod
      when 409 then AccessLimitReached
      else InternalError
      end
    end
  end

  class BadRequest < Error
    def to_s
      "Bad Request"
    end
  end

  class UnauthorizedAccessToken < Error
    def to_s
      "Unauthorized Access Token"
    end
  end

  class UnexpectedHTTPMethod < Error
    def to_s
      "Unexpected HTTP Method"
    end
  end

  class AccessLimitReached < Error
    def to_s
      "Access Limit Reached"
    end
  end

  class InternalError < Error
    def to_s
      "Internal Server Error"
    end
  end
end
