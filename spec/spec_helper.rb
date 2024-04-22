# frozen_string_literal: true

require "bundler"
Bundler.setup

require "ferrum/har"
require "pry-byebug"
require "ap"

Bundler.require(:test)

Dir[File.expand_path("support/*.rb", __dir__)].each { |f| require f }
