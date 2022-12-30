# zen_ex

[Zendesk REST API](https://developer.zendesk.com/rest_api) client for Elixir

zen_ex is composed of Models and Entities. See [Usage](#usage).

## Installation

Add `zen_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:zen_ex, "~> 0.8.0"}]
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
{:ok, %{entities: users}} = ZenEx.Model.User.list()

# Show user
{:ok, user} = ZenEx.Model.User.show(1)

# Create user
{:ok, user} = ZenEx.Model.User.create(%ZenEx.Entity.User{name: "otoyo", email: "otoyo@otoyo.com"})

# Paginate tickets
{:ok, collection} = ZenEx.Model.Ticket.list(per_page: 100, sort_order: "desc")
tickets = collection.entities
next_tickets = collection |> ZenEx.Collection.next

# Show ticket
{:ok, %{entities: ticket}} = ZenEx.Model.Ticket.show(1)

# Create ticket
{:ok, ticket} = ZenEx.Model.Ticket.create(%ZenEx.Entity.Ticket{subject: "My printer is on fire!", description: "But no problem."})
```

See also under `ZenEx.Model`.

## Supporting multiple Zendesk configs

You may need to interact with more than one instance of Zendesk. In order to facilitate that there is a small override
that can be put into the Process dictionary that will tell it to look for config settings keyed against a class name.

<details>
  <summary>For details...</summary>

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
</details>


## Supported API

| Capabilities | Entities |
| --- | --- |
| Ticketing | Users |
| | User Identities |
| | Tickets |
| | Dynamic Content Items |
| | Dynamic Content Item Variants |
| | Locales |
| | Job Statuses |
| Help Center | Categories |
| | Sections |
| | Articles |
| | Translations |

## Contribution

Please make an Issue or PR.
