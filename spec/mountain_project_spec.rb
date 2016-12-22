# frozen_string_literal: true

describe MountainProject do
  let(:short)     { "foo" }
  let(:short_obf) { "XOR-JQAY" }
  let(:long)      { "foofoofoofoofoofoofoofoofoo" }
  let(:long_obf)  { "XOR-JQAYFh8iVgY6JW9vZm9vZm9vZm9vZm9vZm9v" }

  describe ".deobfuscate" do
    it "works on short strings" do
      expect(described_class.deobfuscate(short_obf)).to eq(short)
    end

    it "works on long strings" do
      expect(described_class.deobfuscate(long_obf)).to eq(long)
    end
  end

  describe ".obfuscate" do
    it "works on short strings" do
      expect(described_class.obfuscate(short)).to eq(short_obf)
    end

    it "works on long strings" do
      expect(described_class.obfuscate(long)).to eq(long_obf)
    end
  end
end
