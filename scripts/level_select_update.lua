function updateLevelSelect()
	buttonUpdate(level_buttons)
	for b in all(level_buttons) do
		b.y_offset = lerp(b.y_offset, -256 * level_page, 0.07)
		-- b.y_offset = flr(b.y_offset)
	end
end
