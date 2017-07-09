class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :username, :case_sensitive => false
end
