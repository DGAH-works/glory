--[[
	太阳神三国杀游戏工具扩展包·战功荣耀（通用战功部分）
	适用版本：V2 - 愚人版（版本号：20150401）清明补丁（版本号：20150405）
]]--
--[[****************************************************************
	战功：安乐公
	描述：在1局游戏中，累计3次被乐不思蜀后判定牌都不是红桃
]]--****************************************************************
sgs.glory_info["AnLeGong"] = {
	name = "AnLeGong",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial},
	data = "AnLeGong_data",
	keys = {
		"count",
	},
}
sgs.AnLeGong_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].AnLeGong = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "indulgence" then
		if isTarget(player) and judge:isBad() then
			addInfo("AnLeGong", "count", 1)
			if getInfo("AnLeGong", "count", 0) >= 3 then
				addFinishTag("AnLeGong")
			end
		end
	end
end
--[[****************************************************************
	战功：八门金锁
	描述：在1局游戏中，装备八卦阵连续判定红色花色至少5次
]]--****************************************************************
sgs.glory_info["BaMenJinSuo"] = {
	name = "BaMenJinSuo",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial},
	data = "BaMenJinSuo_data",
	keys = {
		"count",
	},
}
sgs.BaMenJinSuo_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].BaMenJinSuo = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "eight_diagram" and isTarget(player) then
		if judge:isGood() then
			addInfo("BaMenJinSuo", "count", 1)
			if getInfo("BaMenJinSuo", "count", 0) >= 5 then
				addFinishTag("BaMenJinSuo")
			end
		else
			setInfo("BaMenJinSuo", "count", 0)
		end
	end
end
--[[****************************************************************
	战功：百人斩
	描述：累积杀死100人
]]--****************************************************************
sgs.glory_info["BaiRenZhan"] = {
	name = "BaiRenZhan",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "BaiRenZhan_data",
	keys = {
		--"Global_kill",
		"count",
	},
}
sgs.BaiRenZhan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].BaiRenZhan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		addInfo("BaiRenZhan", "count", 1)
		local count = getInfo("BaiRenZhan", "count", 0)
		local kill = getInfo("BaiRenZhan", "Global_kill", 0)
		local total = kill + count
		if total < 100 then
			addInfo("BaiRenZhan", "Global_kill", 1)
		else
			setInfo("BaiRenZhan", "Global_kill", 0)
			addFinishTag("BaiRenZhan")
		end
	end
end
--[[****************************************************************
	战功：败家子
	描述：在一局游戏中，弃牌阶段累计弃掉至少10张桃
]]--****************************************************************
sgs.glory_info["BaiJiaZi"] = {
	name = "BaiJiaZi",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardsMoveOneTime},
	data = "BaiJiaZi_data",
	keys = {
		"count",
	},
}
sgs.BaiJiaZi_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].BaiJiaZi = function(self, player, data)
	local move = data:toMoveOneTime()
	local source = move.from
	if source and source:objectName() == player:objectName() then
		if isTarget(source) and player:getPhase() == sgs.Player_Discard then
			local basic = bit32.band(move.reason.m_reason, sgs.CardMoveReason_S_MASK_BASIC_REASON)
			if basic == sgs.CardMoveReason_S_REASON_DISCARD then
				for index, id in sgs.qlist(move.card_ids) do
					local peach = sgs.Sanguosha:getCard(id)
					if peach:isKindOf("Peach") then
						addInfo("BaiJiaZi", "count", 1)
						if getInfo("BaiJiaZi", "count", 0) >= 10 then
							if addFinishTag("BaiJiaZi") then
								return 
							end
						end
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：搬石砸脚
	描述：与人决斗失败累计10次
]]--****************************************************************
sgs.glory_info["BanShiZaJiao"] = {
	name = "BanShiZaJiao",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffect, sgs.ChoiceMade, sgs.CardFinished},
	data = "BanShiZaJiao_data",
	keys = {
		--"Global_fail",
		"duel",
		"count",
	},
}
sgs.BanShiZaJiao_data = {}
sgs.ai_event_callback[sgs.CardEffect].BanShiZaJiao = function(self, player, data)
	local effect = data:toCardEffect()
	if effect.card:isKindOf("Duel") then
		local target = effect.to
		if target and target:objectName() == player:objectName() then
			if isTarget(target) or isTarget(effect.from) then
				setInfo("BanShiZaJiao", "duel", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].BanShiZaJiao = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --cardResponded:slash:duel-slash:sgs1:_nil_
		if msg[1] == "cardResponded" and msg[2] == "slash" and msg[#msg] == "_nil_" then
			if getInfo("BanShiZaJiao", "duel", 0) == 1 and isTarget(player) then
				addInfo("BanShiZaJiao", "count", 1)
				local count = getInfo("BanShiZaJiao", "count", 0)
				local fail = getInfo("BanShiZaJiao", "Global_fail", 0)
				local total = fail + count
				if total < 10 then
					addInfo("BanShiZaJiao", "Global_fail", 1)
				else
					setInfo("BanShiZaJiao", "Global_fail", 0)
					addFinishTag("BanShiZaJiao")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].BanShiZaJiao = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("Duel") and getInfo("BanShiZaJiao", "duel", 0) == 1 then
		local source = use.from
		if source and source:objectName() == player:objectName() then
			if isTarget(source) then
				setInfo("BanShiZaJiao", "duel", 0)
			else
				for _,target in sgs.qlist(use.to) do
					if isTarget(target) then
						setInfo("BanShiZaJiao", "duel", 0)
						return 
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：暴君
	描述：身为主公在1局游戏中，在反贼和内奸全部存活的情况下杀死全部忠臣，并最后胜利
]]--****************************************************************
sgs.glory_info["BaoJun"] = {
	name = "BaoJun",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "BaoJun_data",
	keys = {
		"kill_loyalist",
	},
}
sgs.BaoJun_data = {}
sgs.ai_event_callback[sgs.NonTrigger].BaoJun = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and player:getRole() == "lord" then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if victim:getRole() == "loyalist" then
			local players = self.room:getPlayers()
			for _,p in sgs.qlist(players) do
				if p:isDead() then
					if p:getRole() == "rebel" or p:getRole() == "renegade" then
						return 
					end
				end
			end
			addInfo("BaoJun", "kill_loyalist", 1)
		end
	elseif cmd == "gloryGameOverJudge" then
		if amWinner() then
			local players = self.room:getPlayers()
			local count = 0
			for _,p in sgs.qlist(players) do
				if p:getRole() == "loyalist" then
					if p:isAlive() then
						return 
					else
						count = count + 1
					end
				end
			end
			if count > 0 and getInfo("BaoJun", "kill_loyalist", 0) >= count then
				addFinishTag("BaoJun")
			end
		end
	end
end
--[[****************************************************************
	战功：被看穿了吗
	描述：一局游戏中，使用火攻失败至少3次
]]--****************************************************************
sgs.glory_info["BeiKanChuanLeMa"] = {
	name = "BeiKanChuanLeMa",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.ChoiceMade},
	data = "BeiKanChuanLeMa_data",
	keys = {
		"count",
	},
}
sgs.BeiKanChuanLeMa_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].BeiKanChuanLeMa = function(self, player, data)
	local info = data:toString():split(":") or {}
	if info[1] == "cardResponded" and isTarget(player) then
		if info[3] == "@fire-attack" and info[#info] == "_nil_" then
			addInfo("BeiKanChuanLeMa", "count", 1)
			if getInfo("BeiKanChuanLeMa", "count") >= 3 then
				addFinishTag("BeiKanChuanLeMa")
			end
		end
	end
end
--[[****************************************************************
	战功：兵精粮足
	描述：在1局游戏中，累计3次被兵粮寸断后判定牌都是草花
]]--****************************************************************
sgs.glory_info["BingJingLiangZu"] = {
	name = "BingJingLiangZu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial},
	data = "BingJingLiangZu_data",
	keys = {
		"count",
	},
}
sgs.BingJingLiangZu_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].BingJingLiangZu = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "supply_shortage" and isTarget(player) then
		if judge:isGood() then
			addInfo("BingJingLiangZu", "count", 1)
			if getInfo("BingJingLiangZu", "count", 0) >= 3 then
				addFinishTag("BingJingLiangZu")
			end
		end
	end
end
--[[****************************************************************
	战功：兵器库
	描述：在一局游戏中，累计装备过至少10次武器以及10次防具
]]--****************************************************************
sgs.glory_info["BingQiKu"] = {
	name = "BingQiKu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardsMoveOneTime},
	data = "BingQiKu_data",
	keys = {
		"weapon_count",
		"armor_count",
	},
}
sgs.BingQiKu_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].BingQiKu = function(self, player, data)
	local move = data:toMoveOneTime()
	local target = move.to
	if target and target:objectName() == player:objectName() then
		if isTarget(player) and move.to_place == sgs.Player_PlaceEquip then
			local flag = false
			for index, id in sgs.qlist(move.card_ids) do
				local equip = sgs.Sanguosha:getCard(id)
				if equip:isKindOf("Weapon") then
					flag = true
					addInfo("BingQiKu", "weapon_count", 1)
				elseif equip:isKindOf("Armor") then
					flag = true
					addInfo("BingQiKu", "armor_count", 1)
				end
			end
			if flag and getInfo("BingQiKu", "weapon_count", 0) >= 10 then
				if getInfo("BingQiKu", "armor_count", 0) >= 10 then
					addFinishTag("BingQiKu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：秉公无私
	描述：身为主公在一局游戏中从未对忠臣造成伤害，并取得胜利
]]--****************************************************************
sgs.glory_info["BingGongWuSi"] = {
	name = "BingGongWuSi",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "BingGongWuSi_data",
	keys = {
		"damage_to_loyalist",
	},
}
sgs.BingGongWuSi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].BingGongWuSi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" then
		if player:getRole() == "lord" and isTarget(player) then
			local damage = self.room:getTag("gloryData"):toDamage()
			if damage.to:getRole() == "loyalist" then
				setInfo("BingGongWuSi", "damage_to_loyalist", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amWinner() and amLord() and getInfo("BingGongWuSi", "damage_to_loyalist", 0) == 0 then
			local players = self.room:getPlayers() 
			for _,p in sgs.qlist(players) do
				if p:getRole() == "loyalist" then
					addFinishTag("BingGongWuSi")
					return 
				end
			end
		end
	end
end
--[[****************************************************************
	战功：不屈不挠
	描述：一格体力情况下，累计出闪100次
]]--****************************************************************
sgs.glory_info["BuQuBuNao"] = {
	name = "BuQuBuNao",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.PreCardUsed, sgs.PreCardResponded},
	data = "BuQuBuNao_data",
	keys = {
		--"Global_times",
	},
}
sgs.BuQuBuNao_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].BuQuBuNao = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("Jink") and player:getHp() == 1 then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			addInfo("BuQuBuNao", "Global_times", 1)
			if getInfo("BuQuBuNao", "Global_times", 0) >= 100 then
				setInfo("BuQuBuNao", "Global_times", 0)
				addFinishTag("BuQuBuNao")
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardResponded].BuQuBuNao = function(self, player, data)
	local response = data:toCardResponse()
	if response.m_card:isKindOf("Jink") and player:getHp() == 1 then
		addInfo("BuQuBuNao", "Global_times", 1)
		if getInfo("BuQuBuNao", "Global_times", 0) >= 100 then
			setInfo("BuQuBuNao", "Global_times", 0)
			addFinishTag("BuQuBuNao")
		end
	end
