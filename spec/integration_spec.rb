require 'spec_helper'

RSpec.describe EventReporter do
  it "successfully completes the 'happy path' spec" do
    instream = StringIO.new("load event_attendees.csv\nqueue count\nfind first_name John\nqueue count\nqueue clear\nqueue count\nhelp\nhelp queue count\nhelp queue print\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include("63 records added to queue")
    outstream.string.slice! "63 records added to queue"
    expect(outstream.string).to include("63 records in queue")
    outstream.string.slice! "63 records in queue"
    expect(outstream.string).to include("Queue now has 0 records")
    outstream.string.slice! "Queue now has 0 records"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include(">>> ALL COMMANDS:")
    outstream.string.slice! ">>> ALL COMMANDS:"
    expect(outstream.string).to include(">>> HELP: QUEUE COUNT")
    outstream.string.slice! ">>> HELP: QUEUE COUNT"
    expect(outstream.string).to include(">>> HELP: QUEUE PRINT")
    outstream.string.slice! ">>> HELP: QUEUE PRINT"
  end

  it "successfully completes the 'let's try printing' spec" do
    instream = StringIO.new("load\nqueue count\nfind first_name John\nfind first_name Mary\nqueue print\n queue print by last_name\n queue count\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include("63 records added to queue")
    outstream.string.slice! "63 records added to queue"
    expect(outstream.string).to include("16 records added to queue")
    outstream.string.slice! "16 records added to queue"
    expect(outstream.string).to include("-\nBrowne")
    outstream.string.slice! "-\nBrowne"
    expect(outstream.string).to include("-\nBastias")
    outstream.string.slice! "-\nBastias"
    expect(outstream.string).to include("16 records in queue")
    outstream.string.slice! "16 records in queue"
  end

  it "successfully completes the 'saving' spec" do
    instream = StringIO.new("load\nfind city Salt Lake City\nqueue print\n queue save to city_sample.csv\nfind state DC\nqueue print by last_name\n                         queue save to state_sample.csv\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("13 records added to queue")
    outstream.string.slice! "13 records added to queue"
    expect(outstream.string).to include("-\nPanek")
    outstream.string.slice! "-\nPanek"
    city_file_path = File.join(EventReporter::LOAD_FILE_DIR, "city_sample.csv")
    expect(File.exist?(city_file_path)).to be_truthy
    File.delete(city_file_path)
    expect(outstream.string).to include("236 records added to queue")
    outstream.string.slice! "236 records added to queue"
    expect(outstream.string).to include("-\nAbraham")
    outstream.string.slice! "-\nAbraham"
    state_file_path = File.join(EventReporter::LOAD_FILE_DIR, "state_sample.csv")
    expect(File.exist?(state_file_path)).to be_truthy
    File.delete(state_file_path)
  end

  it "successfully completes the 'Reading your data' spec" do
    instream1 = StringIO.new("load\nfind state MD\nqueue save to state_sample.csv\nq\n")
    outstream1 = StringIO.new
    EventReporter::CLI.new(instream1, outstream1).call
    expect(outstream1.string).to include("5175 entries")
    outstream1.string.slice! "5175 entries"
    expect(outstream1.string).to include("294 records added to queue")
    outstream1.string.slice! "294 records added to queue"
    state_file_path = File.join(EventReporter::LOAD_FILE_DIR, "state_sample.csv")
    expect(File.exist?(state_file_path)).to be_truthy

    instream2 = StringIO.new("load state_sample.csv\nfind first_name John\nqueue count\nq\n")
    outstream2 = StringIO.new
    EventReporter::CLI.new(instream2, outstream2).call
    expect(outstream2.string).to include("294 entries")
    outstream2.string.slice! "294 entries"
    expect(outstream2.string).to include("4 records added to queue")
    outstream2.string.slice! "4 records added to queue"
    expect(outstream2.string).to include("4 records in queue")
    outstream2.string.slice! "4 records in queue"
    File.delete(state_file_path)
  end

  it "successfully completes the 'emptiness' spec" do
    instream = StringIO.new("find last_name Johnson\nqueue count\nqueue print\nqueue clear\nqueue print by last_name\nqueue save to empty.csv\nqueue count\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("0 records added to queue")
    outstream.string.slice! "0 records added to queue"
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
    expect(outstream.string).to include("Nothing to print")
    outstream.string.slice! "Nothing to print"
    expect(outstream.string).to include("Queue now has 0 records")
    outstream.string.slice! "Queue now has 0 records"
    expect(outstream.string).to include("Nothing to print")
    outstream.string.slice! "Nothing to print"
    file_path = File.join(EventReporter::LOAD_FILE_DIR, "empty.csv")
    expect(File.exist?(file_path)).to be_truthy
    File.delete(file_path)
    expect(outstream.string).to include("0 records in queue")
    outstream.string.slice! "0 records in queue"
  end

  it "successfully completes the 'improved find' spec" do
    instream = StringIO.new("load\nfind first_name sarah and state CA\nq")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("4 records added to queue")
    outstream.string.slice! "4 records added to queue"
  end

  it "successfully completes the 'queue math' spec" do
    instream = StringIO.new("load\nfind zipcode 20011\nsubtract first_name william\nadd zipcode 20010\nq\n")
    outstream = StringIO.new
    EventReporter::CLI.new(instream, outstream).call
    expect(outstream.string).to include("5175 entries")
    outstream.string.slice! "5175 entries"
    expect(outstream.string).to include("4 records added to queue")
    outstream.string.slice! "4 records added to queue"
    expect(outstream.string).to include("Removed 1 records from the queue")
    outstream.string.slice! "Removed 1 records from the queue"
    expect(outstream.string).to include("5 records added to queue")
    outstream.string.slice! "5 records added to queue"
  end
end
