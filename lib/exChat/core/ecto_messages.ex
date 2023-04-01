defmodule EctoMessages do
  use Ecto.Type
  def type, do: :binary

  def cast(messages) when is_binary(messages) do
    data = :erlang.binary_to_term(messages)
    {:ok, data}
  end

  def cast(messages) when is_list(messages) do
    {:ok, messages}
  end

  def cast(_), do: :error

  def load(messages) when is_binary(messages) do
    data = :erlang.binary_to_term(messages)
    {:ok, data}
  end

  def dump(messages) when is_list(messages) do
    {:ok, :erlang.term_to_binary(messages)}
  end

  def dump(_), do: :error
end
