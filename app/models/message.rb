class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  after_create_commit :send_notification

  def send_notification
    ActionCable.server.broadcast "notifications", {
      chat_name: self.chat.title,
      message_body: self.body
    }
  end
end
