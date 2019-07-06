--[[
	太阳神三国杀游戏工具扩展包·战功荣耀（模式信息部分）
	适用版本：V2 - 愚人版（版本号：20150401）清明补丁（版本号：20150405）
]]--
--[[****************************************************************
	特殊模式登记
]]--****************************************************************
sgs.special_mode["02_1v1"] = true
sgs.special_mode["04_1v3"] = true
sgs.special_mode["04_boss"] = true
sgs.special_mode["06_3v3"] = true
sgs.special_mode["06_XMode"] = true
sgs.special_mode["08_defense"] = true
sgs.special_mode["fancheng"] = true
sgs.special_mode["impasse_fight"] = true
sgs.special_mode["guandu"] = true
sgs.special_mode["zombie_mode"] = true
sgs.special_mode["couple"] = true
--[[****************************************************************
	模式匹配信息
]]--****************************************************************
sgs.match_mode["战功生效所需要的游戏模式"] = function(mode, player, hegemony)
	--mode：当前游戏模式
	--player：进行战功统计的角色
	--hegemony：当前游戏开启了国战模式
end
sgs.match_mode["all_modes"] = function(mode, player, hegemony)
	return true
end
sgs.match_mode["roles"] = function(mode, player, hegemony)
	if hegemony then
		return false
	elseif sgs.special_mode[mode] then
		return false
	elseif string.match("_mini_", mode) then
		return false
	end
	return true
end
sgs.match_mode["hegemony"] = function(mode, player, hegemony)
	return hegemony
end
sgs.match_mode["mini"] = function(mode, player, hegemony)
	return string.find(game_mode, "_mini_")
end
sgs.match_mode["custom_scenario"] = function(mode, player, hegemony)
	return mode == "custom_scenario"
end
sgs.match_mode["02_1v1"] = function(mode, player, hegemony)
	return mode == "02_1v1"
end
sgs.match_mode["04_1v3"] = function(mode, player, hegemony)
	return mode == "04_1v3"
end
sgs.match_mode["04_boss"] = function(mode, player, hegemony)
	return mode == "04_boss"
end
sgs.match_mode["06_3v3"] = function(mode, player, hegemony)
	return mode == "06_3v3"
end
sgs.match_mode["06_XMode"] = function(mode, player, hegemony)
	return mode == "06_XMode"
end
sgs.match_mode["08_defense"] = function(mode, player, hegemony)
	return mode == "08_defense"
end
sgs.match_mode["fancheng"] = function(mode, player, hegemony)
	return mode == "fancheng"
end
sgs.match_mode["impasse_fight"] = function(mode, player, hegemony)
	return mode == "impasse_fight"
end
sgs.match_mode["guandu"] = function(mode, player, hegemony)
	return mode == "guandu"
end
sgs.match_mode["zombie_mode"] = function(mode, player, hegemony)
	return mode == "zombie_mode"
end
sgs.match_mode["couple"] = function(mode, player, hegemony)
	return mode == "couple"
end
--[[****************************************************************
	身份局
]]--****************************************************************
sgs.same_camp["roles"] = function(playerA, roleA, playerB, roleB)
	if roleA == roleB then
		return true
	elseif string.match("lord|loyalist", roleA) and string.match("lord|loyalist", roleB) then
		return true
	end
	return false
