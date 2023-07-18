defmodule Blackjack.Deck do
  @card_suites ["D", "H", "C", "S"]
  @face_cards ["A", "K", "Q", "J"]
  @numeral_cards Enum.map(2..10, &to_string/1)

  def generate do
    deck = for suite <- @card_suites,
      card <- @numeral_cards ++ @face_cards,
      into: [],
      do: "#{card}#{suite}"

    shuffle(deck)
  end

  def shuffle(deck), do: Enum.shuffle(deck)

  def deal_card([card | rest]), do: {card, rest}
  def deal_card({_first, rest}), do: deal_card(rest)

  def aces(deck), do: deck |> Enum.filter(&(String.starts_with?(&1, "A")))
  def face_cards(deck), do: deck |> Enum.filter(&(String.starts_with?(&1, @face_cards -- ["A"])))

  def separate_value_and_suite(hand) do
    hand
    |> String.split(~r/#{Enum.join(@card_suites, "|")}/, include_captures: true, trim: true)
  end

  def suit_extended_name(suit) do
    suites = %{
      "S" => "spades",
      "C" => "clubs",
      "D" => "diamonds",
      "H" => "hearts",
    }

    Map.get(suites, suit)
  end

  def face_card_extended_name(card) do
    face_cards = %{
      "A" => "ace",
      "K" => "king",
      "Q" => "queen",
      "J" => "jack",
    }

    Map.get(face_cards, card)
  end
end
