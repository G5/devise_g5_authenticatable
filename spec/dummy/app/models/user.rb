class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :database_authenticatable,
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me
  # attr_accessible :title, :body
end
