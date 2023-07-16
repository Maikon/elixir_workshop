defmodule CasinoWeb.GameLive.Index do
  use CasinoWeb, :live_view

  alias Blackjack.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, game_pid} = Blackjack.Game.start_link()

    {:ok,
     socket
     |> assign(:game_pid, game_pid)
     |> assign(:game, Blackjack.Game.state(game_pid))}
  end

  @impl true
  def handle_event("deal_cards", _url, socket) do
    game_pid = socket.assigns.game_pid

    {
      :noreply,
      update(
        socket,
        :game,
        fn _game -> Blackjack.Game.deal_cards(game_pid) end
      )
    }
  end

  @impl true
  def handle_event("deal_dealer", _url, socket) do
    game_pid = socket.assigns.game_pid

    {
      :noreply,
      update(
        socket,
        :game,
        fn _game -> Game.deal_player(:dealer, game_pid) end
      )
    }
  end

  @impl true
  def handle_event("deal_player", _url, socket) do
    game_pid = socket.assigns.game_pid

    {
      :noreply,
      update(
        socket,
        :game,
        fn _game -> Game.deal_player(:player, game_pid) end
      )
    }
  end

  def convert_hand(_assigns, [], _player), do: ""

  def convert_hand(assigns, cards, :dealer) do
    if length(cards) > 2 do
      hand = cards
      |> Enum.map(fn hand -> hand_to_card(hand) end)

      assigns = assign(assigns, :hand, hand)
      ~H"""
      <%= for card <- @hand do %>
      <span><img src={~p"/images/cards/#{card}"} style="display: inline;" width="120" /></span>
      <% end %>
      """
    else
      [card1, card2] = cards
      |> Enum.map(fn hand -> hand_to_card(hand) end)

      hand = [card1, "astronaut.svg"]

      assigns = assign(assigns, :hand, hand)

      ~H"""
      <%= for card <- @hand do %>
      <span><img src={~p"/images/cards/#{card}"} style="display: inline;" width="120" /></span>
      <% end %>
      """
    end
  end

  def convert_hand(assigns, cards, player) do
    hand = cards
    |> Enum.map(fn hand -> hand_to_card(hand) end)

    assigns = assign(assigns, :hand, hand)

    ~H"""
    <%= for card <- @hand do %>
    <span><img src={~p"/images/cards/#{card}"} style="display: inline;" width="120" /></span>
    <% end %>
    """
  end

  def hand_to_card(hand) do
    suites = %{
      "S" => "spades",
      "C" => "clubs",
      "D" => "diamonds",
      "H" => "hearts",
    }
    [card, suite] = hand
    |> String.split(~r{S|C|D|H}, include_captures: true, trim: true)

    if card in ["A", "K", "Q", "J"] do
      face_cards = %{
      "A" => "ace",
      "K" => "king",
      "Q" => "queen",
      "J" => "jack",
    }
      "#{Map.get(suites, suite)}_#{Map.get(face_cards, card)}.svg"
    else
      "#{Map.get(suites, suite)}_#{card}.svg"
    end
  end
end
