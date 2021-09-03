# frozen_string_literal: true

module Veryfi
  module Api
    class Tag
      attr_reader :request

      def initialize(request)
        @request = request
      end

      def all(params = {})
        response = request.get("/partner/tags/", params)

        response["tags"]
      end

      def delete(id)
        request.delete("/partner/tags/#{id}")
      end
    end
  end
end
