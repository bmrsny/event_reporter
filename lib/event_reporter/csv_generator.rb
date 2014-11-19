module EventReporter
  class CSVGenerator
    attr_reader :instream,
                :outstream,
                :printer,
                :criteria,
                :queue

    def initialize(instream, outstream, printer, criteria, queue)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
      @queue      = queue
    end

    def call
      file_exists? ? confirm_overwrite : create_csv
    end

    def confirm_overwrite
      confirmed?(confirm_prompt) ? create_csv : printer.file_not_overwritten
    end

    def confirm_prompt
      printer.confirm_file_overwrite(criteria[2])
      printer.confirm_overwrite_prompt
      instream.gets.strip.downcase
    end

    def confirmed?(response)
      response == "y" || response == "yes"
    end

    def create_csv
      CSV.open(generate_file_path, "wb") do |csv|
        csv << csv_col_headers
        add_csv_rows(csv) unless queue.nil?
      end
      printer.confirm_file_saved(criteria[2])
    end

    def csv_col_headers
      ["Last Name",
       "First Name",
       "Email Address",
       "Zipcode",
       "City",
       "State",
       "Address",
       "Homephone",
       "Regdate"]
    end

    def add_csv_rows(csv)
      queue.entries.each do |entry|
        csv << ["#{entry.last_name}",
                "#{entry.first_name}",
                "#{entry.email}",
                "#{entry.zipcode}",
                "#{entry.city}",
                "#{entry.state}",
                "#{entry.street}",
                "#{entry.phone}",
                "#{entry.reg_date}"]
      end
    end

    def file_exists?
      File.exist?(generate_file_path)
    end

    def generate_file_path
      File.join(EventReporter::LOAD_FILE_DIR, criteria[2])
    end
  end
end
