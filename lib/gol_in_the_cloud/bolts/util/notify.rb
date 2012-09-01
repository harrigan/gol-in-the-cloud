require "pusher"

module Notify
  PUSHER_APP_ID = nil
  PUSHER_KEY = nil
  PUSHER_SECRET = nil
  
  def init_notify
    Pusher.app_id = PUSHER_APP_ID
    Pusher.key = PUSHER_KEY
    Pusher.secret = PUSHER_SECRET
  end
  
  def notify message
    Pusher["gol"].trigger! "update", message
  end
end
