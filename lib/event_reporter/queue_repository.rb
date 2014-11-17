module EventReporter
  class QueueRepository
    attr_accessor :entries

    def initialize(entries)
      @entries = entries
    end

  end
end
