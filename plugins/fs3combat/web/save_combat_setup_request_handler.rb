module AresMUSH
  module FS3Combat
    class SaveCombatSetupRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        combat = Combat[id]
        if (!combat)
          return { error: t('fs3combat.invalid_combat_number') }
        end
        
        can_manage = FS3Combat.can_manage_combat?(enactor, combat)
        if (!can_manage)
          return { error: t('dispatcher.not_allowed') }
        end        

        if (combat.turn_in_progress)
          return { error: t('fs3combat.turn_in_progress') }
        end

        combatants = request.args[:combatants]
        combatants.each do |key, combatant_data|
          
          combatant = Combatant[combatant_data[:id]]
          
          if (!combatant)
            return { error: t('fs3combat.not_in_combat', :name => combatant_data[:name])}
          end
          
          team = combatant_data[:team].to_i
          stance = combatant_data[:stance]
          weapon = combatant_data[:weapon]
          action = combatant_data[:action]
          if (action.blank?)
            action = "pass"
          end
          action_args = combatant_data[:action_args] || ""
          selected_weapon_specials = (combatant_data[:weapon_specials] || [])
             .select { |k, w| (w[:selected] || "").to_bool }
              .map { |k, w| w[:name] }
          armor = combatant_data[:armor]
          selected_armor_specials = (combatant_data[:armor_specials] || [])
            .select { |k, a| (a[:selected] || "").to_bool }
            .map { |k, a| a[:name] }
          npc_level = combatant_data[:npc_skill]
        
          pp "#{combatant.name} #{action} #{action.nil?} #{action_args}"
          error = FS3Combat.update_combatant(combat, combatant, enactor, team, stance, weapon, selected_weapon_specials, armor, selected_armor_specials, npc_level, action, action_args)
        
          if (error)
            return { error: error }
          end
        end
                    
        {
        }
      end
    end
  end
end


