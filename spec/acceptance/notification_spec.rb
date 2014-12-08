require 'spec_helper'

RSpec.describe 'Shopify Notifications' do
  include Rack::Test::Methods

  let(:app)           { ShopifyWebhook::Endpoint.new 'SUPERSECRET' }
  let(:subscriptions) { [] }

  def subscribe(&block)
    subscriptions << ActiveSupport::Notifications.subscribe(
      'notification.shopify.webhook', &block
    )
  end

  def hmac_for(body)
    Base64.encode64(
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), 'SUPERSECRET', body)
    ).strip
  end

  def post_with_hmac(path, params, headers = {})
    post path, params, headers.merge(
      'HTTP_X_SHOPIFY_HMAC_SHA256' => hmac_for(params)
    )
  end

  after :each do
    subscriptions.each do |subscription|
      ActiveSupport::Notifications.unsubscribe(subscription)
    end
  end

  it 'returns a 200' do
    post_with_hmac '/', '[]'

    expect(last_response.status).to eq(200)
  end

  it 'fires an event' do
    notification = false
    subscribe { |*args| notification = true }

    post_with_hmac '/', '[]'

    expect(notification).to eq(true)
  end

  it 'includes the JSON body' do
    subscribe { |*args|
      event = ActiveSupport::Notifications::Event.new *args
      expect(event.payload[:json]).to eq([{'foo' => 'bar'}])
    }

    post_with_hmac '/', '[{"foo":"bar"}]'
  end

  it 'accepts a dashed HMAC header' do
    post '/', '[]', {'X-Shopify-Hmac-SHA256' => hmac_for('[]')}

    expect(last_response.status).to eq(200)
  end

  context 'with invalid HMAC' do
    it 'returns a 400' do
      post '/', '[]'

      expect(last_response.status).to eq(400)
    end

    it 'does not fire an event' do
      notification = false
      subscribe { |*args| notification = true }

      post '/', '[]'

      expect(notification).to eq(false)
    end
  end
end
