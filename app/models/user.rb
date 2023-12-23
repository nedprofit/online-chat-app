class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :messages

  has_one_attached :avatar

  after_initialize :set_default_language, if: :new_record?

  private

  def set_default_language
    self.language ||= 'ru'
  end
end
