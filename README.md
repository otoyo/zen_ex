# zen\_ex [![Build Status](https://travis-ci.org/otoyo/zen_ex.svg?branch=master)](https://travis-ci.org/otoyo/zen_ex)

[Zendesk REST API](https://developer.zendesk.com/rest_api) client for Elixir

zen\_ex is composed of Models and Entities. See [Usage](#usage).

## Installation

Add `zen_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:zen_ex, "~> 0.3.0"}]
end
```

Update your dependencies:

```sh
% mix deps.get
```

Add your Zendesk settings to your config:

```elixir
config :zen_ex,
  subdomain: "your-zendesk-subdomain",
  user: "otoyo@otoyo.com",
  api_token: "xxxx"
```

See also: [Generating a new API token](https://support.zendesk.com/hc/en-us/articles/226022787)

## Usage

```elixir
# List users
users = ZenEx.Model.User.list

# Show user
user = ZenEx.Model.User.show(1)

# Create user
user = ZenEx.Model.User.create(%ZenEx.Entity.User{name: "otoyo", email: "otoyo@otoyo.com"})

# List tickets
tickets = ZenEx.Model.Ticket.list

# Show ticket
ticket = ZenEx.Model.Ticket.show(1)

# Create ticket
ticket = ZenEx.Model.Ticket.create(%ZenEx.Entity.Ticket{subject: "My printer is on fire!", description: "But no problem."})
```

See also under ZenEx.Model.

## Supported API

### [Core API](https://developer.zendesk.com/rest_api/docs/core/introduction)

- Users
  - `list`
  - `show`
  - `create`
  - `update`
  - `create_or_update`
  - `destroy`
  - `create_many`
  - `update_many`
  - `create_or_update_many`
  - `destroy_many`
- Tickets
  - `list`
  - `show`
  - `create`
  - `update`
  - `destroy`
  - `create_many`
  - `update_many`
  - `destroy_many`
- Dynamic contents
  - `list`
  - `show`
  - `create`
  - `update`
  - `destroy`
- Variants of dynamic contents
  - `list`
  - `show`
  - `create`
  - `create_many`
  - `update`
  - `update_many`
  - `destroy`
- Locales
  - `show`
- Job statuses
  - `list`
  - `show`
  - `show_many`

### [Help Center API](https://developer.zendesk.com/rest_api/docs/help_center/introduction)

- Categories
  - `list`
  - `show`
  - `create`
  - `update`
  - `destroy`
- Sections
  - `list`
  - `show`
  - `create`
  - `update`
  - `destroy`
- Articles
  - `list`
  - `show`
  - `create`
  - `update`
  - `search`
  - `destroy`
- Translations
  - `list`
  - `list_missing`
  - `show`
  - `create`
  - `update`
  - `destroy`

## Contributing

Contributions are welcome ;)

## LICENSE

ZenEx is released under CC0-1.0 (see LICENSE).
