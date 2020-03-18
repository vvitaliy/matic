# frozen_string_literal: true

module Matic
  class Folders
    def client_api_imports
      @client_api_imports = ClientApiImports::ClientApiImportsSpot.new
    end

    def rest_client_imports
      @rest_client_imports = RestClientImports::RestClientImportsSpot.new
    end
  end
end
