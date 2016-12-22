# frozen_string_literal: true

class Climbing::RouteRating
  include Comparable

  attr_reader :grades

  # Make a new RouteRating from a raw value.
  #
  # raw - A raw String rating (Eg. 5.10a V1 R)
  #
  # Returns a new RouteRating instance.
  def self.[](raw)
    grades = raw.split(" ").map { |r| Climbing::Rating[r] }.compact
    new(grades: grades)
  end

  # Initialize a new RouteRating instance.
  #
  # grades - An Array of Rating::Grades.
  #
  # Returns nothing.
  def initialize(grades:)
    @grades = grades
  end

  # Rating::Grades indexed by Rating::System.
  #
  # Returns a Hash.
  def grades_by_system
    @grades_by_system ||= grades.reduce({}) do |hash, grade|
      hash.update(grade.system => grade)
    end
  end

  # The Rating::Systems our grades are comprised of.
  #
  # Returns an Array of Rating::Systems.
  def systems
    @systems ||= grades.map(&:system).uniq
  end

  # Compare to RouteRatings.
  #
  # other - Another RouteRating.
  #
  # TODO: What should we do when comparing with mutiple Rating::Grades.
  #       Eg. 5.10a PG vs 5.5 X
  #
  # Returns -1, 0, 1.
  def <=>(other)
    grades_by_system.each do |system, grade|
      if other_grade = other.grades_by_system[system]
        return grade <=> other_grade
      end
    end

    grades_by_system.each do |system, grade|
      if system.default_grade
        return grade <=> system.default_grade
      end
    end

    other.grades_by_system.each do |system, grade|
      if system.default_grade
        return system.default_grade <=> grade
      end
    end

    raise Climbing::InvalidComparisonError
  end

  # Represent as a String.
  #
  # Returns a String.
  def inspect
    # "5.11b/c PG13".length == 12
    "%-12s" % grades.map(&:inspect).join(" ")
  end

  # Represent as a String.
  #
  # Returns a String.
  def to_s
    inspect
  end
end
