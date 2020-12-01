# frozen_string_literal: true

require_relative 'endpoints/trackings'

module Routes
  module V1
    class API < Grape::API
      version 'v1'

      mount Tracking
    end
  end
end
