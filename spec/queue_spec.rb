require 'spec_helper'

RSpec.describe EventReporter::Queue do
  context 'when validating criteria' do
    before do
      @outstream = StringIO.new
      @printer = EventReporter::Printer.new(@outstream)
      criteria = []
      @queuer = EventReporter::Queue.new(StringIO.new, @outstream, @printer, criteria)
    end

    it "validates that criteria contains either 1 or 3 params" do
      @queuer.criteria = ["print", "by"]
      expect(@queuer.valid_criteria?).to be_falsey
      @queuer.criteria = ["print", "by", "first", "name"]
      expect(@queuer.valid_criteria?).to be_falsey
    end

    it "validates that correct length criteria must be valid cmds" do
      @queuer.criteria = ["print"]
      expect(@queuer.valid_criteria?).to be_truthy
      @queuer.criteria = ["pizza"]
      expect(@queuer.valid_criteria?).to be_falsey
      @queuer.criteria = ["print", "by", "first_name"]
      expect(@queuer.valid_criteria?).to be_truthy
      @queuer.criteria = ["pizza", "by", "first_name"]
      expect(@queuer.valid_criteria?).to be_falsey
    end
  end

  context "when queue has entries" do
    before do
      row1 = {:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"}
      row2 = {:_=>"100", :regdate=>"12/8/08 21:26", :first_name=>"Genna", :last_name=>"Chudkowski", :email_address=>"xkriffard@jumpstartlab.com", :homephone=>"856-401-2000", :street=>"123 Garfield Ave", :city=>"Salt Lake City", :state=>"NJ", :zipcode=>"8012"}
      entry1 = EventReporter::Entry.new(row1)
      entry2 = EventReporter::Entry.new(row2)
      entry_objects = [entry1, entry2]
      $queue_repository = EventReporter::QueueRepository.new(entry_objects)
      @outstream = StringIO.new
      @printer = EventReporter::Printer.new(@outstream)
      criteria = []
      @queuer = EventReporter::Queue.new(StringIO.new, @outstream, @printer, criteria)
    end

    it "can return the size of the queue" do
      expect(@queuer.queue_count).to eql(2)
    end

    it "can print out the queue" do
      @queuer.queue_print
      expect(@outstream.string).to include("FIRST NAME", "Maia")
    end

    it "can print out the queue sorted" do
      @queuer.criteria = ["print", "by", "first_name"]
      expect($queue_repository.entries[0].first_name).to eql("Maia")
      @queuer.queue_print_by
      expect($queue_repository.entries[0].first_name).to eql("Genna")
      expect(@outstream.string).to include("FIRST NAME", "Maia")
    end

    it "can clear the queue" do
      expect(@queuer.queue_count).to eql(2)
      @queuer.queue_clear
      expect(@queuer.queue_count).to eql(0)
    end

    it "can call the csv generator class" do
      expect_any_instance_of(EventReporter::CSVGenerator).to receive(:call)
      @queuer.queue_save_to
    end
  end
end
