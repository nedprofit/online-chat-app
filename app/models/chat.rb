class Chat < ApplicationRecord
  has_many :messages

  validates :title, presence: true
end
