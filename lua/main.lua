-- true if there's a unit at the selected hex
--      the unit has advancements
--      the unit is allied
--      the unit has multiple options in either its original set of advancements or current set of advancements
if pcall(function () return type(pickadvance.menu_available) end) then
	function pickadvance.menu_available()
		local unit = wesnoth.units.get(wml.variables.x1, wml.variables.y1)
		return unit and
			#unit.advances_to > 1
			and not wesnoth.sides.is_enemy(unit.side,wml.variables["side_number"])
	end
end

