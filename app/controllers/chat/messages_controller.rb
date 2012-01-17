module Chat
  class MessagesController < ApplicationController
    before_filter :authenticate_user!
    inherit_resources
    defaults :resource_class => Chat::Message, :collection_name => "messages", :instance_name => "message"

    def create
      @message = build_resource
      @message.channel = current_user.chat_channel
      @message.creator = current_user
      create! do |success, failure|
        success.html do
          if EM.reactor_running?
            EM.next_tick do
              pusher = Pusher[@message.channel.name].trigger_async("message", @message.payload.to_json, params[:socket_id])
              pusher.errback do |error|
                Rails.logger.error(error.message)
              end
            end
          else
            Pusher[@message.channel.name].trigger("message", @message.payload.to_json, params[:socket_id])
          end
          render :json => @message.payload.to_json
        end
        failure.html do
          render :json => @message.payload.merge(:message => "Message is a no gooer")
        end
      end
    end

  end
end

