class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :attendances, dependent: :destroy
  has_many :minutes, through: :attendances

  def login_name
    email.slice(/^[^@]+/)
  end
end
