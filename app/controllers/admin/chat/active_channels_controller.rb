module Admin
  module Chat
    class ActiveChannelsController < ::Admin::BaseController
      before_filter :authenticate_admin!
      inherit_resources
      defaults :resource_class => ::Chat::Channel, :collection_name => "channels", :instance_name => "channel"
      custom_actions :collection => :auth
      protect_from_forgery :except => :auth # stop rails CSRF protection for this action
      
      def auth
        response = Pusher[params["channel_name"]].authenticate(params[:socket_id], {
          :user_id => current_user.id.to_s,
          :user_info => { 
            :display_name => current_user.display_name,
            :creator_id  => params["channel_name"].gsub("presence-user-",""),
            :avatar_url => current_user.avatar_url
            }
          })
        render :json => response
      end

      protected
      def collection
        @channels ||= end_of_association_chain.active
      end
      
    end
  end
end

