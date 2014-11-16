require 'csv'

module EventReporter
  class Load
    attr_reader   :printer
    attr_accessor :file_name,
                  :criteria

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
      @file_name  = ''
    end

    def call
      get_filename
      file_exists? ? load_file : printer.invalid_file_name(file_name)
      printer.confirm_file_load(@@entry_repository.entries.length)
    end

    def load_file
      file_path          = generate_file_path
      contents           = read_in_csv(file_path)
      csv_rows           = contents.map { |row| row.to_hash }
      @@entry_repository = EventReporter::EntryRepository.new(csv_rows)
    end

    def get_filename
      if    no_criteria?   then self.file_name = 'event_attendees.csv'
      elsif one_criterion? then self.file_name = criteria[0]
      else                      printer.invalid_load_criteria(criteria.length)
      end
    end

    def generate_file_path
      File.join(EventReporter::LOAD_FILE_DIR, file_name)
    end

    def file_exists?
      File.exist?(generate_file_path)
    end

    def read_in_csv(file_path)
      CSV.open file_path, headers: true, header_converters: :symbol
    end

    def no_criteria?
      criteria.length == 0
    end

    def one_criterion?
      criteria.length == 1
    end
  end
end
