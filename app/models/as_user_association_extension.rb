module AsUserAssociationExtension
  def created_by?(user)
    self.user == user
  end

  def destroy_as(user)
    unless created_by? user
      errors.add(:user, 'cannot delete this restaurant')
    return false
    end
    
    destroy
  end
  
  def update_as(user, attributes = {})
    unless created_by? user
      errors.add(:user, 'cannot edit this restaurant')
    return false
    end
    
    update(attributes)
  end
  
end
