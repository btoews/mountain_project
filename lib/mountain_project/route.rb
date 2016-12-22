# frozen_string_literal: true

class MountainProject::Route < MountainProject::Node.new(:package, :id, :title, :rating, :type, :pitches, :stars, :parent_id, :votes)

  # Fix Hash keys when using Route.from_hash.
  map(parent_id: :parentId)
  map(pitches:   :numPitches)
  map(votes:     :numVotes)

  # Fix Hash values when using Route.from_hash.
  massage(:title)       { |raw| MountainProject.deobfuscate(raw) }
  massage(:rating)      { |raw| MountainProject::RouteRating[raw] }
  massage(:numPitches)  { |raw| raw.to_i }
  massage(:stars)       { |raw| raw.to_f }
  massage(:numVotes)    { |raw| raw.to_i }

  # Headings to use for our table.
  #
  # Returns an Array of Strings.
  def self.table_headings
    ["Title", "Rating", "Stars (votes)", "Pitches"]
  end

  # Values for a row in our table.
  #
  # Returns an Array of Objects.
  def table_row
    [
      title,
      rating,
      star_string,
      pitches
    ]
  end

  # String representation of this route's stars.
  #
  # Returns a String.
  def star_string
    s = if votes > 0
      ("★" * stars.to_i) + " (#{votes})"
    else
      ""
    end

    # "★★★★★ (123)".length == 11
    "%-11s" % s
  end

  # Represent as a String.
  #
  # Returns a String.
  def inspect
    "#{rating} #{star_string} #{title}"
  end

  # Represent as a String.
  #
  # Returns a String.
  def to_s
    inspect
  end

  # A description of this type of node.
  #
  # Returns a Symbol.
  def node_type
    :route
  end
end
