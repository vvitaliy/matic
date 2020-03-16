# frozen_string_literal: true

module Matic
  class Pages
    def imports
      @imports = Imports::ImportsSpot.new
    end
  end
end
