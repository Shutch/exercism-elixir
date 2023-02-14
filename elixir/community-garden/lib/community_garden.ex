# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> [plot_id: 1, registrations: []] end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn state -> state[:registrations] end)
  end

  def register(pid, register_to) do
    plot_id = Agent.get(pid, fn state -> state[:plot_id] end)
    new_plot = %Plot{plot_id: plot_id, registered_to: register_to}
    Agent.update(pid, fn state ->
      [plot_id: plot_id + 1, registrations: state[:registrations] ++ [new_plot]]
    end)
    new_plot
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn state ->
      [plot_id: state[:plot_id], registrations: Enum.reject(state[:registrations], fn reg -> reg.plot_id == plot_id end)]
    end)
  end

  def get_registration(pid, plot_id) do
    registration = Agent.get(pid, fn state ->
      Enum.find(state[:registrations], fn reg -> reg.plot_id == plot_id end)
    end)
    if registration do
      registration
    else
      {:not_found, "plot is unregistered"}
    end
  end
end
