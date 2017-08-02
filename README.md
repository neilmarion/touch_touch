# TouchTouch

Record who touched whom without saving it in the database! This is using Redis instead.

### Installation

```sh
$ gem install touch_touch
```

### Usage

In your "toucher" ActiveRecord class:

```ruby
class AdminUser < ActiveRecord::Base
  include TouchTouch::Toucher

  # Lead is the "touchee" class
  # Choose to only store 5 at a time in the queue
  touch_alias :recently_searched, {class: Lead, limit: 5}
end
```

You can now do this:

```ruby
admin_user = AdminUser.first
lead = Lead.first
admin_user.recently_searched(lead)

# returns an array of recently searched leads
admin_user.recently_searched_leads
```

### Todos

- Lots

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
