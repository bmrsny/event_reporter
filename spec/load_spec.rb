require 'spec_helper'

RSpec.describe EventReporter::Load do
  context "when getting a filename" do
    before do
      instream = StringIO.new
      @outstream = StringIO.new
      printer = EventReporter::Printer.new(@outstream)
      criteria = []
      @loader = EventReporter::Load.new(instream, @outstream, printer, criteria)
    end

    it "defaults filename if no critera are provided" do
      @loader.get_filename
      expect(@loader.file_name).to eq('event_attendees.csv')
    end

    it "sets one criterion as the filename" do
      @loader.criteria = ["x.csv"]
      @loader.get_filename
      expect(@loader.file_name).to eq("x.csv")
    end

    it "returns invalid if multiple criteron are passed in" do
      @loader.criteria = ["y.csv", "w.csv"]
      @loader.call
      expect(@outstream.string).to include("Invalid load criteria:")
    end

    it "returns error if the file does not exist in files dir" do
      @loader.criteria = ["dskgjslasd.csv"]
      @loader.call
      expect(@outstream.string).to include("does not exist")
    end

    it "generates a load path" do
      @loader.criteria = ["x.csv"]
      @loader.get_filename
      path = @loader.generate_file_path
      expect(path).to eql('././files/x.csv')
    end
  end

  context "when loading a file" do
    before do
      instream = StringIO.new
      @outstream = StringIO.new
      printer = EventReporter::Printer.new(@outstream)
      criteria = []
      @loader = EventReporter::Load.new(instream, @outstream, printer, criteria)
    end

    it "reads in a csv file" do
      @loader.file_name = ['event_attendees.csv']
      path = @loader.generate_file_path
      opened_csv = @loader.read_in_csv(path)
      expect(opened_csv).to be_a CSV
    end

    it "converts csv row objects to hashes" do
      @loader.file_name = ['event_attendees.csv']
      path = @loader.generate_file_path
      opened_csv = @loader.read_in_csv(path)
      hashes = @loader.csv_to_hash(opened_csv)
      expect(hashes[0]).to be_a Hash
    end

    it "creates a new EntryRepository object" do
      @loader.call
      expect($entry_repository).to be_a EventReporter::EntryRepository
    end
  end
end
