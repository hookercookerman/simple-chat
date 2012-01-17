# encoding: utf-8
require File.expand_path("../../../spec_helper", __FILE__)

describe "Chat::Channel" do
  it "should be cool from the factory" do
    expect {FactoryGirl.create :chat_channel}.to_not raise_error
  end

  context "when the channel is offline" do
    describe "#start_chat!" do
      let(:user) do
        FactoryGirl.create :user
      end

      let(:channel) do
        FactoryGirl.create :chat_channel, :creator => user
      end

      before(:each) do
        channel.start_chat!
      end

      it "should be in an online state " do
        channel.should be_online
      end
    end

    context "when the channel is 'online'" do
      describe "#end_chat!" do

        let(:user) do
          FactoryGirl.create :user
        end

        let(:channel) do
          FactoryGirl.create :chat_channel, :creator => user
        end

        before(:each) do
          channel.start_chat!
          channel.end_chat!
        end

        it "should be offline" do
          channel.should be_offline
        end

      end
    end
  end
end
