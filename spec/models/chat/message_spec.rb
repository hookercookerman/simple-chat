# encoding: utf-8
require File.expand_path("../../../spec_helper", __FILE__)

describe "Chat::Message" do
  describe "Creating A Message" do
    let(:user) do
      FactoryGirl.create :user
    end

    let(:channel) do
      channel = FactoryGirl.create :chat_channel
      channel.start_chat!
      channel
    end

    let!(:message) do
      @time = Time.now
      Timecop.freeze(@time)
      FactoryGirl.create :chat_message, :channel => channel, :creator => user
    end

    it "should update the message count on the channel" do
      channel.message_count.should be(1)
    end

    it "should set the lastest message date on the channel from when message was created" do
      channel.last_message_at.to_i.should == @time.to_i
    end
  end

  describe "Creating A Message when chat is offline" do
    let(:message) do
      FactoryGirl.build :chat_message
    end

    it "Should not be valid" do
      message.should_not be_valid
    end
  end
end
