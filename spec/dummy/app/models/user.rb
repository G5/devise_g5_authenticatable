class User < ActiveRecord::Base
  # Include devise modules. Others available are:
  # :database_authenticatable, :recoverable
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me
  # attr_accessible :title, :body
end
