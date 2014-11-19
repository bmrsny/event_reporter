module EventReporter
  class TablePrinter
    attr_reader :outstream, :queue, :col_names
    attr_accessor :col_widths, :temp_queue, :instream, :count, :round_max

    SPACER = 2

    def initialize(instream, outstream, queue)
      @instream   = instream
      @outstream  = outstream
      @queue      = $queue_repository
      @col_widths = Hash.new
      @col_names  = {
          :last_name  => "LAST NAME",
          :first_name => "FIRST NAME",
          :email      => "EMAIL",
          :zipcode    => "ZIPCODE",
          :city       => "CITY",
          :state      => "STATE",
          :street     => "ADDRESS",
          :phone      => "PHONE"
        }
      @temp_queue = nil
      @count      = 0
      @round_max  = 0
    end

    def call
      print_headers
      print_rows
    end

    def print_headers
      print_queue_headers
    end

    def print_rows
      temp_queue = $queue_repository.entries.dup
      until temp_queue.entries.empty?
        self.round_max = 0
        10.times do
          temp_queue[0].nil? ? break : print_queue_row(temp_queue.shift)
          self.round_max += 1
        end
        print_remaining_entries
        print_next_action unless temp_queue.entries.empty?
        wait_for_spacebar unless temp_queue.entries.empty?
        print_last        if     temp_queue.entries.empty?
      end
    end

    def wait_for_spacebar
      sleep 0.01 until instream.getch == " "
    end

    def print_remaining_entries
      outstream.puts "Displaying records #{self.count += 1} - #{self.count += (round_max - 1)} of #{queue.entries.length}"
    end

    def print_next_action
      outstream.puts "press <space> to show the next set of records"
      outstream.puts
    end

    def print_last
      outstream.puts
      outstream.puts "<<< END OF RECORDS >>>"
      outstream.puts
    end

    def find_column_widths
      attribute_list = EventReporter::Entry.instance_methods(false).grep(/^((?!cleaner).)*$/)
      attribute_list.each do |attr|
        max_size(attr)
      end
    end

    def max_size(attr)
      data_longest = queue.entries.max_by { |entry| entry.send(attr).length }
      header_longest = col_names[attr].nil? ? 0 : col_names[attr].length
      length = data_longest.send(attr).length > header_longest ? data_longest.send(attr).length : header_longest
      col_widths[attr] = (length + SPACER) if col_names[attr]
    end

    def print_queue_headers
      find_column_widths
      outstream.puts
      print_divider
      col_names.keys.each do |attr|
        outstream.print "#{col_names[attr].ljust(col_widths[attr], " ")}"
      end
      outstream.print "\n"
      print_divider
    end

    def print_divider
      width = col_widths.values.reduce(:+)
      outstream.puts "".ljust(width, "-")
    end

    def print_queue_row(entry)
      col_names.keys.each do |attr|
        outstream.print "#{entry.send(attr).ljust(col_widths[attr], " ")}"
      end
      outstream.print "\n"
    end
  end
end

