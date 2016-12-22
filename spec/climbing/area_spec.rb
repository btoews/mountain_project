# frozen_string_literal: true

describe Climbing::Route do
  let(:session)    { test_session }
  let(:selection)  { session.selection }
  let(:area_title) { "Area Two" }
  let(:area_id)    { selection[title: area_title].send(:tree).keys.first }
  let(:area)       { selection.nodes_by_id[area_id] }

  subject { area }

  it "is a Node" do
    expect(subject).to be_a(Climbing::Node)
  end

  it "is an area" do
    expect(subject.node_type).to eq(:area)
  end

  it "has a title" do
    expect(subject.title).to eq(area_title)
  end

  it "has an ID" do
    expect(subject.id).to eq(area_id)
  end

  it "has a parent ID" do
    expect(subject.parent_id).to eq(1)
  end

  it "converts to a nice string" do
    expect(subject.to_s).to eq(area_title)
  end
end
