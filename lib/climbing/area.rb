# frozen_string_literal: true

class Climbing::Area < Climbing::Node.new(:title, :id, :parent_id)
  map(parent_id: :parentId)

  massage(:title) do |raw|
    if raw.start_with?("XOR")
      Climbing.deobfuscate(raw)
    else
      raw
    end
  end

  def node_type
    :area
  end
end
