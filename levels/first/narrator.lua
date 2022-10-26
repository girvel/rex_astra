local narrator = prototypes.narrator("levels/first/lines", {})


narrator.interpret.game_start = function()
	narrator.lines.game_start:play()

	if not launch.debug then
		ui.mode = ui.modes.pause
	end
end

narrator.interpret.win = function(player)
	if player.codename == "player" then
		narrator.lines.win_player:play()

		narrator.lines[
			level.ai.zanarthians.surrendered 
				and "ending_peaceful" 
				or "ending_violent"
		]:play()
	else
		narrator.lines["win_" .. player.codename]:play()
	end
end

narrator.interpret.loss = function(player)
	if player.codename == "zanarthians" then
		narrator.lines["loss_zanarthians_" .. (
			player.surrendered 
				and "surrender" 
				or "extinction"
		)]:play()
	else
		narrator.lines["loss_" .. player.codename]:play()
	end
end

narrator.interpret.surrender = function(player, target)
	narrator.lines["surrender_" .. player.codename]:play()
end


return narrator