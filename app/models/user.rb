class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :username, :case_sensitive => false
  validates :username, :length => { :maximum => 20, :minimum => 3 }
  validates :display_name, :length => { :maximum => 20 }
  validates :description, :length => { :maximum => 350 }
  
    has_many :posts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    
    has_many :comments, dependent: :destroy
    
    
    has_attached_file :avatar, styles: { medium: "256x256#", thumb: "50x50#", small: "100x100#" }, default_url: "/blank.jpg"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
    def follow(other)
      active_relationships.create(followed_id: other.id)
    end
    
    def unfollow(other)
      active_relationships.find_by(followed_id: other.id).destroy
    end
    
    def following?(other)
      following.include?(other)
    end
    
end
