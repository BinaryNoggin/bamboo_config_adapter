defmodule Bamboo.ConfigAdapter.Email do
  @moduledoc """
  Used to update emails with configuration overrides for `BamBoo.ConfigAdapter`


  # Example Usage

      def welcome do
        email
        |> Bamboo.ConfigAdapter.put_config(%{server: "smtp.other_domain)})
        |> Mailer.deliver_now()
      end
  """

  alias Bamboo.Email

  @spec get_config(Email.t) :: map
  def get_config(%Email{private: private}) do
    Map.get(private, :config_adapter, %{})
  end

  @doc """
    Used to add specific adapter configuration to an email

   # Example

      iex> Bamboo.ConfigAdapter.Email.put_config(%Bamboo.Email{}, %{foo: :bar})
      %Bamboo.Email{private: %{config_adapter: %{foo: :bar}}}

      iex> Bamboo.ConfigAdapter.Email.put_config(%Bamboo.Email{private: %{other: :baz}}, %{foo: :bar})
      %Bamboo.Email{private: %{config_adapter: %{foo: :bar}, other: :baz}}
  """
  @spec put_config(Email.t, map) :: Email.t
  def put_config(%Email{} = email, config) do
    Map.update(email, :private, %{config_adapter: config}, fn
      current_private -> Map.put(current_private, :config_adapter, config)
    end)
  end
end
