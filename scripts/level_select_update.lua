function updateLevelSelect()
	if #popups < 1 then
	
		for b in all(level_buttons) do
            buttonUpdate(b)
			b.y_offset = lerp(b.y_offset, -256 * level_page, 0.07)
			-- b.y_offset = flr(b.y_offset)
		end
	end
end
