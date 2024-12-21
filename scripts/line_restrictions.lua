--[[pod_format="raw",created="2024-12-10 16:33:43",modified="2024-12-10 16:37:23",revision=2]]
line_restrictions_lib = {
	exact_power = {
		description = "power value in \nthis row/column \nmust equal X",
		eval_fun = function(self)
			local power = 0
			local list_of_ids = {}
			for i in all(self.cells) do
				local comp = getComponentFromCell(i)
				if comp ~= nil then
					--to make sure we don't count the same component twice
					local have_i_counted_before = false
					for id in all(list_of_ids) do
						if comp.id == id then
							have_i_counted_before = true
						end
					end
					if have_i_counted_before == false then
						power += (comp.power)
						add(list_of_ids, comp.id)
					end
				end
			end

			return power == self.value
		end,
		draw_fun = function(self)
			drawLineRestrictionIcon(self.line_type, self.index, 176, self.check, self.description, self.value)
		end

	},
	forbidden_type = {
		description = "no components of \nthis type allowed",
		eval_fun = function(self)
			local clean = true
			for i in all(self.cells) do
				local comp = getComponentFromCell(i)

				if comp ~= nil then
					if comp.type == self.value then clean = false end
				end
			end
			return clean
		end,
		draw_fun = function(self)
			drawLineRestrictionIcon(self.line_type, self.index, 178, self.check, self.description)
		end
	}
}

function createLineRestriction(line_type, index, restriction_type, value)
	local restriction = {
		check = false,
		line_type = line_type,
		index = index,
		value = value,
		description = restriction_type.description,
		eval_fun = restriction_type.eval_fun,
		draw_fun = restriction_type.draw_fun
	}
	return restriction
end
