# zen\_ex

[Zendesk REST API](https://developer.zendesk.com/rest_api) client for Elixir

zen\_ex is composed of Models and Entities. See [Usage](#usage).

## Installation

Add `zen_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:zen_ex, "~> 0.5.0"}]
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
users = ZenEx.Model.User.list.entities

# Show user
user = ZenEx.Model.User.show(1)

# Create user
user = ZenEx.Model.User.create(%ZenEx.Entity.User{name: "otoyo", email: "otoyo@otoyo.com"})

# List tickets
collection = ZenEx.Model.Ticket.list(per_page: 100, sort_order: "desc")
tickets = collection.entities
next_tickets = collection |> ZenEx.Collection.next

# Show ticket
ticket = ZenEx.Model.Ticket.show(1)

# Create ticket
ticket = ZenEx.Model.Ticket.create(%ZenEx.Entity.Ticket{subject: "My printer is on fire!", description: "But no problem."})
```

See also under ZenEx.Model.

## Supporting multiple Zendesk configs
You may need to interact with more than one instance of Zendesk. In order to facilitate that there is a small override
that can be put into the Process dictionary that will tell it to look for config settings keyed against a class name.

For example:

config/config.exs
```
config :zen_ex,
  subdomain: System.get_env("ZENDESK_SUBDOMAIN"),
  user: System.get_env("ZENDESK_USER_EMAIL"),
  api_token: System.get_env("ZENDESK_API_TOKEN")

config :zen_ex, ZendeskAlt,
  subdomain: System.get_env("ZENDESK_ALT_SUBDOMAIN"),
  user: System.get_env("ZENDESK_ALT_USER_EMAIL"),
  api_token: System.get_env("ZENDESK_ALT_API_TOKEN")
```

Then whenever you want to use the alternate config, before using anything in the `zen_ex` library make sure to
add a line of code like the following:

```
Process.put(:zendesk_config_module, ZendeskAlt)
```

Anytime you use the zendesk library after that it will use the alternate config until you remove that process
dictionary entry. It is good practice to put it back when you are done.

```
Process.put(:zendesk_config_module, nil)
```

If you do not add a `:zendesk_config_module` key to the Process dictionary then it will continue to use the
default `zen_ex` config settings.

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
  - `search`
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
