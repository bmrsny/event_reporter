require 'csv'

module EventReporter
  class Load
    attr_reader :printer
    attr_accessor :file_name, :criteria

    def initialize(instream, outstream, printer, criteria)
      @instream = instream
      @outstream = outstream
      @printer = printer
      @criteria = criteria
      @file_name = ''
    end

    def call
      get_filename
      load_file
      #save_to_datastore
    end

    def get_filename
      if criteria.length == 0
        self.file_name = 'event_attendees.csv'
      elsif criteria.length == 1
        self.file_name = criteria[0]
      else
        printer.invalid_load_criteria(criteria.length)
      end
    end

    def load_file
      file_path = File.join(EventReporter::LOAD_FILE_DIR,file_name)
      contents = CSV.open file_path, headers: true, header_converters: :symbol
      csv_rows = contents.map do |row|
        row.to_hash
      end
      @@entry_repository = EventReporter::EntryRepository.new(csv_rows)
    end
    # read file
    # parse file
    # save the results to data-store
  end
end
