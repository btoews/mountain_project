# frozen_string_literal: true
require "terminal-table"

class MountainProject::Node < Struct
  # Hash of corrections for hash keys when using Node.from_hash.
  #
  # Returns a Hash, mapping "Struct field" => "Hash key"
  # (Eg. {:parent_id => :parentId}).
  def self.mappings
    @mappings ||= {}
  end

  # Register a key correction to be applied when using Node.from_hash.
  #
  # Example:
  #   map(parent_id: :parentId)
  #
  # Returns nothing.
  def self.map(hash)
    mappings.update(hash)
  end

  # Blocks that massage values
  #
  # Returns a Hash.
  def self.massages
    @massages ||= {}
  end

  # Massage values with the given key using the given block.
  #
  # key    - The Symbol key whose values we'll massage.
  # &block - The block that massages the value.
  #
  # Returns nothing.
  def self.massage(key, &block)
    massages[key] = block
  end

  # Instantiate a Struct from a Hash.
  #
  # hash   - A Hash.
  # kwargs - Optional keyword arguments.
  #
  # Returns a Node instance.
  def self.from_hash(hash)
    values = members.map do |key|
      key = mappings.fetch(key, key)
      value = hash[key.to_s]

      if value.nil? || !massages.key?(key)
        value
      else
        massages[key].call(value)
      end
    end

    new(*values)
  end

  # Make a Terminal::Table from the given Nodes.
  #
  # nodes - An Array of Node instances.
  #
  # Returns a Terminal::Table instance.
  def self.table(nodes)
    Terminal::Table.new(
      :headings => table_headings,
      :rows => nodes.map(&:table_row)
    )
  end

  # Headings to use for our table.
  #
  # Returns an Array of Strings.
  def self.table_headings
    ["Title"]
  end

  # Values for a row in our table.
  #
  # Returns an Array of Objects.
  def table_row
    [title]
  end

  # A description of this type of node.
  #
  # Returns a Symbol.
  def node_type
    raise MountainProject::ImplementMe
  end

  # Try getting the value of a field that may or may not exist in thie Node.
  #
  # field - The Symbol field to look for.
  #
  # Returns the field's value or nil.
  def try(field)
    respond_to?(field) ? send(field) : nil
  end

  # Does this node match all conditions?
  #
  # conditions - A Hash, mapping {field => value}.
  #                - If `value` is a Regexp, we consider it a match if the
  #                  Node's value matches the Regexp. For example, if
  #                  `conditions` is `{title: /Foo/}`, we'll call it a match if
  #                  `self.title =~ /Foo/`.
  #                - If `value` is an Array, we treat it as
  #                  [operator, compared_value]. We apply the operator to the
  #                  Node's field, using the `compared_value` as an argument.
  #                  For example, if `conditions` is {stars: [:>=, 4]}, we'll
  #                  call it a match if `self.stars >= 4`.
  #                - Otherwise, we'll consider it a match if the Node's value is
  #                  an exact match for value. For example, if `conditions` is
  #                  `{title: "Foo"}`, we'll call it a match if
  #                  `self.title == "foo"`
  #
  # Returns boolean.
  def match?(conditions)
    conditions.all? do |field, value|
      return false unless this_value = try(field)

      begin
        case value
        when Regexp
          # areas[title: /Potrero/]
          this_value =~ value
        when Array
          # areas[rating: [:>=, R['5.10a']]]
          operator, value = value
          this_value.send(operator, value)
        else
          # areas[title: 'Colorado']
          this_value == value
        end
      rescue MountainProject::InvalidComparisonError
        false
      end
    end
  end

  # Represent as a String.
  #
  # Returns a String.
  def inspect
    title
  end

  # Represent as a String.
  #
  # Returns a String.
  def to_s
    title
  end
end
