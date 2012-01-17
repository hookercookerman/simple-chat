class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Concerns
  include Canable::Cans

  # == concerns 
  concerned_with :permission

  # == fields
  field :email, type: String

  # == index
  index :email, :unique => true
    
  # == Devise  
  devise :database_authenticatable, :registerable, :validatable

  # == Callbacks
  after_create :make_admin!

  # == relations
  has_many :chat_messages, :class_name => "Chat::Message", :foreign_key => "creator_id", :dependent => :destroy
  has_one :my_chat_channel, :foreign_key => "creator_id", :class_name => "Chat::Channel", :dependent => :destroy
  
  def chat_channel
    @chat_channel ||= my_chat_channel.present? ? my_chat_channel : create_my_chat_channel
  end
  
  # @return [String] a string that replace the @ makes a name from it
  def display_name
    email.sub(/@.*/,'')
  end

  # @return [String] a string representing a gravatar for the given email
  def avatar_url
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png" 
  end

  protected
  def make_admin!
    self.has_role!(Role.admin)
  end

end


