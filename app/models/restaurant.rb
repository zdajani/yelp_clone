class Restaurant < ActiveRecord::Base
  has_many :reviews,
        -> { extending WithUserAssociationExtension },
        dependent: :restrict_with_exception
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true
  validates :user_id, :presence => true
end
