# frozen_string_literal: true

require './api/parcels/fedex'
require 'singleton'

module Parcels
  class ParcelsFactory
    include Singleton

    PARCELS = {
      fedex: Parcels::Fedex.new
    }.freeze

    def for(type)
      PARCELS[type.downcase.to_sym]
    end
  end
end
