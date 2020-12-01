# frozen_string_literal: true

module Utils
  # JSend specification
  class JSend
    def self.success(data)
      {
        status: 'success',
        data: data
      }
    end

    def self.fail(data)
      {
        status: 'fail',
        data: data
      }
    end

    def self.error(message)
      {
        status: 'error',
        message: message
      }
    end
  end
end
