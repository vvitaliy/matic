# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Matic' do
  context 'Test task' do
    it 'customers information can be successfully imported' do
      # using client-api gem
      # client_api_imports.generate_valid_csv_file
      # client_api_imports.create_new_import
      # client_api_imports.start_import
      # client_api_imports.take_import_details

      # using rest-client gem
      rest_client_imports.generate_valid_csv_file
      import_id = rest_client_imports.create_new_import
      rest_client_imports.start_import(import_id)
      rest_client_imports.take_import_details(import_id)
    end
  end
end
