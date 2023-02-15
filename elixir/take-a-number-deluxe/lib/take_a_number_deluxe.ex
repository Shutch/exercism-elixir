defmodule TakeANumberDeluxe do
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    min_number = init_arg[:min_number]
    max_number = init_arg[:max_number]
    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
    case TakeANumberDeluxe.State.new(min_number, max_number, auto_shutdown_timeout) do
      {:ok, state} ->
        GenServer.start_link(__MODULE__, state)
      {:error, error} ->
        {:error, error}
    end
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(pid) do
    GenServer.call(pid, {:report_state})
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(pid) do
    state = report_state(pid)
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} ->
        new_number = GenServer.call(pid, {:queue_new_number, new_number, new_state})
        {:ok, new_number}
      {:error, error} ->
        {:error, error}
    end
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(pid, priority_number \\ nil) do
    state = report_state(pid)
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, next_number, new_state} ->
        next_number = GenServer.call(pid, {:serve_next_queued_number, next_number, new_state})
        {:ok, next_number}
      {:error, error} ->
        {:error, error}
    end
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(pid) do
    state = report_state(pid)
    min_number = state.min_number
    max_number = state.max_number
    auto_shutdown_timeout = state.auto_shutdown_timeout
    case TakeANumberDeluxe.State.new(min_number, max_number, auto_shutdown_timeout) do
      {:ok, state} ->
        GenServer.cast(pid, {:reset_state, state})
        :ok
      {:error, error} ->
        {:error, error}
    end
  end

  # Server callbacks

  @impl GenServer
  def init(state) do
    {:ok, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call({:report_state}, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call({:queue_new_number, new_number, new_state}, _pid, state) do
    {:reply, new_number, new_state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, next_number, new_state}, _pid, state) do
    {:reply, next_number, new_state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_cast({:reset_state, new_state}, state) do
    {:noreply, new_state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_reason, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
