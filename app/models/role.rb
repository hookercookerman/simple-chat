# Simple simple Roles
class Role
  include Mongoid::Document
  
  # == fields
  field :name
  field :display_name

  # == validations
  validates_presence_of :name
  
  # == Relations
  has_many :permissions
  
  def display_name
    read_attribute(:display_name) ? read_attribute(:display_name) : name
  end
  
  def self.admin
    Role.find_or_create_by(:name => "admin")
  end
end

