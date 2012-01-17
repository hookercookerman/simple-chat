module Admin
  module Chat
    class MessagesController < ::Admin::BaseController
      before_filter :authenticate_admin!
      inherit_resources
      belongs_to :active_channel, :parent_class => ::Chat::Channel
      defaults :resource_class => ::Chat::Message, :instance_name => "message", :collection_name => "messages"
      custom_actions :collection => :writing_message

      def create
        @message = build_resource
        @message.creator = current_user
        create! do |success, failure| 
          success.html do
            if EM.reactor_running?
              EM.next_tick do 
                pusher = Pusher[@active_channel.name].trigger_async("message", @message.payload.to_json, params[:socket_id])
                pusher.errback do |error|
                  Rails.logger.error(error.message)
                end
              end
            else
              Pusher[@active_channel.name].trigger("message", @message.payload.to_json, params[:socket_id])
            end
            render :json => @message.payload.to_json
          end
          failure.html do
            render :json => @message.payload.merge(:message => "chat could not be created")
          end
        end
      end

    end
  end
end

