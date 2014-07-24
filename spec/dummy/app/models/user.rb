class User < ActiveRecord::Base
  # Include devise modules. Others available are:
  # :database_authenticatable, :recoverable, :rememberable
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :trackable, :validatable,
         :g5_authenticatable
end
