# frozen_string_literal: true

module Utils
  class << self
    def event_to_hash(event)
      hash_event = {}
      event.instance_variables.each do |var|
        hash_event[var.to_s.delete('@')] = event.instance_variable_get(var)
      end
      hash_event
    end
  end
end
