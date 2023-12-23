class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    @message = @chat.messages.new(message_params.merge(user: current_user))
    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    else
      redirect_to @chat, alert: "Не удалось отправить сообщение"
    end
  end


  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end