# Zendex [![Build Status](https://travis-ci.org/otoyo/zendex.svg?branch=master)](https://travis-ci.org/otoyo/zendex)

[Zendesk REST API](https://developer.zendesk.com/rest_api) client for Elixir

## Installation

Add `zendex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:zendex, github: "otoyo/zendex"}]
end
```

Update your dependencies:

```sh
% mix deps.get
```

Add your Zendesk settings to your config:

```elixir
config :zendex,
  subdomain: "your-zendesk-subdomain",
  user: "otoyo@otoyo.com",
  api_token: "xxxx"
```

See also: [Generating a new API token](https://support.zendesk.com/hc/en-us/articles/226022787)

## Usage

```elixir
# List users
users = Zendex.Model.User.list

# Show user
user = Zendex.Model.User.show(1)

# Create user
user = Zendex.Model.User.create(%Zendex.Entity.User{name: "otoyo", email: "otoyo@otoyo.com"})

# List tickets
tickets = Zendex.Model.Ticket.list

# Show ticket
ticket = Zendex.Model.Ticket.show(1)

# Create ticket
ticket = Zendex.Model.Ticket.create(%Zendex.Entity.Ticket{subject: "My printer is on fire!", description: "But no problem."})
```

See also under Zendex.Model.

## Supported API

- `User`
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
- `Ticket`
  - `list`
  - `show`
  - `create`
  - `update`
  - `destroy`
  - `create_many`
  - `update_many`
  - `destroy_many`
- `JobStatus`
  - `list`
  - `show`
  - `show_many`

## Contributing

Contributions are welcome ;)

## LICENSE

Zendex is released under CC0-1.0 (see LICENSE).