end
--[[****************************************************************
	战功：拆迁办
	描述：在一个回合内使用卡牌过河拆桥/顺手牵羊累计4次
]]--****************************************************************
sgs.glory_info["ChaiQianBan"] = {
	name = "ChaiQianBan",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardUsed, sgs.EventPhaseStart},
	data = "ChaiQianBan_data",
	keys = {
		"dismantlement_count",
		"snatch_count",
	},
}
sgs.ChaiQianBan_data = {}
sgs.ai_event_callback[sgs.CardUsed].ChaiQianBan = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		local trick = use.card
		if trick:isKindOf("Dismantlement") then
			addInfo("ChaiQianBan", "dismantlement_count", 1)
		elseif trick:isKindOf("Snatch") then
			addInfo("ChaiQianBan", "snatch_count", 1)
		else
			return 
		end
		if getInfo("ChaiQianBan", "dismantlement_count", 0) + getInfo("ChaiQianBan", "snatch_count", 0) >= 4 then
			addFinishTag("ChaiQianBan")
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].ChaiQianBan = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("ChaiQianBan", "dismantlement_count", 0)
		setInfo("ChaiQianBan", "snatch_count", 0)
	end
end
--[[****************************************************************
	战功：拆迁大队
	描述：在一局游戏中，累计使用卡牌过河拆桥10次以上
]]--****************************************************************
sgs.glory_info["ChaiQianDaDui"] = {
	name = "ChaiQianDaDui",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardUsed},
	data = "ChaiQianDaDui_data",
	keys = {
		"count",
	},
}
sgs.ChaiQianDaDui_data = {}
sgs.ai_event_callback[sgs.CardUsed].ChaiQianDaDui = function(self, player, data)
	local use = data:toCardUse()
	local dismantlement = use.card
	if dismantlement and dismantlement:isKindOf("Dismantlement") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			addInfo("ChaiQianDaDui", "count", 1)
			if getInfo("ChaiQianDaDui", "count", 0) >= 10 then
				addFinishTag("ChaiQianDaDui")
			end
		end
	end
end
--[[****************************************************************
	战功：常胜将军
	描述：连续胜利10局
]]--****************************************************************
sgs.glory_info["ChangShengJiangJun"] = {
	name = "ChangShengJiangJun",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "ChangShengJiangJun_data",
	keys = {
		--"Global_count",
	},
}
sgs.ChangShengJiangJun_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ChangShengJiangJun = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isGameOver() then
		if amWinner() then
			addInfo("ChangShengJiangJun", "Global_count", 1)
			if getInfo("ChangShengJiangJun", "Global_count", 0) >= 10 then
				setInfo("ChangShengJiangJun", "Global_count", 0)
				addFinishTag("ChangShengJiangJun")
			end
		else
			setInfo("ChangShengJiangJun", "Global_count", 0)
		end
	end
end
--[[****************************************************************
	战功：趁虚而入
	描述：身为反贼在1局游戏中，在自己的第1回合时手刃主公
]]--****************************************************************
sgs.glory_info["ChenXuErRu"] = {
	name = "ChenXuErRu",
	state = "验证通过",
	once_only = true,
	mode = "roles",
	events = {sgs.NonTrigger, sgs.TurnStart},
	data = "ChenXuErRu_data",
	keys = {
		"turn",
	},
}
sgs.ChenXuErRu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ChenXuErRu = function(self, player, data)
	if player:getRole() == "rebel" then
		local cmd = data:toString()
		if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
			if getInfo("ChenXuErRu", "turn", 0) == 0 then
				local death = self.room:getTag("gloryData"):toDeath()
				local victim = death.who
				if victim:getRole() == "lord" then
					addFinishTag("ChenXuErRu")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].ChenXuErRu = function(self, player, data)
	if isTarget(player) then
		addInfo("ChenXuErRu", "turn", 1)
	end
end
--[[****************************************************************
	战功：赤胆忠心
	描述：身为忠臣在1局游戏中，手刃至少2个反贼或内奸
]]--****************************************************************
sgs.glory_info["ChiDanZhongXin"] = {
	name = "ChiDanZhongXin",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "ChiDanZhongXin_data",
	keys = {
		"kill_rebel",
		"kill_renegade",
	},
}
sgs.ChiDanZhongXin_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ChiDanZhongXin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and player:getRole() == "loyalist" then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		local role = victim:getRole()
		if role == "rebel" then
			addInfo("ChiDanZhongXin", "kill_rebel", 1)
		elseif role == "renegade" then
			addInfo("ChiDanZhongXin", "kill_renegade", 1)
		else
			return 
		end
		if getInfo("ChiDanZhongXin", "kill_rebel", 0) + getInfo("ChiDanZhongXin", "kill_renegade", 0) >= 2 then
			addFinishTag("ChiDanZhongXin")
		end
	end
end
--[[****************************************************************
	战功：打酱油的
	描述：在1局游戏中，在自己的回合开始前就死亡
]]--****************************************************************
sgs.glory_info["DaJiangYouDe"] = {
	name = "DaJiangYouDe",
	state = "验证通过",
	once_only = true,
	mode = "all_modes",
	events = {sgs.EventPhaseStart, sgs.NonTrigger},
	data = "DaJiangYouDe_data",
	keys = {
		"turn_start",
	},
}
sgs.DaJiangYouDe_data = {}
sgs.ai_event_callback[sgs.EventPhaseStart].DaJiangYouDe = function(self, player, data)
	if player:getPhase() == sgs.Player_RoundStart and isTarget(player) then
		setInfo("DaJiangYouDe", "turn_start", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].DaJiangYouDe = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) then
		if getInfo("DaJiangYouDe", "turn_start", 0) == 0 then
			addFinishTag("DaJiangYouDe")
		end
	end
end
--[[****************************************************************
	战功：打铁匠
	描述：累计将铁索连环重铸30次
]]--****************************************************************
sgs.glory_info["DaTieJiang"] = {
	name = "DaTieJiang",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardsMoveOneTime},
	data = "DaTieJiang_data",
	keys = {
		--"Global_times",
	},
}
sgs.DaTieJiang_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].DaTieJiang = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.reason.m_reason == sgs.CardMoveReason_S_REASON_RECAST then
		local source = move.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			addInfo("DaTieJiang", "Global_times", 1)
			if getInfo("DaTieJiang", "Global_times", 0) >= 30 then
				setInfo("DaTieJiang", "Global_times", 0)
				addFinishTag("DaTieJiang")
			end
		end
	end
end
--[[****************************************************************
	战功：大事化小
	描述：一局游戏中发动白银狮子特效减少伤害至少1次
]]--****************************************************************
sgs.glory_info["DaShiHuaXiao"] = {
	name = "DaShiHuaXiao",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger, sgs.DamageInflicted},
	data = "DaShiHuaXiao_data",
	keys = {
		"count",
	},
}
sgs.DaShiHuaXiao_data = {}
sgs.ai_event_callback[sgs.NonTrigger].DaShiHuaXiao = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageInflicted" and isTarget(player) and player:hasArmorEffect("silver_lion") then
		local damage = self.room:getTag("gloryData"):toDamage()
		if damage.damage > 1 then
			player:setFlags("glory_DaShiHuaXiao_Attention")
		end
	end
end
sgs.ai_event_callback[sgs.DamageInflicted].DaShiHuaXiao = function(self, player, data)
	if player:hasFlag("glory_DaShiHuaXiao_Attention") then
		player:setFlags("-glory_DaShiHuaXiao_Attention")
		local damage = data:toDamage()
		if damage.damage <= 1 then
			addInfo("DaShiHuaXiao", "count", 1)
			if getInfo("DaShiHuaXiao", "count", 0) >= 1 then
				addFinishTag("DaShiHuaXiao")
			end
		end
	end
end
--[[****************************************************************
	战功：刀枪不入
	描述：一局游戏中发动仁王盾特效3次
]]--****************************************************************
sgs.glory_info["DaoQiangBuRu"] = {
	name = "DaoQiangBuRu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.SlashEffected},
	data = "DaoQiangBuRu_data",
	keys = {
		"count",
	},
}
sgs.DaoQiangBuRu_data = {}
sgs.ai_event_callback[sgs.SlashEffected].DaoQiangBuRu = function(self, player, data)
	local effect = data:toSlashEffect()
	local target = effect.to
	if target and target:objectName() == player:objectName() and isTarget(player) then
		if target:hasArmorEffect("renwang_shield") and effect.slash:isBlack() then
			addInfo("DaoQiangBuRu", "count", 1)
			if getInfo("DaoQiangBuRu", "count", 0) >= 3 then
				addFinishTag("DaoQiangBuRu")
			end
		end
	end
