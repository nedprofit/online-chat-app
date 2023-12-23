class Rack::Attack
  # Ограничение количества запросов на создание сообщений
  throttle('api/messages', limit: 2, period: 1.minute) do |req|
    req.ip if req.path == '/api/messages' && req.post?
  end

  # Ограничение на получение списка чатов
  throttle('api/chats', limit: 2, period: 1.minute) do |req|
    req.ip if req.path == '/api/chats' && req.get?
  end

  # Ответ сервера на ограниченные запросы
  self.throttled_responder = lambda do |env|
    [429, # HTTP статус
     {'Content-Type' => 'application/json'},
     [{ error: "Throttle limit reached. Retry later." }.to_json]
    ]
  end
end
