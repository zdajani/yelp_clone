class Restaurant < ActiveRecord::Base
  include AsUserAssociationExtension
  
  has_many :reviews,
        -> { extending WithUserAssociationExtension },
        dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true
  validates :user_id, :presence => true
  
end
