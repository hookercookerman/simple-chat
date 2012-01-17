class Permission
  include Mongoid::Document

  # == validations
  validates_presence_of :role_id, :user_id
  validates_uniqueness_of :role_id, :scope => [:user_id]

  # == relations
  belongs_to :role, :index => true
  belongs_to :user, :index => true
end

