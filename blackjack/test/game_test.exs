defmodule Blackjack.GameTest do
  use ExUnit.Case

  alias Blackjack.Game

  setup do
    game_pid = start_supervised!(Game)

    %{game: game_pid}
  end

  test "starts with an empty initial state", %{game: game_pid} do
    %{dealer: dealer, player: player, deck: deck} = Game.state(game_pid)

    assert length(deck) == 52
    assert Enum.empty?(dealer)
    assert Enum.empty?(player)
  end

  test "it deals the cards to the players", %{game: game_pid} do
    Game.deal_cards(game_pid)

    %{dealer: dealer, player: player, deck: deck} = Game.state(game_pid)

    assert length(deck) == 48
    assert length(dealer) == 2
    assert length(player) == 2
  end

  test "it deals additional cards to a given player", %{game: game_pid} do
    Game.deal_cards(game_pid)
    Game.deal_player(:player, game_pid)

    %{dealer: dealer, player: player, deck: deck} = Game.state(game_pid)

    assert length(deck) == 47
    assert length(dealer) == 2
    assert length(player) == 3
  end
end
