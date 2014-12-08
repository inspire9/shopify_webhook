class ShopifyWebhook::Endpoint
  delegate :instrument, to: ActiveSupport::Notifications

  def call(env)
    request = Rack::Request.new env

    instrument 'notification.shopify.webhook', json: json(request)

    [200, {}, ['']]
  end

  def json(request)
    request.body.rewind
    MultiJson.load request.body.read
  end
end
