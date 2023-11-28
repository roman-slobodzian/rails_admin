# frozen_string_literal: true

require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Enum < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :filter_operators do
            %w[_discard] +
              enum.map do |label, value|
                {label: label, value: value || label}
              end + (required? ? [] : %w[_separator _present _blank])
          end

          register_instance_option :partial do
            :form_enumeration
          end

          register_instance_option :enum_method do
            @enum_method ||= abstract_model.model.respond_to?("#{name}_enum") || (bindings[:object] || abstract_model.model.new).respond_to?("#{name}_enum") ? "#{name}_enum" : name
          end

          register_instance_option :enum do
            options =
              if abstract_model.model.respond_to?(enum_method)
                abstract_model.model.send(enum_method)
              else
                (bindings[:object] || abstract_model.model.new).send(enum_method)
              end
            next options.to_h { |key| [translate_enum(key), key] } if options.is_a?(Array)

            options
          end

          register_instance_option :pretty_value do
            selected_values = Array.wrap(value).compact_blank

            if enum.is_a?(::Hash)
              selected_values.map do |selected_value|
                enum.select { |_k, v| v.to_s == selected_value.to_s }.keys.first.to_s.presence || selected_value
              end
            elsif enum.is_a?(::Array) && enum.first.is_a?(::Array)
              selected_values.map do |selected_value|
                enum.detect { |e| e[1].to_s == selected_value.to_s }.try(:first).to_s.presence || selected_value
              end
            else
              selected_values
            end.join(', ').presence || ' - '
          end

          register_instance_option :multiple? do
            properties && [:serialized].include?(properties.type)
          end

          def translate_enum(key)
            I18n.t("admin.models.#{abstract_model.to_param}.enums.#{name}.#{key}", default: key)
          end
        end
      end
    end
  end
end
