# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = Chat.all
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to chats_path
    else
      render :new
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
