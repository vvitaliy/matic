# frozen_string_literal: true

module Matic
  module ClientApiImports
    class ClientApiImportsSpot < BasePage
      attr_reader :import_id, :file_name

      def_delegators :@api, :get, :post, :status, :body

      def initialize
        @api = ClientApi::Api.new
        @file_name = 'list_of_customers.csv'
        @import_id = 145 # will be removed
      end

      def generate_valid_csv_file
        generate_csv_file
        fill_data_in_file
      end

      # gives 400 error
      def create_new_import
        headers = { 'Content-Type': 'multipart/form-data' }
        file = File.new('list_of_customers.csv')
        custom_body = { 'client_api_import[file]': file,
                        'client_api_import[title]': 'Api client_api_import' }
        post('/api/imports', custom_body, headers)
        expect(status).to eq(201)
      end

      def start_import
        post("/api/imports/#{import_id}/start", {})
        expect(status).to eq(200)
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
        rand(1..50).times do
          CSV.open(file_name, 'a+') do |csv|
            csv << [Faker::Name.first_name,
                    Faker::Name.last_name,
                    Faker::Internet.email,
                    "#{rand(1970..2000)}.#{rand(1..12)}.#{rand(1..31)}"]
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
