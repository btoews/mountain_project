# frozen_string_literal: true

class MountainProject::Area < MountainProject::Node.new(:title, :id, :parent_id)
  map(parent_id: :parentId)

  massage(:title) do |raw|
    if raw.start_with?("XOR")
      MountainProject.deobfuscate(raw)
    else
      raw
    end
  end

  def node_type
    :area
  end
end
