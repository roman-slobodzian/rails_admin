# frozen_string_literal: true

module RailsAdmin
  module Config
    module Services
      class Save < Base
        def execute
          object.save
        end
      end
    end
  end
end
