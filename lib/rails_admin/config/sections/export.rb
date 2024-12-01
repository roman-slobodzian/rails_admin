# frozen_string_literal: true

require 'rails_admin/config/sections/base'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Export < RailsAdmin::Config::Sections::Base
        register_instance_option :filename do
          "#{bindings[:controller].params[:model_name]}_#{DateTime.now.strftime('%Y-%m-%d_%Hh%Mm%S')}"
        end
      end
    end
  end
end
