local F = wesnoth.require "functional"

-- replace any non-alphanumeric characters with an underscore
local function clean_type_func(unit_type)
	return string.gsub(unit_type, "[^a-zA-Z0-9]", "_")
end

-- splits a comma delimited string of unit types
-- returns a table of unit types that aren't blank, "null", and that exist
local function split_comma_units(string_to_split)
	return F.filter(
		stringx.split(string_to_split or ""),
		function(s) return s ~= "" and s ~= "null" and wesnoth.unit_types[s] end
	)
end

-- returns a table of the original unit types
--         a comma delimited string containing the same values
local function original_advances(unit)
	local clean_type = clean_type_func(unit.type)
	local variable = unit.variables["pickadvance_orig_" .. clean_type] or ""
	return split_comma_units(variable), clean_type_func(variable)
end

-- true if there's a unit at the selected hex
--      the unit has advancements
--      the unit is side 1 or 2
--      the unit has multiple options in either its original set of advancements or current set of advancements
if pcall(function () return type(pickadvance.menu_available) end) then
	function pickadvance.menu_available()
		local unit = wesnoth.units.get(wml.variables.x1, wml.variables.y1)
		return unit and
			#unit.advances_to > 0
			and not wesnoth.sides.is_enemy(unit.side,wml.variables["side_number"])
			and (#original_advances(unit) > 1 or #unit.advances_to > 1)
	end
end