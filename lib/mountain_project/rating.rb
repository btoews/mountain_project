# frozen_string_literal: true

module MountainProject::Rating
  # Lookup a grade by its name.
  #
  # Returns a Grade instance or nil.
  def self.[](name)
    System.grades_by_name[name]
  end
end

require "mountain_project/rating/grade"
require "mountain_project/rating/system"

MountainProject::Rating::YDS = MountainProject::Rating::System.new do
  grade("4th")
  grade("Easy 5th")
  (0..15).each do |number|
    grade("5.#{number}-")
    if number > 9
      grade("5.#{number}a")
      grade("5.#{number}a/b")
      grade("5.#{number}b")
      grade("5.#{number}b/c", "5.#{number}") # 5.10 == 5.10b/c ¯\_(ツ)_/¯
      grade("5.#{number}c")
      grade("5.#{number}c/d")
      grade("5.#{number}d")
    else
      grade("5.#{number}")
    end
    grade("5.#{number}+")
  end
end

MountainProject::Rating::Hueco = MountainProject::Rating::System.new do
  grade("V-easy")
  (0..16).each do |number|
    grade("V#{number}-")
    grade("V#{number}")
    grade("V#{number}+")
    grade("V#{number}-#{number+1}")
  end
end

MountainProject::Rating::WaterIce = MountainProject::Rating::System.new do
  (1..8).each do |number|
    grade("WI#{number}-")
    grade("WI#{number}")
    grade("WI#{number}+")
    grade("WI#{number}-#{number+1}")
  end
end

MountainProject::Rating::AlpineIce = MountainProject::Rating::System.new do
  (1..6).each do |number|
    grade("AI#{number}-")
    grade("AI#{number}")
    grade("AI#{number}+")
    grade("AI#{number}-#{number+1}")
  end
end

MountainProject::Rating::Mixed = MountainProject::Rating::System.new do
  (1..11).each do |number|
    grade("M#{number}-")
    grade("M#{number}")
    grade("M#{number}+")
    grade("M#{number}-#{number+1}")
  end
end

MountainProject::Rating::Aid = MountainProject::Rating::System.new do
  (0..5).each do |number|
    grade("A#{number}-", "C#{number}-")
    grade("A#{number}", "C#{number}")
    grade("A#{number}+", "C#{number}+")
    grade("A#{number}-#{number+1}", "C#{number}-#{number+1}")
  end
end

MountainProject::Rating::Protection = MountainProject::Rating::System.new do
  grade("G")
  grade("PG")
  grade("PG13")
  grade("R")
  grade("X")

  self.default_grade = self["PG"]
end
