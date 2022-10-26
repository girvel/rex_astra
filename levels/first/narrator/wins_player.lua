return function(narrator)
	narrator.lines.wins_player:play()

	narrator.lines[
		level.ai.zanarthians.surrendered 
			and "ending_peaceful" 
			or "ending_violent"
	]:play()
end