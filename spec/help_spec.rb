require 'spec_helper'

RSpec.describe EventReporter::Help do
  before do
    @outstream = StringIO.new
    @printer = EventReporter::Printer.new(@outstream)
    criteria = []
    @helper = EventReporter::Help.new(StringIO.new, @outstream, @printer, criteria)
  end

  it "rejects criteria if it is too long" do
    @helper.criteria = ["pizza", "queue", "print_by", "queue_save_to"]
    expect(@helper.valid_length?).to be_falsey
  end

  it "accepts a valid criteria length " do
    @helper.criteria = ["pizza", "queue", "print_by"]
    expect(@helper.valid_length?).to be_truthy
  end

  it "accepts valid commands" do
    @helper.criteria = ["queue", "print", "by"]
    expect(@helper.valid_commands?).to be_truthy
  end

  it "rejects criteria if not a valid command" do
    @helper.criteria = ["queue","pizza", "cookie"]
    expect(@helper.valid_commands?).to be_falsey
  end

  it "returns a error message when inputing invalid criteria" do
    @helper.criteria = ["invalid_command", "queue"]
    @helper.call
    expect(@outstream.string).to include("Invalid help")
  end

  it "returns a valid message when inputing valid criteria" do
    @helper.criteria = ["queue", "print", "by"]
    @helper.call
    expect(@outstream.string).to include("Enter 'queue print by")
  end
end
