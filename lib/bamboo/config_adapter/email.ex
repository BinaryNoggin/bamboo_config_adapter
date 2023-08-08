defmodule Bamboo.ConfigAdapter.Email do
  @moduledoc """
  Used to update emails with configuration overrides for `BamBoo.ConfigAdapter`


  # Example Usage
      import Bamboo.Email

      def welcome do
        new_email()
        |> Bamboo.ConfigAdapter.Email.put_config(%{server: "smtp.other_domain)})
        |> Mailer.deliver_now()
      end
  """
  @config_key :config_adapter

  alias Bamboo.Email

  @spec get_config(Email.t()) :: map
  def get_config(%Email{private: private}) do
    Map.get(private, @config_key, %{})
  end

  @doc """
  Replaces current config adapter dynamic configuration

  # Example

    iex> Bamboo.ConfigAdapter.Email.put_config(%Bamboo.Email{}, %{foo: :bar})
    %Bamboo.Email{private: %{config_adapter: %{foo: :bar}}}

    iex> Bamboo.ConfigAdapter.Email.put_config(%Bamboo.Email{private: %{other: :baz}}, %{foo: :bar})
    %Bamboo.Email{private: %{config_adapter: %{foo: :bar}, other: :baz}}

    iex> Bamboo.ConfigAdapter.Email.put_config(%Bamboo.Email{private: %{config_adapter: :bar}}, %{foo: :baz})
    %Bamboo.Email{private: %{config_adapter: %{foo: :baz}}}
  """
  @spec put_config(Email.t(), map) :: Email.t()
  def put_config(%Email{} = email, config) do
    Map.update(email, :private, %{@config_key => config}, fn
      current_private -> Map.put(current_private, @config_key, config)
    end)
  end
end
