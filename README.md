# Shopify Webhook

A Rack endpoint for handling Shopify webhooks, and fires an ActiveSupport notification for each succesful request.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopify_webhook', '0.0.1'
```

## Usage

Mount an instance of `ShopifyWebhook::Endpoint` to your preferred route. In a Rails app, that'd look something like this:

```ruby
post '/shopify/webhook', to: ShopifyWebhook::Endpoint.new
```

Then, handle the notifications using something like the following (which would probably go in an initialiser for a Rails app):

```ruby
ActiveSupport::Notifications.subscribe(
  'notification.shopify.webhook'
) do |*args|
  event = ActiveSupport::Notifications::Event.new *args
  # use event.payload[:json] however you like.
end
```

## Contributing

1. Fork it ( https://github.com/inspire9/shopify_webhook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

Copyright (c) 2014, Shopify Webhook is developed and maintained by [Inspire9](http://development.inspire9.com), and is released under the open MIT Licence.
