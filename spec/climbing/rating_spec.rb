# frozen_string_literal: true

describe Climbing::Rating do
  let(:five_ten) { Climbing::Rating::YDS["5.10"] }

  it "can lookup grades with []" do
    expect(Climbing::Rating["5.10"]).to eq(five_ten)
  end
end
