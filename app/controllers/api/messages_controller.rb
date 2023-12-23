module Api
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      @chat = Chat.find(params[:chat_id])
      # Здесь мы используем костыль с анонимным юзером
      user = User.find_by(email: "anonymous@example.com")
      @message = @chat.messages.create(message_params.merge(user: user))
      if @message.save
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:body)
    end
  end
end
