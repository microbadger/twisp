defmodule Mix.Tasks.Twisp.Init do
  use Mix.Task

  def run(_args) do
    Mix.Task.run "deps.get"
    Mix.Task.run "compile"

    dev_config  = EEx.eval_file "config/env.secret.eex", [secret_key_base: random_string]
    prod_config = EEx.eval_file "config/env.secret.eex", [secret_key_base: random_string]

    Mix.Generator.create_file "config/dev.secret.exs",  dev_config
    Mix.Generator.create_file "config/prod.secret.exs", prod_config

    Mix.shell.info "Please set your credentials in config/dev.secret.exs"
    Mix.shell.info "Note that secrets files are ignored by git"
    Mix.shell.info "When done, run `mix ecto.create`"
  end

  defp random_string do
    :crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64)
  end

end
