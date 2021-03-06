# frozen_string_literal: true

describe MountainProject::Rating::System do
  subject { MountainProject::Rating::YDS }

  it "collects systems on the System class" do
    expect(described_class.instances).to include(subject)
  end

  it "has grades" do
    expect(subject.grades).to be_an(Array)
    subject.grades.each do |grade|
      expect(grade).to be_a(MountainProject::Rating::Grade)
    end
  end

  it "can lookup grades by name" do
    expect(subject["5.10b"]).to be_a(MountainProject::Rating::Grade)
  end
end
