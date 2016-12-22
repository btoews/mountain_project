# frozen_string_literal: true

class MountainProject::Selection
  attr_reader :nodes_by_id, :selected_node_ids, :index

  # Initialize a new Selection.
  #
  # nodes:             - An Array or Set of Node instances (optional).
  # nodes_by_id:       - A Hash, indexing Node instances by their #id.
  # selected_node_ids: - An Array or Set of Integer Node#id values.
  #
  # Returns nothing.
  def initialize(nodes: [], nodes_by_id: nil, selected_node_ids: nil)
    @nodes_by_id = nodes_by_id
    @nodes_by_id ||= nodes.reduce({}) { |h, n| h.update(n.id => n) }
    @selected_node_ids = selected_node_ids || Set.new(@nodes_by_id.keys)
  end

  # Lookup a subtree or subselection.
  #
  # conditions - If String, lookup highest subtree with this title. If Regexp,
  #              lookup highest subtree with title matching this. If Hash,
  #              lookup all matching nodes (See Node#match?).
  #
  # Returns a Selection instance.
  def [](conditions)
    case conditions
    when String, Regexp
      subtree_where(title: conditions)
    when Hash
      where(conditions)
    else
      raise InvalidConditionsError
    end
  end

  # Filter current selection to Nodes matching conditions.
  #
  # conditions - A Hash of conditions (See Node#match?).
  #
  # Returns a Selection instance.
  def where(conditions)
    new_selection = selected_nodes.select { |n| n.match?(conditions) }

    self.class.new(
      nodes_by_id: nodes_by_id,
      selected_node_ids: new_selection.map(&:id).to_set
    )
  end

  # Represent as String.
  #
  # Returns a String.
  def to_s
    inspect
  end

  # Represent as String.
  #
  # If all selected nodes are the same class, render a table. Otherwise, render
  # a tree.
  #
  # Returns a String.
  def inspect
    if empty?
      "No matching routes"
    elsif hemogenous?
      klass = nodes_by_id[selected_node_ids.first].class
      klass.table(selected_nodes).to_s
    else
      inspect_tree
    end
  end

  # Make a new selection including current selection and their ancestors.
  #
  # Returns a Selection instance.
  def add_ancestors
    new_selection = selected_node_ids.reduce(Set.new) do |s, id|
      s | with_ancestors(id)
    end

    self.class.new(
      nodes_by_id: nodes_by_id,
      selected_node_ids: new_selection
    )
  end
  alias_method :areas, :add_ancestors

  def routes
    where(node_type: :route)
  end

  # Make a new selection containing only n nodes.
  #
  # n - An Integer.
  #
  # Returns a Selection instance.
  def limit(n)
    new_selection = selected_nodes.first(n).map(&:id)

    self.class.new(
      nodes_by_id: nodes_by_id,
      selected_node_ids: new_selection
    )
  end

  # Make a new selection with the current selection sorted by some field.
  #
  # by       - A Symbol field to sort by.
  # reverse: - Whether to reverse the sorting.
  #
  # Returns a Selection instance.
  def sort(by, reverse: false)
    new_selection = selected_nodes.sort_by do |node|
      node.try(by)
    end.map(&:id)

    new_selection.reverse! if reverse

    self.class.new(
      nodes_by_id: nodes_by_id,
      selected_node_ids: new_selection
    )
  end

  # Are there no nodes in the selection?
  #
  # Returns bollean.
  def empty?
    selected_node_ids.empty?
  end

  private

  # Are all selected nodes of the same class?
  #
  # Returns boolean.
  def hemogenous?
    return true if empty?

    klass = nodes_by_id[selected_node_ids.first].class
    selected_nodes.all? { |n| n.class == klass }
  end

  # Represent the selection as a tree.
  #
  # tree_hash   - The Hash tree to represent.
  # indentation - String with which to indent each line of output.
  #
  # Returns a String.
  def inspect_tree(tree_hash=tree, indentation="")
    parts = []
    tree_hash.each do |id, subtree|
      parts << indentation + nodes_by_id[id].to_s
      unless subtree.empty?
        parts << inspect_tree(subtree, indentation + "    ")
      end
    end

    unless parts.empty?
      parts.compact.join("\n")
    end
  end

  # All Nodes, regardless of selection.
  #
  # Returns an Array of Node instances.
  def nodes
    nodes_by_id.values
  end

  # Selected nodes.
  #
  # Returns an Array of Node instances.
  def selected_nodes
    nodes_by_id.values_at(*selected_node_ids)
  end

  # Find the highest node matching conditions and make a new selection including
  # all its ancestors.
  #
  # conditions - A Hash of conditions (See Node#match?).
  #
  # Returns a Selection instance.
  def subtree_where(conditions)
    breadth_traverse do |id, subtree|
      node = nodes_by_id[id]
      if node.match?(conditions)
        return self.class.new(
          nodes_by_id: nodes_by_id,
          selected_node_ids: flatten_tree(subtree)
        )
      end
    end
  end

  # Traverse the tree, breadth first.
  #
  # Returns nothing. Yields [Node, Hash] for each selected Node.
  def breadth_traverse
    next_trees = [tree]

    while next_trees.any? do
      trees = next_trees
      next_trees = []

      trees.each do |t|
        t.each do |id, nodes|
          yield([id, nodes])
          next_trees << nodes
        end
      end
    end
  end

  # Get all the ids from a tree Hash.
  #
  # subtree - A tree Hash.
  #
  # Returns a Set of Node IDs.
  def flatten_tree(subtree)
    subtree.reduce(Set.new) do |ids, (id, subsubtree)|
      ids.add(id)
      ids | flatten_tree(subsubtree)
    end
  end

  # The selection represented as a tree.
  #
  # Returns a nested Hash, indexing "Node ID" => "Children Hash".
  def tree
    @tree ||= build_tree
  end

  # Build a tree Hash from selected Nodes.
  #
  # Returns a nested Hash, indexing "Node ID" => "Children Hash".
  def build_tree
    roots = Set.new
    hash = {}
    nodes = selected_nodes

    nodes.each do |node|
      loop do
        hash[node.id] ||= {}
        if hash.key?(node.parent_id)
          # Another loop has already added our parent. Add ourself to its hash
          # and break early.
          hash[node.parent_id][node.id] = hash[node.id]
          break
        else
          if selected_node_ids.include?(node.parent_id)
            # Our parent is a selected node. Add a hash for it and add ourself
            # to that. Keep looping to add our parent's parent.
            hash[node.parent_id] = {}
            hash[node.parent_id][node.id] = hash[node.id]
            node = nodes_by_id[node.parent_id]
          else
            # Our parent isn't selected, so we must be a root.
            roots.add(node.id)
            break
          end
        end
      end
    end

    hash.keep_if { |k, _| roots.include?(k) }
  end

  # Get the ancestors of a given node.
  #
  # id - The ID of the Node.
  #
  # Returns a Set including the provided ID and all its ancestors' IDs.
  def with_ancestors(id)
    ids = Set.new
    while node = nodes_by_id[id]
      ids.add(node.id)
      id = node.parent_id
    end
    ids
  end
end
