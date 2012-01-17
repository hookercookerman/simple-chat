module Chat
  class Channel
    include Mongoid::Document
  
    # == fields
    field :name, type: String
    field :online_at, type: Time
    field :last_message_at, type: Time
    field :message_count, type: Integer, :default => 0
  
    # == validations
    validates_presence_of :name
    validates_presence_of :creator
  
    # == relations
    belongs_to :creator, :class_name => "User"
    has_many :messages, :class_name => "Chat::Message"
    
    # == scopes
    scope :active, where(:state.in => ["online"])
    scope :by_message_count, order_by([:messages_count, :desc])
    scope :by_last_message, order_by([:by_last_message, :desc])
  
    # == Callbacks
    before_validation :on => :create do
      create_channel_name
    end
    
    # == state machine
    state_machine :state, :initial => :offline do
      event :start_chat do
        transition :offline => :online
      end

      event :end_chat do
        transition [:online] => :offline
      end

      after_transition :offline => :online, :do => :move_online
      after_transition :online  => :offline, :do => :move_offline
    end

    protected
    def move_online
      update_attribute(:online_at, Time.now)
    end
  
    def move_offline
      update_attribute(:online_at, nil)
    end
  
    def create_channel_name
      if creator
        self.name = "presence-user-#{creator.id.to_s}"
      end
    end

  end
end

