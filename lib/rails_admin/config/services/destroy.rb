# frozen_string_literal: true

module RailsAdmin
  module Config
    module Services
      class Destroy < Base
        def execute
          object.destroy
        end
      end
    end
  end
end
