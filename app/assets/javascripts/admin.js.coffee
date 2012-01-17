do ($ = jQuery) ->  
  class AdminChat
    @setup: (dev = true)->
      Pusher.channel_auth_endpoint = '/admin/chat/active_channels/auth';
      if dev
        Pusher.log = (message) ->
          if window.console && window.console.log
            window.console.log(message)
        WEB_SOCKET_DEBUG = true 
       
    @scrollToBottom: =>
      $('#chat_messages').animate
        'scrollTop' : $('#chat_messages')[0].scrollHeight
      
    constructor: (@pusherKey, @chat_id = "#admin_chat") ->
      @pusher = new Pusher(@pusherKey)
      @pusher.connection.bind 'connected', @connected
      @pusher.connection.bind 'disconnected', @disconnected

      if $(@chat_id).length
        @channel_name = $(@chat_id).attr("data-channel_name")
        @channel = @pusher.subscribe @channel_name
        @channel.bind "message", @receiveMessage
        @channel.bind "pusher:member_added", @userOnline
        @channel.bind "pusher:member_removed", @userOffline

    attachMessageBehaviour: =>
      $("#new_message").append("<input type='hidden' name='socket_id' value=#{@socket_id} />")
      $("#new_message #message_body").keypress (e) ->
        if e.which is 13
          $(@).focus()
          $("#new_message").submit()
          false

      $("#new_message").bind "submit", ->
        if !$("#new_message #message_body").val()
          false

      $("#new_message").bind "ajax:success", (evt, data, status, xhr) =>
        data = JSON.parse(data)
        $("#chat_messages").append("<li class='message'>
          <div class='sent'>
            <img src=#{data['avatar_url']} width='50px' height='50px'/><div class='display-name'>Me, #{data["created_at"]}</div>
            <div class='body'>#{data["message"]}</div>
          </div>
        </li>")
        $("#new_message #message_body").val("")
        AdminChat.scrollToBottom()
        
    userOnline: (member) =>
      $("#admin_chat").show()
      $("#chat_messages").css('opacity', 1)
      $("#chat_messages").append("<li class='message'><div class='notice'><img src=#{member["info"]['avatar_url']} width='50px' height='50px'/>#{member['info']['display_name']} is online to chat</div></li>")
      AdminChat.scrollToBottom()

    userOffline: (member) =>
      $("#admin_chat").show()
      $("#chat_messages").css('opacity', 1)
      $("#chat_messages").append("<li class='message'><div class='notice'><img src=#{member['info']['avatar_url']} width='50px' height='50px'/>#{member['info']['display_name']} is offline</div></li>")
      AdminChat.scrollToBottom()

    subscriptionError:  ->
      $("#chat_status_indicator").removeClass()
      $("#chat_status_indicator").addClass("error")
      $("#chat_messages").append("<li class='message'><div class='notice'>Sorry chat is Dead</div></li>")
      AdminChat.scrollToBottom()
      
    receiveMessage: (message) ->
      if not $("#admin_chat").is(":visible")
        $("#admin_chat").show()
      $("#chat_messages").append("<li class='message'>
        <div class='received'>
          <img src=#{message['avatar_url']} width='50px' height='50px'/><div class='display-name'>#{message['display_name']}, #{message["created_at"]}</div>
          <div class='body'>#{message["message"]}</div>
        </div>
      </li>")
      AdminChat.scrollToBottom()
      
    disconnected: (message) ->
      messageDom = $("<li class='message'><div class='notice'><img src=#{message['avatar_url']} width='50px' height='50px'/>#{message['message']}</div></li>")
      if $("#chat_messages")
        $("#chat_messages").append(messageDom)
        $("#chat_messages").css('opacity', 0.5)
        ClientChat.scrollToBottom()

    connected: =>
      @socket_id = @pusher.connection.socket_id
      @attachMessageBehaviour()

  $(document).ready ->
    if $("#admin_chat").length
      AdminChat.setup()
      admin = new AdminChat(PUSHER_KEY)
