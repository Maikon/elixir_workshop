defmodule Blackjack.Game do
  use GenServer

  alias Blackjack.Deck

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def state(server \\ __MODULE__) do
    GenServer.call(server, :state)
  end

  def deal_cards(server \\ __MODULE__) do
    GenServer.call(server, :deal)
  end

  def deal_player(player, server \\ __MODULE__) do
    GenServer.call(server, {:deal_player, player})
  end

  @impl true
  def init(:ok) do
    {:ok, %{deck: Deck.generate(), dealer: [], player: []}}
  end

  @impl true
  def handle_call(:deal, _from, state) do
    game =
      state
      |> deal_player(:dealer, 2)
      |> deal_player(:player, 2)

    {:reply, game, game}
  end

  @impl true
  def handle_call({:deal_player, player}, _from, game) do
    game =
      game
      |> deal_player(player, 1)

    {:reply, game, game}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  defp deal_player(game, player, no_of_cards) do
    Enum.reduce(1..no_of_cards, game, fn _, updated_game ->
      {card, rest} = Deck.deal_card(updated_game.deck)
      cards = Map.get(updated_game, player) ++ [card]

      updated_game
      |> Map.replace(player, cards)
      |> Map.replace(:deck, rest)
    end)
  end
end
