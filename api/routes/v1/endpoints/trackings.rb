# frozen_string_literal: true

require './api/business/trackings'

module Routes
  module V1
    class Tracking < Grape::API
      include Utils
      version 'v1'

      desc 'Resource to handle tracking numbers'
      resource :trackings do
        desc 'Create a tracking'
        params do
          requires :tracking_number,
                   type: String,
                   allow_blank: false,
                   desc: 'Tracking Number'
          requires :carrier,
                   type: String,
                   allow_blank: false,
                   desc: 'Parcel Servicess'
        end
        post do
          JSend.success(tracking_number: Business::Tracking.new.create(params[:tracking_number],
                                                                       params[:carrier]))
        end
      end
    end
  end
end
