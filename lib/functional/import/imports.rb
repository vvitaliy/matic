# frozen_string_literal: true

module Matic
  module Imports
    class ImportsSpot < BasePage
      attr_reader :import_id, :file_name

      def_delegators :@api, :get, :post, :status, :body
      def_delegators :@imports_requests

      def initialize
        @api = ClientApi::Api.new
        @imports_requests = ImportsRequests.new
        @file_name = 'list_of_customers.csv'
        @import_id = 135 # will be removed
      end

      def generate_valid_csv_file
        generate_csv_file
        fill_data_in_file
      end

      def create_new_import
        @api.post('/api/imports',
                  'type': { 'content-type': 'multipart/form-data' },
                  'data': { 'import[file]': File.new('list_of_customers.csv'),
                            'import[title]': 'Automate import v.2' })
        expect(status).to eq(201)
      end

      def take_import_details
        get("/api/imports/#{import_id}")
        expect(status).to eq(200)

        check_import_details(body)
      end

      def check_import_details(body)
        parsed = JSON.parse(body.to_json)

        status_completed?(parsed)
        all_customers_processed?(parsed)
      end

      private

      def generate_csv_file
        header = CSV.generate do |csv|
          csv << %i[first_name last_name email date_of_birth]
        end

        File.write(file_name, header)
      end

      def fill_data_in_file
        rand(1..100).times do
          CSV.open(file_name, 'a+') do |csv|
            csv << [Faker::Name.first_name,
            Faker::Name.last_name,
            Faker::Internet.email,
            "#{rand(1..30)}.#{rand(1..12)}.#{rand(1970..2000)}"]
          end
        end
      end

      def status_completed?(parsed)
        expect(parsed['status']).to eq('completed')
      end

      def all_customers_processed?(parsed)
        expect(parsed['processed']).to eq(parsed['total_count'])
      end
    end
  end
end
