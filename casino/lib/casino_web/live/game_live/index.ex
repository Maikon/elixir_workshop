defmodule CasinoWeb.GameLive.Index do
  use CasinoWeb, :live_view

  alias Blackjack.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, new_game(socket)}
  end

  @impl true
  def handle_event("new_game", _url, socket) do
    {:noreply, new_game(socket)}
  end

  @impl true
  def handle_event("deal_cards", _url, socket) do
    game_pid = socket.assigns.game_pid
    updated_game = Blackjack.Game.deal_cards(game_pid)

    socket = socket
    |> update(:game, fn _game -> updated_game end)
    |> update(:dealer_score, fn _score -> dealer_score(updated_game.dealer, socket.assigns.show_dealer) end)
    |> update(:player_score, fn _dealer -> score(updated_game.player) end)

    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_event("deal_dealer", _url, socket) do
    game_pid = socket.assigns.game_pid
    updated_game = Game.deal_player(:dealer, game_pid)

    socket = socket
    |> update(:game, fn _game -> updated_game end)
    |> update(:dealer_score, fn _score -> dealer_score(updated_game.dealer, socket.assigns.show_dealer) end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("deal_player", _url, socket) do
    game_pid = socket.assigns.game_pid
    updated_game = Game.deal_player(:player, game_pid)

    socket = socket
    |> update(:game, fn _game -> updated_game end)
    |> update(:player_score, fn _dealer -> score(updated_game.player) end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("show_dealer", _url, socket) do
    game_pid = socket.assigns.game_pid
    game = Game.state(game_pid)

    updated_socket =
      socket
      |> update(:show_dealer, fn _state -> true end)

    {:noreply, update(
      updated_socket,
      :dealer_score, fn _score -> dealer_score(game.dealer, updated_socket.assigns.show_dealer) end
      )
    }
  end

  def convert_hand(_assigns, [], _player, _show_dealer), do: ""
  def convert_hand(assigns, cards, player, show_dealer) do
    if !show_dealer && player == :dealer do
      [card1, _card2] = cards
      |> Enum.map(fn hand -> hand_to_card(hand) end)

      hand = [card1, "astronaut.svg"]
      assigns = assign(assigns, :hand, hand)

      ~H"""
      <%= for card <- @hand do %>
      <span><img src={~p"/images/cards/#{card}"} style="display: inline;" width="120" /></span>
      <% end %>
      """
    else
      hand = cards
      |> Enum.map(fn hand -> hand_to_card(hand) end)

      assigns = assign(assigns, :hand, hand)

      ~H"""
      <%= for card <- @hand do %>
      <span><img src={~p"/images/cards/#{card}"} style="display: inline;" width="120" /></span>
      <% end %>
      """
    end
  end

  defp new_game(socket) do
    {:ok, game_pid} = Blackjack.Game.start_link()

    socket
    |> assign(:game_pid, game_pid)
    |> assign(:dealer_score, 0)
    |> assign(:player_score, 0)
    |> assign(:show_dealer, false)
    |> assign(:game, Blackjack.Game.state(game_pid))
  end

  defp dealer_score(dealer_hand, show_dealer) do
    case show_dealer do
      true ->
        score(dealer_hand)
      _ ->
        [card1, _card2] = dealer_hand
        score([card1])
    end
  end

  defp score(cards), do: cards |> Blackjack.HandScorer.score()

  defp hand_to_card(hand) do
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
