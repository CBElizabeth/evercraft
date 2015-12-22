require 'spec_helper'

describe Character do
    
  before(:each) do
    @character = Character.new("Lucy") 
  end
    
  it "has a name" do
    expect(@character.name).to eq "Lucy"
  end
  
  it "can change a Character's name" do
    @character.name = "Susan"
    expect(@character.name).to eq "Susan"
  end
  
  it "has an alignment" do
    expect(@character.alignment).to eq "neutral"
  end
  
  it "can change alignments" do
    @character.alignment = "good"
    expect(@character.alignment).to eq "good"
  end
  
  it "can't be set to an invalid alignment" do
    expect{@character.alignment = "sparkly"}.to raise_error(RuntimeError)
  end
  
  it "has an Armor Class of 10 by default" do
    expect(@character.armor_class).to eq 10
  end
  
  it "has 5 hit points by default" do
    expect(@character.hit_points).to eq 5
  end
  
  it "can attack other characters" do
    target = Character.new("Dwarf")
    @character.attack(target, 11)
    expect(target.hit_points).to eq 4
  end
  
  it "does extra damage on critical hits" do
    target = Character.new("Dwarf")
    @character.attack(target, 20)
    expect(target.hit_points).to eq 3
  end
  
  it "can level up" do
    @character.experience = 1000
    target = Character.new("the White Witch")
    @character.attack(target, 20)
    expect(@character.level).to eq 2
  end
end