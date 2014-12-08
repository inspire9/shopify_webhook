class ShopifyWebhook::Verifier
  def initialize(request, secret)
    @request, @secret = request, secret
  end

  def call
    hmac == header
  end

  private

  attr_reader :request, :secret

  def data
    request.body.rewind
    request.body.read
  end

  def header
    request.env['HTTP_X_SHOPIFY_HMAC_SHA256'] ||
    request.env['X-Shopify-Hmac-SHA256']
  end

  def hmac
    Base64.encode64(
      OpenSSL::HMAC.digest(digest, secret, data)
    ).strip
  end

  def digest
    OpenSSL::Digest.new 'sha256'
  end
end
