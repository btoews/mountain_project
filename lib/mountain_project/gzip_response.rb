# frozen_string_literal: true
require "zlib"

#
# This is largely borrowed from the faraday_middleware Gem, but they set a
# default Accept-Encoding header, which we don't want.
#

class MountainProject::GzipResponse
  GZIP             = "gzip"
  XGZIP            = "application/x-gzip"
  ACCEPT_ENCODING  = "Accept-Encoding"
  CONTENT_ENCODING = "Content-Encoding"
  CONTENT_LENGTH   = "Content-Length"
  CONTENT_TYPE     = "Content-Type"

  def initialize(app)
    @app = app
  end

  def call(req_env)
    @app.call(req_env).on_complete do |resp_env|
      if gzip_response?(resp_env)
        resp_env[:body] = uncompress_gzip(resp_env[:body])
        resp_env[:response_headers].delete(CONTENT_ENCODING)
        resp_env[:response_headers][CONTENT_LENGTH] = resp_env[:body].length
      end
    end
  end

  def gzip_response?(env)
    env[:response_headers][CONTENT_ENCODING] == GZIP ||
      env[:response_headers][CONTENT_TYPE] == XGZIP
  end

  def uncompress_gzip(body)
    io = StringIO.new(body)
    gzip_reader = Zlib::GzipReader.new(io)
    gzip_reader.read
  end
end
