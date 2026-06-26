local state = { hidden = false }

local toggle = ya.sync(function()
	if state.hidden then
		Tab.layout = function(self)
			self._chunks = ui.Layout()
				:direction(ui.Layout.HORIZONTAL)
				:constraints({
					ui.Constraint.Ratio(0, 1),
					ui.Constraint.Ratio(2, 3),
					ui.Constraint.Ratio(1, 3),
				})
				:split(self._area)
		end
		state.hidden = false
	else
		Tab.layout = function(self)
			self._chunks = ui.Layout()
				:direction(ui.Layout.HORIZONTAL)
				:constraints({
					ui.Constraint.Ratio(0, 1),
					ui.Constraint.Ratio(1, 1),
					ui.Constraint.Ratio(0, 1),
				})
				:split(self._area)
		end
		state.hidden = true
	end
	ui.render()
end)

local function entry()
	toggle()
end

return { entry = entry }
