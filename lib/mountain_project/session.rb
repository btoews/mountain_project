# frozen_string_literal: true
require "msgpack"
require "json"
require "securerandom"
require "faraday"
require "faraday_middleware"

class MountainProject::Session
  attr_reader :nodes, :selection, :url, :phone_id, :base_path, :packages

  DEFAULT_URL  = "https://www.mountainproject.com/api.php"
  DEFAULT_PATH = File.expand_path(File.join(__FILE__, "../../../data"))

  # Initialize a new Session.
  #
  # url:      - The String URL of the server to use (optional).
  # path:     - The String path to persist data at (optional).
  # phone_id: - The phone-id to send to the server (optional).
  #
  # Returns nothing.
  def initialize(url: DEFAULT_URL, base_path: DEFAULT_PATH, phone_id: SecureRandom.uuid)
    @url = url
    @base_path = base_path
    @phone_id = phone_id
  end

  # Download and persist an package from the server.
  #
  # id - The Integer ID of the package.
  #
  # Returns nothing.
  def download_package(id, reload_selection: true)
    resp = http.get do |req|
      req.params = default_params.merge(
        "action" => "getPackageData",
        "id"     => id
      )

      req.headers = {
        "Range"           => "bytes=0-",
        "Accept-Encoding" => "gzip",
        "User-Agent"      => "Dalvik/2.1.0 (Linux; U; Android 7.0; Nexus 5X Build/N5D91L)"
      }
    end

    File.open(package_path(id), "w") do |f|
      json = resp.body
      ruby = JSON.parse(json)
      msgpack = MessagePack.pack(ruby)
      f.write(msgpack)
    end

    load_data if reload_selection

    true
  end

  def load_data
    download_area_list unless File.exist?(area_list_path)

    @nodes = []
    @packages = {}

    al_data = MessagePack.unpack(File.read(area_list_path))
    al_data["topAreas"].each do |ta_hash|
      ta_title = ta_hash["title"]
      ta_id = make_id(ta_title)
      packages[ta_title] = {}

      nodes << MountainProject::Area.from_hash(ta_hash.merge(
        "id"       => ta_id,
        "parentId" => nil
      ))

      ta_hash["packages"].each do |p_hash|
        p_title = p_hash["title"]
        p_id = p_hash["id"]
        p_path = package_path(p_id)
        packages[ta_title][p_title] = p_id

        if File.exist?(p_path)
          p_data = MessagePack.unpack(File.read(p_path))

          p_data["areas"].each do |a_hash|
            a_hash["parentId"] = ta_id if a_hash["parentId"] == 0
            nodes << MountainProject::Area.from_hash(a_hash)
          end

          p_data["routes"].each do |r_hash|
            nodes << MountainProject::Route.from_hash(r_hash)
          end
        end
      end
    end

    @selection = MountainProject::Selection.new(nodes: nodes)
  end

  # Make a fake ID for an area, based on its name.
  #
  # *strings - One or more Strings, describing the area.
  #
  # Returns an Integer ID.
  def make_id(*strings)
    Digest::SHA1.hexdigest(strings.join(";"))[0..16].to_i(16)
  end

  # Path to the persisted area list.
  #
  # Returns a String path.
  def area_list_path
    File.join(base_path, "area_list")
  end

  # Path to a persisted package.
  #
  # id - The Integer ID of the package.
  #
  # Returns a String path.
  def package_path(id)
    File.join(base_path, "area_#{id}")
  end

  # Download and persist an area list from the server.
  #
  # Returns nothing.
  def download_area_list
    resp = http.get do |req|
      req.params = default_params.merge("action" => "getPackageList")
      req.headers = {"User-Agent" => "Mountain Project 3.13"}
    end

    File.open(area_list_path, "w") do |f|
      json = resp.body
      ruby = JSON.parse(json)
      msgpack = MessagePack.pack(ruby)
      f.write(msgpack)
    end
  end

  # HTTP client.
  #
  # Returns a Faraday::Connection instance.
  def http
    @http ||= Faraday::Connection.new(url: url) do |faraday|
      faraday.use MountainProject::GzipResponse
      faraday.use FaradayMiddleware::FollowRedirects

      # Excon doesn't send extra request headers.
      faraday.adapter(:excon)
    end
  end

  # Query parameters to send with every request to the server.
  #
  # Returns a Hash.
  def default_params
    {
      "email"     => "",
      "phoneId"   => phone_id,
      "v"         => "52",
      "osVersion" => "7.0",
      "os"        => "android"
    }
  end
end
