# frozen_string_literal: true

describe MountainProject::RouteRating do
  describe "creating from String" do
    subject { described_class["5.10a R"] }

    it "gets all the grades" do
      expect(subject.grades.first).to eq(MountainProject::Rating["5.10a"])
      expect(subject.grades.last).to eq(MountainProject::Rating["R"])
    end
  end

  describe "comparing with same systems" do
    it "works" do
      expect(described_class["5.10a"]).to be > described_class["5.9"]
      expect(described_class["5.10a"]).to be < described_class["5.11"]
    end

    it "works regardless of extra grades" do
      expect(described_class["5.10a R"]).to be > described_class["5.9"]
      expect(described_class["5.10a"]).to be < described_class["5.11 V14"]
    end
  end

  describe "with default system" do
    it "works" do
      expect(described_class["5.10a"]).to be > described_class["G"]
      expect(described_class["5.10a"]).to be < described_class["X"]
    end

    it "works both directions" do
      expect(described_class["G"]).to be < described_class["5.10a"]
      expect(described_class["X"]).to be > described_class["5.10a"]
    end
  end

  describe "with no common systems" do
    it "doesn't work" do
      expect {
        described_class["AI1"] < described_class["5.10a"]
      }.to raise_error(MountainProject::InvalidComparisonError)
    end
  end
end
