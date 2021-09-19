require 'grape_logging'

module API
  class Line < Grape::API
    version 'v1', using: :header, vendor: 'line'
    format :json
    prefix :api

    use GrapeLogging::Middleware::RequestLogger,
    instrumentation_key: 'grape_key',
    include: [ GrapeLogging::Loggers::Response.new,
              GrapeLogging::Loggers::FilterParameters.new,
              GrapeLogging::Loggers::RequestHeaders.new ]

    helpers do
      def authorize!
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        flg = line_client.validate_signature(request_body, signature)
        Rails.logger.info "test: #{flg}"
        unless flg
          error!('401 Unauthorized', 401)
        end
      end

      def line_client
        @line_client ||= ::Line::Bot::Client.new do |config|
          config.channel_id = Rails.application.credentials.line[:channel_id]
          config.channel_secret = Rails.application.credentials.line[:channel_secret]
          config.channel_token = Rails.application.credentials.line[:channel_token]
        end
      end

      def request_body
        request.body.read
      end
    end

    resource :messaging do
      desc "LINE Messaging API Webhook"
      # params do
      #   requires :destination, type: String
      #   requires :events, type: Array do
      #     requires :type, type: String
      #     optional :message, type: Hash do
      #       optional :type, type: String
      #       optional :id, type: String
      #       optional :text, type: String
      #     end
      #     optional :timestamp, type: Integer
      #     optional :source, type: Hash do
      #       optional :type, type: String
      #       optional :userId, type: String
      #     end
      #     optional :replyToken, type: String
      #     optional :mode, type: String
      #   end
      # end
      post do
        authorize!
        User.all
      end
    end
  end
end
