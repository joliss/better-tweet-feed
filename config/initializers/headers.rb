module BetterTweetFeed
  module Rack
    class Headers
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        duration = nil
        if Rails.env.production?
          case env['REQUEST_PATH']
          when %r{\A/assets/.*-[0-9a-f]{32,}}
            duration = 1.month
          when %r{\A/favicon.ico\z}
            duration = 1.week
          else
            duration = 10.minutes
          end
        end

        headers['Date'] = Time.now.httpdate
        if duration
          headers['Expires'] = (duration == 0 ? '-1' : (Time.now + duration).httpdate)
          headers['Cache-Control'] = "public, max-age=#{duration.to_i}, must-revalidate"
        else
          headers['Pragma'] = 'no-cache'
          headers['Cache-Control'] = 'no-cache'
          headers['Expires'] = '-1'
          # Just to be sure, since sometimes ETag and Last-Modified headers are
          # messed up by Sprockets
          if Rails.env.development?
            headers.delete 'ETag'
            headers.delete 'Last-Modified'
          end
        end

        [status, headers, body]
      end
    end
  end
end
