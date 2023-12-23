class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :body, presence: true

  after_create_commit :send_notification

  private

  def send_notification
    ActionCable.server.broadcast "notifications", {
      chat_name: self.chat.title,
      message_body: self.body
    }
  end
end
