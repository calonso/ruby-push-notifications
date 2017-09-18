# Ruby Push Notifications

[![Build Status](https://travis-ci.org/calonso/ruby-push-notifications.svg)](https://travis-ci.org/calonso/ruby-push-notifications) [![Dependency Status](https://gemnasium.com/calonso/ruby-push-notifications.svg)](https://gemnasium.com/calonso/ruby-push-notifications) [![Code Climate](https://codeclimate.com/github/calonso/ruby-push-notifications/badges/gpa.svg)](https://codeclimate.com/github/calonso/ruby-push-notifications) [![Test Coverage](https://codeclimate.com/github/calonso/ruby-push-notifications/badges/coverage.svg)](https://codeclimate.com/github/calonso/ruby-push-notifications) [![Gem Version](https://badge.fury.io/rb/ruby-push-notifications.svg)](http://badge.fury.io/rb/ruby-push-notifications) [![Join the chat at https://gitter.im/calonso/ruby-push-notifications](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/calonso/ruby-push-notifications?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### iOS, Android and Windows Phone Push Notifications made easy!

## Features

* iOS and Android support
* Complete error and retry management
* Easy and intuitive API

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-push-notifications'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-push-notifications

## Usage

**Ruby Push Notifications** gem usage is really easy.

1. After installing, require the gem
2. Create one or more notifications
3. Create the corresponding `pusher`
4. Push!!
5. Get feedback

For completely detailed examples:

1. [Apple iOS example](https://github.com/calonso/ruby-push-notifications/tree/master/examples/apns.rb)
2. [Google Android example](https://github.com/calonso/ruby-push-notifications/tree/master/examples/gcm.rb)
3. [Windows Phone(MPNS) example](https://github.com/calonso/ruby-push-notifications/tree/master/examples/mpns.rb)
4. [Windows Phone(WNS) example](https://github.com/calonso/ruby-push-notifications/tree/master/examples/wns.rb)

## Pending tasks

Feel free to contribute!!

* Validate iOS notifications format and max size
* Validate iOS tokens format
* Validate GCM registration ids format
* Validate GCM notifications format and max size
* Split GCM notifications in parts if more than 1000 destinations are given (currently raising exception)
* Integrate with APNS Feedback service
* Validate MPNS notifications format
* Validate MPNS data
* Add other platforms (Amazon Fire...)

## Contributing

1. Fork it ( https://github.com/calonso/ruby-push-notifications/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Troubleshooting

**If you see "255 Unknown Error" error code**

This error code is assigned when the connection to push notification server wasn't successful
<a href="https://github.com/calonso/ruby-push-notifications/blob/master/lib/ruby-push-notifications/apns/apns_pusher.rb#L56-L58">255 UNKnown Error code</a>

Checking your connection configuration for example with APNS connection.
When your pem file and token are development make sure you configure the pusher for sandbox mode
``` RubyPushNotifications::APNS::APNSPusher.new('the certificate', true)) ```

or when your pem file and token are production you should configure the pusher for production mode (Set the sandbox mode to false when creating your pusher)
``` RubyPushNotifications::APNS::APNSPusher.new('the certificate', false)) ```

## Changelog

Refer to the [CHANGELOG.md](https://github.com/calonso/ruby-push-notifications/blob/master/CHANGELOG.md) file for detailed changes across versions.