end
--[[****************************************************************
	战功：东宫西略
	描述：在一局游戏中，身份为男性主公，而忠臣为两名女性武将并在女性忠臣全部存活的情况下获胜
]]--****************************************************************
sgs.glory_info["DongGongXiLve"] = {
	name = "DongGongXiLve",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "DongGongXiLve_data",
	keys = {},
}
sgs.DongGongXiLve_data = {}
sgs.ai_event_callback[sgs.NonTrigger].DongGongXiLve = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		if amLord() and amMale() and amWinner() then
			local players = self.room:getPlayers()
			local count = 0
			for _,p in sgs.qlist(players) do
				if p:getRole() == "loyalist" then
					if p:isFemale() and p:isAlive() then
						count = count + 1
					else
						return 
					end
				end
			end
			if count == 2 then
				addFinishTag("DongGongXiLve")
			end
		end
	end
end
--[[****************************************************************
	战功：更大的炮灰
	描述：被南蛮入侵或万箭齐发打死累计50次
]]--****************************************************************
sgs.glory_info["GengDaDePaoHui"] = {
	name = "GengDaDePaoHui",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "GengDaDePaoHui_data",
	keys = {
		--"Global_savage_assault_times",
		--"Global_archery_attack_times",
	},
}
sgs.GengDaDePaoHui_data = {}
sgs.ai_event_callback[sgs.NonTrigger].GengDaDePaoHui = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local reason = death.damage
		if reason then
			local aoe = reason.card
			if aoe and aoe:isKindOf("AOE") then
				if aoe:isKindOf("SavageAssault") then
					addInfo("GengDaDePaoHui", "Global_savage_assault_times", 1)
				elseif aoe:isKindOf("ArcheryAttack") then
					addInfo("GengDaDePaoHui", "Global_archery_attack_times", 1)
				end
				local count = getInfo("GengDaDePaoHui", "Global_savage_assault_times", 0)
				count = count + getInfo("GengDaDePaoHui", "Global_archery_attack_times", 0)
				if count >= 50 then
					setInfo("GengDaDePaoHui", "Global_savage_assault_times", 0)
					setInfo("GengDaDePaoHui", "Global_archery_attack_times", 0)
					addFinishTag("GengDaDePaoHui")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：攻其不备
	描述：一局游戏中，成功使用火攻造成伤害至少3次
]]--****************************************************************
sgs.glory_info["GongQiBuBei"] = {
	name = "GongQiBuBei",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "GongQiBuBei_data",
	keys = {
		"count",
	},
}
sgs.GongQiBuBei_data = {}
sgs.ai_event_callback[sgs.NonTrigger].GongQiBuBei = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) then
		local damage = self.room:getTag("gloryData"):toDamage()
		local fire_attack = damage.card
		if fire_attack and fire_attack:isKindOf("FireAttack") then
			addInfo("GongQiBuBei", "count", 1)
			if getInfo("GongQiBuBei", "count", 0) >= 3 then
				addFinishTag("GongQiBuBei")
			end
		end
	end
end
--[[****************************************************************
	战功：狗屎运
	描述：当你的开局4牌的颜色全为黑色时,清除你的N盘逃跑记录(N为5-10的随机数)
]]--****************************************************************
sgs.glory_info["GouShiYun"] = {
	name = "GouShiYun",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.AfterDrawInitialCards},
	data = "GouShiYun_data",
	keys = {},
}
sgs.GouShiYun_data = {}
sgs.ai_event_callback[sgs.AfterDrawInitialCards].GouShiYun = function(self, player, data)
	if isTarget(player) then
		local handcards = player:getHandcards()
		if handcards:length() == 4 then
			for _,c in sgs.qlist(handcards) do
				if not c:isBlack() then
					return 
				end
			end
			addFinishTag("GouShiYun")
			local n = math.random(5, 10)
			clearEscapeRecord(self.room, player, n)
		end
	end
end
function clearEscapeRecord(room, player, n)
	local roles, hegemony = 0, 0
	local r_count, h_count = 0, 0
	local r_times = getInfo("statistics", "Global_roles_play_times", 0)
	local h_times = getInfo("statistics", "Global_hegemony_play_times", 0)
	local r_finish = getInfo("statistics", "Global_roles_finish_times", 0)
	local h_finish = getInfo("statistics", "Global_hegemony_finish_times", 0)
	local r_escape = math.max(0, r_times - r_finish)
	local h_escape = math.max(0, h_times - h_finish)
	if r_escape == 0 then
		if h_escape == 0 then
			return
		else
			roles, hegemony = n, 0
			r_count, h_count = math.min(roles, r_escape), 0
		end
	else
		if h_escape == 0 then
			roles, hegemony = 0, n
			r_count, h_count = 0, math.min(hegemony, h_escape)
		else
			local rate = r_escape / h_escape
			roles = math.max(0, math.ceil(n * rate))
			hegemony = n - roles
			r_count = math.min(roles, r_escape)
			h_count = math.min(hegemony, h_escape)
		end
	end
	setInfo("statistics", "Global_roles_play_times", r_times - r_count)
	setInfo("statistics", "Global_hegemony_play_times", h_times - h_count)
	if roles > 0 then
		local msg = sgs.LogMessage()
		msg.type = "#ClearRolesEscapeRate"
		msg.from = player
		msg.arg = roles
		msg.arg2 = r_count
		room:sendLog(msg) --发送提示信息
	end
	if hegemony > 0 then
		local msg = sgs.LogMessage()
		msg.type = "#ClearHegemonyEscapeRate"
		msg.from = player
		msg.arg = hegemony
		msg.arg2 = h_count
		room:sendLog(msg) --发送提示信息
	end
end
--[[****************************************************************
	战功：苟延残喘
	描述：在1局游戏中被救活至少5次
]]--****************************************************************
sgs.glory_info["GouYanCanChuan"] = {
	name = "GouYanCanChuan",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.PreHpRecover, sgs.HpRecover},
	data = "GouYanCanChuan_data",
	keys = {
		"count",
	},
}
sgs.GouYanCanChuan_data = {}
sgs.ai_event_callback[sgs.PreHpRecover].GouYanCanChuan = function(self, player, data)
	if player:hasFlag("Global_Dying") and isTarget(player) then
		player:setFlags("glory_GouYanCanChuan_Attention")
	else
		player:setFlags("-glory_GouYanCanChuan_Attention")
	end
end
sgs.ai_event_callback[sgs.HpRecover].GouYanCanChuan = function(self, player, data)
	if player:hasFlag("glory_GouYanCanChuan_Attention") then
		local recover = data:toRecover()
		if player:getHp() > 0 and recover.recover > 0 then
			player:setFlags("-glory_GouYanCanChuan_Attention")
			addInfo("GouYanCanChuan", "count", 1)
			if getInfo("GouYanCanChuan", "count", 0) >= 5 then
				addFinishTag("GouYanCanChuan")
			end
		end
	end
end
--[[****************************************************************
	战功：诡计重重
	描述：在一局游戏中，累计使用锦囊牌至少20次
]]--****************************************************************
sgs.glory_info["GuiJiChongChong"] = {
	name = "GuiJiChongChong",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardUsed},
	data = "GuiJiChongChong_data",
	keys = {
		"count",
	},
}
sgs.GuiJiChongChong_data = {}
sgs.ai_event_callback[sgs.CardUsed].GuiJiChongChong = function(self, player, data)
	local use = data:toCardUse()
	local trick = use.card
	if trick and trick:isKindOf("TrickCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			addInfo("GuiJiChongChong", "count", 1)
			if getInfo("GuiJiChongChong", "count", 0) >= 20 then
				addFinishTag("GuiJiChongChong")
			end
		end
	end
end
--[[****************************************************************
	战功：果农
	描述：游戏开始时，起手手牌全部是“桃”
]]--****************************************************************
sgs.glory_info["GuoNong"] = {
	name = "GuoNong",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.AfterDrawInitalCards},
	data = "GuoNong_data",
	keys = {},
}
sgs.GuoNong_data = {}
sgs.ai_event_callback[sgs.AfterDrawInitialCards].GuoNong = function(self, player, data)
	if isTarget(player) then
		local handcards = self.player:getHandcards()
		if not handcards:isEmpty() then
			for _,c in sgs.qlist(handcards) do
				if not c:isKindOf("Peach") then
					return 
				end
			end
		end
		addFinishTag("GuoNong")
	end
end
--[[****************************************************************
	战功：何以解忧
	描述：一局游戏中，使用酒回复体力至少2次
]]--****************************************************************
sgs.glory_info["HeYiJieYou"] = {
	name = "HeYiJieYou",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.HpRecover},
	data = "HeYiJieYou_data",
	keys = {
		"count",
	},
}
sgs.HeYiJieYou_data = {}
sgs.ai_event_callback[sgs.HpRecover].HeYiJieYou = function(self, player, data)
	local recover = data:toRecover()
	local anal = recover.card
	if anal and anal:isKindOf("Analeptic") and isTarget(player) and recover.recover > 0 then
		addInfo("HeYiJieYou", "count", 1)
		if getInfo("HeYiJieYou", "count", 0) >= 2 then
			addFinishTag("HeYiJieYou")
		end
	end
end
--[[****************************************************************
	战功：横扫千军
	描述：在1局游戏中，手刃7名角色并且获得胜利
]]--****************************************************************
sgs.glory_info["HengSaoQianJun"] = {
	name = "HengSaoQianJun",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "HengSaoQianJun_data",
	keys = {
		"count",
	},
}
sgs.HengSaoQianJun_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HengSaoQianJun = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) then
			addInfo("HengSaoQianJun", "count", 1)
		end
	elseif cmd == "gloryGameOverJudge" then
		if amWinner() and getInfo("HengSaoQianJun", "count", 0) >= 7 then
			addFinishTag("HengSaoQianJun")
		end
	end
