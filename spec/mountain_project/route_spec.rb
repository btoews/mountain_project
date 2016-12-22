# frozen_string_literal: true

describe MountainProject::Route do
  let(:session)   { test_session }
  let(:selection) { session.selection }
  let(:routes)    { selection[node_type: :route] }
  let(:route)     { routes.send(:selected_nodes).first }

  subject { route }

  it "is a Node" do
    expect(subject).to be_a(MountainProject::Node)
  end

  it "is a route" do
    expect(subject.node_type).to eq(:route)
  end

  it "has an ID" do
    expect(subject.id).to eq(5)
  end

  it "has a parent ID" do
    expect(subject.parent_id).to eq(2)
  end

  it "has a title" do
    expect(subject.title).to eq("Route One")
  end

  it "has pitches" do
    expect(subject.pitches).to eq(1)
  end

  it "has stars" do
    expect(subject.stars).to eq(4.0)
  end

  it "has votes" do
    expect(subject.votes).to eq(1)
  end

  it "has a rating" do
    expect(subject.rating).to eq(MountainProject::RouteRating["5.10b/c"])
  end

  it "converts to a nice string" do
    expect(subject.to_s).to eq("5.10b/c      ★★★★ (1)    Route One")
  end
end
