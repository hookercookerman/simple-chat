FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user, :aliases => [:creator] do
    email
    password "testing123"
    password_confirmation {password}
  end

  factory :chat_channel, :class => "Chat::Channel" do
    creator
  end

  factory :chat_message, :class => "Chat::Message" do
    creator
    body "this is a chat message of some kind dude"
    association :channel, :factory => :chat_channel
  end
end
