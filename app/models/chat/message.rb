module Chat
  class Message
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Paranoia

    # == fields
    field :body, type: String
  
    # == validations
    validates_presence_of :channel
    validates_presence_of :creator
    validates_presence_of :body
    validates_length_of :body, :within => 1..500
    validate :chat_is_online
  
    # == relations
    belongs_to :creator, :class_name => "User"
    belongs_to :channel, :class_name => "Chat::Channel"

    # == Callbacks
    after_create :update_channel

    # @return [Hash] a hash for a message payload
    def payload
      {
        message: body,
        avatar_url: creator.avatar_url,
        display_name: creator.display_name,
        channel_name: channel.name,
        created_at: created_at ? created_at.strftime('%D - %R') : Time.now.strftime('%R')
      }
    end
  
    protected
    def update_channel
      channel.inc(:message_count, 1)
      channel.set(:last_message_at, Time.now)
    end

    def chat_is_online
      errors.add "channel", "your chat is offline" if channel &&channel.offline?
    end
  end
end

