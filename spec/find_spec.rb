require 'spec_helper'

RSpec.describe EventReporter::Find do
  context 'when validating criteria' do
    before do
      @outstream = StringIO.new
      @printer = EventReporter::Printer.new(@outstream)
      criteria = []
      @finder = EventReporter::Find.new(StringIO.new, @outstream, @printer, criteria)
    end

    it "accepts criteria shorter than or equal to 2" do
      @finder.criteria = ["first_name", "pizza"]
      expect(@finder.valid_criteria?).to be_truthy
    end

    it "rejects criteria shorter than 2" do
      @finder.criteria = ["pizza"]
      expect(@finder.valid_criteria?).to be_falsey
    end

    it "returns an error message if too short" do
      @finder.criteria = ["pizza"]
      @finder.call
      expect(@outstream.string).to include("Invalid find criteria")
    end

    it "accepts a valid parameter" do
      @finder.criteria = ["first_name", "Steve"]
      expect(@finder.valid_attribute?).to be_truthy
    end

    it "return an error message for an invalid param" do
      @finder.criteria = ["invalid_attribute", "Steve"]
      @finder.call 
      expect(@outstream.string).to include("Invalid attribute:")
    end
  end

  context "when searching entries" do
    before do
      rows = [{:_=>"99", :regdate=>"12/8/08 21:24", :first_name=>"Maia", :last_name=>"Allen", :email_address=>"gqckerj@jumpstartlab.com", :homephone=>"(913) 963-7000", :street=>"1541 Kentucky St.", :city=>"Lawrence", :state=>"KS", :zipcode=>"66044"},
              {:_=>"100", :regdate=>"12/8/08 21:26", :first_name=>"Genna", :last_name=>"Chudkowski", :email_address=>"xkriffard@jumpstartlab.com", :homephone=>"856-401-2000", :street=>"123 Garfield Ave", :city=>"Salt Lake City", :state=>"NJ", :zipcode=>"8012"}]
      $entry_repository = EventReporter::EntryRepository.new(rows)
      @outstream = StringIO.new
      @printer = EventReporter::Printer.new(@outstream)
      criteria = ["first_name", ""]
      @finder = EventReporter::Find.new(StringIO.new, @outstream, @printer, criteria)
    end

    it "can find matching entries" do
      first_criteria = "genna"
      second_criteria = nil
      found = @finder.get_matching_entries(first_criteria, second_criteria)
      expect(found.length).to eql(1)
    end

    it "finds nothing if no matches" do
      first_criteria = "steve"
      second_criteria = nil
      found = @finder.get_matching_entries(first_criteria, second_criteria)
      expect(found.length).to eql(0)
    end

    it "can search for a multi-word string" do
      #@finder.criteria = ["city", "salt", "lake", "city"]
      @finder.criteria = ["city", ""]
      found = @finder.get_matching_entries("salt lake city", nil)
      expect(found.length).to eql(1)
    end

    it "can do a full search" do
      @finder.criteria = ["city", "salt", "lake", "city"]
      expect($queue_repository).to be_nil
      @finder.call
      expect($queue_repository).to_not be_nil
      expect($queue_repository.entries.length).to eql(1)
    end
  end
end
