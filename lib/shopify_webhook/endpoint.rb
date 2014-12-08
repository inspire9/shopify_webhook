class ShopifyWebhook::Endpoint
  delegate :instrument, to: ActiveSupport::Notifications

  def initialize(secret)
    @secret = secret
  end

  def call(env)
    request = Rack::Request.new env

    if ShopifyWebhook::Verifier.new(request, secret).call
      instrument 'notification.shopify.webhook', json: json(request)
      [200, {}, ['']]
    else
      [400, {}, ['']]
    end
  end

  private

  attr_reader :secret

  def json(request)
    request.body.rewind
    MultiJson.load request.body.read
  end
end
