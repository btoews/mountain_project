# frozen_string_literal: true

module MountainProject
  Error                  = Class.new(StandardError)
  ImplementMe            = Class.new(Error)
  InvalidComparisonError = Class.new(Error)
  InvalidConditionsError = Class.new(Error)
end
