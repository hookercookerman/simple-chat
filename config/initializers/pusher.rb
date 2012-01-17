require 'pusher'
Pusher.logger = Rails.logger
 
# Set your pusher API credentials here
Pusher.app_id = SimpleChat[:pusher_app_id]
Pusher.key = SimpleChat[:pusher_key]
Pusher.secret = SimpleChat[:pusher_secret]

# == Async is all the Rage so lets do it
require "eventmachine"
require "em-http"

module SimpleChat
  def self.start
    Thread.new { EM.run }
    die_gracefully_on_signal
  end

  def self.die_gracefully_on_signal
    Signal.trap("INT")  { EM.stop }
    Signal.trap("TERM") { EM.stop }
  end
end
SimpleChat.start

