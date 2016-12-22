# frozen_string_literal: true
require "base64"

module Climbing
  OBFUSCATION_KEY = [67, 111, 119, 112, 112, 77, 48, 105, 85, 67]

  # Deobfuscate a route/area's title.
  #
  # tin - The String title to deobfuscate.
  #
  # Returns a String.
  def self.deobfuscate(tin)
    raw  = Base64.decode64(tin[4..-1])
    tout = raw[0..9].bytes.zip(OBFUSCATION_KEY).map { |a,b| (a^b).chr }.join
    tout += (raw[10..-1] || "")
    tout.force_encoding('utf-8')
  end

  def self.obfuscate(tin)
    tout = tin[0..9].bytes.zip(OBFUSCATION_KEY).map { |a,b| (a^b).chr }.join
    tout += (tin[10..-1] || "")
    'XOR-' + Base64.strict_encode64(tout)
  end
end

require "climbing/errors"
require "climbing/gzip_response"
require "climbing/rating"
require "climbing/route_rating"
require "climbing/selection"
require "climbing/node"
require "climbing/route"
require "climbing/area"
require "climbing/session"
