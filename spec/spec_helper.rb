require 'simplecov'
SimpleCov.start { add_filter "/spec/" }
require 'event_reporter'
require 'event_reporter/load'
require 'event_reporter/printer'
require 'event_reporter/entry'
require 'event_reporter/entry_repository'
