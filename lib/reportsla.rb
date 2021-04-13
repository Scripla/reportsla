# frozen_string_literal: true

require_relative "reportsla/version"
require_relative "registerable"
require_relative "reports/base"
require_relative "reportsla/engine"

module Reportsla
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :registers
    def initialize
      @registers = {}
    end
  end
  # Your code goes here...

end
