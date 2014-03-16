class Card

  attr_accessor :suit, :value

  def initialize (suit, value)
    @suit = suit.to_s
    @value = value.to_s
  end

  def to_s
    "[#{@value} of #{@suit}]"
  end

end
#####################
# DECK - intially an array of 52 cards
class Deck

  attr_accessor :array_of_cards

  #create a deck of cards. takes a number of decks parameter to use more than 52 cards.
  def initialize (num_of_decks)
    @array_of_cards = []
    num_of_decks.times do
      ['Hearts', 'Diamonds', 'Clubs', 'Spades'].each do |suit|
        ['A','2','3','4','5','6','7','8','9','10','J', 'Q', 'K'].each do |value|
          @array_of_cards.push(Card.new(suit,value))
        end
      end
    end
    @array_of_cards.shuffle!
  end

  def print_cards
    @array_of_cards.each do |card|
      card.to_s
    end
  end

  def count_cards
    @array_of_cards.length
  end

  def give_card
    dealt_card = @array_of_cards.pop
    #puts "The dealt card was #{dealt_card.value} of #{dealt_card.suit}."
    dealt_card
  end

end
############
class Human
  attr_accessor :hand, :name

  def initialize(name)
    @name = name
    @hand = []
  end

  #player chooses to hit on their turn
  def recieve_card (card)
  #player receives a new card
    @hand.push(card)
    #puts "-> #{@name} received the card."
  end

  def count_hand
    @hand.length
  end

  def calculate_hand
    card_total = 0
    @hand.each do |card|
      #check if the card is "special"
      if card.value == "A"
        card_total += 11
        if card_total > 21
          card_total -= 10
        end
      elsif card.value.to_i == 0
        card_total += 10
      elsif card.value.to_i > 0
        card_total += card.value.to_i
      end
    end
    puts "#{@name}'s total is #{card_total}."

    if card_total == 21
      puts "Blackjack! You win."
      exit
    elsif card_total > 21
      puts "You bust! Sorry, you lost."
      exit
    end
    card_total
  end



  def show_hand
    puts "#{@name}'s cards are..."
    puts @hand
    calculate_hand
  end

end
############
class Player < Human

  def initialize(name)
    super
    puts "Hi #{name}. Let's get started. I'll deal the cards."
  end


  def choose
    puts "Would you like to HIT or STAY?"
    gets.chomp
  end

  
end

class Dealer < Human
  def initialize(name)
    super
  end

  def turn
    current_total = calculate_hand
    if current_total >= 17
      puts "Dealer's turn is over."
    elsif current_total < 17
      puts "Dealer takes another card!"
    end
  end

  def calculate_hand
    card_total = 0
    @hand.each do |card|
      #check if the card is "special"
      if card.value.to_i == 0
        card_total += 10
      elsif card.value.to_i > 0
        card_total += card.value.to_i
      end
    end
    puts "#{@name}'s total is #{card_total}."

    if card_total == 21
      puts "Dealer got Blackjack. You lost :("
      exit
    elsif card_total > 21
      puts "Dealer bust. You win!"
      exit
    end
    card_total
  end
end

########### Game Start
myDeck = Deck.new(2)
dealer = Dealer.new("Dealer")
puts "Hello! Welcome to Blackjack. What is your name?"
player = gets.chomp
player1 = Player.new(player)
# deals 2 cards to players, 2 cards to dealer.
player1.recieve_card(myDeck.give_card)
dealer.recieve_card(myDeck.give_card)
player1.recieve_card(myDeck.give_card)
dealer.recieve_card(myDeck.give_card)
#shows player their hand
puts player1.show_hand
puts dealer.show_hand
# asks player to hit or stay
response = player1.choose
# if hit, then another card is drawn from the deck and given to the player
until response.upcase == "STAY"
  if response.upcase == "HIT"
    puts "You are hitting."
    player1.recieve_card(myDeck.give_card)
    puts player1.show_hand
    response = player1.choose
  else
    puts "HUH????"
    response = player1.choose
  end
end
puts "It is the Dealer's Turn!"
total = dealer.show_hand
puts total
until total >= 17
  dealer.recieve_card(myDeck.give_card)
  total = dealer.show_hand
end
puts "Dealer's turn is over."
player_final = player1.show_hand
dealer_final = dealer.show_hand
if player_final > dealer_final
  puts "YOU WIN!"
elsif dealer_final > player_final
  puts "YOU LOST!"
else 
  puts "TIE!!!"
end


