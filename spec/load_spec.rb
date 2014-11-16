require 'spec_helper'

RSpec.describe EventReporter::Load do
  context "when getting filename" do
    before do
      instream = StringIO.new
      @outstream = StringIO.new
      printer = EventReporter::Printer.new(@outstream)
      criteria = []
      @loader = EventReporter::Load.new(instream, @outstream, printer, criteria)
    end

    it "defaults filename if no critera" do
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
      @loader.get_filename
      expect(@outstream.string).to include("Invalid load criteria:")
    end
  end
end