end
--[[****************************************************************
	战功：鸿运当头
	描述：在1个回合内使用至少3次无中生有
]]--****************************************************************
sgs.glory_info["HongYunDangTou"] = {
	name = "HongYunDangTou",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardUsed, sgs.EventPhaseStart},
	data = "HongYunDangTou_data",
	keys = {
		"count",
	},
}
sgs.HongYunDangTou_data = {}
sgs.ai_event_callback[sgs.CardUsed].HongYunDangTou = function(self, player, data)
	local use = data:toCardUse()
	local trick = use.card
	if trick and trick:isKindOf("ExNihilo") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			addInfo("HongYunDangTou", "count", 1)
			if getInfo("HongYunDangTou", "count", 0) >= 3 then
				addFinishTag("HongYunDangTou")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].HongYunDangTou = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("HongYunDangTou", "count", 0)
	end
end
--[[****************************************************************
	战功：饥肠辘辘
	描述：在1局游戏中，累计3次被兵粮寸断后判定牌都不是草花
]]--****************************************************************
sgs.glory_info["JiChangLuLu"] = {
	name = "JiChangLuLu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial},
	data = "JiChangLuLu_data",
	keys = {
		"count",
	},
}
sgs.JiChangLuLu_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].JiChangLuLu = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "supply_shortage" and judge:isBad() then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			addInfo("JiChangLuLu", "count", 1)
			if getInfo("JiChangLuLu", "count", 0) >= 3 then
				addFinishTag("JiChangLuLu")
			end
		end
	end
end
--[[****************************************************************
	战功：极乐世界
	描述：在1局游戏中，累计3次被乐不思蜀后判定牌都是红桃
]]--****************************************************************
sgs.glory_info["JiLeShiJie"] = {
	name = "JiLeShiJie",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial},
	data = "JiLeShiJie_data",
	keys = {
		"count",
	},
}
sgs.JiLeShiJie_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].JiLeShiJie = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "indulgence" and judge:isGood() then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			addInfo("JiLeShiJie", "count", 1)
			if getInfo("JiLeShiJie", "count", 0) >= 3 then
				addFinishTag("JiLeShiJie")
			end
		end
	end
end
--[[****************************************************************
	战功：箭无虚发
	描述：使用1次万箭齐发打死至少3名角色
]]--****************************************************************
sgs.glory_info["JianWuXuFa"] = {
	name = "JianWuXuFa",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardFinished, sgs.NonTrigger},
	data = "JianWuXuFa_data",
	keys = {
		"count",
	},
}
sgs.JianWuXuFa_data = {}
sgs.ai_event_callback[sgs.CardFinished].JianWuXuFa = function(self, player, data)
	local use = data:toCardUse()
	local aoe = use.card
	if aoe and aoe:isKindOf("ArcheryAttack") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then 
			setInfo("JianWuXuFa", "count", 0)
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].JianWuXuFa = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local aoe = death.damage.card
		if aoe and aoe:isKindOf("ArcheryAttack") then
			addInfo("JianWuXuFa", "count", 1)
			if getInfo("JianWuXuFa", "count", 0) >= 3 then
				addFinishTag("JianWuXuFa")
			end
		end
	end
end
--[[****************************************************************
	战功：竭智尽忠
	描述：身为忠臣在1局游戏中，在自己的首回合中手刃一个反贼或内奸，最后取得胜利
]]--****************************************************************
sgs.glory_info["JieZhiJinZhong"] = {
	name = "JieZhiJinZhong",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger, sgs.TurnStart},
	data = "JieZhiJinZhong_data",
	keys = {
		"turn",
		"kill_rebel",
		"kill_renegade",
	},
}
sgs.JieZhiJinZhong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JieZhiJinZhong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and getInfo("JieZhiJinZhong", "turn", 0) == 0 then
			local death = self.room:getTag("gloryData"):toDeath()
			local role = death.who:getRole()
			if role == "rebel" then
				addInfo("JieZhiJinZhong", "kill_rebel", 1)
			elseif role == "renegade" then
				addInfo("JieZhiJinZhong", "kill_renegade", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amLoyalist() and amWinner() then
			if getInfo("JieZhiJinZhong", "kill_rebel", 0) + getInfo("JieZhiJinZhong", "kill_renegade", 0) >= 1 then
				addFinishTag("JieZhiJinZhong")
			end
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].JieZhiJinZhong = function(self, player, data)
	if player:getRole() == "loyalist" and isTarget(player) then
		addInfo("JieZhiJinZhong", "turn", 1)
	end
end
--[[****************************************************************
	战功：酒鬼
	描述：出牌阶段开始时，手牌中至少有3张“酒”
]]--****************************************************************
sgs.glory_info["JiuGui"] = {
	name = "JiuGui",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.EventPhaseStart},
	data = "JiuGui_data",
	keys = {},
}
sgs.JiuGui_data = {}
sgs.ai_event_callback[sgs.EventPhaseStart].JiuGui = function(self, player, data)
	if player:getPhase() == sgs.Player_Play and isTarget(player) then
		local handcards = self.player:getHandcards()
		local count = 0
		for _,anal in sgs.qlist(handcards) do
			if anal:isKindOf("Analeptic") then
				count = count + 1
			end
		end
		if count >= 3 then
			addFinishTag("JiuGui")
		end
	end
end
--[[****************************************************************
	战功：举火燎天
	描述：在一局游戏中，造成火焰伤害累计10点以上，不含武将技能
]]--****************************************************************
sgs.glory_info["JuHuoLiaoTian"] = {
	name = "JuHuoLiaoTian",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "JuHuoLiaoTian_data",
	keys = {
		"count",
	},
}
sgs.JuHuoLiaoTian_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JuHuoLiaoTian = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) then
		local damage = self.room:getTag("gloryData"):toDamage()
		if damage.nature == sgs.DamageStruct_Fire then
			local skillcard = damage.card
			if skillcard and skillcard:isKindOf("SkillCard") then
				return 
			end
			addInfo("JuHuoLiaoTian", "count", damage.damage)
			if getInfo("JuHuoLiaoTian", "count", 0) >= 10 then
				addFinishTag("JuHuoLiaoTian")
			end
		end
	end
end
--[[****************************************************************
	战功：绝处逢生
	描述：身为反贼在1局游戏中，在其他反贼全部死亡且忠臣全部存活的情况下获胜
]]--****************************************************************
sgs.glory_info["JueChuFengSheng"] = {
	name = "JueChuFengSheng",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "JueChuFengSheng_data",
	keys = {},
}
sgs.JueChuFengSheng_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JueChuFengSheng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		if amRebel() and amWinner() then
			local players = self.room:getPlayers()
			local alive_loyalist = false
			for _,p in sgs.qlist(players) do
				local role = p:getRole()
				if role == "rebel" then
					if p:objectName() == sgs.glory_data["player_objectName"] then
					elseif p:isAlive() then
						return 
					end
				elseif role == "loyalist" then
					if p:isDead() then
						return 
					else
						alive_loyalist = true
					end
				end
			end
			if alive_loyalist then
				addFinishTag("JueChuFengSheng")
			end
		end
	end
end
--[[****************************************************************
	战功：绝对防御
	描述：在一局游戏中，使用八卦阵累计出闪20次
]]--****************************************************************
sgs.glory_info["JueDuiFangYu"] = {
	name = "JueDuiFangYu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial},
	data = "JueDuiFangYu_data",
	keys = {
		"count",
	},
}
sgs.JueDuiFangYu_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].JueDuiFangYu = function(self, player, data)
	local judge = data:toJudge()
	local reason = judge.reason
	if reason == "eight_diagram" or reason == "bazhen" and judge:isGood() then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			addInfo("JueDuiFangYu", "count", 1)
			if getInfo("JueDuiFangYu", "count", 0) >= 20 then
				addFinishTag("JueDuiFangYu")
			end
		end
	end
end
--[[****************************************************************
	战功：绝对零度
	描述：一局游戏中发动寒冰剑特效至少3次
]]--****************************************************************
sgs.glory_info["JueDuiLingDu"] = {
	name = "JueDuiLingDu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.ChoiceMade},
	data = "JueDuiLingDu_data",
	keys = {
		"count",
	},
}
sgs.JueDuiLingDu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JueDuiLingDu = function(self, player, data)
	if data:toString() == "skillInvoke:ice_sword:yes" then
		if isTarget(player) then
			addInfo("JueDuiLingDu", "count", 1)
			if getInfo("JueDuiLingDu", "count", 0) >= 3 then
				addFinishTag("JueDuiLingDu")
			end
		end
	end
end
--[[****************************************************************
	战功：辣手摧花
	描述：一局游戏中杀死至少2名女性角色
]]--****************************************************************
sgs.glory_info["LaShouCuiHua"] = {
	name = "LaShouCuiHua",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "LaShouCuiHua_data",
	keys = {
		"count",
	},
}
sgs.LaShouCuiHua_data = {}
sgs.ai_event_callback[sgs.NonTrigger].LaShouCuiHua = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if victim:isFemale() then
			addInfo("LaShouCuiHua", "count", 1)
			if getInfo("LaShouCuiHua", "count", 0) >= 2 then
				addFinishTag("LaShouCuiHua")
			end
		end
	end
