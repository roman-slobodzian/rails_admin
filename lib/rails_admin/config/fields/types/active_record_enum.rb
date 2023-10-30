# frozen_string_literal: true

require 'rails_admin/config/fields/types/enum'

module RailsAdmin
  module Config
    module Fields
      module Types
        class ActiveRecordEnum < Enum
          RailsAdmin::Config::Fields::Types.register(self)

          def type
            :enum
          end

          register_instance_option :enum do
            abstract_model.model.defined_enums[name.to_s].to_h do |key|
              [translate_enum(name, key), key]
            end
          end

          register_instance_option :pretty_value do
            value = bindings[:object].send(name)
            next translate_enum(name, value) if value.present?

            ' - '
          end

          register_instance_option :multiple? do
            false
          end

          register_instance_option :queryable do
            false
          end

          def parse_value(value)
            return unless value.present?

            abstract_model.model.attribute_types[name.to_s].serialize(value)
          end

          def form_value
            enum[super] || super
          end

          def translate_enum(name, key)
            I18n.t("admin.models.#{abstract_model.to_param}.enums.#{name}.#{key}", default: key)
          end
        end
      end
    end
  end
end
