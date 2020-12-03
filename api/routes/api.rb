# frozen_string_literal: true

require './api/utils/jsend'
require 'grape'
require 'logger'
require_relative 'v1/routes'

module TrackingsService
  class API < Grape::API
    prefix :api
    format :json
    content_type :json, 'application/json'

    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = 'POST'
    end

    # V1
    mount Routes::V1::API
  end
end
