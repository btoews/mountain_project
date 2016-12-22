# frozen_string_literal: true

describe MountainProject::Rating do
  let(:five_ten) { MountainProject::Rating::YDS["5.10"] }

  it "can lookup grades with []" do
    expect(MountainProject::Rating["5.10"]).to eq(five_ten)
  end
end
