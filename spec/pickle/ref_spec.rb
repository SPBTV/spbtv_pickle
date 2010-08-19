require 'spec_helper'

describe Pickle::Ref do
  describe "(factory name) " do
    describe ".new 'colour'" do
      subject { Pickle::Ref.new('colour') }
      
      its(:index)   { should be_nil }
      its(:factory) { should == 'colour' }
      its(:label)   { should be_nil }
    end

    describe "with a prefix" do
      ['a', 'an', 'the', 'that', 'another'].each do |prefix|
        describe ".new '#{prefix} colour'" do
          subject { Pickle::Ref.new("#{prefix} colour") }
        
          its(:factory) { should == 'colour' }
        end
      end
    end
    
    describe ".new 'awesome_colour'" do
      subject { Pickle::Ref.new('awesome_colour') }
      
      its(:factory) { should == 'awesome_colour' }
    end
  end
  
  describe "(index)" do
    describe ".new('1st colour')" do
      subject { Pickle::Ref.new('1st colour') }

      its(:index)   { should == '1st' }
      its(:factory) { should == 'colour' }
      its(:label)   { should be_nil }
      
      ['2nd', 'first', 'last', '3rd', '4th'].each do |index|
        describe ".new('#{index} colour')" do
          subject { Pickle::Ref.new("#{index} colour") }
        
          its(:index) { should == index}
        end
      end
            
      describe "the 2nd colour" do
        subject { Pickle::Ref.new('the 2nd colour') }
        
        its(:index)   { should == '2nd' }
        its(:factory) { should == 'colour' }
      end
    end
    
    describe "(label)" do
      describe "'colour: \"red\"'" do
        subject { Pickle::Ref.new('colour: "red"') }

        its(:index)   { should == nil }
        its(:factory) { should == 'colour' }
        its(:label)   { should == 'red' }
      end
      
      describe "'\"red\"'" do
        subject { Pickle::Ref.new('"red"') }

        its(:index)   { should == nil }
        its(:factory) { should == nil }
        its(:label)   { should == 'red' }
      end
    end
  end
  
  describe "[perverse usage]" do
    describe "superflous content:" do
      ['awesome colour', 'the colour fred', '1st colour gday', 'a', 'the ""'].each do |str|
        describe ".new '#{str}'" do
          subject { Pickle::Ref.new(str) }
          it { lambda { subject }.should raise_error(Pickle::InvalidPickleRefError, /superfluous/) }
        end
      end
    end

    describe "factory or label required:" do
      ['1st', ''].each do |str|
        describe ".new '#{str}'" do
          subject { Pickle::Ref.new(str) }
          it { lambda { subject }.should raise_error(Pickle::InvalidPickleRefError, /factory or label/) }
        end
      end
    end
    
    describe "can't specify both index and label:" do
      ['1st user "fred"', 'last user: "jim"'].each do |str|
        describe ".new '#{str}'" do
          subject { Pickle::Ref.new(str) }
          it { lambda { subject }.should raise_error(Pickle::InvalidPickleRefError, /can't specify both index and label/) }
        end
      end
    end
  end
end

#  Given a website owner user "betty" exists
#  
#  # Given 3 users exists with site: "betty"'s site
#  # ==
#  # Given "betty"'s site has 3 users
#  
#  Given /^#{pickle_ref}'s (\w+) has (\d+) #{pickle_factory}$/ do |ref, assoc, amount, factory|
#    association = retrieve_from_scenario(pickle_ref).send(assoc)
#    amount.times do
#      create_on_and_store(association, factory)
#      # machinist
#        betty.users.make
#      # factory girl & AR
#        betty.users.create(Factory.plan(:user))
#    end
#  
#    User.make(:website_owner)
#  
#  
#  And "betty"'s site has 3 users
#    retrieve("betty").site.users.
#  
  # API suggestions
  #   c.alias "color", :as => "colour"
  #   c.label "colour", :using => "hue"
  #   c.label "user", :using => "name"
  #
  #     Given a colour exists with hue: "blue"
  #       create_model_in_scenario('color', 'hue: "blue"')
  #         factory = parse_factory_from_pickle_ref('color') #=> 'colour'
  #         attrs = parse_attributes_from_fields('hue: "blue"') # => hash
  #         
  #         if label in pickle_ref use that
  #         if label_attrs
  #
  #         obj = factories['colour'].create_model(attrs hash)
  #         store_in_scenario(obj, :label => nil)
  #
  #    Given a color "red" exists
  #    Then "red" should be bright
  
  #        
  #
  #    Given a color exists with hue: "red"
  #       create_model_in_scenario('color "red"')
  #         factory = ... # 'colour'
  #         obj = Colour.make(:hue => "red")
  #         store_model(obj, :label => 'red')
  #
  #    And a color "brown" exists
  #    Then the color "red" should be bright
  #    And the color "brown" should be dull
  #
  #
  #        
  #    Given a user "Fred" exists
  #    Then "Fred" should not be activated
  #    When I poke "Fred"
  #
  #    When(/^I poke #{capture_model}$/)
  #
  
  #create_model_in_scenario 'color', 'hue: "blue"'
  #def create_model_in_scenario(pickle_ref, fields = nil)
  #  factory, label = *parse_pickle_ref(pickle_ref)  #=> 'color', nil
  #  
  #  factory = get_the_factory_using_possibly_aliased_factory(factory)
  #  
  #  attrs = parse_the_fields_converting_pickle_refs_to_models_and_also_applying_transforms(fields)
  #  
  #  if label defined in pickle_ref         # eg "betty"
  #    assign label to attrs if appropriate # attrs[:name] = "betty"
  #  else
  #    label = get the label from attrs if appropriate  # label = attrs[:name]
  #  end
  #  
  #  make the object using the factory & attrs
  #  
  #  store the object using the label
  #end
  
  #Transform /#{pickle_ref}/ |str| { Pickle::Ref.new(str) }
  #
  #Given /$#{pickle_ref} should be cool/ do |pickle_ref|
  #  pickle_ref
  #  retreive_model_from_scenario(pickle_ref)
  #  pickle_ref.factory
  
  #Transform(/^#{pickle_ref}$/) {|str| Pickle::Ref.new(str) }
  #
  #Given(/^#{pickle_ref} exists(?: with #{pickle_fields})?$/) do |ref, fields|
  #  create_and_store(ref, fields)
  #end
  #
  #Given(/^#{pickle_ref} should exist(?: with #{pickle_fields})$/) do |ref, fields|
  #  find(ref, fields).store
  #end
  
  