class Admin < ActiveRecord::Base
  devise :g5_authenticatable, :registerable, :trackable, :validatable
end