end
--[[****************************************************************
	战功：老奸巨猾
	描述：身为内奸在1局游戏中，在主公杀死过忠臣的情况下取得胜利
]]--****************************************************************
sgs.glory_info["LaoJianJuHua"] = {
	name = "LaoJianJuHua",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "LaoJianJuHua_data",
	keys = {
		"lord_kill_loyalist",
	},
}
sgs.LaoJianJuHua_data = {}
sgs.ai_event_callback[sgs.NonTrigger].LaoJianJuHua = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if player:getRole() == "lord" then
			local death = self.room:getTag("gloryData"):toDeath()
			if death.who:getRole() == "loyalist" then
				setInfo("LaoJianJuHua", "lord_kill_loyalist", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amRenegade() and amWinner() and getInfo("LaoJianJuHua", "lord_kill_loyalist", 0) == 1 then
			addFinishTag("LaoJianJuHua")
		end
	end
end
--[[****************************************************************
	战功：老谋深算
	描述：身为内奸在1局游戏中手刃至少4个反贼或忠臣并且取得胜利
]]--****************************************************************
sgs.glory_info["LaoMouShenSuan"] = {
	name = "LaoMouShenSuan",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "LaoMouShenSuan_data",
	keys = {
		"kill_rebel",
		"kill_loyalist",
	},
}
sgs.LaoMouShenSuan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].LaoMouShenSuan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and amRenegade() then
			local death = self.room:getTag("gloryData"):toDeath()
			local role = death.who:getRole()
			if role == "rebel" then
				addInfo("LaoMouShenSuan", "kill_rebel", 1)
			elseif role == "loyalist" then
				addInfo("LaoMouShenSuan", "kill_loyalist", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amRenegade() and amWinner() then
			if getInfo("LaoMouShenSuan", "kill_rebel", 0) + getInfo("LaoMouShenSuan", "kill_loyalist", 0) >= 4 then
				addFinishTag("LaoMouShenSuan")
			end
		end
	end
end
--[[****************************************************************
	战功：乐不思蜀
	描述：在对你的“乐不思蜀”生效后的回合弃牌阶段弃置超过8张手牌
]]--****************************************************************
sgs.glory_info["LeBuSiShu"] = {
	name = "LeBuSiShu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.FinishRetrial, sgs.CardsMoveOneTime, sgs.EventPhaseStart},
	data = "LeBuSiShu_data",
	keys = {
		"indulgence",
		"count",
	},
}
sgs.LeBuSiShu_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].LeBuSiShu = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "indulgence" then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			setInfo("LeBuSiShu", "indulgence", 1)
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].LeBuSiShu = function(self, player, data)
	if player:getPhase() == sgs.Player_Discard and isTarget(player) then
		local move = data:toMoveOneTime()
		local source = move.from
		if source and source:objectName() == player:objectName() then
			if getInfo("LeBuSiShu", "indulgence", 0) == 1 then
				if move.reason.m_reason == sgs.CardMoveReason_S_REASON_RULEDISCARD then
					addInfo("LeBuSiShu", "count", move.card_ids:length())
					if getInfo("LeBuSiShu", "count", 0) >= 8 then
						addFinishTag("LeBuSiShu")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].LeBuSiShu = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("LeBuSiShu", "indulgence", 0)
	end
end
--[[****************************************************************
	战功：乱臣贼子
	描述：身为反贼在1局游戏中，手刃至少2个忠臣或内奸
]]--****************************************************************
sgs.glory_info["LuanChenZeiZi"] = {
	name = "LuanChenZeiZi",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "LuanChenZeiZi_data",
	keys = {
		"kill_loyalist",
		"kill_renegade",
	},
}
sgs.LuanChenZeiZi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].LuanChenZeiZi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and player:getRole() == "rebel" then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		local role = victim:getRole()
		if role == "loyalist" then
			addInfo("LuanChenZeiZi", "kill_loyalist", 1)
		elseif role == "renegade" then
			addInfo("LuanChenZeiZi", "kill_renegade", 1)
		else
			return 
		end
		if getInfo("LuanChenZeiZi", "kill_loyalist", 0) + getInfo("LuanChenZeiZi", "kill_renegade", 0) >= 2 then
			addFinishTag("LuanChenZeiZi")
		end
	end
end
--[[****************************************************************
	战功：落井下石
	描述：一局游戏中发动古锭刀特效至少3次
]]--****************************************************************
sgs.glory_info["LuoJingXiaShi"] = {
	name = "LuoJingXiaShi",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.DamageCaused},
	data = "LuoJingXiaShi_data",
	keys = {
		"count",
	},
}
sgs.LuoJingXiaShi_data = {}
sgs.ai_event_callback[sgs.DamageCaused].LuoJingXiaShi = function(self, player, data)
	local damage = data:toDamage()
	if damage.transfer or damage.chain then
		return false
	elseif damage.by_user then
		local source = damage.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if player:hasWeapon("guding_blade") and damage.to:isKongcheng() then
				local slash = damage.card
				if slash and slash:isKindOf("Slash") then
					addInfo("LuoJingXiaShi", "count", 1)
					if getInfo("LuoJingXiaShi", "count", 0) >= 3 then
						addFinishTag("LuoJingXiaShi")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：命不该绝
	描述：被闪电劈中但是没有死
]]--****************************************************************
sgs.glory_info["MingBuGaiJue"] = {
	name = "MingBuGaiJue",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffect, sgs.Damaged, sgs.PostCardEffected},
	data = "MingBuGaiJue_data",
	keys = {
		"lightning",
	},
}
sgs.MingBuGaiJue_data = {}
sgs.ai_event_callback[sgs.CardEffect].MingBuGaiJue = function(self, player, data)
	local effect = data:toCardEffect()
	local trick = effect.card
	if trick and trick:isKindOf("Lightning") then
		local victim = effect.to
		if victim and victim:objectName() == player:objectName() and isTarget(player) then
			setInfo("MingBuGaiJue", "lightning", 1)
		end
	end
end
sgs.ai_event_callback[sgs.Damaged].MingBuGaiJue = function(self, player, data)
	local damage = data:toDamage()
	local trick = damage.card
	if trick and trick:isKindOf("Lightning") and player:isAlive() then
		local victim = damage.to
		if victim and victim:objectName() == player:objectName() and isTarget(player) then
			if getInfo("MingBuGaiJue", "lightning", 0) == 1 then
				addFinishTag("MingBuGaiJue")
			end
		end
	end
end
sgs.ai_event_callback[sgs.PostCardEffected].MingBuGaiJue = function(self, player, data)
	local effect = data:toCardEffect()
	local trick = effect.card
	if trick and trick:isKindOf("Lightning") then
		local victim = effect.to
		if victim and victim:objectName() == player:objectName() and isTarget(player) then
			setInfo("MingBuGaiJue", "lightning", 0)
		end
	end
end
--[[****************************************************************
	战功：炮灰
	描述：被南蛮入侵或万箭齐发打死累计10次
]]--****************************************************************
sgs.glory_info["PaoHui"] = {
	name = "PaoHui",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "PaoHui_data",
	keys = {
		--"Global_savage_assault_times",
		--"Global_archery_attack_times",
	},
}
sgs.PaoHui_data = {}
sgs.ai_event_callback[sgs.NonTrigger].PaoHui = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local reason = death.damage
		if reason then
			local aoe = reason.card
			if aoe and aoe:isKindOf("AOE") then
				if aoe:isKindOf("SavageAssault") then
					addInfo("PaoHui", "Global_savage_assault_times", 1)
				elseif aoe:isKindOf("ArcheryAttack") then
					addInfo("PaoHui", "Global_archery_attack_times", 1)
				end
				local count = getInfo("PaoHui", "Global_savage_assault_times", 0)
				count = count + getInfo("PaoHui", "Global_archery_attack_times", 0)
				if count >= 10 then
					setInfo("PaoHui", "Global_savage_assault_times", 0)
					setInfo("PaoHui", "Global_archery_attack_times", 0)
					addFinishTag("PaoHui")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：平反大将
	描述：在1局游戏中手刃4个反贼
]]--****************************************************************
sgs.glory_info["PingFanDaJiang"] = {
	name = "PingFanDaJiang",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "PingFanDaJiang_data",
	keys = {
		"count",
	},
}
sgs.PingFanDaJiang_data = {}
sgs.ai_event_callback[sgs.NonTrigger].PingFanDaJiang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:getRole() == "rebel" then
			addInfo("PingFanDaJiang", "count", 1)
			if getInfo("PingFanDaJiang", "count", 0) >= 4 then
				addFinishTag("PingFanDaJiang")
			end
		end
	end
end
--[[****************************************************************
	战功：旗开得胜
	描述：一局游戏中，在自己的首回合结束前获胜
]]--****************************************************************
sgs.glory_info["QiKaiDeSheng"] = {
	name = "QiKaiDeSheng",
	state = "验证通过",
	once_only = true,
	mode = "all_modes",
	events = {sgs.NonTrigger, sgs.TurnStart},
	data = "QiKaiDeSheng_data",
	keys = {
		"turn",
	},
}
sgs.QiKaiDeSheng_data = {}
sgs.ai_event_callback[sgs.NonTrigger].QiKaiDeSheng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		if getInfo("QiKaiDeSheng", "turn", 0) == 0 and amWinner() then
			addFinishTag("QiKaiDeSheng")
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].QiKaiDeSheng = function(self, player, data)
	if isTarget(player) then
		addInfo("QiKaiDeSheng", "turn", 1)
	end
end
--[[****************************************************************
	战功：起死回生
	描述：在一局游戏中，累计受过至少20点伤害且最后存活获胜
]]--****************************************************************
sgs.glory_info["QiSiHuiSheng"] = {
	name = "QiSiHuiSheng",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "QiSiHuiSheng_data",
	keys = {
		"damage",
	},
}
sgs.QiSiHuiSheng_data = {}
sgs.ai_event_callback[sgs.NonTrigger].QiSiHuiSheng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone" and isTarget(player) then
		local damage = self.room:getTag("gloryData"):toDamage()
		addInfo("QiSiHuiSheng", "damage", damage.damage)
	elseif cmd == "gloryGameOverJudge" then
		if getInfo("QiSiHuiSheng", "damage", 0) >= 20 and amAlive() and amWinner() then
			addFinishTag("QiSiHuiSheng")
		end
	end
