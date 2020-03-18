# frozen_string_literal: true

module Matic
  module RestClientImports
    class RestClientImportsSpot < BasePage
      attr_reader :url, :headers, :file_name, :import_id

      def initialize
        @url = 'https://testtaskmatic.herokuapp.com'
        @headers = { 'Authorization': 'Bearer 1f43d455fgjkgfjgf48',
                     'Content-Type': 'multipart/form-data' }
        @file_name = 'list_of_customers.csv'
      end

      def generate_valid_csv_file
        generate_csv_file
        fill_data_in_file
      end

      def create_new_import
        path = "#{url}/api/imports"

        import_name = Faker::Beer.brand
        body = { 'import[file]': File.new(file_name.to_s),
                 'import[title]': import_name.to_s }

        response = RestClient.post(path, body, headers)
        expect(response.code).to eq(201)

        save_import_id(response)
      end

      def start_import(import_id)
        response = RestClient.post("#{url}/api/imports/#{import_id}/start",
                                   {}, headers)
        expect(response.code).to eq(200)
      end

      def take_import_details(import_id)
        response = RestClient.get("#{url}/api/imports/#{import_id}", headers)
        expect(response.code).to eq(200)

        check_import_details(response)
      end

      def check_import_details(response)
        parsed = JSON.parse(response)

        status_completed?(parsed)
        all_customers_processed?(parsed)
      end

      def save_import_id(response)
        parsed = JSON.parse(response)
        parsed['id']
      end

      private

      def generate_csv_file
        header = CSV.generate do |csv|
          csv << %i[first_name last_name email date_of_birth]
        end

        File.write(file_name, header)
      end

      def fill_data_in_file
        rand(1..10).times do
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
        puts "Import name: #{parsed['title']}"
        puts "Status: #{parsed['status']}"
      end

      def all_customers_processed?(parsed)
        expect(parsed['processed']).to eq(parsed['total_count'])
        puts "Processed customers: #{parsed['processed']}"
        puts "Total customers: #{parsed['total_count']}"
      end
    end
  end
end
