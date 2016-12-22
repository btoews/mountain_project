# frozen_string_literal: true

class MountainProject::Rating::System
  attr_accessor :default_grade

  # A collection of all rating systems.
  #
  # Returns nothing.
  def self.instances
    @instances ||= []
  end

  # Organize instances by the first characters their grades can start with.
  #
  # Returns a Hash.
  def self.instances_by_prefix
    @instances_by_prefix ||= Hash.new { |h,k| h[k] = [] }.tap do |hash|
      instances.each do |instance|
        prefixes = instance.grades.map { |g| g.name.each_char.first }.uniq
        prefixes.each do |prefix|
          hash[prefix] ||= []
          hash[prefix] << instance
        end
      end
    end
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

  # Lookup a grade by its name.
  #
  # name - The String name of the grade.
  #
  # Returns a Grade instance or nil.
  def [](name)
    grades.find { |g| g.name == name }
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
