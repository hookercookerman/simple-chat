module Chat
  class ChannelsController < ApplicationController
    before_filter :authenticate_user!
    protect_from_forgery :except => :auth # stop rails CSRF protection for this action
    
    # the rather need ractoring auth action yummy
    def auth
      if current_user
        @channel = current_user.chat_channel
        if @channel.name == params["channel_name"]
          response = Pusher[params["channel_name"]].authenticate(params[:socket_id], {
            :user_id => current_user.id.to_s,
            :user_info => {
              :display_name => current_user.display_name,
              :creator_id => current_user.id.to_s,
              :avatar_url => current_user.avatar_url
              }
            })
          render :json => response
        else
          render :text => "Not authorized", :status => '403'
        end
      else
        render :text => "Not authorized", :status => '403'
      end
    end

    def activate
      current_user.chat_channel.start_chat! unless current_user.chat_channel.online?
      render :nothing => true
    end

  end
end

