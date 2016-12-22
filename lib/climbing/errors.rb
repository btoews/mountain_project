# frozen_string_literal: true

module Climbing
  Error                  = Class.new(StandardError)
  ImplementMe            = Class.new(Error)
  InvalidComparisonError = Class.new(Error)
  InvalidConditionsError = Class.new(Error)
end
