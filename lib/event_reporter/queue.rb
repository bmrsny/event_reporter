module EventReporter
  class Queue
    attr_reader :criteria,
                :printer,
                :instream

    def initialize(instream, outstream, printer, criteria)
      @instream   = instream
      @outstream  = outstream
      @printer    = printer
      @criteria   = criteria
    end

    @@valid_commands = ["count", "clear", "print", "print by", "save to"]

    def call
      return printer.invalid_queue_command(criteria.join(" ")) if !valid_criteria?
      process_command
    end

    def process_command
      case
      when count?    then print_queue_count
      when clear?    then queue_clear
      when print?    then queue_print
      when print_by? then queue_print_by
      when save_to?  then queue_save_to
      end
    end

    def valid_criteria?
      valid_single_criterion? || valid_multi_criterion?
    end

    def valid_single_criterion?
      criteria.length == 1 && @@valid_commands.include?(criteria[0])
    end

    def valid_multi_criterion?
      criteria.length == 3 && @@valid_commands.include?(criteria[0..1].join(" "))
    end

    def queue_count
      $queue_repository.nil? ? 0 : $queue_repository.entries.length
    end

    def print_queue_count
      printer.print_queue_count(queue_count)
    end

    def queue_clear
      $queue_repository = nil
      printer.print_queue_cleared(queue_count)
    end

    def queue_print
      return printer.print_nothing_to_print if queue_count == 0
      print_headers
      print_rows
    end

    def print_headers
      printer.print_queue_headers
    end

    def print_rows
      $queue_repository.entries.each do |entry|
        printer.print_queue_row(entry)
      end
    end

    def queue_print_by
      queue_sort
      queue_print
    end

    def queue_sort
      return if $queue_repository.nil?
      sort_entries
    end

    def sort_entries
      $queue_repository.entries = $queue_repository.entries.sort_by do |entry|
        entry.send(criteria[2].to_sym).downcase
      end
    end

    def queue_save_to
      file_exists? ? confirm_overwrite : create_csv
    end

    def confirm_overwrite
      response = confirm_prompt
      confirmed?(response) ? create_csv : printer.file_not_overwritten
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
      file = generate_file_path
      CSV.open(file, "wb") do |csv|
        csv << csv_col_headers
        add_csv_rows(csv) unless $queue_repository.nil?
      end
      printer.confirm_file_saved(criteria[2])
    end

    def csv_col_headers
      ["Last_Name",
       "First_Name",
       "Email_Address",
       "Zipcode",
       "City",
       "State",
       "Address",
       "HomePhone"]
    end

    def add_csv_rows(csv)
      $queue_repository.entries.each do |entry|
        csv << ["#{entry.last_name}",
                "#{entry.first_name}",
                "#{entry.email}",
                "#{entry.zipcode}",
                "#{entry.city}",
                "#{entry.state}",
                "#{entry.street}",
                "#{entry.phone}"]
      end
    end

    def file_exists?
      File.exist?(generate_file_path)
    end

    def generate_file_path
      File.join(EventReporter::LOAD_FILE_DIR, criteria[2])
    end

    def count?
      criteria[0] == 'count'
    end

    def clear?
      criteria[0] == 'clear'
    end

    def print?
      criteria[0] == 'print' && criteria.length == 1
    end

    def print_by?
      criteria[0..1].join(" ") == 'print by'
    end

    def save_to?
      criteria[0..1].join(" ") == "save to"
    end
  end
end
