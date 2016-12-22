# frozen_string_literal: true

describe Climbing::Node do
  let(:session)   { test_session }
  let(:selection) { session.selection }
  let(:routes)    { selection[node_type: :route] }
  let(:route)     { routes.send(:selected_nodes).first }

  describe ".from_hash" do
    subject do
      Class.new(Climbing::Node.new(:foo, :bar)) do
        map(foo: :Foo)

        massage(:bar) { |raw| raw.reverse }
      end
    end

    it "maps keys" do
      expect(subject.from_hash(:Foo => 1).foo).to eq(1)
    end

    it "massages values" do
      expect(subject.from_hash(:bar => "asdf").bar).to eq("fdsa")
    end
  end

  subject { route }

  describe "#try" do
    it "returns field value if present" do
      expect(subject.try(:title)).to eq("Route One")
    end

    it "returns nil unless field present" do
      expect(subject.try(:foobar)).to be_nil
    end
  end

  describe "#match?" do
    it "works with Regexp" do
      expect(subject.match?(title: /One/)).to eq(true)
      expect(subject.match?(title: /Two/)).to eq(false)
    end

    it "works with Strings" do
      expect(subject.match?(title: "Route One")).to eq(true)
      expect(subject.match?(title: "Route Two")).to eq(false)
    end

    it "works with operators" do
      expect(subject.match?(stars: [:>=, 0])).to   eq(true)
      expect(subject.match?(stars: [:>=, 100])).to eq(false)
    end

    it "is false for missing field" do
      expect(subject.match?(foo: /Two/)).to       eq(false)
      expect(subject.match?(foo: "Route Two")).to eq(false)
      expect(subject.match?(foo: nil)).to         eq(false)
      expect(subject.match?(foo: [:>=, 100])).to  eq(false)
    end
  end
end
