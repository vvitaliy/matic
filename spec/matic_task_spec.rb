# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'Matic' do
  context 'Test task' do
    it 'customers information can be successfully imported' do

      # @api.get('/api/users/2')
      # expect(@api.status).to eq(200)
      # puts @api.body
      imports.generate_valid_csv_file

      # # create a new import
      imports.create_new_import

      # # start import
      # imports.start_import

      # # get import
      # imports.get_import_details

      # # get customer
      # imports.get_list_of_customers

      # # check import status
      # imports.check_import_details
    end
  end
end
