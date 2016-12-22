# frozen_string_literal: true

describe MountainProject::Rating::Grade do
  let(:five_ten)     { MountainProject::Rating::YDS["5.10"] }
  let(:five_ten_a)   { MountainProject::Rating::YDS["5.10a"] }
  let(:five_ten_b)   { MountainProject::Rating::YDS["5.10b"] }
  let(:five_ten_b_c) { MountainProject::Rating::YDS["5.10b/c"] }
  let(:v0)           { MountainProject::Rating::Hueco["V0"] }

  it "has the right name" do
    expect(five_ten.name).to eq("5.10")
  end

  it "can be compared with another grade of the same system" do
    expect(five_ten_a).to be < five_ten_b
    expect(five_ten_b).to be > five_ten_a
  end

  it "can be compared to another grade of the same difficulty" do
    expect(five_ten_b_c).to eq(five_ten)
  end

  it "can't be compared to a grade of a different system" do
    expect {
      five_ten > v0
    }.to raise_error(MountainProject::InvalidComparisonError)
  end
end
