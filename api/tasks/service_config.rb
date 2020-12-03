# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'
require 'yaml'

# Configuration container.
class ServiceConfig
  extend Dry::Container::Mixin

  register :configuration, memoize: true do
    ServiceConfig.load_config
  end

  class << self
    def load_config
      YAML.safe_load(File.open('./api/config/config.yml'))
    end
  end
end

ConfigContainer = Dry::AutoInject(ServiceConfig)
