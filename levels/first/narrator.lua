local narrator = prototypes.narrator("levels/first/lines", {})


narrator.interpret.win = function(player)
	if player.codename == "player" then
		narrator.lines.wins_player:play()

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