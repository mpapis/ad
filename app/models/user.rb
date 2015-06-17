class User < ActiveRecord::Base
  has_many :posts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_owner_of(post)
    return self.email == post.user_id
  end
end
