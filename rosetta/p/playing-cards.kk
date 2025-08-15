import std/num/random

type suit
  Hearts
  Diamonds
  Clubs
  Spades

pub fun suit/show(this : suit) : e string
  match this
    Hearts -> "♥"
    Diamonds -> "♦"
    Clubs -> "♣"
    Spades -> "♠"

type rank
  Ace
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
  Nine
  Ten
  Jack
  Queen
  King

pub fun rank/show(this : rank) : e string
  match this
    Ace -> "Ace"
    Two -> "2"
    Three -> "3"
    Four -> "4"
    Five -> "5"
    Six -> "6"
    Seven -> "7"
    Eight -> "8"
    Nine -> "9"
    Ten -> "10"
    Jack -> "Jack"
    Queen -> "Queen"
    King -> "King"

struct card
  rank: rank
  suit: suit

fun card/show(card: card)
  card.suit.show ++ card.rank.show

struct deck
  cards: list<card>

fun deck/show(d: deck)
  d.cards.map(_.show).join("\n")

fun deck(): deck
  val suits = [Hearts, Diamonds, Clubs, Spades]
  val ranks = [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]
  Deck(suits.map(fn(s) ranks.map(Card(_,s))).concat)

effect split
  fun split(): ()

fun shuffle(d: deck): random deck
  var deck := d.cards
  val l = d.cards.length
  with handler
    fun split()
      val (top, bottom) = deck.split(random-int() % l)
      val (h,tl) = top.split(1)
      deck := tl ++ h ++ bottom 
    return(_) Deck(deck)
  for(0, 200) fn(_)
    split()

fun players/deal(d: deck, players: int, num: int): (list<deck>, deck)
  list(0, players - 1).foldl(([], d)) fn((acc, deck), _) 
    val (cds, rst) = deck.cards.split(num) 
    (Cons(Deck(cds), acc), Deck(rst))

fun simple/deal(d: deck, num: int): (deck, deck)
  d.cards.split(num).map(Deck)

fun main()
  val deck = deck()
  val shuffled = shuffle(deck)
  val (cards1, deck2) = shuffled.deal(2)
  println("Dealt:\n" ++ cards1.show ++ "\n")
  val (hands, _) = deck2.deal(3, 2)
  println("Dealt to players:\n")
  println(hands.map-indexed("Player " ++ (_ + 1).show ++ " has:\n" ++ _.show).join("\n\n"))
