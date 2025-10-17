class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :reviews, dependent: :destroy
  has_many :books, through: :reviews

  def admin?
    admin
  end

  def banned?
    deleted_at.present?
  end

  def active
    deleted_at.nil?
  end

  def active=(value)
    self.deleted_at = value.to_s == '1' ? nil : Time.current
  end

  def initial
    username.first.upcase
  end
end
