require "event_reporter/version"
require 'event_reporter/printer'
require 'event_reporter/cli'
require 'event_reporter/load'
require 'event_reporter/entry_repository'
require 'event_reporter/entry'
require 'event_reporter/queue'
require 'event_reporter/find'

module EventReporter
  LOAD_FILE_DIR = '././files/'

  @@entry_repository = nil
  @@queue            = nil
end
