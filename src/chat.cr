require "./chat/*"
require "kemal"

module Chat
  SOCKETS = [] of HTTP::WebSocket

  # You can easily access the context and set content_type like 'application/json'.
  # Look how easy to build a JSON serving API.
  get "/" do |env|
    render "views/index.ecr"
  end

  ws "/chat" do |socket|
    # Add the client to SOCKETS list
    SOCKETS << socket

    # Broadcast each message to all clients
    socket.on_message do |message|
      SOCKETS.each { |socket| socket.send message }
    end

    # Remove clients from the list when it's closed
    socket.on_close do
      SOCKETS.delete socket
    end
  end

  Kemal.run
end
