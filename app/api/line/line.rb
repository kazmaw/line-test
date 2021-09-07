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
      desc "user test"
      post do
        Rails.logger.info parmas[:replyToken]
        Rails.logger.info parmas[:replyToken].to_s
        User.all
      end
    end
  end
end