end
sgs.am_winner["roles"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" or role == "loyalist" then --自己是主公或忠臣
		if n_rebel == 0 and n_renegade == 0 and n_lord == 1 then --反贼和内奸全军覆没，主公存活
			return true
		end
	elseif role == "renegade" then --自己是内奸
		if n_rebel == 0 and n_loyalist == 0 and n_lord == 0 and n_renegade == 1 then --主忠反均死亡、内奸唯一存活
			return true
		end
	elseif role == "rebel" then --自己是反贼
		if n_lord == 0 then --主公死亡
			if n_rebel > 0 or n_loyalist > 0 or n_renegade > 1 then --反贼至少一人存活；忠臣至少一人存活；内奸多人存活
				return true
			end
		end
	end
end
sgs.game_over["roles"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_lord == 0 then --主公死亡
		return true
	elseif n_rebel == 0 and n_renegade == 0 then --反贼和内奸均死亡
		return true
	end
end
--[[****************************************************************
	国战模式
]]--****************************************************************
sgs.same_camp["hegemony"] = function(playerA, roleA, playerB, roleB)
	return roleA == roleB 
end
sgs.am_winner["hegemony"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	local alives = room:getAlivePlayers()
	local special = sgs.glory_changeHero_player
	local special_name = special and special:objectName() or ""
	for _,p in sgs.qlist(alives) do
		local names = p:property("basara_generals"):toString():split("+")
		if #names == 0 then
		elseif #names == 1 and p:objectName() == special_name then
		else
			return false
		end
	end
	if role == "lord" then --自己属于魏势力
		if n_loyalist == 0 and n_rebel == 0 and n_renegade == 0 and n_lord > 0 then
			return true
		end
	elseif role == "loyalist" then --自己属于蜀势力
		if n_lord == 0 and n_rebel == 0 and n_renegade == 0 and n_loyalist > 0 then
			return true
		end
	elseif role == "rebel" then --自己属于吴势力
		if n_lord == 0 and n_loyalist == 0 and n_renegade == 0 and n_rebel > 0 then
			return true
		end
	elseif role == "renegade" then --自己属于群势力
		if n_lord == 0 and n_loyalist == 0 and n_rebel == 0 and n_renegade > 0 then
			return true
		end
	end
end
sgs.game_over["hegemony"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	local alives = room:getAlivePlayers()
	local special = sgs.glory_changeHero_player
	local special_name = special and special:objectName() or ""
	for _,p in sgs.qlist(alives) do
		local names = p:property("basara_generals"):toString():split("+")
		if #names == 0 then
		elseif #names == 1 and p:objectName() == special_name then
		else
			return false
		end
	end
	if n_lord > 0 and n_loyalist == 0 and n_rebel == 0 and n_renegade == 0 then --只剩魏势力
		return true
	elseif n_lord == 0 and n_loyalist > 0 and n_rebel == 0 and n_renegade == 0 then --只剩蜀势力
		return true
	elseif n_lord == 0 and n_loyalist == 0 and n_rebel > 0 and n_renegade == 0 then --只剩吴势力
		return true
	elseif n_lord == 0 and n_loyalist == 0 and n_rebel == 0 and n_renegade > 0 then --只剩群势力
		return true
	end
end
--[[****************************************************************
	KOF模式（02_1v1）
]]--****************************************************************
sgs.same_camp["02_1v1"] = function(playerA, roleA, playerB, roleB)
	return roleA == roleB
end
sgs.am_winner["02_1v1"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" then --自己是暖色方
		if n_renegade == 0 and n_lord > 0 then --冷色方阵亡，暖色方存活
			local lord = room:getLord()
			local renegade = room:getOtherPlayers(lord, true):first()
			local list = renegade:getTag("1v1Arrange"):toStringList()
			local rule = sgs.GetConfig("1v1/Rule", "2013")
			if rule == "2013" then
				if #list > 3 then
					return false
				end
			else
				if #list > 0 then
					return false
				end
			end
			return true
		end
	elseif role == "renegade" then --自己是冷色方
		if n_lord == 0 and n_renegade > 0 then --暖色方阵亡，冷色方存活
			local lord = room:getLord()
			local list = lord:getTag("1v1Arrange"):toStringList()
			local rule = sgs.GetConfig("1v1/Rule", "2013")
			if rule == "2013" then
				if #list > 3 then
					return false
				end
			else
				if #list > 0 then
					return false
				end
			end
			return true
		end
	end
end
sgs.game_over["02_1v1"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_lord == 0 then --暖色方阵亡
		local lord = room:getLord()
		local list = lord:getTag("1v1Arrange"):toStringList()
		local rule = sgs.GetConfig("1v1/Rule", "2013")
		if rule == "2013" then
			if #list > 3 then
				return false
			end
		else
			if #list > 0 then
				return false
			end
		end
		return true
	elseif n_renegade == 0 then --冷色方阵亡
		local lord = room:getLord()
		local renegade = room:getOtherPlayers(lord, true):first()
		local list = renegade:getTag("1v1Arrange"):toStringList()
		local rule = sgs.GetConfig("1v1/Rule", "2013")
		if rule == "2013" then
			if #list > 3 then
				return false
			end
		else
			if #list > 0 then
				return false
			end
		end
		return true
	end
end
--[[****************************************************************
	虎牢关模式（04_1v3）
]]--****************************************************************
sgs.same_camp["04_1v3"] = function(playerA, roleA, playerB, roleB)
	return roleA == roleB
end
sgs.am_winner["04_1v3"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" then --自己是吕布
		if n_rebel == 0 and n_lord == 1 then --联合军全军覆没，吕布存活
			return true
		end
	elseif role == "rebel" then --自己属于联合军
		if n_lord == 0 and n_rebel > 0 then --吕布死亡，联合军至少一人存活
			return true 
		end
	end
	return false
end
sgs.game_over["04_1v3"] = sgs.game_over["roles"]
--[[****************************************************************
	闯关模式（04_boss）
]]--****************************************************************
sgs.same_camp["04_boss"] = function(playerA, roleA, playerB, roleB)
	return roleA == roleB 
end
sgs.am_winner["04_boss"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" then --自己是BOSS
		if n_rebel == 0 and n_lord == 1 then --挑战者全军覆没、BOSS存活
			return true
		end
	elseif role == "rebel" then --自己是挑战者
		if n_lord == 0 and n_rebel > 0 then --BOSS死亡，挑战者至少一人存活
			if sgs.GetConfig("BossModeEndless", false) then
				return false
			elseif room:getTag("BossModeLevel"):toInt() < sgs.GetConfig("BossLevel", 0) - 1 then
				return false
			end
			return true
		end
	end
end
sgs.game_over["04_boss"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_rebel == 0 then --挑战者均死亡
		return true
	elseif n_lord == 0 then --BOSS死亡
		return true
	end
end
--[[****************************************************************
	3v3对战模式（06_3v3）
]]--****************************************************************
sgs.same_camp["06_3v3"] = function(playerA, roleA, playerB, roleB)
	if roleA == roleB then
		return true
	elseif string.match("lord|loyalist", roleA) and string.match("lord|loyalist", roleB) then
		return true
	elseif string.match("renegade|rebel", roleA) and string.match("renegade|rebel", roleB) then
		return true
	end
end
sgs.am_winner["06_3v3"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" or role == "loyalist" then --自己属于暖色方
		if n_renegade == 0 and n_lord == 1 then --冷色方主帅死亡，暖色方主帅存活
			return true
		end
	elseif role == "renegade" or role == "rebel" then --自己属于冷色方
		if n_lord == 0 and n_renegade == 1 then --暖色方主帅死亡，冷色方主帅存活
			return true
		end
	end
end
sgs.game_over["06_3v3"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_lord == 0 or n_renegade == 0 then --暖色方主帅死亡或冷色方主帅死亡
		return true
	end
end
--[[****************************************************************
	血战到底（06_XMode）
]]--****************************************************************
sgs.same_camp["06_XMode"] = sgs.same_camp["06_3v3"]
sgs.am_winner["06_XMode"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" or role == "loyalist" then --自己属于暖色方
		if n_renegade + n_rebel < 3 then
			local players = room:getPlayers()
			for _,p in sgs.qlist(players) do
				if p:getRole() == "renegade" then
					local backup = p:getTag("XModeBackup"):toStringList()
					if #backup == 0 then
						return true
					end
					break
				end
			end
		end
	elseif role == "renegade" or role == "rebel" then --自己属于冷色方
		if n_lord + n_loyalist < 3 then
			local players = room:getPlayers()
			for _,p in sgs.qlist(players) do
				if p:getRole() == "lord" then
					local backup = p:getTag("XModeBackup"):toStringList()
					if #backup == 0 then
						return true
					end
					break
				end
			end
		end
	end
end
sgs.game_over["06_XMode"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	local players = room:getPlayers()
	for _,p in sgs.qlist(players) do
		if p:getRole() == "lord" then
			local backup = p:getTag("XModeBackup"):toStringList()
			if #backup == 0 and n_lord + n_loyalist < 3 then
				return true
			end
		elseif p:getRole() == "renegade" then
			local backup = p:getTag("XModeBackup"):toStringList()
			if #backup == 0 and n_renegade + n_rebel < 3 then
				return true
			end
		end
	end
end
--[[****************************************************************
	守卫剑阁（08_defense）
]]--****************************************************************
sgs.same_camp["08_defense"] = function(playerA, roleA, playerB, roleB)
	return roleA == roleB 
end
sgs.am_winner["08_defense"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "loyalist" then --自己属于蜀势力防御方
		if n_rebel == 0 and n_loyalist > 0 then --魏势力全军覆没，蜀势力至少一人存活
			return true
		end
	elseif role == "rebel" then --自己属于魏势力进攻方
		if n_loyalist == 0 and n_rebel > 0 then --蜀势力全军覆没，魏势力至少一人存活
			return true
		end
	end
end
sgs.game_over["08_defense"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_loyalist == 0 or n_rebel == 0 then --蜀势力均死亡或魏势力均死亡
		return true
	end
end
--[[****************************************************************
	樊城之战（fancheng）
]]--****************************************************************
sgs.same_camp["fancheng"] = sgs.same_camp["roles"]
sgs.am_winner["fancheng"] = sgs.am_winner["roles"]
sgs.game_over["fancheng"] = sgs.game_over["roles"]
--[[****************************************************************
	绝境之战（impasse_fight）
]]--****************************************************************
sgs.same_camp["impasse_fight"] = sgs.same_camp["roles"]
sgs.am_winner["impasse_fight"] = sgs.am_winner["roles"]
sgs.game_over["impasse_fight"] = sgs.game_over["roles"]
--[[****************************************************************
	官渡之战（guandu）
]]--****************************************************************
sgs.same_camp["guandu"] = sgs.same_camp["roles"]
sgs.am_winner["guandu"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" or role == "loyalist" then --自己是袁绍、颜良文丑或甄姬
		if n_rebel == 0 and n_renegade == 0 and n_lord == 1 then --曹操、郭嘉、张辽、刘备、关羽均死亡，袁绍存活
			return true
		end
	elseif role == "renegade" then --自己是刘备或关羽
		if n_rebel == 0 and n_loyalist == 0 and n_lord == 0 and n_renegade > 0 then --主忠反均死亡
			return true
		end
	elseif role == "rebel" then --自己是曹操、郭嘉或张辽
		if n_lord == 0 then --袁绍阵亡
			if n_rebel > 0 or n_loyalist > 0 then --反贼至少一人存活；忠臣至少一人存活
				return true
			end
		end
	end
end
sgs.game_over["guandu"] = sgs.game_over["roles"]
--[[****************************************************************
	僵尸模式（zombie_mode）
]]--****************************************************************
sgs.same_camp["zombie_mode"] = sgs.same_camp["roles"]
sgs.am_winner["zombie_mode"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" or role == "loyalist" then --自己是人类
		if room:getLord():getMark("@round") >= 8 then --人类主公获得8枚退治标记
			return true
		elseif room:getTag("Round"):toInt() > 2 then
			if n_rebel == 0 and n_renegade == 0 and n_loyalist + n_lord > 0 then --僵尸全军覆没，人类至少一人存活
				return true 
			end
		end
	elseif role == "rebel" then --自己是大僵尸
		if n_lord == 0 and n_loyalist == 0 and n_rebel + n_renegade > 0 then --人类全军覆没，僵尸至少一人存活
			return true
		end
	end
end
sgs.game_over["zombie_mode"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_lord > 0 and room:getLord():getMark("@round") >= 8 then --人类主公获得8枚“退治”标记
		return true
	elseif n_lord == 0 and n_loyalist == 0 then --人类均死亡
		return true
	elseif room:getTag("Round"):toInt() > 2 and n_rebel == 0 and n_renegade == 0 then --僵尸均死亡
		return true
	end
end
--[[****************************************************************
	夫妻协战（couple）
]]--****************************************************************
sgs.same_camp["couple"] = function(playerA, roleA, playerB, roleB)
	local spouse = playerA:getTag("spouse"):toPlayer()
	if spouse and spouse:objectName() == playerB then
		return true
	end
end
sgs.am_winner["couple"] = function(room, player, role, n_lord, n_loyalist, n_renegade, n_rebel)
	if role == "lord" or role == "loyalist" then --自己是曹操或被夺之妻
		if n_renegade == 0 and n_lord == 1 then
			return true
		end
	elseif role == "renegade" then --自己是夫妻之一
		if count <= 2 then
			local spouse = sgs.glory_data["player"]:getTag("spouse"):toPlayer()
			local name = sgs.glory_data["player_objectName"]
			local name2 = spouse and spouse:objectName() or ""
			local alives = room:getAlivePlayers()
			local other_alive = false
			for _,p in sgs.qlist(alives) do
				if p:objectName() ~= name and p:objectName() ~= name2 then
					other_alive = true
					break
				end
			end
			if not other_alive then
				return true
			end
		end
	end
end
sgs.game_over["couple"] = function(room, player, n_lord, n_loyalist, n_renegade, n_rebel)
	if n_renegade == 0 then --夫妻档均死亡
		return true
	elseif n_lord == 0 and n_loyalist == 0 then --曹操和被夺之妻均死亡
		if n_renegade == 1 then --只剩一名夫妻档成员
			return true
		elseif n_renegade == 2 then --只剩两名夫妻档成员
			local alives = self.room:getAlivePlayers()
			local playerA, playerB = alives:first(), alives:at(1)
			local spouse = playerA:getTag("spouse"):toPlayer()
			if spouse and spouse:objectName() == playerB:objectName() then --剩余两名成员为夫妻
				return true
			end
		end
	end
end
--[[****************************************************************
	小型场景
]]--****************************************************************
--[[****************************************************************
	自定义场景（custom_scenario）
]]--****************************************************************