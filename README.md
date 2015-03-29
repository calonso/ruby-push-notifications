# Ruby Push Notifications [![Build Status](https://travis-ci.org/calonso/ruby-push-notifications.svg)](https://travis-ci.org/calonso/ruby-push-notifications) [![Dependency Status](https://gemnasium.com/calonso/ruby-push-notifications.svg)](https://gemnasium.com/calonso/ruby-push-notifications)[![Gem Version](https://badge.fury.io/rb/ruby-push-notifications.svg)](http://badge.fury.io/rb/ruby-push-notifications)

###iOS and Android Push Notifications made easy!

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

## Pending tasks

Feel free to contribute!!

* Validate iOS notifications format and max size
* Validate iOS tokens format
* Validate GCM registration ids format
* Validate GCM notifications format and max size
* Split GCM notifications in parts if more than 1000 destinations are given (currently raising exception)

## Contributing

1. Fork it ( https://github.com/calonso/ruby-push-notifications/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
