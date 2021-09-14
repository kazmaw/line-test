require 'grape_logging'

module Line
  class API < Grape::API
    use GrapeLogging::Middleware::RequestLogger,
    instrumentation_key: 'grape_key',
    include: [ GrapeLogging::Loggers::Response.new,
              GrapeLogging::Loggers::FilterParameters.new,
              GrapeLogging::Loggers::RequestHeaders.new ]
    version 'v1', using: :header, vendor: 'line'
    format :json
    prefix :api

    # helpers do
    #   def current_user
    #     @current_user ||= User.authorize!(env)
    #   end

    #   def authenticate!
    #     error!('401 Unauthorized', 401) unless current_user
    #   end
    # end

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
        Rails.logger.info '-----'
        Rails.logger.info request.body.read
        User.all
      end
    end
  end
end