module Api
  class ChatsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      @chats = Chat.all
      render json: @chats
    end
  end
end
