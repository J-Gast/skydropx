# frozen_string_literal: true

require './api/tasks/service_config'
require './api/utils/jsend'
require 'grape'
require 'logger'
require_relative 'v1/routes'

require 'grape-swagger'
require 'grape-swagger/entity'
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

    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              info: {
                                title: 'Tracking packages API',
                                description: 'API to Suscribe tracking numbers and look for updates'
                              },
                              doc_version: '0.1.${TIMESTAMP}',
                              host: '${API_HOST}'
  end
end
