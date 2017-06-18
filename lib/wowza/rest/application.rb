module Wowza
  module REST
    class Application

      include Assignment::Attributes

      attr_accessor :id, :href, :app_type, :dvr_enabled, :drm_enabled,
        :transcoder_enabled, :stream_targets_enabled, :http_cors_enabled,
        :server_name, :vhost_name, :conn

      def initialize(attributes={})
        assign_attributes(attributes) if attributes
        super()
      end

      def attributes
        {
          id: id,
          href: href,
          app_type: app_type,
          dvr_enabled: dvr_enabled,
          drm_enabled: drm_enabled,
          transcoder_enabled: transcoder_enabled,
          stream_targets_enabled: stream_targets_enabled,
          http_cors_enabled: http_cors_enabled,
        }
      end

      def to_json
        {
          id: id,
          href: href,
          appType: app_type,
          dvrEnabled: dvr_enabled,
          drmEnabled: drm_enabled,
          transcoderEnabled: transcoder_enabled,
          streamTargetsEnabled: stream_targets_enabled,
          httpCORSHeadersEnabled: http_cors_enabled,
          # temp default securityConfig obj to allow remote streaming  
          securityConfig: {
            "clientStreamWriteAccess": "*",
            "publishRequirePassword": true,
            "publishAuthenticationMethod": "digest",
          }
        }.to_json
      end

      def create
        resp = conn.send(:post, href) do |req|
          req.body = to_json
        end
      end

      def destroy
        resp = conn.delete href
      end

      def instances
        Instances.new(conn, self)
      end

      def href
        if !@href && resource_path
          resource_path
        else
          @href
        end
      end

      def resource_path
        id && "#{vhost_path}/applications/#{id}"
      end

      def server_name
        @server_name || "_defaultServer_"
      end

      def server_path
        "/v2/servers/#{server_name}"
      end

      def vhost_name
        @vhost_name || "_defaultVHost_"
      end

      def vhost_path
        "#{server_path}/vhosts/#{vhost_name}"
      end

    end
  end
end
