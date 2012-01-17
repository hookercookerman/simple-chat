# encoding: utf-8
require File.expand_path("../../acceptance_helper", __FILE__)

feature "Chat" do
  context "User is signed in" do
    background  do
      @user = FactoryGirl.create(:user, email:  "test@test.com", password: "testing123", password_confirmation: "testing123")
      @user.chat_channel.start_chat!
      sign_in(@user)
    end

    scenario "reciving a message from the admin", js: true do
      save_and_open_page
      page.execute_script(%Q(
        Pusher.dispatch('#{@user.chat_channel.name}', 'message', {'display_name': 'Hookercookerman', 'message':'Just testing', 'channel_name' : '#{@user.chat_channel.name}'});
      ))
      page.should have_content("Just testing")
      page.should have_content("Hookercookerman")
    end
  end
end
