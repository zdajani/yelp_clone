class Restaurant < ActiveRecord::Base
  has_many :reviews
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true
  
  def build_with_user(attributes = {}, user)
    attributes[:user] ||= user
    reviews.build(attributes)
  end
  
end
