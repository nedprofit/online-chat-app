class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @chats = pagy(Chat.all)
  end

  def show
    @chat = Chat.find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @chat = Chat.new

    case request.headers['Turbo-Frame']
    when 'modal'
      respond_to do |format|
        format.html { render partial: request.headers['partial'] }
      end
    else
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end

  def create
    @chat = Chat.new(chat_params)
    @pagy, @chats = pagy(Chat.all)

    if @chat.save
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    else
      render :new
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :description)
  end
end
