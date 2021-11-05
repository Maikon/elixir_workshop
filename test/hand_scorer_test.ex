defmodule Blackjack.HandScorerTest do
  use ExUnit.Case

  alias Blackjack.HandScorer

  test "face cards, minus the ace, have a value of 10" do
    hands = [
      ["K"],
      ["Q"],
      ["J"]
    ]

    assert Enum.map(hands, &HandScorer.score/1) == [10, 10, 10]
  end

  test "numeral cards have their values" do
    hands = for card <- 2..10, do: [to_string(card)]

    scores =
      hands
      |> Enum.map(&HandScorer.score/1)
      |> Enum.sort()

    assert scores == Enum.to_list(2..10)
  end

  test "it ignores invalid cards" do
    assert 11 = HandScorer.score(["A", "i"])
    assert 2 = HandScorer.score(["2", "13"])
  end

  test "it scores an 'A' as 1 when over 21" do
    assert 21 = HandScorer.score(["A", "Q", "10"])
    assert 18 = HandScorer.score(["A", "Q", "7"])
  end
end
