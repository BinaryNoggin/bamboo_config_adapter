# Bamboo.ConfigAdapter

In some cooperate environments sending emails isn't simply picking a
server and sending it to that server. Sometimes different emails require
different types of configurations that are only known at runtime. Does
this sound like your problem? This may seem convoluted, but this
happens and Bamboo.ConfigAdapter is here to help.

## Installation

[bamboo_config_adapter](https://hex.pm/packages/bamboo_config_adapter) can be installed
by adding `bamboo_config_adapter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bamboo_config_adapter, "~> 0.2.0"}
  ]
end
```

## Example using SMTPAdapter

### Config

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.ConfigAdapter,
        chained_adapter: Bamboo.SMTPAdapter,
        server: "smtp.domain",
        hostname: "www.mydomain.com",
        username: "your.name@your.domain", # or {:system, "SMTP_USERNAME"}
        password: "pa55word", # or {:system, "SMTP_PASSWORD"}

#### Or if chained adapter is configured completely at runtime

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.ConfigAdapter

### Delivering mail

      def welcome do
        email
        |> Bamboo.ConfigAdapter.Email.put_config(%{server: "smtp.other_domain"})
        |> Mailer.deliver_now()
      end

     def welcome_runtime_adapter do
       email
       |> Bamboo.ConfigAdapter.Email.put_config(%{
          server: "smtp.other_domain",
          chained_adapter: Bamboo.SMTPAdapter})
       |> Mailer.deliver_now()
     end
"""

## Testing

If the config option `:test_mode` is set to true then the email will be sent to Bamboo.TestAdapter instead of the chained_adapter in the config. All config, merged from the config file and any runtime config will available under the element test_merged_config on the returned email.

For example:


## Gotchas

Bamboo Adapters must implement a `supports_attachments?/0`. Since the function takes no
arguments there is no way for `Bamboo.ConfigAdapter` to know if the chained adapter
supports attachements. Instead we have opted to always return `true`, but it is up to
you to ensure that attachments will work with the chained adapter.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bamboo_config_adapter](https://hexdocs.pm/bamboo_config_adapter).

