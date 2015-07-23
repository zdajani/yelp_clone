class Restaurant < ActiveRecord::Base
  has_many :reviews,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true
  validates :user_id, :presence => true
  
  def destroy_as(user)
    return false unless self.user == user
    destroy
    true
  end
end
