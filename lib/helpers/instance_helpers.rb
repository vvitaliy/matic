# frozen_string_literal: true

module PageInstanceHelper
  extend Forwardable

  def_delegators :@app,
                 :client_api_imports,
                 :rest_client_imports
end
