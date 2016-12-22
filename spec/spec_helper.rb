# frozen_string_literal: true
require "mountain_project"
require "vcr"

module SpecHelper

  def test_phone_id
    "1234"
  end

  def test_base_path
    File.expand_path(File.join(__FILE__, "../fixtures/resources"))
  end

  def test_url
    "https://httpbin.org/get"
  end

  def test_session
    @test_session ||= MountainProject::Session.new(
      phone_id:  test_phone_id,
      base_path: test_base_path,
      url:       test_url
    ).tap(&:load_data)
  end
end

RSpec.configure do |c|
  c.include SpecHelper
end

VCR.configure do |c|
  c.default_cassette_options = {record: :new_episodes}
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :faraday

  c.around_http_request do |request|
    VCR.use_cassette(request.uri, &request)
  end
end
