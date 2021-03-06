defmodule PowAssent.Config do
  @moduledoc """
  Methods to parse and modify configurations.
  """
  alias Pow.Config

  defmodule ConfigError do
    defexception [:message]
  end

  @doc """
  Gets the providers for the configuration.
  """
  @spec get_providers(Config.t()) :: Config.t()
  def get_providers(config) do
    Config.get(config, :providers, [])
  end

  @doc """
  Gets the provider configuration from the provided configuration.
  """
  @spec get_provider_config(Config.t(), atom()) :: Config.t() | no_return
  def get_provider_config(config, provider) do
    Config.get(get_providers(config), provider) || raise_no_provider_configuration(provider)
  end

  defp raise_no_provider_configuration(provider) do
    raise ConfigError, message: "No provider configuration available for #{provider}."
  end

  @doc """
  Gets the application environment configuration for the provided `:otp_app`.

  If no `:otp_app` defined, it'll just pull the global environment configuration.
  """
  @spec env_config(Config.t()) :: Config.t()
  def env_config(config \\ []) do
    otp_app = Pow.Config.get(config, :otp_app)

    case otp_app do
      nil     -> Application.get_all_env(:pow_assent)
      otp_app -> Application.get_env(otp_app, :pow_assent, [])
    end
  end
end
