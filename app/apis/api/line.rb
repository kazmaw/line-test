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
        unless line_client.validate_signature(request_body, signature)
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
      params do
        requires :destination, type: String
        requires :events, type: Array do
          requires :type, type: String
          optional :message, type: Hash do
            optional :type, type: String
            optional :id, type: String
            optional :text, type: String
          end
          optional :timestamp, type: Integer
          optional :source, type: Hash do
            optional :type, type: String
            optional :userId, type: String
          end
          optional :replyToken, type: String
          optional :mode, type: String
        end
      end
      post do
        authorize!
        events = line_client.parse_events_from(params.to_json)
        events.each do |event|
          case event
          when ::Line::Bot::Event::Message
            case event.type
            when ::Line::Bot::Event::MessageType::Text
              message = {
                "type": "template",
                "altText": "This is a buttons template",
                "template": {
                  "type": "buttons",
                  "imageBackgroundColor": "#FFFFFF",
                  "title": "Menu",
                  "text": "Please select",
                  "actions": [
                    {
                      "type": "message",
                      "label": "test message 1",
                      "text": "test message 1"
                    },
                    {
                      "type": "message",
                      "label": "test message 2",
                      "text": "test message 2"
                    },
                    {
                      "type": "message",
                      "label": "test message 3",
                      "text": "test message 3"
                    }
                  ]
                }
              }
              Rails.logger.info message
              line_client.reply_message(event['replyToken'], message)
            end
          end
        end
      end
    end
  end
end
