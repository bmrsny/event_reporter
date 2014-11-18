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
      @file_name  = 'event_attendees.csv'
    end

    def call
      return invalid_criterion_msg if !valid_criteria?
      get_filename
      return invalid_filename_msg if !file_exists?
      load_file
    end

    def load_file
      file_path          = generate_file_path
      contents           = read_in_csv(file_path)
      csv_rows           = csv_to_hash(contents)
      $entry_repository  = EventReporter::EntryRepository.new(csv_rows)
      confirm_load
    end

    def get_filename
      self.file_name = criteria[0] if one_criterion?
    end

    def generate_file_path
      File.join(EventReporter::LOAD_FILE_DIR, file_name)
    end

    def valid_criteria?
      no_criteria? || one_criterion?
    end

    def file_exists?
      File.exist?(generate_file_path)
    end

    def read_in_csv(file_path)
      CSV.open file_path, headers: true, header_converters: :symbol
    end

    def csv_to_hash(csv_rows)
      csv_rows.map(&:to_hash)
    end

    def confirm_load
      printer.confirm_file_load($entry_repository.entries.length)
    end

    def no_criteria?
      criteria.length == 0
    end

    def one_criterion?
      criteria.length == 1
    end

    def invalid_criterion_msg
      printer.invalid_load_criteria(criteria.length)
    end

    def invalid_filename_msg
      printer.invalid_file_name(file_name)
    end
  end
end
