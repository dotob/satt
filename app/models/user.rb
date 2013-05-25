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
  
  def get_favorites(menu)
    MenuItem.joins(:order_items => :user_order).select('menu_items.*, count(*) as anzahl').where("user_orders.user_id=#{self.id} AND menu_items.menu_id=#{menu.id}").group('menu_items.id').order('anzahl DESC').limit(5)
  end
end
