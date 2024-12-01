# frozen_string_literal: true

require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'

module RailsAdmin
  module Config
    module Services
      class Base
        include RailsAdmin::Config::Proxyable
        include RailsAdmin::Config::Configurable

        def execute
          raise NotImplementedError
        end

        def object
          bindings[:object]
        end
      end
    end
  end
end
