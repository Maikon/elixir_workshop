defmodule Blackjack.DeckTest do
  use ExUnit.Case

  alias Blackjack.Deck

  test "it generates a deck with all the right cards" do
    deck = Deck.generate()

    assert length(deck) == 52

    (["A", "K", "Q", "J"] ++ Enum.map(2..10, &to_string/1))
    |> Enum.each(fn card ->
      assert card in deck
    end)
  end

  test "it deals the first card from the deck and returns the rest" do
    assert Deck.deal_card(["A", "2"]) == {"A", ["2"]}
  end
end
