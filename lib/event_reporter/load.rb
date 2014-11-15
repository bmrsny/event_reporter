module EventReporter
  class Load
    attr_reader :criteria, :printer
    attr_accessor :file_name

    def initialize(instream, outstream, printer, criteria)
      @instream = instream
      @outstream = outstream
      @printer = printer
      @criteria = criteria
      @file_name = ''
    end

    def call
      get_filename
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
    # look at filename
    # check for valid filename
    # read file
    # parse file
    # save the results to data-store
  end
end
