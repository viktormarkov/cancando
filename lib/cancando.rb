require 'cancan'

module Cancando
  include CanCan::Ability

  def can_do(actions, resource, conditions = {})
    add(abilities, actions, resource, conditions)
  end

  def cannot_do(actions, resource, conditions = {})
    add(restrictions, actions, resource, conditions)
  end

  def abilities
    @abilities ||= Hash.new { |hash, k| hash[k] = [] }
  end

  def restrictions
    @restrictions ||= Hash.new { |hash, k| hash[k] = [] }
  end

  def apply
    merge_and_grant(abilities, 'can') if abilities
    merge_and_grant(restrictions, 'cannot') if restrictions
  end

  private

  def add(target, actions, resource, conditions)
    Array(actions).each do |action|
      target[resource] << {action: action, conditions: conditions}
    end
  end

  def merge_and_grant(abilities_to_merge, method)
    abilities_to_merge.each do |resource, abilities|
      merged_abilities = []
      abilities.each do |ability|
        merge_abilities(merged_abilities, ability)
      end
      grant_abilities(merged_abilities, resource, method)
    end
  end

  def merge_abilities(abilities, ability_to_merge)
    if abilities.empty?
      abilities << ability_to_merge
      return
    end

    merged = false
    abilities.each do |ability|
      if same_actions?(ability[:action], ability_to_merge[:action]) &&
          same_single_condition_attr?(ability_to_merge[:conditions], ability[:conditions])

        merge_conditions(ability, ability_to_merge)
        merge_actions(ability, ability_to_merge)
        merged = true
        break
      elsif equal_conditions?(ability_to_merge[:conditions], ability[:conditions])
        merge_actions(ability, ability_to_merge)
        merged = true
        break
      end
    end

    abilities << ability_to_merge unless merged
  end

  def same_actions?(actions1, actions2)
    if actions1.is_a? Array
      actions1.include? actions2
    else
      actions1 == actions2
    end
  end

  def same_single_condition_attr?(conditions1, conditions2)
    conditions1.length == 1 && conditions1.keys == conditions2.keys
  end

  def equal_conditions?(conditions1, conditions2)
    conditions1.sort == conditions2.sort
  end

  def merge_conditions(ability1, ability2)
    attr_value1 = ability1[:conditions].first[1]
    attr_value2 = ability2[:conditions].first[1]
    attr_name = ability2[:conditions].first[0]
    merged_value = (Array(attr_value1) + Array(attr_value2)).uniq

    ability1[:conditions][attr_name] = merged_value.length == 1 ? merged_value[0] : merged_value
  end

  def merge_actions(ability1, ability2)
    ability1[:action] = (Array(ability1[:action]) + Array(ability2[:action])).uniq
  end

  # apply abilities by cancanan methods can or cannot
  def grant_abilities(abilities, resource, method)
    abilities.each do |ability|
      send(method, ability[:action], resource, ability[:conditions])
    end
  end
end
