defmodule Bamboo.ConfigAdapter do
  @behaviour Bamboo.Adapter
  @moduledoc """

  # Example using SMTPAdapter

  ## Config

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.ConfigAdapter,
        chained_adapter: Bamboo.SMTPAdapter,
        server: "smtp.domain",
        hostname: "www.mydomain.com",
        username: "your.name@your.domain", # or {:system, "SMTP_USERNAME"}
        password: "pa55word", # or {:system, "SMTP_PASSWORD"}

  ### Or if chained adapter is configured completely at runtime

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.ConfigAdapter

  ## Delivering mail

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

  alias Bamboo.ConfigAdapter.Email

  def deliver(email, config) do
    custom_config =
      email
      |> Email.get_config()

    merged_config =
      config
      |> Map.merge(custom_config)

    test_mode = Map.get(merged_config, :test_mode, false)

    {chained_adapter, email} = if test_mode do
      {Bamboo.TestAdapter, Map.put(email, :test_merged_config, merged_config)}
    else
      {Map.get(merged_config, :chained_adapter), email}
    end

    final_config =
      merged_config
      |> chained_adapter.handle_config()

    email
    |> Email.put_config(%{}) # clear private config before we go to the chained adapter
    |> chained_adapter.deliver(final_config)
  end

  def handle_config(config) do
    config
  end

  def supports_attachments?, do: true
end
