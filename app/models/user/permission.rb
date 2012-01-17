# super simple Permissions
class User
  ADMIN_ROLE = "admin".freeze

  # == relations
  has_many :permissions
  
  def admin?
    roles.map(&:name).include?(ADMIN_ROLE)
  end

  def has_role?(role)
    role_ids = roles.collect{ |r| r.id }
    role_ids.include?(role.id)
  end
    
  def has_role!(role)
    permissions.create(:role => role)
  end

  def remove_role!(role)
    role = permissions.where(:role_id => role.id).first
    role && role.destroy
  end

  def roles
    permissions.map(&:role)
  end
end
