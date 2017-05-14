module Wowza
  module REST
    class Applications

      def initialize(conn)
        @conn = conn
      end

      def all
        resp = conn.get('/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications')
        JSON.parse(resp.body)['applications'].map do |attrs|
          Application.new(parse_attributes(attrs)).tap do |app|
            app.conn = conn
          end
        end
      end

      def find(id)
        resp = conn.get("/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/#{id}")
        if resp.code == "200"
          attrs = JSON.parse(resp.body)
          Application.new( id: attrs["name"] ).tap do |app|
            app.conn = conn
          end
        else
          nil
        end
      end

      private
      def parse_attributes(attrs)
        {
          id: attrs["id"],
          href: attrs["href"],
          app_type: attrs["appType"],
          dvr_enabled: attrs["dvrEnabled"],
          drm_enabled: attrs["drmEnabled"],
          transcoder_enabled: attrs["transcoderEnabled"],
          stream_targets_enabled: attrs["streamTargetsEnabled"],
          http_cors_enabled: attrs["httpCORSHeadersEnabled"],
        }
      end
      attr_reader :conn
    end
  end
end
