module Line
  class API < Grape::API
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
        User.all
      end
    end
  end
end