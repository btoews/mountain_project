# frozen_string_literal: true

class MountainProject::Rating::System
  attr_accessor :default_grade

  # A collection of all rating systems.
  #
  # Returns nothing.
  def self.instances
    @instances ||= []
  end

  # All grades, indexed by name.
  #
  # Returns a Hash.
  def self.grades_by_name
    @grades_by_name ||= instances.map(&:grades_by_name).reduce(&:merge)
  end

  # Initialize a new rating system.
  #
  # &block - A block to be eval'ed in the context of this instance.
  #
  # Returns nothing.
  def initialize(&block)
    self.class.instances << self
    instance_eval(&block) if block
  end

  # The grades associated with this system.
  #
  # Returns an Array of Grades.
  def grades
    @grades ||= []
  end

  # The grades, indexed by their name.
  #
  # Returns a Hash.
  def grades_by_name
    @grades_by_name ||= grades.reduce({}) { |h, g| h.update(g.name => g) }
  end

  # Lookup a grade by its name.
  #
  # name - The String name of the grade.
  #
  # Returns a Grade instance or nil.
  def [](name)
    grades_by_name[name]
  end

  # Add new, equivelant grade for this system.
  #
  # names - String name(s) of the grade(s).
  #
  # Returns nothing.
  def grade(*names)
    index = grades.size
    names.each do |name|
      grades << MountainProject::Rating::Grade.new(
        name: name,
        index: index,
        system: self
      )
    end
  end
end
