require 'yaml'

class Character
  
  attr_reader :alignment, :armor_class, :ability_scores, :level
  # Both :hit_points and :experience are bad candidates for a setter
  attr_accessor :name, :hit_points, :experience
  
  @constants = YAML.load_file("constants.yml")
  # Torn between loading the YAML multiple times and having so many global variables
  @@possible_alignments = @constants["alignments"]
  @@abilities = @constants["abilities"]
  @@ability_modifiers = @constants["ability_modifiers"]
  @@die = Random.new
  
  def initialize(name)
    @name = name
    @alignment = "neutral"
    @level = 1
    @experience = 0
    @ability_scores = Hash[@@abilities.map {|ability| [ability,10]}]
    @armor_class = 10 + ability_modifier("dexterity")
    @hit_points = [5 + ability_modifier("constitution"), 1].max
  end
  
  def alignment=(alignment)
    unless @@possible_alignments.include? alignment
      raise RuntimeError, "'#{alignment}' is invalid. Alignment options are: #{@@possible_alignments.join(", ")}"
    end
    @alignment = alignment
  end
  
  def ability_modifier(ability)
    @@ability_modifiers[@ability_scores[ability]].to_i
  end
  
  def level_up?
    @experience / 1000 + 1 > @level
  end
  
  def attack_power(roll)
    attack = @level / 2
    if roll == 20
      attack += [2 + (2 * ability_modifier("strength")), 2].max
    else
      attack += [1 + ability_modifier("strength"), 1].max
    end
    attack
  end
  
  def attack(target, test_die)
    roll = test_die || @@die.rand(1..20)
    unless target.hit_points < 0
      if roll == 20
        target.hit_points -= attack_power(roll)
        puts "You rolled #{roll}. CRITICAL HIT! #{target.name} lost 2 hit points."
        @experience += 10
      elsif roll >= target.armor_class
        target.hit_points -= attack_power(roll)
        puts "You rolled #{roll}. Success! #{target.name} lost 1 hit point."
        @experience += 10
      else
        puts "You rolled #{roll}. Failure! #{target.name} did not take damage."
      end
    else
      puts "#{target.name} is already dead."
    end
    if level_up?
      @level += 1
      @hit_points += 5 + ability_modifier("constitution") 
      puts "Congratulations, you are now level #{@level}!"
    end
  end
end