# frozen_string_literal: true

require './api/tasks/updater'
require './api/utils/jsend'
require 'grape'
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

    Tasks::Updater.look_for_updates
    # V1
    mount Routes::V1::API
  end
end