end
--[[****************************************************************
	战功：千人斩
	描述：累积杀1000人
]]--****************************************************************
sgs.glory_info["QianRenZhan"] = {
	name = "QianRenZhan",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "QianRenZhan_data",
	keys = {
		--"Global_kill",
		"count",
	},
}
sgs.QianRenZhan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].QianRenZhan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		addInfo("QianRenZhan", "count", 1)
		local count = getInfo("QianRenZhan", "count", 0)
		local kill = getInfo("QianRenZhan", "Global_kill", 0)
		local total = kill + count
		if total < 1000 then
			addInfo("QianRenZhan", "Global_kill", 1)
		else
			setInfo("QianRenZhan", "Global_kill", 0)
			addFinishTag("QianRenZhan")
		end
	end
end
--[[****************************************************************
	战功：惹火上身
	描述：一局游戏中，装备藤甲的时受到至少3次火焰伤害
]]--****************************************************************
sgs.glory_info["ReHuoShangShen"] = {
	name = "ReHuoShangShen",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "ReHuoShangShen_data",
	keys = {
		"count",
	},
}
sgs.ReHuoShangShen_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ReHuoShangShen = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone" and isTarget(player) and player:hasArmorEffect("vine") then
		local damage = self.room:getTag("gloryData"):toDamage()
		if damage.nature == sgs.DamageStruct_Fire and damage.damage > 0 then
			addInfo("ReHuoShangShen", "count", 1)
			if getInfo("ReHuoShangShen", "count", 0) >= 3 then
				addFinishTag("ReHuoShangShen")
			end
		end
	end
end
--[[****************************************************************
	战功：杀很大
	描述：一回合中发动诸葛连弩特效至少4次
]]--****************************************************************
sgs.glory_info["ShaHenDa"] = {
	name = "ShaHenDa",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "ShaHenDa_data",
	keys = {
		"count",
	},
}
sgs.ShaHenDa_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShaHenDa = function(self, player, data)
	local use = data:toCardUse()
	local slash = use.card
	if slash and slash:isKindOf("Slash") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if player:hasWeapon("crossbow") or player:hasWeapon("vscrossbow") then
				addInfo("ShaHenDa", "count", 1)
				if getInfo("ShaHenDa", "count", 0) >= 4 then
					addFinishTag("ShaHenDa")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].ShaHenDa = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("ShaHenDa", "count", 0)
	end
end
--[[****************************************************************
	战功：塞翁失马
	描述：一局游戏中，失去白银狮子回复体力至少2次
]]--****************************************************************
sgs.glory_info["SaiWengShiMa"] = {
	name = "SaiWengShiMa",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.BeforeCardsMove, sgs.HpRecover},
	data = "SaiWengShiMa_data",
	keys = {
		"silver_lion",
		"count",
	},
}
sgs.SaiWengShiMa_data = {}
sgs.ai_event_callback[sgs.BeforeCardsMove].SaiWengShiMa = function(self, player, data)
	local move = data:toMoveOneTime()
	local source = move.from
	if source and source:objectName() == player:objectName() and isTarget(player) and player:isWounded() then
		for index, id in sgs.qlist(move.card_ids) do
			local place = move.from_places:at(index)
			if place == sgs.Player_PlaceEquip then
				local armor = sgs.Sanguosha:getCard(id)
				if armor and armor:isKindOf("SilverLion") then
					setInfo("SaiWengShiMa", "silver_lion", 1)
					return 
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.HpRecover].SaiWengShiMa = function(self, player, data)
	if isTarget(player) and getInfo("SaiWengShiMa", "silver_lion", 0) == 1 then
		local recover = data:toRecover()
		local armor = recover.card
		if armor and armor:isKindOf("SilverLion") then
			setInfo("SaiWengShiMa", "silver_lion", 0)
			addInfo("SaiWengShiMa", "count", 1)
			if getInfo("SaiWengShiMa", "count", 0) >= 2 then
				addFinishTag("SaiWengShiMa")
			end
		end
	end
end
--[[****************************************************************
	战功：射人先射马
	描述：一局游戏中发动麒麟弓特效至少3次
]]--****************************************************************
sgs.glory_info["SheRenXianSheMa"] = {
	name = "SheRenXianSheMa",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.ChoiceMade},
	data = "SheRenXianSheMa_data",
	keys = {
		"count",
	},
}
sgs.SheRenXianSheMa_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].SheRenXianSheMa = function(self, player, data)
	if data:toString() == "skillInvoke:kylin_bow:yes" and isTarget(player) then
		addInfo("SheRenXianSheMa", "count", 1)
		if getInfo("SheRenXianSheMa", "count", 0) >= 3 then
			addFinishTag("SheRenXianSheMa")
		end
	end
end
--[[****************************************************************
	战功：神偷再世
	描述：在一局游戏中，累计使用卡牌顺手牵羊10次以上
]]--****************************************************************
sgs.glory_info["ShenTouZaiShi"] = {
	name = "ShenTouZaiShi",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardUsed},
	data = "ShenTouZaiShi_data",
	keys = {
		"count",
	},
}
sgs.ShenTouZaiShi_data = {}
sgs.ai_event_callback[sgs.CardUsed].ShenTouZaiShi = function(self, player, data)
	local use = data:toCardUse()
	local snatch = use.card
	if snatch and snatch:isKindOf("Snatch") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			addInfo("ShenTouZaiShi", "count", 1)
			if getInfo("ShenTouZaiShi", "count", 0) >= 10 then
				addFinishTag("ShenTouZaiShi")
			end
		end
	end
end
--[[****************************************************************
	战功：势如破竹
	描述：一局游戏中发动贯石斧特效至少3次
]]--****************************************************************
sgs.glory_info["ShiRuPoZhu"] = {
	name = "ShiRuPoZhu",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.ChoiceMade},
	data = "ShiRuPoZhu_data",
	keys = {
		"count",
	},
}
sgs.ShiRuPoZhu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ShiRuPoZhu = function(self, player, data)
	local info = data:toString():split(":")
	if info[1] == "cardResponded" and info[2] == "@axe" and info[#info] ~= "_nil_" then
		if isTarget(player) then
			addInfo("ShiRuPoZhu", "count", 1)
			if getInfo("ShiRuPoZhu", "count", 0) >= 3 then
				addFinishTag("ShiRuPoZhu")
			end
		end
	end
end
--[[****************************************************************
	战功：桃花运
	描述：当你的开局手牌全部为红桃时，体力上限加1
]]--****************************************************************
sgs.glory_info["TaoHuaYun"] = {
	name = "TaoHuaYun",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.AfterDrawInitialCards},
	data = "TaoHuaYun_data",
	keys = {},
}
sgs.TaoHuaYun_data = {}
sgs.ai_event_callback[sgs.AfterDrawInitialCards].TaoHuaYun = function(self, player, data)
	if isTarget(player) and not player:isKongcheng() then
		local handcards = self.player:getHandcards()
		for _,heart in sgs.qlist(handcards) do
			if heart:getSuit() ~= sgs.Card_Heart then
				return 
			end
		end
		addFinishTag("TaoHuaYun")
		local msg = sgs.LogMessage()
		msg.type = "#gloryTaoHuaYun"
		msg.from = self.player
		msg.arg = 1
		self.room:sendLog(msg) --发送提示信息
		local maxhp = self.player:getMaxHp() + 1
		self.room:setPlayerProperty(self.player, "maxhp", sgs.QVariant(maxhp))
	end
end
--[[****************************************************************
	战功：桃王
	描述：在1局游戏中给自己吃过5个或者更多的桃（华佗的技能“急救”除外）
]]--****************************************************************
sgs.glory_info["TaoWang"] = {
	name = "TaoWang",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffected},
	data = "TaoWang_data",
	keys = {
		"count",
	},
}
sgs.TaoWang_data = {}
sgs.ai_event_callback[sgs.CardEffected].TaoWang = function(self, player, data)
	local effect = data:toCardEffect()
	local peach = effect.card
	if peach and peach:isKindOf("Peach") and peach:getSkillName() ~= "jijiu" then
		local source, target = effect.from, effect.to
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if target and target:objectName() == player:objectName() then
				addInfo("TaoWang", "count", 1)
				if getInfo("TaoWang", "count", 0) >= 5 then
					addFinishTag("TaoWang")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：桃仙
	描述：在1局游戏中，使用桃救人至少5次（华佗的技能“急救”除外）
]]--****************************************************************
sgs.glory_info["TaoXian"] = {
	name = "TaoXian",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffect},
	data = "TaoXian_data",
	keys = {
		"count",
	},
}
sgs.TaoXian_data = {}
sgs.ai_event_callback[sgs.CardEffect].TaoXian = function(self, player, data)
	local effect = data:toCardEffect()
	local peach = effect.card
	if peach and peach:isKindOf("Peach") and peach:getSkillName() ~= "jijiu" then
		local source, target = effect.from, effect.to
		if target and target:objectName() == player:objectName() and player:hasFlag("Global_Dying") then
			if source and source:objectName() ~= player:objectName() and isTarget(source) then
				addInfo("TaoXian", "count", 1)
				if getInfo("TaoXian", "count", 0) >= 5 then
					addFinishTag("TaoXian")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：藤甲兵
	描述：一局游戏中发动藤甲效果抵挡杀、南蛮入侵或万箭齐发至少3次
]]--****************************************************************
sgs.glory_info["TengJiaBing"] = {
	name = "TengJiaBing",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffect},
	data = "TengJiaBing_data",
	keys = {
		"avoid_slash",
		"avoid_savage_assault",
		"avoid_archery_attack",
	},
}
sgs.TengJiaBing_data = {}
sgs.ai_event_callback[sgs.CardEffect].TengJiaBing = function(self, player, data)
	local effect = data:toCardEffect()
	local target = effect.to
	if target and target:objectName() == player:objectName() and isTarget(player) and player:hasArmorEffect("vine") then
		local card = effect.card
		if card:isKindOf("Slash") and not card:isKindOf("NatureSlash") then
			addInfo("TengJiaBing", "avoid_slash", 1)
		elseif card:isKindOf("SavageAssault") then
			addInfo("TengJiaBing", "avoid_savage_assault", 1)
		elseif card:isKindOf("ArcheryAttack") then
			addInfo("TengJiaBing", "avoid_archery_attack", 1)
		else
			return 
		end
		local count = getInfo("TengJiaBing", "avoid_slash", 0) 
		count = count + getInfo("TengJiaBing", "avoid_savage_assault", 0)
		count = count + getInfo("TengJiaBing", "avoid_archery_attack", 0)
		if count >= 3 then
			addFinishTag("TengJiaBing")
		end
	end
