defmodule TakeANumber do
  def start() do
    spawn(fn -> machine(0) end)
  end

  defp machine(value) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, value)
        machine(value)
      {:take_a_number, sender_pid} ->
        send(sender_pid, value + 1)
        machine(value + 1)
      :stop -> :ok
      _ -> machine(value)
    after
      1000 -> self()
    end
  end
end
