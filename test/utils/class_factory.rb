# frozen_string_literal: true

module Utils
  class ClassFactory
    def self.create_class(new_class, *fields)
      c = Class.new do
        fields.each do |field|
          define_method field.intern do
            instance_variable_get("@#{field}")
          end
          define_method "#{field}=".intern do |arg|
            instance_variable_set("@#{field}", arg)
          end
        end
      end

      Kernel.const_set new_class, c
    end
  end
end