end
--[[****************************************************************
	战功：天道威仪
	描述：身为主公在1局游戏中，在忠臣全部死亡后杀死至少3名角色，取得胜利
]]--****************************************************************
sgs.glory_info["TianDaoWeiYi"] = {
	name = "TianDaoWeiYi",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "TianDaoWeiYi_data",
	keys = {
		"dead_loyalist",
		"count",
	},
}
sgs.TianDaoWeiYi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].TianDaoWeiYi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		if player:getRole() == "lord" and getInfo("TianDaoWeiYi", "dead_loyalist", 0) > 0 then
			local alives = self.room:getAlivePlayers()
			for _,p in sgs.qlist(alives) do
				if p:getRole() == "loyalist" then
					return 
				end
			end
			addInfo("TianDaoWeiYi", "count", 1)
		end
	elseif cmd == "gloryGameOverJudge" then
		if player:getRole() == "loyalist" then
			addInfo("TianDaoWeiYi", "dead_loyalist", 1)
		end
		if amLord() and getInfo("TianDaoWeiYi", "count", 0) >= 3 and amWinner() then
			addFinishTag("TianDaoWeiYi")
		end
	end
end
--[[****************************************************************
	战功：天谴
	描述：不被改判定牌的情况下被闪电劈死
]]--****************************************************************
sgs.glory_info["TianQian"] = {
	name = "TianQian",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.StartJudge, sgs.FinishRetrial, sgs.NonTrigger},
	data = "TianQian_data",
	keys = {
		"judge_card",
		"lightning",
	},
}
sgs.TianQian_data = {}
sgs.ai_event_callback[sgs.StartJudge].TianQian = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "lightning" then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			local card = judge.card
			setInfo("TianQian", "judge_card", card:getEffectiveId())
			setInfo("TianQian", "lightning", 0)
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].TianQian = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "lightning" then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			local card = judge.card
			if getInfo("TianQian", "judge_card", -1) == card:getEffectiveId() then
				setInfo("TianQian", "lightning", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].TianQian = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local reason = death.damage
		if reason then
			local trick = reason.card
			if trick and trick:isKindOf("Lightning") then
				if getInfo("TianQian", "lightning", 0) == 1 then
					setInfo("TianQian", "lightning", 0)
					addFinishTag("TianQian")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：威震四海
	描述：一次对其他角色造成至少5点伤害
]]--****************************************************************
sgs.glory_info["WeiZhenSiHai"] = {
	name = "WeiZhenSiHai",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "WeiZhenSiHai_data",
	keys = {},
}
sgs.WeiZhenSiHai_data = {}
sgs.ai_event_callback[sgs.NonTrigger].WeiZhenSiHai = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) then
		local damage = self.room:getTag("gloryData"):toDamage()
		if damage.damage >= 5 and damage.to:objectName() ~= player:objectName() then
			addFinishTag("WeiZhenSiHai")
		end
	end
end
--[[****************************************************************
	战功：为时未晚
	描述：身为反贼，在一局游戏中杀死了除自己以外所有反贼并获得游戏的胜利
]]--****************************************************************
sgs.glory_info["WeiShiWeiWan"] = {
	name = "WeiShiWeiWan",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "WeiShiWeiWan_data",
	keys = {
		"kill_rebel",
	},
}
sgs.WeiShiWeiWan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].WeiShiWeiWan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and player:getRole() == "rebel" then
			local death = self.room:getTag("gloryData"):toDeath()
			local victim = death.who
			if victim and victim:objectName() ~= player:objectName() and victim:getRole() == "rebel" then
				addInfo("WeiShiWeiWan", "kill_rebel", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amRebel() and amWinner() then
			local count = 0
			local players = self.room:getPlayers()
			for _,p in sgs.qlist(players) do
				if p:getRole() == "rebel" and p:objectName() ~= sgs.glory_data["player_objectName"] then
					if p:isAlive() then
						return 
					else
						count = count + 1
					end
				end
			end
			if count > 0 and count == getInfo("WeiShiWeiWan", "kill_rebel", 0) then
				addFinishTag("WeiShiWeiWan")
			end
		end
	end
end
--[[****************************************************************
	战功：唯有杜康
	描述：一局游戏中，使用酒后成功使用杀造成伤害至少3次
]]--****************************************************************
sgs.glory_info["WeiYouDuKang"] = {
	name = "WeiYouDuKang",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.NonTrigger},
	data = "WeiYouDuKang_data",
	keys = {
		"drank",
		"count",
	},
}
sgs.WeiYouDuKang_data = {}
sgs.ai_event_callback[sgs.NonTrigger].WeiYouDuKang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryConfirmDamage" then
		local damage = self.room:getTag("gloryData"):toDamage()
		if isTarget(player) then
			if damage.to:getMark("SlashIsDrank") > 0 then
				setInfo("WeiYouDuKang", "drank", 1)
			else
				setInfo("WeiYouDuKang", "drank", 0)
			end
		end
	elseif cmd == "gloryDamageDone_Source" and isTarget(player) then
		local damage = self.room:getTag("gloryData"):toDamage()
		local slash = damage.card
		if slash and slash:isKindOf("Slash") then
			if getInfo("WeiYouDuKang", "drank", 0) == 1 then
				setInfo("WeiYouDuKang", "drank", 0)
				addInfo("WeiYouDuKang", "count", 1)
				if getInfo("WeiYouDuKang", "count", 0) >= 3 then
					addFinishTag("WeiYouDuKang")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：先拔头筹
	描述：一局游戏中，自己的首回合结束前杀死至少一名非本方武将
]]--****************************************************************
sgs.glory_info["XianBaTouChou"] = {
	name = "XianBaTouChou",
	state = "验证通过",
	once_only = true,
	mode = "all_modes",
	events = {sgs.NonTrigger, sgs.TurnStart},
	data = "XianBaTouChou_data",
	keys = {
		"turn",
		"count",
	},
}
sgs.XianBaTouChou_data = {}
sgs.ai_event_callback[sgs.NonTrigger].XianBaTouChou = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		if getInfo("XianBaTouChou", "turn", 0) == 0 then
			local death = self.room:getTag("gloryData"):toDeath()
			local victim = death.who
			if not isSameCamp(player, victim) then
				addInfo("XianBaTouChou", "count", 1)
				if getInfo("XianBaTouChou", "count", 0) >= 1 then
					addFinishTag("XianBaTouChou")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].XianBaTouChou = function(self, player, data)
	if isTarget(player) then
		addInfo("XianBaTouChou", "turn", 1)
	end
end
--[[****************************************************************
	战功：邪念惑心
	描述：作为忠臣在一局游戏中，在场上没有反贼时手刃主公
]]--****************************************************************
sgs.glory_info["XieNianHuoXin"] = {
	name = "XieNianHuoXin",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "XieNianHuoXin_data",
	keys = {},
}
sgs.XieNianHuoXin_data = {}
sgs.ai_event_callback[sgs.NonTrigger].XieNianHuoXin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and player:getRole() == "loyalist" then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:getRole() == "lord" then
			local alives = self.room:getAlivePlayers()
			for _,p in sgs.qlist(alives) do
				if p:getRole() == "rebel" then
					return 
				end
			end
			addFinishTag("XieNianHuoXin")
		end
	end
end
--[[****************************************************************
	战功：星驰电走
	描述：在一局游戏中，累计出闪20次
]]--****************************************************************
sgs.glory_info["XingChiDianZou"] = {
	name = "XingChiDianZou",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardResponded},
	data = "XingChiDianZou_data",
	keys = {
		"count",
	},
}
sgs.XingChiDianZou_data = {}
sgs.ai_event_callback[sgs.CardResponded].XingChiDianZou = function(self, player, data)
	local response = data:toCardResponse()
	if response.m_card:isKindOf("Jink") and isTarget(player) then
		addInfo("XingChiDianZou", "count", 1)
		if getInfo("XingChiDianZou", "count", 0) >= 20 then
			addFinishTag("XingChiDianZou")
		end
	end
end
--[[****************************************************************
	战功：悬壶济世
	描述：在一局游戏中，使用桃或技能累计将我方队友脱离濒死状态4次以上
]]--****************************************************************
sgs.glory_info["XuanHuJiShi"] = {
	name = "XuanHuJiShi",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.HpRecover},
	data = "XuanHuJiShi_data",
	keys = {
		"count",
	},
}
sgs.XuanHuJiShi_data = {}
sgs.ai_event_callback[sgs.HpRecover].XuanHuJiShi = function(self, player, data)
	local recover = data:toRecover()
	local source = recover.who
	if source and isTarget(source) and player:hasFlag("Global_Dying") and isSameCamp(source, player) then
		addInfo("XuanHuJiShi", "count", 1)
		if getInfo("XuanHuJiShi", "count", 0) >= 4 then
			addFinishTag("XuanHuJiShi")
		end
	end
