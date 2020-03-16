# frozen_string_literal: true

module PageInstanceHelper
  extend Forwardable

  def_delegators :@app,
                 :imports
end
