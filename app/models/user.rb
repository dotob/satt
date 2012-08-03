class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_orders, :inverse_of => :user
  has_many :master_orders, :inverse_of => :user

  validates :name, :uniqueness => { :case_sensitive => false }, :presence => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
end
