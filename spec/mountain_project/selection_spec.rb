# frozen_string_literal: true

describe MountainProject::Selection do
  let(:session)   { test_session }
  let(:selection) { session.selection }
  let(:nodes)     { selection.send(:nodes) }

  subject { selection }

  describe "#initialize" do
    it "can take nodes_by_id argument" do
      nbid = {foo: :bar}
      selection = described_class.new(nodes_by_id: nbid)

      expect(selection.nodes_by_id).to eq(nbid)
      expect(selection.selected_node_ids).to eq(Set.new([:foo]))
    end

    it "calculates nodes_by_id if not provided" do
      s = Struct.new(:id)
      nodes = [s.new("One"), s.new("Two"), s.new("Three")]
      selection = described_class.new(nodes: nodes)

      expect(selection.nodes_by_id.keys).to   eq(nodes.map(&:id))
      expect(selection.nodes_by_id.values).to eq(nodes)
      expect(selection.selected_node_ids).to eq(Set.new(["One", "Two", "Three"]))
    end
  end
end
