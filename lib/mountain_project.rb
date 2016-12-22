# frozen_string_literal: true
require "base64"

module MountainProject
  OBFUSCATION_KEY = [67, 111, 119, 112, 112, 77, 48, 105, 85, 67] + ([0] * 1000)

  # Deobfuscate a route/area's title.
  #
  # tin - The String title to deobfuscate.
  #
  # Returns a String.
  def self.deobfuscate(tin)
    raw  = Base64.decode64(tin[4..-1])
    raw.bytes.zip(OBFUSCATION_KEY).map { |a,b| a ^ b }.pack("U*")
  end

  def self.obfuscate(tin)
    tout = tin.bytes.zip(OBFUSCATION_KEY).map { |a,b| a ^ b }.pack("U*")
    'XOR-' + Base64.strict_encode64(tout)
  end
end

require "mountain_project/errors"
require "mountain_project/gzip_response"
require "mountain_project/rating"
require "mountain_project/route_rating"
require "mountain_project/selection"
require "mountain_project/node"
require "mountain_project/route"
require "mountain_project/area"
require "mountain_project/session"