end
--[[****************************************************************
	战功：一骑讨
	描述：与人决斗胜利累计30次
]]--****************************************************************
sgs.glory_info["YiJiTao"] = {
	name = "YiJiTao",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffect, sgs.ChoiceMade, sgs.CardFinished},
	data = "YiJiTao_data",
	keys = {
		--"Global_times",
	},
}
sgs.YiJiTao_data = {}
sgs.ai_event_callback[sgs.CardEffect].YiJiTao = function(self, player, data)
	local effect = data:toCardEffect()
	if effect.card:isKindOf("Duel") then
		local target = effect.to
		if target and target:objectName() == player:objectName() then
			if isTarget(target) or isTarget(effect.from) then
				setInfo("YiJiTao", "duel", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].YiJiTao = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --cardResponded:slash:duel-slash:sgs1:_nil_
		if msg[1] == "cardResponded" and msg[2] == "slash" and msg[#msg] == "_nil_" then
			if getInfo("YiJiTao", "duel", 0) == 1 and msg[4] == getTargetName() then
				addInfo("YiJiTao", "count", 1)
				local count = getInfo("YiJiTao", "count", 0)
				local fail = getInfo("YiJiTao", "Global_times", 0)
				local total = fail + count
				if total < 30 then
					addInfo("YiJiTao", "Global_times", 1)
				else
					setInfo("YiJiTao", "Global_times", 0)
					addFinishTag("YiJiTao")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].YiJiTao = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("Duel") and getInfo("YiJiTao", "duel", 0) == 1 then
		local source = use.from
		if source and source:objectName() == player:objectName() then
			if isTarget(source) then
				setInfo("YiJiTao", "duel", 0)
			else
				for _,target in sgs.qlist(use.to) do
					if isTarget(target) then
						setInfo("YiJiTao", "duel", 0)
						return 
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：异族之愤
	描述：使用1次南蛮入侵打死至少3名角色
]]--****************************************************************
sgs.glory_info["YiZuZhiFen"] = {
	name = "YiZuZhiFen",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardFinished, sgs.NonTrigger},
	data = "YiZuZhiFen_data",
	keys = {
		"count",
	},
}
sgs.YiZuZhiFen_data = {}
sgs.ai_event_callback[sgs.CardFinished].YiZuZhiFen = function(self, player, data)
	local use = data:toCardUse()
	local aoe = use.card
	if aoe and aoe:isKindOf("SavageAssault") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then 
			setInfo("YiZuZhiFen", "count", 0)
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].YiZuZhiFen = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local aoe = death.damage.card
		if aoe and aoe:isKindOf("SavageAssault") then
			addInfo("YiZuZhiFen", "count", 1)
			if getInfo("YiZuZhiFen", "count", 0) >= 3 then
				addFinishTag("YiZuZhiFen")
			end
		end
	end
end
--[[****************************************************************
	战功：有难同当
	描述：1局游戏中，使用铁索连环累计横置其他角色至少6次
]]--****************************************************************
sgs.glory_info["YouNanTongDang"] = {
	name = "YouNanTongDang",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardEffect, sgs.ChainStateChanged},
	data = "YouNanTongDang_data",
	keys = {
		"target",
		"count",
	},
}
sgs.YouNanTongDang_data = {}
sgs.ai_event_callback[sgs.CardEffect].YouNanTongDang = function(self, player, data)
	local effect = data:toCardEffect()
	if effect.card:isKindOf("IronChain") then
		local target = effect.to
		if target and target:objectName() == player:objectName() and not player:isChained() then
			local source = effect.from
			if source and isTarget(source) and source:objectName() ~= player:objectName() then
				setInfo("YouNanTongDang", "target", target:objectName())
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChainStateChanged].YouNanTongDang = function(self, player, data)
	if player:isChained() and getInfo("YouNanTongDang", "target", "") == player:objectName() then
		setInfo("YouNanTongDang", "target", "")
		addInfo("YouNanTongDang", "count", 1)
		if getInfo("YouNanTongDang", "count", 0) >= 6 then
			addFinishTag("YouNanTongDang")
		end
	end
end
--[[****************************************************************
	战功：驭马大师
	描述：在一局游戏中，至少更换过8匹马
]]--****************************************************************
sgs.glory_info["YuMaDaShi"] = {
	name = "YuMaDaShi",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.CardsMoveOneTime},
	data = "YuMaDaShi_data",
	keys = {
		"count",
	},
}
sgs.YuMaDaShi_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].YuMaDaShi = function(self, player, data)
	local move = data:toMoveOneTime()
	local source = move.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		local target = move.to
		if target and target:objectName() == player:objectName() then
			if move.to_place == sgs.Player_PlaceEquip then
				for index, id in sgs.qlist(move.card_ids) do
					local horse = sgs.Sanguosha:getCard(id)
					if horse:isKindOf("Horse") then
						addInfo("YuMaDaShi", "count", 1)
						if getInfo("YuMaDaShi", "count", 0) >= 8 then
							if addFinishTag("YuMaDaShi") then
								return 
							end
						end
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：原地起爆
	描述：回合开始阶段你1血0牌的情况下，一回合内杀死3名角色
]]--****************************************************************
sgs.glory_info["YuanDiQiBao"] = {
	name = "YuanDiQiBao",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.EventPhaseStart, sgs.NonTrigger},
	data = "YuanDiQiBao_data",
	keys = {
		"start",
		"count",
	},
}
sgs.YuanDiQiBao_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YuanDiQiBao = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		if getInfo("YuanDiQiBao", "start", 0) == 1 then
			addInfo("YuanDiQiBao", "count", 1)
			if getInfo("YuanDiQiBao", "count", 0) >= 3 then
				addFinishTag("YuanDiQiBao")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].YuanDiQiBao = function(self, player, data)
	if isTarget(player) then
		local phase = player:getPhase()
		if phase == sgs.Player_RoundStart then
			if player:getHp() == 1 and player:isNude() then
				setInfo("YuanDiQiBao", "start", 1)
			else
				setInfo("YuanDiQiBao", "start", 0)
			end
			setInfo("YuanDiQiBao", "count", 0)
		elseif phase == sgs.Player_NotActive then
			setInfo("YuanDiQiBao", "start", 0)
			setInfo("YuanDiQiBao", "count", 0)
		end
	end
end
--[[****************************************************************
	战功：元芳，你怎么看
	描述：元芳，你怎么看？大人，这不科学。
]]--****************************************************************
sgs.glory_info["YuanFang_NiZenMeKan"] = {
	name = "YuanFang_NiZenMeKan",
	state = "验证通过",
	once_only = true,
	mode = "roles",
	events = {sgs.NonTrigger, sgs.TurnStart},
	data = "YuanFang_NiZenMeKan_data",
	keys = {
		"turn",
	},
}
sgs.YuanFang_NiZenMeKan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YuanFang_NiZenMeKan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		if player:getRole() == "lord" and isTarget(player) then
			if getInfo("YuanFang_NiZenMeKan", "turn", 0) == 0 then
				local death = self.room:getTag("gloryData"):toDeath()
				local reason = death.damage
				if reason and reason.from then
					addFinishTag("YuanFang_NiZenMeKan")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].YuanFang_NiZenMeKan = function(self, player, data)
	if isTarget(player) then
		addInfo("YuanFang_NiZenMeKan", "turn", 1)
	end
end
--[[****************************************************************
	战功：至圣至明
	描述：身为主公在一局游戏中手刃所有反贼和内奸，并在忠臣全部存活的情况下获胜
]]--****************************************************************
sgs.glory_info["ZhiShengZhiMing"] = {
	name = "ZhiShengZhiMing",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "ZhiShengZhiMing_data",
	keys = {
		"kill_rebel",
		"kill_renegade",
	},
}
sgs.ZhiShengZhiMing_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ZhiShengZhiMing = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and player:getRole() == "lord" then
		local death = self.room:getTag("gloryData"):toDeath()
		local role = death.who:getRole()
		if role == "rebel" then
			addInfo("ZhiShengZhiMing", "kill_rebel", 1)
		elseif role == "renegade" then
			addInfo("ZhiShengZhiMing", "kill_renegade", 1)
		end
	elseif cmd == "gloryGameOverJudge" then
		if amLord() and amWinner() then
			local alive_loyalist, kill_rebel, kill_renegade = 0, 0, 0
			local players = self.room:getPlayers()
			for _,p in sgs.qlist(players) do
				if p:objectName() ~= sgs.glory_data["player_objectName"] then
					local role = p:getRole()
					if role == "loyalist" then
						if p:isDead() then
							return 
						else
							alive_loyalist = alive_loyalist + 1
						end
					elseif role == "renegade" then
						if p:isDead() then
							kill_renegade = kill_renegade + 1
						end
					elseif role == "rebel" then
						if p:isDead() then
							kill_rebel = kill_rebel + 1
						end
					end
				end
			end
			if alive_loyalist > 0 then
				if kill_rebel == getInfo("ZhiShengZhiMing", "kill_rebel", 0) then
					if kill_renegade == getInfo("ZhiShengZhiMing", "kill_renegade", 0) then
						addFinishTag("ZhiShengZhiMing")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：忠肝义胆
	描述：身为忠臣在1局游戏中存活，并且主公满体力的情况下取得胜利
]]--****************************************************************
sgs.glory_info["ZhongGanYiDan"] = {
	name = "ZhongGanYiDan",
	state = "验证通过",
	mode = "roles",
	events = {sgs.NonTrigger},
	data = "ZhongGanYiDan_data",
	keys = {},
}
sgs.ZhongGanYiDan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ZhongGanYiDan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		if amLoyalist() and amAlive() and amWinner() then
			local alives = self.room:getAlivePlayers()
			for _,p in sgs.qlist(alives) do
				if p:getRole() == "lord" and p:getLostHp() == 0 then
					addFinishTag("ZhongGanYiDan")
					return 
				end
			end
		end
	end
end
--[[****************************************************************
	战功：朱雀星君
	描述：一局游戏中发动朱雀羽扇特效至少3次
]]--****************************************************************
sgs.glory_info["ZhuQueXingJun"] = {
	name = "ZhuQueXingJun",
	state = "验证通过",
	mode = "all_modes",
	events = {sgs.ChoiceMade},
	data = "ZhuQueXingJun_data",
	keys = {
		"count",
	},
}
sgs.ZhuQueXingJun_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ZhuQueXingJun = function(self, player, data)
	if data:toString() == "skillInvoke:fan:yes" and isTarget(player) then
		addInfo("ZhuQueXingJun", "count", 1)
		if getInfo("ZhuQueXingJun", "count", 0) >= 3 then
			addFinishTag("ZhuQueXingJun")
		end
	end
end