# Cancando
[![Gem Version](https://badge.fury.io/rb/cancando.svg)](https://badge.fury.io/rb/cancando)

Helper for [Cancancan](https://github.com/CanCanCommunity/cancancan) gem.

Increase `accessible_by` query performance via ability merging.

If your app have more than one ability declaration for one resource
```ruby
can :index, User, id: [1, 2, 3]
can :index, User, id: [4, 5, 6]
```
`User.accessible_by(ability, :index)` generates sql query like that:
```sql
SELECT users.* FROM users WHERE (users.id IN (4, 5, 6)) OR (users.id IN (1, 2, 3))
```

In case of big data that fact causes significant performance issue.

Cancando helps to avoid that situation by merging conditions:
```ruby
can :index, User, id: [1, 2, 3, 4, 5, 6]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cancando'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cancando

## Usage

Important. You have to install [Cancancan](https://github.com/CanCanCommunity/cancancan) gem first.

1) Add `include Cancando`
2) User `can_do` and `cannot_do` instead of `can` and `cannot` from cancancan
3) Call `apply` for merge and save abilities

Simple example:
```ruby
class Permission
  include Cancando
  
  def grant_permission
    can_do :index, User, company_id: available_company_ids
    can_do :update, Company, id: current_user.company_id
    apply
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viktormarkov/cancando. This project is intended to be a safe, welcoming space for collaboration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
