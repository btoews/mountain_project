# frozen_string_literal: true

class MountainProject::Rating::Grade
  include Comparable

  attr_reader :name, :index, :system

  # Initialize a new grade.
  #
  # name:   - The String name of the grade (Eg. 5.10b)
  # index:  - How hard this grade is compared to others of the same system.
  # system: - The System instance this grade is associated with.
  #
  # Returns nothing.
  def initialize(name:, index:, system:)
    @name = name
    @index = index
    @system = system
  end

  def inspect
    name
  end

  def to_s
    inspect
  end

  def <=>(other)
    unless other.is_a?(MountainProject::Rating::Grade) && system == other.system
      raise MountainProject::InvalidComparisonError
    end

    index <=> other.index
  end
end
