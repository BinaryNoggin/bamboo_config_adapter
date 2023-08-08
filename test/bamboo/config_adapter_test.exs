defmodule Bamboo.ConfigAdapter.Test do
  use ExUnit.Case, async: true
  alias Bamboo.ConfigAdapter, as: Subject
  alias Bamboo.Email

  defmodule ChainedAdapter do
    @behaviour Bamboo.Adapter

    def deliver(email, config) do
      send(self(), {:deliver, email, config})
      {:ok, email}
    end

    def handle_config(%{required_config: _} = config) do
      send(self(), {:handle_config, config})
      config
    end

    def handle_config(config) do
      raise ArgumentError,
            "#{__MODULE__} requires required_config to be configured, got #{inspect(config)}"
    end

    def supports_attachments?, do: true
  end

  test "handle_config/1 delegates to the configured `:chained_adapter` and returns config" do
    config = %{chained_adapter: __MODULE__.ChainedAdapterchained_adapter, required_config: true}
    assert config == Subject.handle_config(config)
  end

  test "deliver/2 checks configuration for chained adapter" do
    email = %Email{}
    config = %{chained_adapter: __MODULE__.ChainedAdapter}

    assert_raise ArgumentError, fn ->
      Subject.deliver(email, config)
    end
  end

  test "deliver/2 merges configuration and delegates to the chained adapter" do
    email =
      Subject.Email.put_config(%Email{}, %{changed: true, added: true, required_config: true})

    config = %{chained_adapter: __MODULE__.ChainedAdapter, changed: false}

    assert {:ok, _} = Subject.deliver(email, config)
    assert_receive {:deliver, %Email{}, final_config}
    assert final_config.changed
    assert final_config.added
  end

  test "deliver/2 passes configuration to the chained adapter when no custom config is found" do
    email = %Email{}
    config = %{chained_adapter: __MODULE__.ChainedAdapter, changed: false, required_config: true}

    assert {:ok, _} = Subject.deliver(email, config)
    assert_receive {:deliver, %Email{}, final_config}
    refute final_config.changed
  end

  describe "configuring the chained adapter on the fly" do
    test "deliver/2 merges configuration and delegates to the chained adapter" do
      email =
        Subject.Email.put_config(%Email{}, %{
          chained_adapter: __MODULE__.ChainedAdapter,
          changed: true,
          added: true,
          required_config: true
        })

      config = %{changed: false}

      assert {:ok, _} = Subject.deliver(email, config)
      assert_receive {:deliver, %Email{}, final_config}
      assert final_config.changed
      assert final_config.added
    end

    test "deliver/2 uses the chained adapter of the email" do
      email =
        Subject.Email.put_config(%Email{}, %{
          chained_adapter: __MODULE__.ChainedAdapter,
          changed: true,
          added: true,
          required_config: true
        })

      config = %{chained_adapter: :bad_adapter, changed: false}

      assert {:ok, _} = Subject.deliver(email, config)
      assert_receive {:deliver, %Email{}, final_config}
      assert final_config.changed
      assert final_config.added
    end
  end
end
