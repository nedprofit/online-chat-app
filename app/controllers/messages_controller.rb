class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    @message = @chat.messages.new(message_params.merge(user: current_user))
    if @message.save
      respond_to do |format|
        format.turbo_stream do
          @message.broadcast_append_to "chat_#{@chat.id}",
                                       target: "messages_chat_#{@chat.id}",
                                       partial: "messages/message",
                                       locals: { message: @message, broadcast: true }
        end
        format.html { redirect_to @chat }
      end
    else
      redirect_to @chat, alert: "Не удалось отправить сообщение"
    end
  end

  def show
    @user = current_user
    @message = Message.find(params[:id])

    respond_to do |format|
      format.turbo_stream { render partial: 'messages/message', locals: { message: @message, user: @user } }
      format.html { render partial: 'messages/message', locals: { message: @message, user: @user } }
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