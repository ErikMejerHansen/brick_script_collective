defmodule BrickScriptCollective.VmLeaderSelector do
  use GenServer

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{leader: nil, participants: MapSet.new()}}
  end

  def join(pid) do
    GenServer.cast(__MODULE__, {:join, pid})
  end

  def leave(pid) do
    GenServer.cast(__MODULE__, {:leave, pid})
  end

  def handle_cast({:join, pid}, %{leader: nil, participants: participants}) do
    IO.inspect("Got join!")
    participants = MapSet.put(participants, pid)
    leader = do_leader_select(participants)

    {:noreply, %{leader: leader, participants: participants}}
  end

  def handle_cast({:join, pid}, state) do
    participants = MapSet.put(state.participants, pid)
    {:noreply, %{state | participants: participants}}
  end

  def handle_cast({:leave, pid}, state) do
    participants = MapSet.delete(state.participants, pid)

    if(pid == state.leader) do
      new_leader = do_leader_select(participants)
      {:noreply, %{leader: new_leader, participants: participants}}
    else
      {:noreply, %{state | participants: participants}}
    end
  end

  defp do_leader_select(participants) do
    unless MapSet.size(participants) == 0 do
      leader = Enum.random(participants)

      IO.inspect("Sending leader selection message =======================")
      send(leader, :selected_leader)

      leader
    else
      IO.inspect("Empty participants list")
      nil
    end
  end
end
