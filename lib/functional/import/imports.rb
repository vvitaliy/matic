# frozen_string_literal: true

module Matic
  module Imports
    class ImportsSpot < BasePage
      def_delegators :@api, :get, :post, :status, :body
      def_delegators :@imports_requests

      def initialize
        @api = ClientApi::Api.new
        @imports_requests = ImportsRequests.new
      end

      def generate_valid_csv_file
        @file_name = 'list_of_customers.csv'

        generate_csv_file(@file_name)
        fill_data_in_file(@file_name)
      end

      def create_new_import
        @api.post('/api/imports',
                  'type' => 'multipart/form-data',
                  'data' => {'import[file]': 'list_of_customers.csv',
                             'import[title]': 'Automate import v.1'
                  })
        # @api.post('/api/users', # '/api/imports'),
        #           'body' => { 'name': 'morpheus',
        #                      'job': 'leader' })


             # payload('type' => 'multipart/form-data',
             #         'data' => { 'import[file]': @file_name,
             #                     'import[title]': "#{Faker::Color.color_name} "\
             #                                      "#{Faker::Team.creature}" }))
      end

      private

      def generate_csv_file(name)
        header = CSV.generate do |csv|
          csv << %i[first_name last_name email date_of_birth]
        end

        File.write(name, header)
      end

      def fill_data_in_file(name)
        rand(1..100).times do
          CSV.open(name, 'a+') do |csv|
            csv << [Faker::Name.first_name,
                    Faker::Name.last_name,
                    Faker::Internet.email,
                    "#{rand(1..30)}.#{rand(1..12)}.#{rand(1970..2000)}"]
          end
        end
      end
    end
  end
end
