# frozen_string_literal: true
require "tmpdir"

describe MountainProject::Session do
  subject { test_session }

  describe "#packages" do
    it "works" do
      expect(subject.packages).to eq(
        "Foo" => {
          "Bar" => 2345,
          "Baz" => 3456
        },
        "Asdf" => {
          "Qwer" => 5678,
          "Zxcv" => 7890
        }
      )
    end
  end

  describe "#http" do
    it "makes http requests" do
      expect(subject.http.get.status).to eq(200)
    end

    it "only sends Host/User-Agent headers" do
      response = subject.http.get
      headers = JSON.parse(response.body)["headers"].keys
      expect(headers.sort).to eq(%w(Host User-Agent))
    end

    it "follows redirects" do
      response = subject.http.get("/redirect-to?url=%2fget")
      expect(response.status).to eq(200)
    end

    it "decodes gzip" do
      response = subject.http.get("/gzip")
      expect { JSON.parse(response.body) }.not_to raise_error
    end
  end

  describe "#download_area_list" do
    let(:tmpdir)  { Dir.mktmpdir }
    let(:request) { MessagePack.unpack(File.read(subject.area_list_path)) }
    let(:params)  { request["args"] }
    let(:headers) { request["headers"] }

    subject {
      described_class.new(
        phone_id: test_phone_id, base_path: tmpdir, url: test_url
      )
    }

    before(:each) do
      subject.download_area_list
    end

    it "persists the file" do
      expect(File.exist?(subject.area_list_path)).to eq(true)
    end

    it "doesn't send extra headers" do
      expect(headers.keys.sort).to eq(%w(Host User-Agent))
    end

    it "sends the right headers" do
      expect(headers["Host"]).to eq("httpbin.org")
      expect(headers["User-Agent"]).to eq("Mountain Project 3.13")
    end

    it "doesn't send extra paramters" do
      expect(params.keys.sort).to eq(%w(action email os osVersion phoneId v))
    end

    it "sends the right parameters" do
      expect(params["action"]).to eq("getPackageList")
      expect(params["email"]).to eq("")
      expect(params["os"]).to eq("android")
      expect(params["osVersion"]).to eq("7.0")
      expect(params["v"]).to eq("52")
    end
  end

  describe "#download_area_list" do
    let(:id)      { 1234 }
    let(:tmpdir)  { Dir.mktmpdir }
    let(:request) { MessagePack.unpack(File.read(subject.package_path(id))) }
    let(:params)  { request["args"] }
    let(:headers) { request["headers"] }

    subject {
      described_class.new(
        phone_id: test_phone_id, base_path: tmpdir,  url: test_url
      )
    }

    before(:each) do
      subject.download_package(id, reload_selection: false)
    end

    it "persists the file" do
      expect(File.exist?(subject.package_path(id))).to eq(true)
    end

    it "doesn't send extra headers" do
      expect(headers.keys.sort).to eq(%w(Accept-Encoding Host Range User-Agent))
    end

    it "sends the right headers" do
      expect(headers["Accept-Encoding"]).to eq("gzip")
      expect(headers["Host"]).to eq("httpbin.org")
      expect(headers["Range"]).to eq("bytes=0-")
      expect(headers["User-Agent"]).to eq("Dalvik/2.1.0 (Linux; U; Android 7.0; Nexus 5X Build/N5D91L)")
    end

    it "doesn't send extra paramters" do
      expect(params.keys.sort).to eq(%w(action email id os osVersion phoneId v))
    end

    it "sends the right parameters" do
      expect(params["id"]).to eq(id.to_s)
      expect(params["action"]).to eq("getPackageData")
      expect(params["email"]).to eq("")
      expect(params["os"]).to eq("android")
      expect(params["osVersion"]).to eq("7.0")
      expect(params["v"]).to eq("52")
    end
  end
end
