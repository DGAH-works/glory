--[[
	太阳神三国杀游戏工具扩展包·战功荣耀（武将专属战功部分）
	适用版本：V2 - 愚人版（版本号：20150401）清明补丁（版本号：20150405）
]]--
--[[****************************************************************
	战功：暗箭难防
	描述：使用旧马岱在一局游戏中发动“潜袭”成功至少6次
]]--****************************************************************
sgs.glory_info["AnJianNanFang"] = {
	name = "AnJianNanFang",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_madai",
	events = {sgs.FinishRetrial},
	data = "AnJianNanFang_data",
	keys = {
		"count",
	},
}
sgs.AnJianNanFang_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].AnJianNanFang = function(self, player, data)
	if isTarget(player) and isGeneral(player, "nos_madai", true) then
		local judge = data:toJudge()
		if judge.reason == "nosqianxi" and judge:isGood() then
			addInfo("AnJianNanFang", "count", 1)
			if getInfo("AnJianNanFang", "count", 0) >= 6 then
				addFinishTag("AnJianNanFang")
			end
		end
	end
end
--[[****************************************************************
	战功：霸业可图
	描述：使用陈宫在一局游戏中对吕布发动明策至少2次
]]--****************************************************************
sgs.glory_info["BaYeKeTu"] = {
	name = "BaYeKeTu",
	state = "验证通过",
	mode = "all_modes",
	general = "chengong",
	events = {sgs.CardEffect},
	data = "BaYeKeTu_data",
	keys = {
		"count",
	},
}
sgs.BaYeKeTu_data = {}
sgs.ai_event_callback[sgs.CardEffect].BaYeKeTu = function(self, player, data)
	local effect = data:toCardEffect()
	if effect.card:isKindOf("MingceCard") then
		local target = effect.to
		if target and target:objectName() == player:objectName() and isGeneral(target, "lvbu", false) then
			local source = effect.from
			if source and isTarget(source) and isGeneral(source, "chengong", true) then
				addInfo("BaYeKeTu", "count", 1)
				if getInfo("BaYeKeTu", "count", 0) == 2 then
					addFinishTag("BaYeKeTu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：白马义从
	描述：使用公孙瓒在体力大于2的情况下杀死至少3名角色，并且在体力1的情况下存活并获胜。
]]--****************************************************************
sgs.glory_info["BaiMaYiCong"] = {
	name = "BaiMaYiCong",
	state = "验证通过",
	mode = "all_modes",
	general = "gongsunzan",
	events = {sgs.NonTrigger},
	data = "BaiMaYiCong_data",
	keys = {
		"count",
	},
}
sgs.BaiMaYiCong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].BaiMaYiCong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and isGeneral(player, "gongsunzan", false) and player:getHp() > 2 then
			addInfo("BaiMaYiCong", "count", 1)
		end
	elseif cmd == "gloryGameOverJudge" then
		if amAlive() and sgs.glory_data["player"]:getHp() == 1 and amWinner() then
			if getInfo("BaiMaYiCong", "count", 0) >= 3 then
				addFinishTag("BaiMaYiCong")
			end
		end
	end
end
--[[****************************************************************
	战功：暴虐之王
	描述：使用董卓在一局游戏中利用技能“暴虐”至少回血10次
]]--****************************************************************
sgs.glory_info["BaoNveZhiWang"] = {
	name = "BaoNveZhiWang",
	state = "验证通过",
	mode = "all_modes",
	general = "dongzhuo",
	events = {sgs.ChoiceMade, sgs.FinishRetrial, sgs.HpRecover},
	data = "BaoNveZhiWang_data",
	keys = {
		"baonve",
		"count",
	},
}
sgs.BaoNveZhiWang_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].BaoNveZhiWang = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then -- playerChosen:baonue:sgs1
		if msg[1] == "playerChosen" and msg[2] == "baonue" and msg[3] == sgs.glory_data["player_objectName"] then
			setInfo("BaoNveZhiWang", "baonve", 1)
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].BaoNveZhiWang = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "baonue" and getInfo("BaoNveZhiWang", "baonve", 0) == 1 then
		if judge:isBad() then
			setInfo("BaoNveZhiWang", "baonue", 0)
		end
	end
end
sgs.ai_event_callback[sgs.HpRecover].BaoNveZhiWang = function(self, player, data)
	if isTarget(player) and isGeneral(player, "dongzhuo", false) then
		if getInfo("BaoNveZhiWang", "baonve", 0) == 1 then
			setInfo("BaoNveZhiWang", "baonve", 0)
			addInfo("BaoNveZhiWang", "count", 1)
			if getInfo("BaoNveZhiWang", "count", 0) >= 10 then
				addFinishTag("BaoNveZhiWang")
			end
		end
	end
end
--[[****************************************************************
	战功：变拙成巧
	描述：使用张郃在一局游戏中发动巧变移动判定区的牌及装备区的牌各至少3张
]]--****************************************************************
sgs.glory_info["BianZhuoChengQiao"] = {
	name = "BianZhuoChengQiao",
	state = "验证通过",
	mode = "all_modes",
	general = "zhanghe",
	events = {sgs.CardsMoveOneTime},
	data = "BianZhuoChengQiao_data",
	keys = {
		"judge_count",
		"equip_count",
	},
}
sgs.BianZhuoChengQiao_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].BianZhuoChengQiao = function(self, player, data)
	local move = data:toMoveOneTime()
	local reason = move.reason
	if reason.m_reason == sgs.CardMoveReason_S_REASON_TRANSFER then
		if reason.m_playerId == sgs.glory_data["player_objectName"] and reason.m_skillName == "qiaobian" then
			local source = move.from
			if source and source:objectName() == player:objectName() and isGeneral(getTarget(), "zhanghe", true) then
				local flag = false
				for index, place in sgs.qlist(move.from_places) do
					if place == sgs.Player_PlaceEquip then
						addInfo("BianZhuoChengQiao", "equip_count", 1)
						flag = true
					elseif place == sgs.Player_PlaceDelayedTrick then
						addInfo("BianZhuoChengQiao", "judge_count", 1)
						flag = true
					end
				end
				if flag and getInfo("BianZhuoChengQiao", "judge_count", 0) >= 3 then
					if getInfo("BianZhuoChengQiao", "equip_count", 0) >= 3 then
						addFinishTag("BianZhuoChengQiao")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：不遗余力
	描述：使用郭嘉在1局游戏中发动遗计发牌至少5次
]]--****************************************************************
sgs.glory_info["BuYiYuLi"] = {
	name = "BuYiYuLi",
	state = "验证通过",
	mode = "all_modes",
	general = "guojia",
	events = {sgs.ChoiceMade},
	data = "BuYiYuLi_data",
	keys = {
		"count",
	},
}
sgs.BuYiYuLi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].BuYiYuLi = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 and isTarget(player) then
		if msg[1] == "skillInvoke" and msg[3] == "yes" and isGeneral(player, "guojia", false) then
			if msg[2] == "yiji" or msg[2] == "nosyiji" then
				addInfo("BuYiYuLi", "count", 1)
				if getInfo("BuYiYuLi", "count", 0) >= 5 then
					addFinishTag("BuYiYuLi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：才兼文武
	描述：使用姜维在一局游戏中发动挑衅弃掉牌至少4张并发动观星至少2次
]]--****************************************************************
sgs.glory_info["CaiJianWenWu"] = {
	name = "CaiJianWenWu",
	state = "验证通过",
	mode = "all_modes",
	general = "jiangwei",
	events = {sgs.ChoiceMade},
	data = "CaiJianWenWu_data",
	keys = {
		"tiaoxin_count",
		"guanxing_times",
	},
}
sgs.CaiJianWenWu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].CaiJianWenWu = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 and isTarget(player) then
		local flag = false
		if msg[1] == "cardChosen" and msg[2] == "tiaoxin" then
			if isGeneral(player, "jiangwei", false) then
				addInfo("CaiJianWenWu", "tiaoxin_count", 1)
				flag = true
			end
		elseif msg[1] == "skillInvoke" and msg[2] == "guanxing" and msg[3] == "yes" then
			if isGeneral(player, "jiangwei", false) then
				addInfo("CaiJianWenWu", "guanxing_times", 1)
				flag = true
			end
		end
		if flag and getInfo("CaiJianWenWu", "tiaoxin_count", 0) >= 4 then
			if getInfo("CaiJianWenWu", "guanxing_times", 0) >= 2 then
				addFinishTag("CaiJianWenWu")
			end
		end
	end
end
--[[****************************************************************
	战功：拆桃不偿
	描述：使用甘宁在一局游戏中至少拆掉对方5张桃
]]--****************************************************************
sgs.glory_info["ChaiTaoBuChang"] = {
	name = "ChaiTaoBuChang",
	state = "验证通过",
	mode = "all_modes",
	general = "ganning",
	events = {sgs.ChoiceMade},
	data = "ChaiTaoBuChang_data",
	keys = {
		"count",
	},
}
sgs.ChaiTaoBuChang_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ChaiTaoBuChang = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 and isTarget(player) then
		if msg[1] == "cardChosen" and isGeneral(player, "ganning", false) then
			if msg[2] == "dismantlement" or msg[2] == "yinling" then
				local id = tonumber(msg[3])
				local peach = sgs.Sanguosha:getCard(id)
				if peach and peach:isKindOf("Peach") then
					addInfo("ChaiTaoBuChang", "count", 1)
					if getInfo("ChaiTaoBuChang", "count", 0) >= 5 then
						addFinishTag("ChaiTaoBuChang")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：长坂虎威
	描述：使用张飞在一回合内使用8张杀
]]--****************************************************************
sgs.glory_info["ChangBanHuWei"] = {
	name = "ChangBanHuWei",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangfei",
	events = {sgs.PreCardUsed, sgs.EventPhaseChanging},
	data = "ChangBanHuWei_data",
	keys = {
		"count",
	},
}
sgs.ChangBanHuWei_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ChangBanHuWei = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("Slash") and isTarget(player) then
		local source = use.from
		if source and source:objectName() == player:objectName() and isGeneral(player, "zhangfei", false) then
			addInfo("ChangBanHuWei", "count", 1)
			if getInfo("ChangBanHuWei", "count", 0) >= 8 then
				addFinishTag("ChangBanHuWei")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].ChangBanHuWei = function(self, player, data)
	local change = data:toPhaseChange()
	if change.to == sgs.Player_NotActive or change.from == sgs.Player_NotActive then
		if isTarget(player) and isGeneral(player, "zhangfei", false) then
			setInfo("ChangBanHuWei", "count", 0)
		end
	end
end
--[[****************************************************************
	战功：长坂英雄
	描述：使用赵云在一局游戏中，在刘禅为队友且存活情况下获胜
]]--****************************************************************
sgs.glory_info["ChangBanYingXiong"] = {
	name = "ChangBanYingXiong",
	state = "验证通过",
	mode = "all_modes",
	general = "zhaoyun|gaodayihao",
	events = {sgs.NonTrigger},
	data = "ChangBanYingXiong_data",
	keys = {},
}
sgs.ChangBanYingXiong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ChangBanYingXiong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() then
		local alives = self.room:getAlivePlayers()
		local me = getTarget()
		if isGeneral(me, "zhaoyun|gaodayihao", false) then
			for _,p in sgs.qlist(alives) do
				if p:objectName() == me:objectName() then
				elseif isGeneral(p, "liushan", false) and isSameCamp(me, p) then
					addFinishTag("ChangBanYingXiong")
					return 
				end
			end
		end
	end
end
--[[****************************************************************
	战功：刺美人
	描述：使用祝融在1局游戏中对一名男性发动烈刃并拼点赢至少3次
]]--****************************************************************
sgs.glory_info["CiMeiRen"] = {
	name = "CiMeiRen",
	state = "验证通过",
	mode = "all_modes",
	general = "zhurong",
	events = {sgs.Pindian},
	data = "CiMeiRen_data",
	keys = {
		"count",
	},
}
sgs.CiMeiRen_data = {}
sgs.ai_event_callback[sgs.Pindian].CiMeiRen = function(self, player, data)
	local pindian = data:toPindian()
	if pindian.reason == "lieren" and pindian.success then
		local source = pindian.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			local target = pindian.to
			if target and target:isMale() and isGeneral(player, "zhurong", false) then
				addInfo("CiMeiRen", "count", 1)
				if getInfo("CiMeiRen", "count", 0) >= 3 then
					addFinishTag("CiMeiRen")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：此情常在
	描述：在一局游戏中，布练师发动安恤4次并在阵亡情况下获胜
]]--****************************************************************
sgs.glory_info["CiQingChangZai"] = {
	name = "CiQingChangZai",
	state = "验证通过",
	mode = "all_modes",
	general = "bulianshi",
	events = {sgs.PreCardUsed, sgs.NonTrigger},
	data = "CiQingChangZai_data",
	keys = {
		"anxu_times",
	},
}
sgs.CiQingChangZai_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].CiQingChangZai = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("AnxuCard") and isTarget(player) then
		local source = use.from
		if source and source:objectName() == player:objectName() and isGeneral(player, "bulianshi", false) then
			addInfo("CiQingChangZai", "anxu_times", 1)
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].CiQingChangZai = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amDead() and amWinner() and amGeneral("bulianshi", false) then
		if getInfo("CiQingChangZai", "anxu_times", 0) >= 4 then
			addFinishTag("CiQingChangZai")
		end
	end
end
--[[****************************************************************
	战功：大幻化师
	描述：使用左慈在一局游戏中获得化身牌至少10张
]]--****************************************************************
sgs.glory_info["DaHuanHuaShi"] = {
	name = "DaHuanHuaShi",
	state = "验证通过",
	mode = "all_modes",
	general = "zuoci",
	events = {sgs.ChoiceMade},
	data = "DaHuanHuaShi_data",
	keys = {},
}
sgs.DaHuanHuaShi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].DaHuanHuaShi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:xinsheng:yes" and isTarget(player) and isGeneral(player, "zuoci", false) then
		local names = player:getTag("Huashens"):toStringList()
		if #names + 1 >= 10 then
			addFinishTag("DaHuanHuaShi")
		end
	end
end
--[[****************************************************************
	战功：大军在此
	描述：使用徐盛在一局游戏中发动破军至少3次并获胜
]]--****************************************************************
sgs.glory_info["DaJunZaiCi"] = {
	name = "DaJunZaiCi",
	state = "验证通过",
	mode = "all_modes",
	general = "xusheng",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "DaJunZaiCi_data",
	keys = {
		"count",
	},
}
sgs.DaJunZaiCi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].DaJunZaiCi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:pojun:yes" and isTarget(player) and isGeneral(player, "xusheng", false) then
		addInfo("DaJunZaiCi", "count", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].DaJunZaiCi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("DaJunZaiCi", "count", 0) >= 3 then
			addFinishTag("DaJunZaiCi")
		end
	end
end
--[[****************************************************************
	战功：大权在握
	描述：使用钟会在一局游戏中有超过8张权
]]--****************************************************************
sgs.glory_info["DaQuanZaiWo"] = {
	name = "DaQuanZaiWo",
	state = "验证通过",
	mode = "all_modes",
	general = "zhonghui",
	events = {sgs.DamageComplete},
	data = "DaQuanZaiWo_data",
	keys = {},
}
sgs.DaQuanZaiWo_data = {}
sgs.ai_event_callback[sgs.DamageComplete].DaQuanZaiWo = function(self, player, data)
	local damage = data:toDamage()
	local victim = damage.to
	if victim and victim:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "zhonghui", false) and player:getPile("power"):length() >= 8 then
			addFinishTag("DaQuanZaiWo")
		end
	end
end
--[[****************************************************************
	战功：大姨妈
	描述：使用甄姬连续5回合洛神的第一次结果都是红色，不包括改判
]]--****************************************************************
sgs.glory_info["DaYiMa"] = {
	name = "DaYiMa",
	state = "验证通过",
	mode = "all_modes",
	general = "zhenji",
	events = {sgs.StartJudge, sgs.FinishRetrial, sgs.EventPhaseEnd, sgs.TurnStart},
	data = "DaYiMa_data",
	keys = {
		"turn",
		"last_turn",
		"ignore",
		"judge_card",
		"count",
	},
}
sgs.DaYiMa_data = {}
sgs.ai_event_callback[sgs.StartJudge].DaYiMa = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "luoshen" and isTarget(player) and getInfo("DaYiMa", "ignore", 0) == 0 then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isGeneral(player, "zhenji", false) then
			setInfo("DaYiMa", "judge_card", judge.card:getEffectiveId())
			local turn = getInfo("DaYiMa", "turn", 0)
			if getInfo("DaYiMa", "last_turn", -1) + 1 ~= turn then
				setInfo("DaYiMa", "count", 0)
			end
			setInfo("DaYiMa", "last_turn", turn)
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].DaYiMa = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "luoshen" and isTarget(player) then
		local who = judge.who
		if who and who:objectName() == player:objectName() and getInfo("DaYiMa", "ignore", 0) == 0 then
			local orignal = getInfo("DaYiMa", "judge_card", -1)
			setInfo("DaYiMa", "judge_card", -1)
			setInfo("DaYiMa", "ignore", 1)
			if judge.card:getEffectiveId() == orignal and judge:isBad() then
				addInfo("DaYiMa", "count", 1)
				if getInfo("DaYiMa", "count", 0) >= 5 then
					addFinishTag("DaYiMa")
					return 
				end
			else
				setInfo("DaYiMa", "count", 0)
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseEnd].DaYiMa = function(self, player, data)
	if player:getPhase() == sgs.Player_Start and isTarget(player) then
		setInfo("DaYiMa", "ignore", 0)
		setInfo("DaYiMa", "judge_card", -1)
	end
end
sgs.ai_event_callback[sgs.TurnStart].DaYiMa = function(self, player, data)
	if isTarget(player) then
		addInfo("DaYiMa", "turn", 1)
	end
end
--[[****************************************************************
	战功：大智若愚
	描述：使用刘禅每回合都发动放权并最终获胜
]]--****************************************************************
sgs.glory_info["DaZhiRuoYu"] = {
	name = "DaZhiRuoYu",
	state = "验证通过",
	mode = "all_modes",
	general = "liushan",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "DaZhiRuoYu_data",
	keys = {
		"fangquan_not_invoke",
	},
}
sgs.DaZhiRuoYu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].DaZhiRuoYu = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:fangquan:no" and isTarget(player) and isGeneral(player, "liushan", false) then
		setInfo("DaZhiRuoYu", "fangquan_not_invoke", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].DaZhiRuoYu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() and amGeneral("liushan", false) then
		if getInfo("DaZhiRuoYu", "fangquan_not_invoke", 0) == 0 then
			addFinishTag("DaZhiRuoYu")
		end
	end
end
--[[****************************************************************
	战功：胆小如鼠
	描述：使用旧朱然在一局游戏内连续发动胆守至少7次
]]--****************************************************************
sgs.glory_info["DanXiaoRuShu"] = {
	name = "DanXiaoRuShu",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_zhuran",
	events = {sgs.ChoiceMade},
	data = "DanXiaoRuShu_data",
	keys = {
		"count",
	},
}
sgs.DanXiaoRuShu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].DanXiaoRuShu = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and msg[2] == "nosdanshou" then
			if msg[3] == "yes" then
				addInfo("DanXiaoRuShu", "count", 1)
				if getInfo("DanXiaoRuShu", "count", 0) >= 7 then
					addFinishTag("DanXiaoRuShu")
				end
			elseif msg[3] == "no" then
				setInfo("DanXiaoRuShu", "count", 0)
			end
		end
	end
end
--[[****************************************************************
	战功：荡寇将军
	描述：使用程普在一局游戏中，发动技能“疠火”杀死至少三名反贼最终获得胜利
]]--****************************************************************
sgs.glory_info["DangKouJiangJun"] = {
	name = "DangKouJiangJun",
	state = "验证通过",
	mode = "roles",
	general = "chengpu",
	events = {sgs.NonTrigger},
	data = "DangKouJiangJun_data",
	keys = {
		"kill_rebel",
	},
}
sgs.DangKouJiangJun_data = {}
sgs.ai_event_callback[sgs.NonTrigger].DangKouJiangJun = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "chengpu", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:getRole() == "rebel" then
			local slash = death.damage.card
			if slash and slash:isKindOf("Slash") and slash:getSkillName() == "lihuo" then
				addInfo("DangKouJiangJun", "kill_rebel", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amWinner() and amGeneral("chengpu", false) then
		if getInfo("DangKouJiangJun", "kill_rebel", 0) >= 3 then
			addFinishTag("DangKouJiangJun")
		end
	end
end
--[[****************************************************************
	战功：当阳之吼
	描述：在一局游戏中，使用☆SP张飞累计两次发动大喝与一名角色拼点成功的回合中用红“杀”手刃该角色
]]--****************************************************************
sgs.glory_info["DangYangZhiHou"] = {
	name = "DangYangZhiHou",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_zhangfei",
	events = {sgs.Pindian, sgs.EventPhaseStart, sgs.NonTrigger},
	data = "DangYangZhiHou_data",
	keys = {
		"dahe",
		"target",
		"count",
	},
}
sgs.DangYangZhiHou_data = {}
sgs.ai_event_callback[sgs.Pindian].DangYangZhiHou = function(self, player, data)
	local pindian = data:toPindian()
	if pindian.reason == "dahe" and pindian.success then
		local source = pindian.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "bgm_zhangfei", true) then
				setInfo("DangYangZhiHou", "dahe", 1)
				setInfo("DangYangZhiHou", "target", pindian.to:objectName())
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].DangYangZhiHou = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("DangYangZhiHou", "dahe", 0)
		setInfo("DangYangZhiHou", "target", "")
	end
end
sgs.ai_event_callback[sgs.NonTrigger].DangYangZhiHou = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "bgm_zhangfei", true) then
		local death = self.room:getTag("gloryData"):toDeath()
		local slash = death.damage.card
		if slash and slash:isKindOf("Slash") and slash:isRed() then
			if getInfo("DangYangZhiHou", "dahe", 0) == 1 then
				if getInfo("DangYangZhiHou", "target", "") == death.who:objectName() then
					addInfo("DangYangZhiHou", "count", 1)
					if getInfo("DangYangZhiHou", "count", 0) >= 2 then
						addFinishTag("DangYangZhiHou")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：雕虫小技
	描述：使用卧龙在一局游戏中发动“看破”至少15次
]]--****************************************************************
sgs.glory_info["DiaoChongXiaoJi"] = {
	name = "DiaoChongXiaoJi",
	state = "验证通过",
	mode = "all_modes",
	general = "wolong",
	events = {sgs.CardUsed},
	data = "DiaoChongXiaoJi_data",
	keys = {
		"count",
	},
}
sgs.DiaoChongXiaoJi_data = {}
sgs.ai_event_callback[sgs.CardUsed].DiaoChongXiaoJi = function(self, player, data)
	local use = data:toCardUse()
	local null = use.card
	if null and null:isKindOf("Nullification") and null:getSkillName() == "kanpo" then
		local source = use.from
		if source and source:objectName() == player:objectName() then
			if isTarget(player) and isGeneral(player, "wolong", true) then
				addInfo("DiaoChongXiaoJi", "count", 1)
				if getInfo("DiaoChongXiaoJi", "count", 0) >= 15 then
					addFinishTag("DiaoChongXiaoJi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：洞察一切
	描述：使用神吕蒙在一局游戏中发动攻心将至少5张无中生有或桃置于牌堆顶
]]--****************************************************************
sgs.glory_info["DongChaYiQie"] = {
	name = "DongChaYiQie",
	state = "验证通过",
	mode = "all_modes",
	general = "shenlvmeng",
	events = {sgs.CardsMoveOneTime},
	data = "DongChaYiQie_data",
	keys = {
		"ex_nihilo",
		"peach",
	},
}
sgs.DongChaYiQie_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].DongChaYiQie = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_DrawPile then
		local source = move.from
		if source and source:objectName() == player:objectName() then
			local reason = move.reason
			if reason.m_skillName == "gongxin" and reason.m_playerId == sgs.glory_data["player_objectName"] then
				local flag = false
				for index, id in sgs.qlist(move.card_ids) do
					local card = sgs.Sanguosha:getCard(id)
					if card:isKindOf("ExNihilo") then
						addInfo("DongChaYiQie", "ex_nihilo", 1)
						flag = true
					elseif card:isKindOf("Peach") then
						addInfo("DongChaYiQie", "peach", 1)
						flag = true
					end
				end
				if flag then
					if getInfo("DongChaYiQie", "ex_nihilo", 0) + getInfo("DongChaYiQie", "peach", 0) >= 5 then
						addFinishTag("DongChaYiQie")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：毒策士
	描述：使用李儒在一局游戏中，发动绝策杀死至少2名角色并发动焚城杀死至少2名角色
]]--****************************************************************
sgs.glory_info["DuCeShi"] = {
	name = "DuCeShi",
	state = "验证通过",
	mode = "all_modes",
	general = "liru",
	events = {sgs.NonTrigger},
	data = "DuCeShi_data",
	keys = {
		"juece_count",
		"fencheng_count",
	},
}
sgs.DuCeShi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].DuCeShi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "liru", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		local reason = death.damage.reason
		if reason == "juece" or reason == "nosjuece" then
			addInfo("DuCeShi", "juece_count", 1)
		elseif reason == "fencheng" or reason == "nosfencheng" then
			addInfo("DuCeShi", "fencheng_count", 1)
		else
			return 
		end
		if getInfo("DuCeShi", "juece_count", 0) >= 2 and getInfo("DuCeShi", "fencheng_count", 0) >= 2 then
			addFinishTag("DuCeShi")
		end
	end
end
--[[****************************************************************
	战功：杜康之子
	描述：使用曹植在一局游戏中发动酒诗后成功用杀造成伤害累计5次
]]--****************************************************************
sgs.glory_info["DuKangZhiZi"] = {
	name = "DuKangZhiZi",
	state = "验证通过",
	mode = "all_modes",
	general = "caozhi",
	events = {sgs.CardUsed, sgs.SlashHit, sgs.NonTrigger, sgs.EventPhaseEnd},
	data = "DuKangZhiZi_data",
	keys = {
		"jiushi",
		"slash_hit",
		"count",
	},
}
sgs.DuKangZhiZi_data = {}
sgs.ai_event_callback[sgs.CardUsed].DuKangZhiZi = function(self, player, data)
	local use = data:toCardUse()
	local anal = use.card
	if anal and anal:isKindOf("Analeptic") and anal:getSkillName() == "jiushi" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "caozhi", false) then
				setInfo("DuKangZhiZi", "jiushi", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.SlashHit].DuKangZhiZi = function(self, player, data)
	local effect = data:toSlashEffect()
	local source = effect.from
	if source and source:objectName() == player:objectName() and isTarget(player) and isGeneral(player, "caozhi", false) then
		if effect.drank > 0 and getInfo("DuKangZhiZi", "jiushi", 0) == 1 then
			setInfo("DuKangZhiZi", "jiushi", 0)
			setInfo("DuKangZhiZi", "slash_hit", 1)
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].DuKangZhiZi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) and isGeneral(player, "caozhi", false) then
		if getInfo("DuKangZhiZi", "slash_hit", 0) == 1 then
			addInfo("DuKangZhiZi", "count", 1)
			if getInfo("DuKangZhiZi", "count", 0) >= 5 then
				addFinishTag("DuKangZhiZi")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].DuKangZhiZi = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		addInfo("DuKangZhiZi", "jiushi", 0)
		addInfo("DuKangZhiZi", "slash_hit", 0)
	end
end
--[[****************************************************************
	战功：恩怨分明
	描述：使用新法正在一局游戏中分别获得卡牌和受到伤害时发动技能恩怨各2次
]]--****************************************************************
sgs.glory_info["EnYuanFenMing"] = {
	name = "EnYuanFenMing",
	state = "验证通过",
	mode = "all_modes",
	general = "fazheng",
	events = {sgs.ChoiceMade},
	data = "EnYuanFenMing_data",
	keys = {
		"en_count",
		"yuan_count",
	},
}
sgs.EnYuanFenMing_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].EnYuanFenMing = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:enyuan:yes" and isTarget(player) and isGeneral(player, "fazheng", true) then
		local isDraw = false
		local alives = self.room:getAlivePlayers()
		for _,p in sgs.qlist(alives) do
			if p:hasFlag("EnyuanDrawTarget") then
				isDraw = true
				break
			end
		end
		if isDraw then
			addInfo("EnYuanFenMing", "en_count", 1)
		else
			addInfo("EnYuanFenMing", "yuan_count", 1)
		end
		if getInfo("EnYuanFenMing", "en_count", 0) >= 2 and getInfo("EnYuanFenMing", "yuan_count", 0) >= 2 then
			addFinishTag("EnYuanFenMing")
		end
	end
end
--[[****************************************************************
	战功：法不容情
	描述：使用满宠在一局游戏中对魏势力角色发动至少4次峻刑
]]--****************************************************************
sgs.glory_info["FaBuRongQing"] = {
	name = "FaBuRongQing",
	state = "验证通过",
	mode = "all_modes",
	general = "manchong",
	events = {sgs.PreCardUsed},
	data = "FaBuRongQing_data",
	keys = {
		"count",
	},
}
sgs.FaBuRongQing_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].FaBuRongQing = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("JunxingCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "manchong", false) then
				for _,p in sgs.qlist(use.to) do
					if p:getKingdom() == "wei" then
						addInfo("FaBuRongQing", "count", 1)
						if getInfo("FaBuRongQing", "count", 0) >= 4 then
							if addFinishTag("FaBuRongQing") then
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
	战功：飞将
	描述：使用吕布在1局游戏中发动方天画戟特效杀死至少2名角色
]]--****************************************************************
sgs.glory_info["FeiJiang"] = {
	name = "FeiJiang",
	state = "验证通过",
	mode = "all_modes",
	general = "lvbu",
	events = {sgs.PreCardUsed, sgs.NonTrigger, sgs.CardFinished},
	data = "FeiJiang_data",
	keys = {
		"halberd",
		"slash",
		"count",
	},
}
sgs.FeiJiang_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].FeiJiang = function(self, player, data)
	local use = data:toCardUse()
	local slash = use.card
	if slash and slash:isKindOf("Slash") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if player:isLastHandCard(slash) and player:hasWeapon("halberd") and use.to:length() > 1 then
				if isGeneral(player, "lvbu", false) then
					setInfo("FeiJiang", "halberd", 1)
					setInfo("FeiJiang", "slash", slash)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].FeiJiang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "lvbu", false) then
		if getInfo("FeiJiang", "halberd", 0) == 1 then
			local death = self.room:getTag("gloryData"):toDeath()
			local card = death.damage.card
			local slash = getInfo("FeiJiang", "slash", nil)
			if slash and card and slash == card then
				addInfo("FeiJiang", "count", 1)
				if getInfo("FeiJiang", "count", 0) >= 2 then
					addFinishTag("FeiJiang")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].FeiJiang = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		local slash = use.card
		if slash and slash:isKindOf("Slash") then
			setInfo("FeiJiang", "halberd", 0)
			setInfo("FeiJiang", "slash", nil)
		end
	end
end
--[[****************************************************************
	战功：愤勇难当
	描述：使用☆SP夏侯惇在一局游戏中，至少发动四次愤勇
]]--****************************************************************
sgs.glory_info["FenYongNanDang"] = {
	name = "FenYongNanDang",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_xiahoudun",
	events = {sgs.ChoiceMade},
	data = "FenYongNanDang_data",
	keys = {
		"count",
	},
}
sgs.FenYongNanDang_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].FenYongNanDang = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:fenyong:yes" and isTarget(player) and isGeneral(player, "bgm_xiahoudun", true) then
		addInfo("FenYongNanDang", "count", 1)
		if getInfo("FenYongNanDang", "count", 0) >= 4 then
			addFinishTag("FenYongNanDang")
		end
	end
end
--[[****************************************************************
	战功：风驰电掣
	描述：使用夏侯渊在1局游戏中，有连续至少3个回合每个回合都发动2次神速
]]--****************************************************************
sgs.glory_info["FengChiDianChe"] = {
	name = "FengChiDianChe",
	state = "验证通过",
	mode = "all_modes",
	general = "xiahouyuan",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "FengChiDianChe_data",
	keys = {
		"turn_count",
		"count",
	},
}
sgs.FengChiDianChe_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].FengChiDianChe = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("ShensuCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xiahouyuan", false) then
				addInfo("FengChiDianChe", "count", 1)
				if getInfo("FengChiDianChe", "count", 0) == 2 then
					addInfo("FengChiDianChe", "turn_count", 1)
					if getInfo("FengChiDianChe", "turn_count", 0) >= 3 then
						addFinishTag("FengChiDianChe")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].FengChiDianChe = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		if getInfo("FengChiDianChe", "count", 0) < 2 then
			setInfo("FengChiDianChe", "turn_count", 0)
		end
		setInfo("FengChiDianChe", "count", 0)
	end
end
--[[****************************************************************
	战功：丰悼王
	描述：使用sp曹昂在一局游戏中发动慷忾摸到装备牌至少3张
]]--****************************************************************
sgs.glory_info["FengDaoWang"] = {
	name = "FengDaoWang",
	state = "验证通过",
	mode = "all_modes",
	general = "caoang",
	events = {sgs.ChoiceMade},
	data = "FengDaoWang_data",
	keys = {
		"count",
	},
}
sgs.FengDaoWang_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].FengDaoWang = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --skillInvoke:kangkai:sgs1:yes
		if msg[1] == "skillInvoke" and msg[2] == "kangkai" and msg[#msg] == "yes" then
			if isTarget(player) and isGeneral(player, "caoang", false) then
				local draw_pile = self.room:getDrawPile()
				local id = draw_pile:first()
				local equip = sgs.Sanguosha:getCard(id)
				if equip:isKindOf("EquipCard") then
					addInfo("FengDaoWang", "count", 1)
					if getInfo("FengDaoWang", "count", 0) >= 3 then
						addFinishTag("FengDaoWang")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：福将
	描述：使用曹洪在一局游戏中发动援护总计回复两点体力
]]--****************************************************************
sgs.glory_info["FuJiang"] = {
	name = "FuJiang",
	state = "验证通过",
	modes = "all_modes",
	general = "caohong",
	events = {sgs.PreCardUsed},
	data = "FuJiang_data",
	keys = {
		"count",
	},
}
sgs.FuJiang_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].FuJiang = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("YuanhuCard") and isTarget(player) then
		local source = use.from
		if source and source:objectName() == player:objectName() and isGeneral(player, "caohong", false) then
			local target = use.to:first()
			if target:getLostHp() > 0 then
				local id = card:getSubcards():first()
				local horse = sgs.Sanguosha:getCard(id)
				if horse and horse:isKindOf("Horse") then
					addInfo("FuJiang", "count", 1)
					if getInfo("FuJiang", "count", 0) >= 2 then
						addFinishTag("FuJiang")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：辅吴将军
	描述：使用张昭&张纮在一局中发动直谏将至少5张装备牌置于吴势力武将装备区
]]--****************************************************************
sgs.glory_info["FuWuJiangJun"] = {
	name = "FuWuJiangJun",
	state = "验证通过",
	mode = "all_modes",
	general = "erzhang",
	events = {},
	data = "FuWuJiangJun_data",
	keys = {
		"count",
	},
}
sgs.FuWuJiangJun_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].FuWuJiangJun = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("ZhijianCard") and isTarget(player) then
		local source = use.from
		if source and source:objectName() == player:objectName() and isGeneral(player, "erzhang", true) then
			if use.to:first():getKingdom() == "wu" then
				addInfo("FuWuJiangJun", "count", 1)
				if getInfo("FuWuJiangJun", "count", 0) >= 5 then
					addFinishTag("FuWuJiangJun")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：刚烈难存
	描述：使用夏侯惇在一局游戏中连续4次刚烈判定均为红桃
]]--****************************************************************
sgs.glory_info["GangLieNanCun"] = {
	name = "GangLieNanCun",
	state = "验证通过",
	mode = "all_modes",
	general = "xiahoudun",
	events = {sgs.FinishRetrial},
	data = "GangLieNanCun_data",
	keys = {
		"count",
	},
}
sgs.GangLieNanCun_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].GangLieNanCun = function(self, player, data)
	local judge = data:toJudge()
	if string.find(judge.reason, "ganglie") then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) and isGeneral(player, "xiahoudun", false) then
			if judge:isGood() then
				setInfo("GangLieNanCun", "count", 0)
			else
				addInfo("GangLieNanCun", "count", 1)
				if getInfo("GangLieNanCun", "count", 0) >= 4 then
					addFinishTag("GangLieNanCun")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：顾曲周郎
	描述：使用神周瑜连续至少4回合发动琴音回复体力
]]--****************************************************************
sgs.glory_info["GuQuZhouLang"] = {
	name = "GuQuZhouLang",
	state = "验证通过",
	mode = "all_modes",
	general = "shenzhouyu",
	events = {sgs.ChoiceMade, sgs.TurnStart},
	data = "GuQuZhouLang_data",
	count = {
		"turn",
		"last_turn",
		"count",
	},
}
sgs.GuQuZhouLang_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].GuQuZhouLang = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillChoice:qinyin:up" and isTarget(player) and isGeneral(player, "shenzhouyu", true) then
		local turn = getInfo("GuQuZhouLang", "turn", 0)
		if getInfo("GuQuZhouLang", "last_turn", -1) + 1 ~= turn then
			setInfo("GuQuZhouLang", "count", 0)
		end
		setInfo("GuQuZhouLang", "last_turn", turn)
		addInfo("GuQuZhouLang", "count", 1)
		if getInfo("GuQuZhouLang", "count", 0) >= 4 then
			addFinishTag("GuQuZhouLang")
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].GuQuZhouLang = function(self, player, data)
	if isTarget(player) then
		addInfo("GuQuZhouLang", "turn", 1)
	end
end
--[[****************************************************************
	战功：固若金汤
	描述：使用曹仁在一局游戏中发动至少3次据守，并且在损失体力不多于3点的情况下获胜。
]]--****************************************************************
sgs.glory_info["GuRuoJinTang"] = {
	name = "GuRuoJinTang",
	state = "验证通过",
	mode = "all_modes",
	general = "caoren",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "GuRuoJinTang_data",
	keys = {
		"count",
	},
}
sgs.GuRuoJinTang_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].GuRuoJinTang = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "jushou") and msg[3] == "yes" then
			if isTarget(player) and isGeneral(player, "caoren", false) then
				addInfo("GuRuoJinTang", "count", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].GuRuoJinTang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() and amGeneral("caoren", false) then
		if getInfo("GuRuoJinTang", "count", 0) >= 3 then
			if getTarget():getLostHp() <= 3 then
				addFinishTag("GuRuoJinTang")
			end
		end
	end
end
--[[****************************************************************
	战功：固政为本
	描述：使用张昭张纮在一局游戏中利用技能“固政”获得累计至少40张牌
]]--****************************************************************
sgs.glory_info["GuZhengWeiBen"] = {
	name = "GuZhengWeiBen",
	state = "验证通过",
	mode = "all_modes",
	general = "erzhang",
	events = {sgs.ChoiceMade, sgs.CardsMoveOneTime, sgs.EventPhaseEnd},
	data = "GuZhengWeiBen_data",
	keys = {
		"guzheng",
		"count",
	},
}
sgs.GuZhengWeiBen_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].GuZhengWeiBen = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --AGChosen:guzheng:134
		if msg[1] == "AGChosen" and msg[2] == "guzheng" and tonumber(msg[3]) ~= -1 then
			setInfo("GuZhengWeiBen", "guzheng", 1)
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].GuZhengWeiBen = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if getInfo("GuZhengWeiBen", "guzheng", 0) == 1 and isGeneral(player, "erzhang", true) then
				local current = self.room:getCurrent()
				if current and current:getPhase() == sgs.Player_Discard then
					setInfo("GuZhengWeiBen", "guzheng", 0)
					local count = 0
					for index, place in sgs.qlist(move.from_places) do
						if place == sgs.Player_DiscardPile then
							count = count + 1
						end
					end
					if count > 0 then
						addInfo("GuZhengWeiBen", "count", count)
						if getInfo("GuZhengWeiBen", "count", 0) >= 40 then
							addFinishTag("GuZhengWeiBen") 
						end
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseEnd].GuZhengWeiBen = function(self, player, data)
	if player:getPhase() == sgs.Player_Discard then
		setInfo("GuZhengWeiBen", "guzheng", 0)
	end
end
--[[****************************************************************
	战功：过目之才
	描述：使用☆SP庞统一回合内累计拿到至少16张牌
]]--****************************************************************
sgs.glory_info["GuoMuZhiCai"] = {
	name = "GuoMuZhiCai",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_pangtong",
	events = {sgs.CardsMoveOneTime, sgs.EventPhaseChanging},
	data = "GuoMuZhiCai_data",
	keys = {
		"count",
	},
}
sgs.GuoMuZhiCai_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].GuoMuZhiCai = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "bgm_pangtong", true) then
				addInfo("GuoMuZhiCai", "count", move.card_ids:length())
				if getInfo("GuoMuZhiCai", "count", 0) >= 16 then
					addFinishTag("GuoMuZhiCai")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].GuoMuZhiCai = function(self, player, data)
	local change = data:toPhaseChange()
	if change.from == sgs.Player_NotActive or change.to == sgs.Player_NotActive then
		if isTarget(player) then
			setInfo("GuoMuZhiCai", "count", 0)
		end
	end
end
--[[****************************************************************
	战功：红莲业火
	描述：使用神周瑜在一回合发动业炎造成至少5点伤害
]]--****************************************************************
sgs.glory_info["HongLianYeHuo"] = {
	name = "HongLianYeHuo",
	state = "验证通过",
	mode = "all_modes",
	general = "shenzhouyu",
	events = {sgs.NonTrigger, sgs.EventPhaseChanging},
	data = "HongLianYeHuo_data",
	keys = {
		"count",
	},
}
sgs.HongLianYeHuo_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HongLianYeHuo = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) and isGeneral(player, "shenzhouyu", true) then
		local damage = self.room:getTag("gloryData"):toDamage()
		if damage.nature == sgs.DamageStruct_Fire and damage.reason == "yeyan" then
			addInfo("HongLianYeHuo", "count", damage.damage)
			if getInfo("HongLianYeHuo", "count", 0) >= 5 then
				addFinishTag("HongLianYeHuo")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].HongLianYeHuo = function(self, player, data)
	local change = data:toPhaseChange()
	if change.from == sgs.Player_NotActive or change.from == sgs.Player_NotActive then
		if isTarget(player) then
			setInfo("HongLianYeHuo", "count", 0)
		end
	end
end
--[[****************************************************************
	战功：红颜祸水
	描述：使用SP貂蝉在一局游戏中，两次对主公和忠臣发动技能“离间”并导致2名忠臣阵亡
]]--****************************************************************
sgs.glory_info["HongYanHuoShui"] = {
	name = "HongYanHuoShui",
	state = "验证通过",
	mode = "roles",
	general = "diaochan",
	events = {sgs.PreCardUsed, sgs.NonTrigger, sgs.CardFinished},
	data = "HongYanHuoShui_data",
	keys = {
		"lijian",
		"count",
	},
}
sgs.HongYanHuoShui_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].HongYanHuoShui = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("LijianCard") or card:isKindOf("NosLijianCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "diaochan", false) then
				setInfo("HongYanHuoShui", "lijian", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].HongYanHuoShui = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and player:getRole() == "lord" then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:getRole() == "loyalist" and getInfo("HongYanHuoShui", "lijian", 0) == 1 then
			local duel = death.damage.card
			if duel and string.find(duel:getSkillName(), "lijian") then
				addInfo("HongYanHuoShui", "count", 1)
				if getInfo("HongYanHuoShui", "count", 0) >= 2 then
					addFinishTag("HongYanHuoShui")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].HongYanHuoShui = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		local card = use.card
		if card:isKindOf("LijianCard") or card:isKindOf("NosLijianCard") then
			setInfo("HongYanHuoShui", "lijian", 0)
		end
	end
end
--[[****************************************************************
	战功：虎子同心
	描述：使用旧关兴张苞在父魂成功后，一个回合杀死至少三名反贼
]]--****************************************************************
sgs.glory_info["HuZiTongXin"] = {
	name = "HuZiTongXin",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_guanxingzhangbao",
	events = {sgs.NonTrigger, sgs.EventPhaseStart},
	data = "HuZiTongXin_data",
	keys = {
		"count",
	},
}
sgs.HuZiTongXin_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HuZiTongXin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "nos_guanxingzhangbao", true) then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:getRole() == "rebel" and player:hasFlag("nosfuhun") then
			addInfo("HuZiTongXin", "count", 1)
			if getInfo("HuZiTongXin", "count", 0) >= 3 then
				addFinishTag("HuZiTongXin")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].HuZiTongXin = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("HuZiTongXin", "count", 0)
	end
end
--[[****************************************************************
	战功：换斗移星
	描述：使用神诸葛在一局游戏中让至少一名狂风状态的角色被火攻杀死
]]--****************************************************************
sgs.glory_info["HuanDouYiXing"] = {
	name = "HuanDouYiXing",
	state = "验证通过",
	modes = "all_modes",
	general = "shenzhugeliang",
	events = {sgs.NonTrigger},
	data = "HuanDouYiXing_data",
	keys = {},
}
sgs.HuanDouYiXing_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HuanDouYiXing = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and player:getMark("@gale") > 0 then
		local death = self.room:getTag("gloryData"):toDeath()
		local reason = death.damage
		if reason then
			local trick = reason.card
			if trick and trick:isKindOf("FireAttack") then
				if amGeneral("shenzhugeliang", true) then
					addFinishTag("HuanDouYiXing")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：黄天当立
	描述：使用张角在一局游戏中从群雄武将处得到的闪不少于8张
]]--****************************************************************
sgs.glory_info["HuangTianDangLi"] = {
	name = "HuangTianDangLi",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangjiao",
	events = {sgs.CardsMoveOneTime},
	data = "HuangTianDangLi_data",
	keys = {
		"count"
	},
}
sgs.HuangTianDangLi_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].HuangTianDangLi = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			local source = move.from
			if source and source:getKingdom() == "qun" and isGeneral(player, "zhangjiao", false) then
				for index, id in sgs.qlist(move.card_ids) do
					local jink = sgs.Sanguosha:getCard(id)
					if jink:isKindOf("Jink") then
						addInfo("HuangTianDangLi", "count", 1)
						if getInfo("HuangTianDangLi", "count", 0) >= 8 then
							if addFinishTag("HuangTianDangLi") then
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
	战功：挥泪斩马谡
	描述：使用诸葛亮杀死马谡
]]--****************************************************************
sgs.glory_info["HuiLeiZhanMaSu"] = {
	name = "HuiLeiZhanMaSu",
	state = "验证通过",
	mode = "all_modes",
	general = "zhugeliang",
	events = {sgs.NonTrigger},
	data = "HuiLeiZhanMaSu_data",
	keys = {},
}
sgs.HuiLeiZhanMaSu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HuiLeiZhanMaSu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "zhugeliang", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		if isGeneral(death.who, "masu", false) then
			addFinishTag("HuiLeiZhanMaSu")
		end
	end
end
--[[****************************************************************
	战功：浑身是胆
	描述：使用赵云在1局游戏中发动龙胆至少杀死3名角色
]]--****************************************************************
sgs.glory_info["HunShenShiDan"] = {
	name = "HunShenShiDan",
	state = "验证通过",
	mode = "all_modes",
	general = "zhaoyun|gaodayihao",
	events = {sgs.NonTrigger},
	data = "HunShenShiDan_data",
	keys = {
		"count",
	},
}
sgs.HunShenShiDan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HunShenShiDan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local card = death.damage.card
		if card and card:getSkillName() == "longdan" then
			if isGeneral(player, "zhaoyun|gaodayihao", false) then
				addInfo("HunShenShiDan", "count", 1)
				if getInfo("HunShenShiDan", "count", 0) >= 3 then
					addFinishTag("HunShenShiDan")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：坚守不出
	描述：使用曹仁在一局游戏中连续8回合发动据守
]]--****************************************************************
sgs.glory_info["JianShouBuChu"] = {
	name = "JianShouBuChu",
	state = "验证通过",
	mode = "all_modes",
	general = "caoren",
	events = {sgs.ChoiceMade},
	data = "JianShouBuChu_data",
	keys = {
		"count",
	},
}
sgs.JianShouBuChu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JianShouBuChu = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "jushou") then
			if isTarget(player) and isGeneral(player, "caoren", false) then
				if msg[3] == "yes" then
					addInfo("JianShouBuChu", "count", 1)
					if getInfo("JianShouBuChu", "count", 0) >= 8 then
						addFinishTag("JianShouBuChu")
					end
				else
					setInfo("JianShouBuChu", "count", 0)
				end
			end
		end
	end
end
--[[****************************************************************
	战功：见者有份
	描述：使用杨修在一局游戏中发动技能“啖酪”至少6次
]]--****************************************************************
sgs.glory_info["JianZheYouFen"] = {
	name = "JianZheYouFen",
	state = "验证通过",
	mode = "all_modes",
	general = "yangxiu",
	events = {sgs.ChoiceMade},
	data = "JianZheYouFen_data",
	keys = {
		"count",
	},
}
sgs.JianZheYouFen_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JianZheYouFen = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:danlao:yes" and isTarget(player) and isGeneral(player, "yangxiu", false) then
		addInfo("JianZheYouFen", "count", 1)
		if getInfo("JianZheYouFen", "count", 0) >= 6 then
			addFinishTag("JianZheYouFen")
		end
	end
end
--[[****************************************************************
	战功：将驰有度
	描述：使用曹彰发动将驰的两种效果各连续两回合
]]--****************************************************************
sgs.glory_info["JiangChiYouDu"] = {
	name = "JiangChiYouDu",
	state = "验证通过",
	mode = "all_modes",
	general = "caozhang",
	events = {sgs.ChoiceMade},
	data = "JiangChiYouDu_data",
	keys = {
		"order",
	},
}
sgs.JiangChiYouDu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JiangChiYouDu = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillChoice" and msg[2] == "jiangchi" then
			if isTarget(player) and isGeneral(player, "caozhang", false) then
				local order = getInfo("JiangChiYouDu", "order", "")
				if msg[3] == "jiang" then
					order = order .. "J"
				elseif msg[3] == "chi" then
					order = order .. "C"
				else
					setInfo("JiangChiYouDu", "order", "")
					return 
				end
				setInfo("JiangChiYouDu", "order", order)
				if string.find(order, "JJCC") or string.find(order, "CCJJ") then
					addFinishTag("JiangChiYouDu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：江东之虎
	描述：使用太史慈在1回合内发动天义拼点胜利后，使用【杀】杀死至少3名角色
]]--****************************************************************
sgs.glory_info["JiangDongZhiHu"] = {
	name = "JiangDongZhiHu",
	state = "验证通过",
	mode = "all_modes",
	general = "taishici",
	events = {sgs.NonTrigger, sgs.EventPhaseStart},
	data = "JiangDongZhiHu_data",
	keys = {
		"count",
	},
}
sgs.JiangDongZhiHu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JiangDongZhiHu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "taishici", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		local slash = death.damage.card
		if slash and slash:isKindOf("Slash") and player:hasFlag("TianyiSuccess") then
			addInfo("JiangDongZhiHu", "count", 1)
			if getInfo("JiangDongZhiHu", "count", 0) >= 3 then
				addFinishTag("JiangDongZhiHu")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].JiangDongZhiHu = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("JiangDongZhiHu", "count", 0)
	end
end
--[[****************************************************************
	战功：江东之花
	描述：使用大乔小乔在一局游戏中发动技能星舞造成4点伤害
]]--****************************************************************
sgs.glory_info["JiangDongZhiHua"] = {
	name = "JiangDongZhiHua",
	state = "验证通过",
	mode = "all_modes",
	general = "erqiao",
	events = {sgs.NonTrigger},
	data = "JiangDongZhiHua_data",
	keys = {
		"point",
	},
}
sgs.JiangDongZhiHua_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JiangDongZhiHua = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) and isGeneral(player, "erqiao", true) then
		local damage = self.room:getTag("gloryData"):toDamage()
		if damage.reason == "xingwu" then
			addInfo("JiangDongZhiHua", "point", damage.damage)
			if getInfo("JiangDongZhiHua", "point", 0) >= 4 then
				addFinishTag("JiangDongZhiHua")
			end
		end
	end
end
--[[****************************************************************
	战功：交际花
	描述：使用孙尚香和全部其他(且至少4个)角色皆使用过结姻
]]--****************************************************************
sgs.glory_info["JiaoJiHua"] = {
	name = "JiaoJiHua",
	state = "验证通过",
	mode = "all_modes",
	general = "sunshangxiang",
	events = {sgs.PreCardUsed},
	data = "JiaoJiHua_data",
	keys = {
		"targets",
	},
}
sgs.JiaoJiHua_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].JiaoJiHua = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("JieyinCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "sunshangxiang", false) then
				local names = getInfo("JiaoJiHua", "targets", ""):split("+")
				local count = self.room:getOtherPlayers(player, true):length()
				for _,target in sgs.qlist(use.to) do
					local name = target:objectName()
					local insert = true
					for _,n in ipairs(names) do
						if n == name then
							insert = false
							break
						end
					end
					if insert then
						table.insert(names, name)
						setInfo("JiaoJiHua", "targets", table.concat(names, "+"))
						if #names >= 4 and #names == count then
							if addFinishTag("JiaoJiHua") then
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
	战功：解烦护主
	描述：使用旧韩当在一局游戏游戏中发动“解烦”救过队友孙权至少两次
]]--****************************************************************
sgs.glory_info["JieFanHuZhu"] = {
	name = "JieFanHuZhu",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_handang",
	events = {sgs.PreCardUsed},
	data = "JieFanHuZhu_data",
	keys = {
		"count",
	},
}
sgs.JieFanHuZhu_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].JieFanHuZhu = function(self, player, data)
	local use = data:toCardUse()
	local peach = use.card
	if peach and peach:isKindOf("Peach") and peach:getSkillName() == "nosjiefan" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "nos_handang", true) then
				for _,target in sgs.qlist(use.to) do
					if target:objectName() == player:objectName() then
					elseif isGeneral(target, "sunquan", false) and isSameCamp(target, player) then
						addInfo("JieFanHuZhu", "count", 1)
						if getInfo("JieFanHuZhu", "count", 0) >= 2 then
							if addFinishTag("JieFanHuZhu") then
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
	战功：解语花
	描述：使用步练师在一局游戏中发动安恤摸八张牌以上
]]--****************************************************************
sgs.glory_info["JieYuHua"] = {
	name = "JieYuHua",
	state = "验证通过",
	mode = "all_modes",
	general = "bulianshi",
	events = {},
	data = "JieYuHua_data",
	keys = {
		"count",
	},
}
sgs.JieYuHua_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].JieYuHua = function(self, player, data)
	local move = data:toMoveOneTime() 
	if move.to_place == sgs.Player_PlaceHand and move.from_places:contains(sgs.Player_DrawPile) then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if move.reason.m_skillName == "anxu" and isGeneral(player, "bulianshi", false) then
				addInfo("JieYuHua", "count", move.card_ids:length())
				if getInfo("JieYuHua", "count", 0) >= 8 then
					addFinishTag("JieYuHua")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：戒酒以备
	描述：使用高顺在一局游戏中使用技能“禁酒”将至少6张酒当成杀使用或打出
]]--****************************************************************
sgs.glory_info["JieJiuYiBei"] = {
	name = "JieJiuYiBei",
	state = "验证通过",
	mode = "all_modes",
	general = "gaoshun",
	events = {sgs.PreCardUsed, sgs.PreCardResponded},
	data = "JieJiuYiBei_data",
	keys = {
		"count",
	},
}
sgs.JieJiuYiBei_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].JieJiuYiBei = function(self, player, data)
	local use = data:toCardUse()
	local slash = use.card
	if slash and slash:isKindOf("Slash") and slash:getSkillName() == "jinjiu" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "gaoshun", false) then
				addInfo("JieJiuYiBei", "count", 1)
				if getInfo("JieJiuYiBei", "count", 0) >= 6 then
					addFinishTag("JieJiuYiBei")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardResponded].JieJiuYiBei = function(self, player, data)
	local response = data:toCardResponse()
	local slash = response.m_card
	if slash and slash:isKindOf("Slash") and slash:getSkillName() == "jinjiu" then
		if isTarget(player) and isGeneral(player, "gaoshun", false) then
			addInfo("JieJiuYiBei", "count", 1)
			if getInfo("JieJiuYiBei", "count", 0) >= 6 then
				addFinishTag("JieJiuYiBei")
			end
		end
	end
end
--[[****************************************************************
	战功：禁军难护
	描述：使用旧韩当在一局游戏中有角色濒死时发动“解烦”并出杀后均被闪避至少5次
]]--****************************************************************
sgs.glory_info["JinJunNanHu"] = {
	name = "JinJunNanHu",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_handang",
	events = {sgs.SlashMissed},
	data = "JinJunNanHu_data",
	keys = {
		"count",
	},
}
sgs.JinJunNanHu_data = {}
sgs.ai_event_callback[sgs.SlashMissed].JinJunNanHu = function(self, player, data)
	local effect = data:toSlashEffect()
	if effect.slash:hasFlag("nosjiefan-slash") then
		local source = effect.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "nos_handang", true) then
				addInfo("JinJunNanHu", "count", 1)
				if getInfo("JinJunNanHu", "count", 0) >= 5 then
					addFinishTag("JinJunNanHu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：锦囊袋
	描述：使用黄月英在1个回合内发动至少10次集智
]]--****************************************************************
sgs.glory_info["JinNangDai"] = {
	name = "JinNangDai",
	state = "验证通过",
	mode = "all_modes",
	general = "huangyueying",
	events = {sgs.ChoiceMade, sgs.EventPhaseStart},
	data = "JinNangDai_data",
	keys = {
		"count",
	},
}
sgs.JinNangDai_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JinNangDai = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "jizhi") and msg[3] == "yes" then
			if isTarget(player) and isGeneral(player, "huangyueying", false) then
				addInfo("JinNangDai", "count", 1)
				if getInfo("JinNangDai", "count", 0) >= 10 then
					addFinishTag("JinNangDai")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].JinNangDai = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("JinNangDai", "count", 0)
	end
end
--[[****************************************************************
	战功：金枪不倒
	描述：使用周泰在1局游戏中拥有过至少9张不屈牌并且未死
]]--****************************************************************
sgs.glory_info["JinQiangBuDao"] = {
	name = "JinQiangBuDao",
	state = "验证通过",
	mode = "all_modes",
	general = "zhoutai",
	events = {sgs.DamageComplete},
	data = "JinQiangBuDao_data",
	keys = {},
}
sgs.JinQiangBuDao_data = {}
sgs.ai_event_callback[sgs.DamageComplete].JinQiangBuDao = function(self, player, data)
	local damage = data:toDamage()
	local victim = damage.to
	if victim and victim:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "zhoutai", false) and player:isAlive() then
			if player:getPile("buqu"):length() >= 9 or player:getPile("nosbuqu"):length() >= 9 then
				addFinishTag("JinQiangBuDao")
			end
		end
	end
end
--[[****************************************************************
	战功：纠结之心
	描述：使用刘备在1局游戏中至少发动5次雌雄双股剑特效
]]--****************************************************************
sgs.glory_info["JiuJieZhiXin"] = {
	name = "JiuJieZhiXin",
	state = "验证通过",
	mode = "all_modes",
	general = "liubei",
	events = {sgs.ChoiceMade},
	data = "JiuJieZhiXin_data",
	keys = {
		"count",
	},
}
sgs.JiuJieZhiXin_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JiuJieZhiXin = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:double_sword:yes" and isTarget(player) and isGeneral(player, "liubei", false) then
		addInfo("JiuJieZhiXin", "count", 1)
		if getInfo("JiuJieZhiXin", "count", 0) >= 5 then
			addFinishTag("JiuJieZhiXin")
		end
	end
end
--[[****************************************************************
	战功：绝境逢生
	描述：使用神赵云在一局游戏中,当体力为一滴血的时候，一直保持一体力直到游戏获胜
]]--****************************************************************
sgs.glory_info["JueJingFengSheng"] = {
	name = "JueJingFengSheng",
	state = "验证通过",
	mode = "all_modes",
	general = "shenzhaoyun",
	events = {sgs.HpChanged, sgs.NonTrigger},
	data = "JueJingFengSheng_data",
	keys = {
		"juejing",
		"not_keep",
	},
}
sgs.JueJingFengSheng_data = {}
sgs.ai_event_callback[sgs.HpChanged].JueJingFengSheng = function(self, player, data)
	if isTarget(player) then
		if getInfo("JueJingFengSheng", "juejing", 0) == 0 then
			if player:getHp() == 1 and isGeneral(player, "shenzhaoyun", true) then
				setInfo("JueJingFengSheng", "juejing", 1)
			end
		elseif getInfo("JueJingFengSheng", "not_keep", 0) == 0 then
			if isGeneral(player, "shenzhaoyun", true) then
				setInfo("JueJingFengSheng", "not_keep", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].JueJingFengSheng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() and amGeneral("shenzhaoyun", true) then
		if getInfo("JueJingFengSheng", "juejing", 0) == 1 then
			if getInfo("JueJingFengSheng", "not_keep", 0) == 0 then
				addFinishTag("JueJingFengSheng")
			end
		end
	end
end
--[[****************************************************************
	战功：军威如山
	描述：使用☆SP甘宁在一局游戏中发动军威累计得到过至少6张“闪”
]]--****************************************************************
sgs.glory_info["JunWeiRuShan"] = {
	name = "JunWeiRuShan",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_ganning",
	events = {sgs.ChoiceMade},
	data = "JunWeiRuShan_data",
	keys = {
		"count",
	},
}
sgs.JunWeiRuShan_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].JunWeiRuShan = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "playerChosen" and msg[2] == "junweigive" then
			if isTarget(player) and isGeneral(player, "bgm_ganning", true) then
				addInfo("JunWeiRuShan", "count", 1)
				if getInfo("JunWeiRuShan", "count", 0) >= 6 then
					addFinishTag("JunWeiRuShan")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：坑爹自重
	描述：使用刘禅，孙权&孙策，曹丕&曹植&曹冲坑了自己的老爹
]]--****************************************************************
sgs.glory_info["KengDieZiZhong"] = {
	name = "KengDieZiZhong",
	state = "验证通过",
	mode = "all_modes",
	general = "liushan|sunquan|sunce|caopi|caozhi|caochong",
	events = {sgs.NonTrigger},
	data = "KengDieZiZhong_data",
	keys = {},
}
sgs.KengDieZiZhong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].KengDieZiZhong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if isGeneral(player, "liushan", false) and isGeneral(victim, "liubei", false) then
			addFinishTag("KengDieZiZhong")
		elseif isGeneral(player, "sunquan|sunce", false) and isGeneral(victim, "sunjian", false) then
			addFinishTag("KengDieZiZhong")
		elseif isGeneral(player, "caopi|caozhi|caochong", false) and isGeneral(victim, "caocao", false) then
			addFinishTag("KengDieZiZhong")
		end
	end
end
--[[****************************************************************
	战功：空城绝唱
	描述：使用诸葛亮在1局游戏中有至少5个回合结束时是空城状态
]]--****************************************************************
sgs.glory_info["KongChengJueChang"] = {
	name = "KongChengJueChang",
	state = "验证通过",
	mode = "all_modes",
	general = "zhugeliang",
	events = {sgs.EventPhaseStart},
	data = "KongChengJueChang_data",
	keys = {
		"count",
	},
}
sgs.KongChengJueChang_data = {}
sgs.ai_event_callback[sgs.EventPhaseStart].KongChengJueChang = function(self, player, data)
	if player:getPhase() == sgs.Player_Finish and isTarget(player) then
		if isGeneral(player, "zhugeliang", false) and player:isKongcheng() then
			addInfo("KongChengJueChang", "count", 1)
			if getInfo("KongChengJueChang", "count", 0) >= 5 then
				addFinishTag("KongChengJueChang")
			end
		end
	end
end
--[[****************************************************************
	战功：狂奔的蜗牛
	描述：使用张角在1局游戏发动雷击杀死至少3名角色
]]--****************************************************************
sgs.glory_info["KuangBenDeWoNiu"] = {
	name = "KuangBenDeWoNiu",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangjiao",
	events = {sgs.NonTrigger},
	data = "KuangBenDeWoNiu_data",
	keys = {
		"count",
	},
}
sgs.KuangBenDeWoNiu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].KuangBenDeWoNiu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "zhangjiao", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		if string.find(death.damage.reason, "leiji") then
			addInfo("KuangBenDeWoNiu", "count", 1)
			if getInfo("KuangBenDeWoNiu", "count", 0) >= 3 then
				addFinishTag("KuangBenDeWoNiu")
			end
		end
	end
end
--[[****************************************************************
	战功：老不死的
	描述：使用孙权在1局游戏中被吴国武将用桃救活至少3次
]]--****************************************************************
sgs.glory_info["LaoBuSiDe"] = {
	name = "LaoBuSiDe",
	state = "验证通过",
	mode = "all_modes",
	general = "sunquan",
	events = {sgs.HpRecover},
	data = "LaoBuSiDe_data",
	keys = {
		"count",
	},
}
sgs.LaoBuSiDe_data = {}
sgs.ai_event_callback[sgs.HpRecover].LaoBuSiDe = function(self, player, data)
	if player:hasFlag("Global_Dying") and isTarget(player) and isGeneral(player, "sunquan", false) then
		local recover = data:toRecover()
		local source = recover.who
		if source and source:getKingdom() == "wu" then
			local peach = recover.card
			if peach and peach:isKindOf("Peach") and player:getHp() > 0 then
				addInfo("LaoBuSiDe", "count", 1)
				if getInfo("LaoBuSiDe", "count", 0) >= 3 then
					addFinishTag("LaoBuSiDe")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：老将的逆袭
	描述：使用黄忠在1局游戏中，剩余1点体力时累计发动烈弓杀死至少3名角色
]]--****************************************************************
sgs.glory_info["LaoJiangDeNiXi"] = {
	name = "LaoJiangDeNiXi",
	state = "验证通过",
	mode = "all_modes",
	general = "huangzhong",
	events = {sgs.ChoiceMade, sgs.NonTrigger, sgs.CardFinished},
	data = "LaoJiangDeNiXi_data",
	keys = {
		"liegong",
		"targets",
		"count",
	},
}
sgs.LaoJiangDeNiXi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LaoJiangDeNiXi = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "liegong") and msg[4] == "yes" then
			if isTarget(player) and player:getHp() == 1 and isGeneral(player, "huangzhong", false) then
				setInfo("LaoJiangDeNiXi", "liegong", 1)
				local targets = getInfo("LaoJiangDeNiXi", "targets", ""):split("+")
				table.insert(targets, msg[3])
				setInfo("LaoJiangDeNiXi", "targets", table.concat(targets, "+"))
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].LaoJiangDeNiXi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "huangzhong", false) then
		if getInfo("LaoJiangDeNiXi", "liegong", 0) == 1 then
			local death = self.room:getTag("gloryData"):toDeath()
			local slash = death.damage.card
			if slash and slash:isKindOf("Slash") then
				local victim = death.who
				local targets = getInfo("LaoJiangDeNiXi", "targets", ""):split("+")
				local yes = false
				for index, name in ipairs(targets) do
					if name == victim:objectName() then
						yes = true
						table.remove(targets, index)
						break
					end
				end
				if yes then
					setInfo("LaoJiangDeNiXi", "targets", table.concat(targets, "+"))
					addInfo("LaoJiangDeNiXi", "count", 1)
					if getInfo("LaoJiangDeNiXi", "count", 0) >= 3 then
						addFinishTag("LaoJiangDeNiXi")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].LaoJiangDeNiXi = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if use.card:isKindOf("Slash") then
			setInfo("LaoJiangDeNiXi", "liegong", 0)
			setInfo("LaoJiangDeNiXi", "targets", "")
		end
	end
end
--[[****************************************************************
	战功：雷公助我
	描述：使用张角在一局游戏中在未更改判定牌的情况下至少4次雷击成功
]]--****************************************************************
sgs.glory_info["LeiGongZhuWo"] = {
	name = "LeiGongZhuWo",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangjiao",
	events = {sgs.ChoiceMade, sgs.StartJudge, sgs.FinishRetrial},
	data = "LeiGongZhuWo_data",
	keys = {
		"leiji",
		"judge_card",
		"count",
	},
}
sgs.LeiGongZhuWo_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LeiGongZhuWo = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "playerChosen" and string.find(msg[2], "leiji") then
			if isTarget(player) and isGeneral(player, "zhangjiao", false) then
				setInfo("LeiGongZhuWo", "leiji", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.StartJudge].LeiGongZhuWo = function(self, player, data)
	local judge = data:toJudge()
	if string.find(judge.reason, "leiji") then
		if getInfo("LeiGongZhuWo", "leiji", 0) == 1 then
			setInfo("LeiGongZhuWo", "judge_card", judge.card:getEffectiveId())
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].LeiGongZhuWo = function(self, player, data)
	local judge = data:toJudge()
	if string.find(judge.reason, "leiji") then
		local who = judge.who
		if who and who:objectName() == player:objectName() then
			if getInfo("LeiGongZhuWo", "leiji", 0) == 1 then
				local id = getInfo("LeiGongZhuWo", "judge_card", -1)
				setInfo("LeiGongZhuWo", "leiji", 0)
				setInfo("LeiGongZhuWo", "judge_card", -1)
				if judge.card:getEffectiveId() == id and judge:isBad() then
					addInfo("LeiGongZhuWo", "count", 1)
					if getInfo("LeiGongZhuWo", "count", 0) >= 4 then
						addFinishTag("LeiGongZhuWo")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：连绵不绝
	描述：使用陆逊在1个回合内发动至少10次连营
]]--****************************************************************
sgs.glory_info["LianMianBuJue"] = {
	name = "LianMianBuJue",
	state = "验证通过",
	mode = "all_modes",
	general = "luxun",
	events = {sgs.ChoiceMade, sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "LianMianBuJue_data",
	keys = {
		"count",
	},
}
sgs.LianMianBuJue_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LianMianBuJue = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:noslianying:yes" and isTarget(player) and isGeneral(player, "luxun", false) then
		addInfo("LianMianBuJue", "count", 1)
		if getInfo("LianMianBuJue", "count", 0) >= 10 then
			addFinishTag("LianMianBuJue")
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].LianMianBuJue = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("LianyingCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "luxun", false) then
				addInfo("LianMianBuJue", "count", 1)
				if getInfo("LianMianBuJue", "count", 0) >= 10 then
					addFinishTag("LianMianBuJue")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].LianMianBuJue = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("LianMianBuJue", "count", 0)
	end
end
--[[****************************************************************
	战功：连破克敌
	描述：使用神司马懿在一局游戏中发动3次连破并最后获胜
]]--****************************************************************
sgs.glory_info["LianPoKeDi"] = {
	name = "LianPoKeDi",
	state = "验证通过",
	mode = "all_modes",
	general = "shensimayi",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "LianPoKeDi_data",
	keys = {
		"count",
	},
}
sgs.LianPoKeDi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LianPoKeDi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:lianpo:yes" and isTarget(player) and isGeneral(player, "shensimayi", true) then
		addInfo("LianPoKeDi", "count", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].LianPoKeDi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "shensimayi", true) then
		if getInfo("LianPoKeDi", "count", 0) >= 3 and amWinner() then
			addFinishTag("LianPoKeDi")
		end
	end
end
--[[****************************************************************
	战功：怜香惜玉
	描述：使用小乔在一局游戏中发动天香让某名男性武将摸牌至少15张
]]--****************************************************************
sgs.glory_info["LianXiangXiYu"] = {
	name = "LianXiangXiYu",
	state = "验证通过",
	mode = "all_modes",
	general = "xiaoqiao",
	events = {sgs.PreCardUsed, sgs.CardsMoveOneTime, sgs.DamageComplete},
	data = "LianXiangXiYu_data",
	keys = {
		"tianxiang",
		"target",
		"count",
	},
}
sgs.LianXiangXiYu_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].LianXiangXiYu = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("TianxiangCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xiaoqiao", false) then
				setInfo("LianXiangXiYu", "tianxiang", 1)
				local target = use.to:first()
				if target and target:isMale() then
					setInfo("LianXiangXiYu", "target", target:objectName())
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].LianXiangXiYu = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand and move.reason.m_skillName == "#tianxiang" then
		local target = move.to
		if target and target:objectName() == player:objectName() then
			if getInfo("LianXiangXiYu", "tianxiang", 0) == 1 then
				setInfo("LianXiangXiYu", "tianxiang", 0)
				if getInfo("LianXiangXiYu", "target", "") == player:objectName() then
					setInfo("LianXiangXiYu", "target", "")
					addInfo("LianXiangXiYu", "count", move.card_ids:length())
					if getInfo("LianXiangXiYu", "count", 0) >= 15 then
						addFinishTag("LianXiangXiYu")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.DamageComplete].LianXiangXiYu = function(self, player, data)
	local damage = data:toDamage()
	if damage.transfer and damage.transfer_reason == "tianxiang" then
		setInfo("LianXiangXiYu", "tianxiang", 0)
		setInfo("LianXiangXiYu", "target", "")
	end
end
--[[****************************************************************
	战功：炼狱武神
	描述：使用神关羽在一局游戏中使用红桃花色的杀杀死至少3名角色
]]--****************************************************************
sgs.glory_info["LianYuWuShen"] = {
	name = "LianYuWuShen",
	state = "验证通过",
	mode = "all_modes",
	general = "shenguanyu",
	events = {sgs.NonTrigger},
	data = "LianYuWuShen_data",
	keys = {
		"count",
	},
}
sgs.LianYuWuShen_data = {}
sgs.ai_event_callback[sgs.NonTrigger].LianYuWuShen = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "shenguanyu", true) then
		local death = self.room:getTag("gloryData"):toDeath()
		local slash = death.damage.card
		if slash and slash:isKindOf("Slash") and slash:getSuit() == sgs.Card_Heart then
			addInfo("LianYuWuShen", "count", 1)
			if getInfo("LianYuWuShen", "count", 0) >= 3 then
				addFinishTag("LianYuWuShen")
			end
		end
	end
end
--[[****************************************************************
	战功：粮尽援绝
	描述：使用徐晃在1局游戏中用装备区的牌发动断粮至少4次
]]--****************************************************************
sgs.glory_info["LiangJinYuanJue"] = {
	name = "LiangJinYuanJue",
	state = "验证通过",
	mode = "all_modes",
	general = "xuhuang",
	events = {sgs.CardsMoveOneTime},
	data = "LiangJinYuanJue_data",
	keys = {
		"count",
	},
}
sgs.LiangJinYuanJue_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].LiangJinYuanJue = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceDelayedTrick then
		local source = move.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xuhuang", false) and move.reason.m_skillName == "duanliang" then
				for index, place in sgs.qlist(move.from_places) do
					if place == sgs.Player_PlaceEquip then
						addInfo("LiangJinYuanJue", "count", 1)
						if getInfo("LiangJinYuanJue", "count", 0) >= 4 then
							if addFinishTag("LiangJinYuanJue") then
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
	战功：龙吟九霄
	描述：使用关平在一局游戏中发动龙吟至少4次，并在本局游戏中杀死至少3名角色
]]--****************************************************************
sgs.glory_info["LongYinJiuXiao"] = {
	name = "LongYinJiuXiao",
	state = "验证通过",
	mode = "all_modes",
	general = "guanping",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "LongYinJiuXiao_data",
	keys = {
		"longyin",
		"kill",
	},
}
sgs.LongYinJiuXiao_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LongYinJiuXiao = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --cardResponded:..:@longyin:_53_
		if msg[1] == "cardResponded" and msg[3] == "@longyin" and msg[4] ~= "_nil_" then
			if isTarget(player) and isGeneral(player, "guanping", false) then
				addInfo("LongYinJiuXiao", "longyin", 1)
				if getInfo("LongYinJiuXiao", "longyin", 0) >= 4 and getInfo("LongYinJiuXiao", "kill", 0) >= 3 then
					addFinishTag("LongYinJiuXiao")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].LongYinJiuXiao = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "guanping", false) then
		addInfo("LongYinJiuXiao", "kill", 1)
		if getInfo("LongYinJiuXiao", "longyin", 0) >= 4 and getInfo("LongYinJiuXiao", "kill", 0) >= 3 then
			addFinishTag("LongYinJiuXiao")
		end
	end
end
--[[****************************************************************
	战功：乱箭肃敌
	描述：使用袁绍在1回合内发动乱击至少6次
]]--****************************************************************
sgs.glory_info["LuanJianSuDi"] = {
	name = "LuanJianSuDi",
	state = "验证通过",
	mode = "all_modes",
	general = "yuanshao",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "LuanJianSuDi_data",
	keys = {
		"count",
	},
}
sgs.LuanJianSuDi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].LuanJianSuDi = function(self, player, data)
	local use = data:toCardUse()
	local aoe = use.card
	if aoe and aoe:isKindOf("ArcheryAttack") and aoe:getSkillName() == "luanji" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "yuanshao", false) then
				addInfo("LuanJianSuDi", "count", 1)
				if getInfo("LuanJianSuDi", "count", 0) >= 6 then
					addFinishTag("LuanJianSuDi")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].LuanJianSuDi = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("LuanJianSuDi", "count", 0)
	end
end
--[[****************************************************************
	战功：乱世的奸雄
	描述：使用曹操在1局游戏中发动奸雄得到至少3张南蛮入侵和1张万箭齐发
]]--****************************************************************
sgs.glory_info["LuanShiDeJianXiong"] = {
	name = "LuanShiDeJianXiong",
	state = "验证通过",
	mode = "all_modes",
	general = "caocao",
	events = {sgs.ChoiceMade, sgs.CardsMoveOneTime, sgs.DamageComplete},
	data = "LuanShiDeJianXiong_data",
	keys = {
		"jianxiong",
		"savage_assault",
		"archery_attack",
	},
}
sgs.LuanShiDeJianXiong_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LuanShiDeJianXiong = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "jianxiong") then
			if msg[3] == "yes" then
				setInfo("LuanShiDeJianXiong", "jianxiong", 1)
			else
				setInfo("LuanShiDeJianXiong", "jianxiong", 0)
			end
		elseif msg[1] == "skillChoice" and string.find(msg[2], "jianxiong") then
			if msg[#msg] == "cancel" then
				setInfo("LuanShiDeJianXiong", "jianxiong", 0)
			else
				setInfo("LuanShiDeJianXiong", "jianxiong", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].LuanShiDeJianXiong = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if getInfo("LuanShiDeJianXiong", "jianxiong", 0) == 1 and isGeneral(player, "caocao", false) then
				local flag = false
				for index, id in sgs.qlist(move.card_ids) do
					local aoe = sgs.Sanguosha:getCard(id)
					if aoe:isKindOf("SavageAssault") then
						addInfo("LuanShiDeJianXiong", "savage_assault", 1)
						flag = true
					elseif aoe:isKindOf("ArcheryAttack") then
						addInfo("LuanShiDeJianXiong", "archery_attack", 1)
						flag = true
					end
				end
				if flag then
					if getInfo("LuanShiDeJianXiong", "savage_assault", 0) >= 3 then
						if getInfo("LuanShiDeJianXiong", "archery_attack", 0) >= 1 then
							addFinishTag("LuanShiDeJianXiong")
						end
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.DamageComplete].LuanShiDeJianXiong = function(self, player, data)
	local damage = data:toDamage()
	local victim = damage.to
	if victim and victim:objectName() == player:objectName() and isTarget(player) then
		setInfo("LuanShiDeJianXiong", "jianxiong", 0)
	end
end
--[[****************************************************************
	战功：乱世歌姬
	描述：使用蔡文姬在一局中发动悲歌至少4次 发动断肠并最终获胜
]]--****************************************************************
sgs.glory_info["LuanShiGeJi"] = {
	name = "LuanShiGeJi",
	state = "验证通过",
	mode = "all_modes",
	general = "caiwenji|caizhaoji",
	events = {sgs.ChoiceMade, sgs.NonTrigger}, 
	data = "LuanShiGeJi_data",
	keys = {
		"beige_times",
		"duanchang",
	},
}
sgs.LuanShiGeJi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].LuanShiGeJi = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "cardResponded" and msg[3] == "@beige" and msg[#msg] ~= "_nil_" then
			if isTarget(player) and isGeneral(player, "caiwenji|caizhaoji", false) then
				addInfo("LuanShiGeJi", "beige_times", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.Death].LuanShiGeJi = function(self, player, data)
	local death = data:toDeath()
	local victim = death.who
	if victim and victim:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "caiwenji|caizhaoji", false) and player:hasSkill("duanchang") then
			local reason = death.damage
			if reason then
				local source = reason.from
				if source and source:isAlive() then
					setInfo("LuanShiGeJi", "duanchang", 1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].LuanShiGeJi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		if amWinner() and getInfo("LuanShiGeJi", "beige_times", 0) >= 4 then
			if getInfo("LuanShiGeJi", "duanchang", 0) == 1 then
				addFinishTag("LuanShiGeJi")
			end
		end
	end
end
--[[****************************************************************
	战功：乱世名医
	描述：使用华佗在1局游戏中发动急救使至少3个不同的角色脱离濒死状态
]]--****************************************************************
sgs.glory_info["LuanShiMingYi"] = {
	name = "LuanShiMingYi",
	state = "验证通过",
	mode = "all_modes",
	general = "huatuo",
	events = {sgs.HpRecover},
	data = "LuanShiMingYi_data",
	keys = {
		"targets",
	},
}
sgs.LuanShiMingYi_data = {}
sgs.ai_event_callback[sgs.HpRecover].LuanShiMingYi = function(self, player, data)
	local recover = data:toRecover()
	local peach = recover.card
	if peach and peach:isKindOf("Peach") and peach:getSkillName() == "jijiu" then
		local source = recover.who
		if source and isTarget(source) and player:hasFlag("Global_Dying") and isGeneral(source, "huatuo", false) then
			local targets = getInfo("LuanShiMingYi", "targets", "")
			targets = targets:split("|")
			local name = player:objectName()
			for _,n in ipairs(targets) do
				if n == name then
					return 
				end
			end
			table.insert(targets, name)
			setInfo("LuanShiMingYi", "targets", table.concat(targets, "|"))
			if #targets >= 3 then
				addFinishTag("LuanShiMingYi")
			end
		end
	end
end
--[[****************************************************************
	战功：洛神赋
	描述：使用甄姬一回合内发动洛神在不被改变判定牌的情况下连续判定黑色花色至少8次
]]--****************************************************************
sgs.glory_info["LuoShenFu"] = {
	name = "LuoShenFu",
	state = "验证通过",
	mode = "all_modes",
	general = "zhenji",
	events = {sgs.StartJudge, sgs.FinishRetrial, sgs.EventPhaseEnd},
	data = "LuoShenFu_data",
	keys = {
		"judge_card",
		"count",
	},
}
sgs.LuoShenFu_data = {}
sgs.ai_event_callback[sgs.StartJudge].LuoShenFu = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "luoshen" then
		local target = judge.who
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "zhenji", false) then
				setInfo("LuoShenFu", "judge_card", judge.card:getEffectiveId())
			end
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].LuoShenFu = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "luoshen" then
		local target = judge.who
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "zhenji", false) then
				local id = getInfo("LuoShenFu", "judge_card", -1)
				setInfo("LuoShenFu", "judge_card", -1)
				if id == judge.card:getEffectiveId() and judge:isGood() then
					addInfo("LuoShenFu", "count", 1)
					if getInfo("LuoShenFu", "count", 0) >= 8 then
						addFinishTag("LuoShenFu")
					end
				else
					setInfo("LuoShenFu", "count", 0)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseEnd].LuoShenFu = function(self, player, data)
	if player:getPhase() == sgs.Player_Start and isTarget(player) then
		setInfo("LuoShenFu", "judge_card", -1)
		setInfo("LuoShenFu", "count", 0)
	end
end
--[[****************************************************************
	战功：妈，我冷
	描述：使用许褚在1局游戏中发动裸衣至少2次并在裸衣的回合中杀死过至少2名角色
]]--****************************************************************
sgs.glory_info["Ma_WoLeng"] = {
	name = "Ma_WoLeng",
	state = "",
	mode = "all_modes",
	general = "xuchu",
	events = {sgs.ChoiceMade, sgs.PreCardUsed, sgs.NonTrigger, sgs.EventPhaseStart},
	data = "Ma_WoLeng_data",
	keys = {
		"luoyi",
		"luoyi_times",
		"kill_count",
	},
}
sgs.Ma_WoLeng_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].Ma_WoLeng = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "luoyi") and msg[3] == "yes" then
			if isGeneral(player, "xuchu", false) then
				if getInfo("Ma_WoLeng", "luoyi", 0) == 0 then
					setInfo("Ma_WoLeng", "luoyi", 1)
					addInfo("Ma_WoLeng", "luoyi_times", 1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].Ma_WoLeng = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("LuoyiCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xuchu", false) then
				if getInfo("Ma_WoLeng", "luoyi", 0) == 0 then
					setInfo("Ma_WoLeng", "luoyi", 1)
					addInfo("Ma_WoLeng", "luoyi_times", 1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].Ma_WoLeng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "xuchu", false) then
		if getInfo("Ma_WoLeng", "luoyi", 0) == 1 then
			addInfo("Ma_WoLeng", "kill_count", 1)
			if getInfo("Ma_WoLeng", "luoyi_times", 0) >= 2 then
				if getInfo("Ma_WoLeng", "kill_count", 0) >= 2 then
					addFinishTag("Ma_WoLeng")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].Ma_WoLeng = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("Ma_WoLeng", "luoyi", 0)
	end
end
--[[****************************************************************
	战功：猛锐盖世
	描述：使用孙策在一局游戏中发动激昂摸牌至少5张并发动技能魂姿
]]--****************************************************************
sgs.glory_info["MengRuiGaiShi"] = {
	name = "MengRuiGaiShi",
	state = "验证通过",
	mode = "all_modes",
	general = "sunce",
	events = {sgs.ChoiceMade, sgs.EventPhaseStart},
	data = "MengRuiGaiShi_data",
	keys = {
		"jiang_draw",
		"hunzi",
	},
}
sgs.MengRuiGaiShi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].MengRuiGaiShi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:jiang:yes" and isTarget(player) and isGeneral(player, "sunce", false) then
		addInfo("MengRuiGaiShi", "jiang_draw", 1)
		if getInfo("MengRuiGaiShi", "jiang_draw", 0) >= 5 then
			if getInfo("MengRuiGaiShi", "hunzi", 0) == 1 then
				addFinishTag("MengRuiGaiShi")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].MengRuiGaiShi = function(self, player, data)
	if player:getPhase() == sgs.Player_Start and isTarget(player) and isGeneral(player, "sunce", false) then
		if player:getMark("hunzi") > 0 then
			setInfo("MengRuiGaiShi", "hunzi", 1)
			if getInfo("MengRuiGaiShi", "jiang_draw", 0) >= 5 then
				if getInfo("MengRuiGaiShi", "hunzi", 0) == 1 then
					addFinishTag("MengRuiGaiShi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：妙法仁心
	描述：使用曹冲在一局游戏中对魏势力角色发动仁心至少3次
]]--****************************************************************
sgs.glory_info["MiaoFaRenXin"] = {
	name = "MiaoFaRenXin",
	state = "验证通过",
	mode = "all_modes",
	general = "caochong",
	events = {sgs.ChoiceMade, sgs.PreCardUsed},
	data = "MiaoFaRenXin_data",
	keys = {
		"count",
	},
}
sgs.MiaoFaRenXin_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].MiaoFaRenXin = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --cardResponded:.Equip:@renxin-card:sgs2:_55_
		if msg[1] == "cardResponded" and msg[3] == "@renxin-card" and msg[#msg] ~= "_nil_" then
			local name = msg[4]
			local target = nil
			local alives = self.room:getAlivePlayers()
			for _,p in sgs.qlist(alives) do
				if p:objectName() == name then
					target = p
					break
				end
			end
			if target and target:getKingdom() == "wei" then
				addInfo("MiaoFaRenXin", "count", 1)
				if getInfo("MiaoFaRenXin", "count", 0) >= 3 then
					addFinishTag("MiaoFaRenXin")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].MiaoFaRenXin = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("NosRenxinCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "caochong", false) then
				local target = use.to:first()
				if target and target:getKingdom() == "wei" then
					addInfo("MiaoFaRenXin", "count", 1)
					if getInfo("MiaoFaRenXin", "count", 0) >= 3 then
						addFinishTag("MiaoFaRenXin")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：能进能退
	描述：使用☆SP赵云在一局游戏中至少发动冲阵获得6张牌并获胜
]]--****************************************************************
sgs.glory_info["NengJinNengTui"] = {
	name = "NengJinNengTui",
	state = "",
	mode = "all_modes",
	general = "bgm_zhaoyun",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "NengJinNengTui_data",
	keys = {
		"count",
	},
}
sgs.NengJinNengTui_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].NengJinNengTui = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and msg[2] == "chongzhen" and msg[#msg] == "yes" then
			if isTarget(player) and isGeneral(player, "bgm_zhaoyun", true) then
				addInfo("NengJinNengTui", "count", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].NengJinNengTui = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("NengJinNengTui", "count", 0) >= 6 then
			addFinishTag("NengJinNengTui")
		end
	end
end
--[[****************************************************************
	战功：你死我活
	描述：使用夏侯惇在1局游戏中发动刚烈杀死至少1名角色
]]--****************************************************************
sgs.glory_info["NiSiWoHuo"] = {
	name = "NiSiWoHuo",
	state = "验证通过",
	mode = "all_modes",
	general = "xiahoudun",
	events = {sgs.NonTrigger},
	data = "NiSiWoHuo_data",
	keys = {
		"count",
	},
}
sgs.NiSiWoHuo_data = {}
sgs.ai_event_callback[sgs.NonTrigger].NiSiWoHuo = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "xiahoudun", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		if string.find(death.damage.reason, "ganglie") then
			addInfo("NiSiWoHuo", "count", 1)
			if getInfo("NiSiWoHuo", "count", 0) >= 1 then
				addFinishTag("NiSiWoHuo")
			end
		end
	end
end
--[[****************************************************************
	战功：逆天改命
	描述：使用张宝在一局游戏中发动咒缚4次，影兵2次
]]--****************************************************************
sgs.glory_info["NiTianGaiMing"] = {
	name = "NiTianGaiMing",
	state = "",
	mode = "all_modes",
	general = "zhangbao",
	events = {sgs.PreCardUsed, sgs.ChoiceMade},
	data = "NiTianGaiMing_data",
	keys = {
		"zhoufu_times",
		"yingbing_times",
	},
}
sgs.NiTianGaiMing_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].NiTianGaiMing = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("ZhoufuCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "zhangbao", true) then
				addInfo("NiTianGaiMing", "zhoufu_times", 1)
				if getInfo("NiTianGaiMing", "zhoufu_times", 0) >= 4 then
					if getInfo("NiTianGaiMing", "yingbing_times", 0) >= 2 then
						addFinishTag("NiTianGaiMing")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].NiTianGaiMing = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:yingbing:yes" and isTarget(player) and isGeneral(player, "zhangbao", true) then
		addInfo("NiTianGaiMing", "yingbing_times", 1)
		if getInfo("NiTianGaiMing", "zhoufu_times", 0) >= 4 then
			if getInfo("NiTianGaiMing", "yingbing_times", 0) >= 2 then
				addFinishTag("NiTianGaiMing")
			end
		end
	end
end
--[[****************************************************************
	战功：破虏大将军
	描述：使用孙坚连续至少3回合在1体力时发动英魂
]]--****************************************************************
sgs.glory_info["PoLuDaJiangJun"] = {
	name = "PoLuDaJiangJun",
	state = "验证通过",
	mode = "all_modes",
	general = "sunjian",
	events = {sgs.ChoiceMade},
	data = "PoLuDaJiangJun_data",
	keys = {
		"count",
	},
}
sgs.PoLuDaJiangJun_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].PoLuDaJiangJun = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "playerChosen" and msg[2] == "yinghun" then
			if isTarget(player) and isGeneral(player, "sunjian", false) then
				if player:getHp() == 1 then
					addInfo("PoLuDaJiangJun", "count", 1)
					if getInfo("PoLuDaJiangJun", "count", 0) >= 3 then
						addFinishTag("PoLuDaJiangJun")
					end
				else
					setInfo("PoLuDaJiangJun", "count", 0)
				end
			end
		end
	end
end
--[[****************************************************************
	战功：破阵斩将
	描述：使用高顺在一局游戏中发动陷阵拼点赢的情况下杀死至少两名角色并获胜
]]--****************************************************************
sgs.glory_info["PoZhenZhanJiang"] = {
	name = "PoZhenZhanJiang",
	state = "",
	mode = "all_modes",
	general = "gaoshun",
	events = {sgs.NonTrigger},
	data = "PoZhenZhanJiang_data",
	keys = {
		"kill",
	},
}
sgs.PoZhenZhanJiang_data = {}
sgs.ai_event_callback[sgs.NonTrigger].PoZhenZhanJiang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and isGeneral(player, "gaoshun", true) and player:hasFlag("XianzhenSuccess") then
			addInfo("PoZhenZhanJiang", "kill", 1)
		end
	elseif cmd == "gloryGameOverJudge" then
		if amWinner() and amGeneral(player, "gaoshun", true) and getInfo("PoZhenZhanJiang", "kill", 0) >= 2 then
			addFinishTag("PoZhenZhanJiang")
		end
	end
end
--[[****************************************************************
	战功：破竹之咒
	描述：使用陈琳在一局游戏中对曹操使用笔伐，并使用颂词使其摸两张牌
]]--****************************************************************
sgs.glory_info["PoZhuZhiZhou"] = {
	name = "PoZhuZhiZhou",
	state = "验证通过",
	mode = "all_modes",
	general = "chenlin",
	events = {sgs.PreCardUsed},
	data = "PoZhuZhiZhou_data",
	keys = {
		"bifa",
		"songci",
	},
}
sgs.PoZhuZhiZhou_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].PoZhuZhiZhou = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) and isGeneral(player, "chenlin", true) then
		local card = use.card
		if card:isKindOf("BifaCard") then
			local target = use.to:first()
			if target and isGeneral(target, "caocao", false) then
				setInfo("PoZhuZhiZhou", "bifa", 1)
				if getInfo("PoZhuZhiZhou", "bifa", 0) == 1 and getInfo("PoZhuZhiZhou", "songci", 0) == 1 then
					addFinishTag("PoZhuZhiZhou")
				end
			end
		elseif card:isKindOf("SongciCard") then
			local target = use.to:first()
			if target and isGeneral(target, "caocao", false) and target:getHandcardNum() < target:getHp() then
				setInfo("PoZhuZhiZhou", "songci", 1)
				if getInfo("PoZhuZhiZhou", "bifa", 0) == 1 and getInfo("PoZhuZhiZhou", "songci", 0) == 1 then
					addFinishTag("PoZhuZhiZhou")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：七步成诗
	描述：使用曹植在一局游戏中发动酒诗7次
]]--****************************************************************
sgs.glory_info["QiBuChengShi"] = {
	name = "QiBuChengShi",
	state = "验证通过",
	mode = "all_modes",
	general = "caozhi",
	events = {sgs.ChoiceMade, sgs.PreCardUsed},
	data = "QiBuChengShi_data",
	keys = {
		"count",
	},
}
sgs.QiBuChengShi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].QiBuChengShi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:jiushi:yes" and isTarget(player) and isGeneral(player, "caozhi", false) then
		addInfo("QiBuChengShi", "count", 1)
		if getInfo("QiBuChengShi", "count", 0) >= 7 then
			addFinishTag("QiBuChengShi")
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].QiBuChengShi = function(self, player, data)
	local use = data:toCardUse()
	local anal = use.card
	if anal and anal:isKindOf("Analeptic") and anal:getSkillName() == "jiushi" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "caozhi", false) then
				addInfo("QiBuChengShi", "count", 1)
				if getInfo("QiBuChengShi", "count", 0) >= 7 then
					addFinishTag("QiBuChengShi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：奇计百出
	描述：使用荀攸在一局游戏中，发动“奇策”使用至少六种锦囊
]]--****************************************************************
sgs.glory_info["QiJiBaiChu"] = {
	name = "QiJiBaiChu",
	state = "验证通过",
	mode = "all_modes",
	general = "xunyou",
	events = {},
	data = "QiJiBaiChu_data",
	keys = {
		"tricks",
	},
}
sgs.QiJiBaiChu_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].QiJiBaiChu = function(self, player, data)
	local use = data:toCardUse()
	local trick = use.card
	if trick and trick:isKindOf("TrickCard") and trick:getSkillName() == "qice" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xunyou", false) then
				local name = trick:objectName()
				local tricks = getInfo("QiJiBaiChu", "tricks", "")
				tricks = tricks:split("|")
				for _,n in ipairs(tricks) do
					if n == name then
						return 
					end
				end
				table.insert(tricks, name)
				setInfo("QiJiBaiChu", "tricks", table.concat(tricks, "|"))
				if #tricks >= 6 then
					addFinishTag("QiJiBaiChu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：奇谋九计
	描述：使用旧王异在一局游戏中至少成功发动九次秘计并获胜。
]]--****************************************************************
sgs.glory_info["QiMouJiuJi"] = {
	name = "QiMouJiuJi",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_wangyi",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "QiMouJiuJi_data",
	keys = {
		"count",
	},
}
sgs.QiMouJiuJi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].QiMouJiuJi = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "miji") and msg[3] == "yes" then
			if isTarget(player) and isGeneral(player, "nos_wangyi", true) then
				addInfo("QiMouJiuJi", "count", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].QiMouJiuJi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() and getInfo("QiMouJiuJi", "count", 0) >= 9 then
		addFinishTag("QiMouJiuJi")
	end
end
--[[****************************************************************
	战功：其利断金
	描述：使用颜良文丑在1局游戏中发动双雄至少3次并在双雄的回合中杀死过至少3名角色
]]--****************************************************************
sgs.glory_info["QiLiDuanJin"] = {
	name = "QiLiDuanJin",
	state = "",
	mode = "all_modes",
	general = "yanliangwenchou",
	events = {sgs.ChoiceMade, sgs.NonTrigger, sgs.EventPhaseStart},
	data = "QiLiDuanJin_data",
	keys = {
		"shuangxiong",
		"shuangxiong_times",
		"kill_count",
	},
}
sgs.QiLiDuanJin_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].QiLiDuanJin = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:shuangxiong:yes" and isTarget(player) then
		if isGeneral(player, "yanliangwenchou", true) then
			setInfo("QiLiDuanJin", "shuangxiong", 1)
			addInfo("QiLiDuanJin", "shuangxiong_times", 1)
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].QiLiDuanJin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		if getInfo("QiLiDuanJin", "shuangxiong", 0) == 1 and isGeneral(player, "yanliangwenchou", true) then
			addInfo("QiLiDuanJin", "kill_count", 1)
			if getInfo("QiLiDuanJin", "shuangxiong_times", 0) >= 3 then
				if getInfo("QiLiDuanJin", "kill_count", 0) >= 3 then
					addFinishTag("QiLiDuanJin")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].QiLiDuanJin = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("QiLiDuanJin", "shuangxiong", 0)
	end
end
--[[****************************************************************
	战功：七擒七纵
	描述：使用孟获在1局游戏中发动再起回复体力至少7点
]]--****************************************************************
sgs.glory_info["QiQinQiZong"] = {
	name = "QiQinQiZong",
	state = "验证通过",
	mode = "all_modes",
	general = "menghuo",
	events = {sgs.CardsMoveOneTime},
	data = "QiQinQiZong_data",
	keys = {
		"count",
	},
}
sgs.QiQinQiZong_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].QiQinQiZong = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_DiscardPile and isTarget(player) then
		local reason = move.reason
		if reason.m_reason == sgs.CardMoveReason_S_REASON_NATURAL_ENTER then
			if reason.m_skillName == "zaiqi" and reason.m_playerId == getTargetName() then
				local count = 0
				for index, id in sgs.qlist(move.card_ids) do
					local heart = sgs.Sanguosha:getCard(id)
					if heart:getSuit() == sgs.Card_Heart then
						count = count + 1
					end
				end
				if count > 0 then
					addInfo("QiQinQiZong", "count", count)
					if getInfo("QiQinQiZong", "count", 0) >= 7 then
						addFinishTag("QiQinQiZong")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：枪林弹雨
	描述：使用袁绍在一回合内发动8次乱击
]]--****************************************************************
sgs.glory_info["QiangLinDanYu"] = {
	name = "QiangLinDanYu",
	state = "验证通过",
	mode = "all_modes",
	general = "yuanshao",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "QiangLinDanYu_data",
	keys = {
		"count",
	},
}
sgs.QiangLinDanYu_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].QiangLinDanYu = function(self, player, data)
	local use = data:toCardUse()
	local aoe = use.card
	if aoe and aoe:isKindOf("ArcheryAttack") and aoe:getSkillName() == "luanji" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "yuanshao", false) then
				addInfo("QiangLinDanYu", "count", 1)
				if getInfo("QiangLinDanYu", "count", 0) >= 8 then
					addFinishTag("QiangLinDanYu")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].QiangLinDanYu = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("QiangLinDanYu", "count", 0)
	end
end
--[[****************************************************************
	战功：倾国倾城
	描述：使用貂蝉在1局游戏中发动离间造成至少3名角色死亡
]]--****************************************************************
sgs.glory_info["QingGuoQingCheng"] = {
	name = "QingGuoQingCheng",
	state = "",
	mode = "all_modes",
	general = "diaochan",
	events = {sgs.PreCardUsed, sgs.NonTrigger, sgs.CardFinished},
	data = "QingGuoQingCheng_data",
	keys = {
		"lijian",
		"count",
	},
}
sgs.QingGuoQingCheng_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].QingGuoQingCheng = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("LijianCard") or card:isKindOf("NosLijianCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "diaochan", false) then
				setInfo("QingGuoQingCheng", "lijian", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].QingGuoQingCheng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and getInfo("QingGuoQingCheng", "lijian", 0) == 1 then
		local death = self.room:getTag("gloryData"):toDeath()
		local duel = death.damage.card
		if duel and string.find(duel:getSkillName(), "lijian") then
			addInfo("QingGuoQingCheng", "count", 1)
			if getInfo("QingGuoQingCheng", "count", 0) >= 3 then
				addFinishTag("QingGuoQingCheng")
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].QingGuoQingCheng = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		local card = use.card
		if card:isKindOf("LijianCard") or card:isKindOf("NosLijianCard") then
			setInfo("QingGuoQingCheng", "lijian", 0)
		end
	end
end
--[[****************************************************************
	战功：驱虎吞狼
	描述：使用荀彧在1局游戏中至少发动5次驱虎并拼点成功
]]--****************************************************************
sgs.glory_info["QuHuTunLang"] = {
	name = "QuHuTunLang",
	state = "",
	mode = "all_modes",
	general = "xunyu",
	events = {sgs.Pindian},
	data = "QuHuTunLang_data",
	keys = {
		"count",
	},
}
sgs.QuHuTunLang_data = {}
sgs.ai_event_callback[sgs.Pindian].QuHuTunLang = function(self, player, data)
	local pindian = data:toPindian()
	if pindian.reason == "quhu" and pindian.success then
		local source = pindian.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xunyu", false) then
				addInfo("QuHuTunLang", "count", 1)
				if getInfo("QuHuTunLang", "count", 0) >= 5 then
					addFinishTag("QuHuTunLang")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：全军突击
	描述：使用马超在1局游戏中发动铁骑连续判定红色花色至少5次
]]--****************************************************************
sgs.glory_info["QuanJunTuJi"] = {
	name = "QuanJunTuJi",
	state = "验证通过",
	mode = "all_modes",
	general = "machao",
	events = {sgs.FinishRetrial},
	data = "QuanJunTuJi_data",
	keys = {
		"count",
	},
}
sgs.QuanJunTuJi_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].QuanJunTuJi = function(self, player, data)
	local judge = data:toJudge()
	if string.find(judge.reason, "tieji")then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) and isGeneral(player, "machao", false) then
			if judge:isGood() then
				addInfo("QuanJunTuJi", "count", 1)
				if getInfo("QuanJunTuJi", "count", 0) >= 5 then
					addFinishTag("QuanJunTuJi")
				end
			else
				setInfo("QuanJunTuJi", "count", 0)
			end
		end
	end
end
--[[****************************************************************
	战功：权倾天下
	描述：使用钟会在一局游戏中发动“排异”累计摸牌至少10张
]]--****************************************************************
sgs.glory_info["QuanQingTianXia"] = {
	name = "QuanQingTianXia",
	state = "验证通过",
	mode = "all_modes",
	general = "zhonghui|zhongshiji",
	events = {},
	data = "QuanQingTianXia_data",
	keys = {
		"count",
	},
}
sgs.QuanQingTianXia_data = {}
sgs.ai_event_callback[sgs.CardEffect].QuanQingTianXia = function(self, player, data)
	local effect = data:toCardEffect()
	if effect.card:isKindOf("PaiyiCard") then
		local source, target = effect.from, effect.to
		if target and target:objectName() == player:objectName() then
			if source and source:objectName() == player:objectName() then
				if isTarget(player) and isGeneral(player, "zhonghui|zhongshiji", false) then
					addInfo("QuanQingTianXia", "count", 2)
					if getInfo("QuanQingTianXia", "count", 0) >= 10 then
						addFinishTag("QuanQingTianXia")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：仁心布众
	描述：使用刘备或旧刘备在一局游戏中，累计仁德至少30张牌
]]--****************************************************************
sgs.glory_info["RenXinBuZhong"] = {
	name = "RenXinBuZhong",
	state = "验证通过",
	mode = "all_modes",
	general = "liubei",
	events = {sgs.PreCardUsed},
	data = "RenXinBuZhong_data",
	keys = {
		"count",
	},
}
sgs.RenXinBuZhong_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].RenXinBuZhong = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("RendeCard") or card:isKindOf("NosRendeCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "liubei", false) then
				addInfo("RenXinBuZhong", "count", card:subcardsLength())
				if getInfo("RenXinBuZhong", "count", 0) >= 30 then
					addFinishTag("RenXinBuZhong")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：肉山
	描述：使用董卓在1局游戏中使用杀杀死至少3名女性角色
]]--****************************************************************
sgs.glory_info["RouShan"] = {
	name = "RouShan",
	state = "",
	mode = "all_modes",
	general = "dongzhuo",
	events = {sgs.NonTrigger},
	data = "RouShan_data",
	keys = {
		"count",
	},
}
sgs.RouShan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].RouShan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "dongzhuo", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:isFemale() then
			local slash = death.damage.card
			if slash and slash:isKindOf("Slash") then
				addInfo("RouShan", "count", 1)
				if getInfo("RouShan", "count", 0) >= 3 then
					addFinishTag("RouShan")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：三分归晋
	描述：使用神司马懿杀死刘备，孙权，曹操各累计10次
]]--****************************************************************
sgs.glory_info["SanFenGuiJin"] = {
	name = "SanFenGuiJin",
	state = "",
	mode = "all_modes",
	general = "shensimayi",
	events = {sgs.NonTrigger},
	data = "SanFenGuiJin_data",
	keys = {
		"Global_liubei",
		"Global_sunquan",
		"Global_caocao",
	},
}
sgs.SanFenGuiJin_data = {}
sgs.ai_event_callback[sgs.NonTrigger].SanFenGuiJin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "shensimayi", true) then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if isGeneral(victim, "liubei", false) then
			addInfo("SanFenGuiJin", "Global_liubei", 1)
		elseif isGeneral(victim, "sunquan", false) then
			addInfo("SanFenGuiJin", "Global_sunquan", 1)
		elseif isGeneral(victim, "caocao", false) then
			addInfo("SanFenGuiJin", "Global_caocao", 1)
		else
			return 
		end
		if getInfo("SanFenGuiJin", "Global_liubei", 0) >= 10 then
			if getInfo("SanFenGuiJin", "Global_sunquan", 0) >= 10 then
				if getInfo("SanFenGuiJin", "Global_caocao", 0) >= 10 then
					setInfo("SanFenGuiJin", "Global_liubei", 0)
					setInfo("SanFenGuiJin", "Global_sunquan", 0)
					setInfo("SanFenGuiJin", "Global_caocao", 0)
					addFinishTag("SanFenGuiJin")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：三思而行
	描述：使用孙权在一局游戏中利用制衡获得至少4张无中生有以及4张桃
]]--****************************************************************
sgs.glory_info["SanSiErXing"] = {
	name = "SanSiErXing",
	state = "验证通过",
	mode = "all_modes",
	general = "sunquan",
	events = {sgs.CardsMoveOneTime},
	data = "SanSiErXing_data",
	keys = {
		"ex_nihilo_count",
		"peach_count",
	},
}
sgs.SanSiErXing_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].SanSiErXing = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand and move.reason.m_skillName == "zhiheng" then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "sunquan", false) then
				local ex_nihilo, peach = 0, 0
				for index, id in sgs.qlist(move.card_ids) do
					local card = sgs.Sanguosha:getCard(id)
					if card:isKindOf("ExNihilo") then
						ex_nihilo = ex_nihilo + 1
					elseif card:isKindOf("Peach") then
						peach = peach + 1
					end
				end
				if ex_nihilo > 0 or peach > 0 then
					addInfo("SanSiErXing", "ex_nihilo_count", ex_nihilo)
					addInfo("SanSiErXing", "peach_count", peach)
					if getInfo("SanSiErXing", "ex_nihilo_count", 0) >= 4 then
						if getInfo("SanSiErXing", "peach_count", 0) >= 4 then
							addFinishTag("SanSiErXing")
						end
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：上将杀手
	描述：使用潘璋＆马忠在一局游戏中杀死关羽和黄忠并获胜
]]--****************************************************************
sgs.glory_info["ShangJiangShaShou"] = {
	name = "ShangJiangShaShou",
	state = "",
	mode = "all_modes",
	general = "panzhangmazhong",
	events = {sgs.NonTrigger},
	data = "ShangJiangShaShou_data",
	keys = {
		"kill_guanyu",
		"kill_huangzhong",
	},
}
sgs.ShangJiangShaShou_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ShangJiangShaShou = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and isGeneral(player, "panzhangmazhong", true) then
			local death = self.room:getTag("gloryData"):toDeath()
			local victim = death.who
			if isGeneral(victim, "guanyu", false) then
				setInfo("ShangJiangShaShou", "kill_guanyu", 1)
			elseif isGeneral(victim, "huangzhong", false) then
				setInfo("ShangJiangShaShou", "kill_huangzhong", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amGeneral("panzhangmazhong", true) and amWinner() then
		if getInfo("ShangJiangShaShou", "kill_guanyu", 0) == 1 then
			if getInfo("ShangJiangShaShou", "kill_huangzhong", 0) == 1 then
				addFinishTag("ShangJiangShaShou")
			end
		end
	end
end
--[[****************************************************************
	战功：舌灿莲花
	描述：使用简雍在一局游戏中，发动巧说拼点赢后，为桃、顺手牵羊和决斗各额外选择一名目标
]]--****************************************************************
sgs.glory_info["SheCanLianHua"] = {
	name = "SheCanLianHua",
	state = "验证通过",
	mode = "all_modes",
	general = "jianyong",
	events = {sgs.ChoiceMade, sgs.PreCardUsed},
	data = "SheCanLianHua_data",
	keys = {
		"qiaoshui",
		"peach",
		"snatch",
		"duel",
	},
}
sgs.SheCanLianHua_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].SheCanLianHua = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillChoice" and msg[2] == "qiaoshui" and isTarget(player) then
			if msg[3] == "add" and isGeneral(player, "jianyong", false) then
				setInfo("SheCanLianHua", "qiaoshui", 1)
			else
				setInfo("SheCanLianHua", "qiaoshui", 0)
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].SheCanLianHua = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "jianyong", false) and getInfo("SheCanLianHua", "qiaoshui", 0) == 1 then
			setInfo("SheCanLianHua", "qiaoshui", 0)
			if use.to:length() > 1 then
				local card = use.card
				if card:isKindOf("Peach") then
					setInfo("SheCanLianHua", "peach", 1)
				elseif card:isKindOf("Snatch") then
					setInfo("SheCanLianHua", "snatch", 1)
				elseif card:isKindOf("Duel") then
					setInfo("SheCanLianHua", "duel", 1)
				else
					return 
				end
				if getInfo("SheCanLianHua", "peach", 0) == 1 and getInfo("SheCanLianHua", "snatch", 0) == 1 then
					if getInfo("SheCanLianHua", "duel", 0) == 1 then
						addFinishTag("SheCanLianHua")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：身曹心汉
	描述：使用新徐庶在一局游戏中对蜀势力角色发动举荐至少3次
]]--****************************************************************
sgs.glory_info["ShenCaoXinHan"] = {
	name = "ShenCaoXinHan",
	state = "验证通过",
	mode = "all_modes",
	general = "xushu",
	events = {sgs.PreCardUsed},
	data = "ShenCaoXinHan_data",
	keys = {
		"count",
	},
}
sgs.ShenCaoXinHan_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShenCaoXinHan = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("JujianCard") or card:isKindOf("NosJujianCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xushu", true) then
				local target = use.to:first()
				if target:getKingdom() == "shu" then
					addInfo("ShenCaoXinHan", "count", 1)
					if getInfo("ShenCaoXinHan", "count", 0) >= 3 then
						addFinishTag("ShenCaoXinHan")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：身体要紧
	描述：在主公是刘备的情况下，使用SP孙尚香做内奸取得胜利
]]--****************************************************************
sgs.glory_info["ShenTiYaoJin"] = {
	name = "ShenTiYaoJin",
	state = "验证通过",
	mode = "roles",
	general = "sp_sunshangxiang",
	events = {sgs.NonTrigger},
	data = "ShenTiYaoJin_data",
	keys = {},
}
sgs.ShenTiYaoJin_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ShenTiYaoJin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("sp_sunshangxiang") and amRenegade() then
		local lord = self.room:getLord()
		if lord and isGeneral(lord, "liubei", false) and amWinner() then
			addFinishTag("ShenTiYaoJin")
		end
	end
end
--[[****************************************************************
	战功：深思熟虑
	描述：使用孙权在一个回合内发动制衡的牌不少于10张
]]--****************************************************************
sgs.glory_info["ShenSiShuLv"] = {
	name = "ShenSiShuLv",
	state = "验证通过",
	mode = "all_modes",
	general = "sunquan",
	events = {sgs.PreCardUsed},
	data = "ShenSiShuLv_data",
	keys = {},
}
sgs.ShenSiShuLv_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShenSiShuLv = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("ZhihengCard") and card:subcardsLength() >= 10 then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "sunquan", false) then
				addFinishTag("ShenSiShuLv")
			end
		end
	end
end
--[[****************************************************************
	战功：神出鬼没
	描述：使用甘宁在1个回合内发动至少6次奇袭
]]--****************************************************************
sgs.glory_info["ShenChuGuiMo"] = {
	name = "ShenChuGuiMo",
	state = "验证通过",
	mode = "all_modes",
	general = "ganning",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "ShenChuGuiMo_data",
	keys = {
		"count",
	},
}
sgs.ShenChuGuiMo_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShenChuGuiMo = function(self, player, data)
	local use = data:toCardUse()
	local dismantlement = use.card
	if dismantlement:isKindOf("Dismantlement") and dismantlement:getSkillName() == "qixi" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "ganning", false) then
				addInfo("ShenChuGuiMo", "count", 1)
				if getInfo("ShenChuGuiMo", "count", 0) >= 6 then
					addFinishTag("ShenChuGuiMo")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].ShenChuGuiMo = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("ShenChuGuiMo", "count", 0)
	end
end
--[[****************************************************************
	战功：神鬼莫测
	描述：使用于吉在1局游戏中累计蛊惑假牌至少成功3次
]]--****************************************************************
sgs.glory_info["ShenGuiMoCe"] = {
	name = "ShenGuiMoCe",
	state = "验证通过",
	mode = "all_modes",
	general = "yuji",
	events = {sgs.PreCardUsed},
	data = "ShenGuiMoCe_data",
	keys = {
		"count",
	},
}
sgs.ShenGuiMoCe_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShenGuiMoCe = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if string.find(card:getSkillName(), "guhuo") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "yuji", false) then
				local id = card:getEffectiveId()
				if id ~= -1 then
					local realcard = sgs.Sanguosha:getEngineCard(id)
					if card:objectName() ~= realcard:objectName() then
						addInfo("ShenGuiMoCe", "count", 1)
						if getInfo("ShenGuiMoCe", "count", 0) >= 3 then
							addFinishTag("ShenGuiMoCe")
						end
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：神鬼无双
	描述：使用神吕布在一局游戏中发动神愤至少2次
]]--****************************************************************
sgs.glory_info["ShenGuiWuShuang"] = {
	name = "ShenGuiWuShuang",
	state = "验证通过",
	mode = "all_modes",
	general = "shenlvbu",
	events = {sgs.PreCardUsed},
	data = "ShenGuiWuShuang_data",
	keys = {
		"count",
	},
}
sgs.ShenGuiWuShuang_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShenGuiWuShuang = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("ShenfenCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "shenlvbu", false) then
				addInfo("ShenGuiWuShuang", "count", 1)
				if getInfo("ShenGuiWuShuang", "count", 0) >= 2 then
					addFinishTag("ShenGuiWuShuang")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：神威之势
	描述：使用神赵云发动各花色龙魂各两次并在存活的情况下取得游戏胜利
]]--****************************************************************
sgs.glory_info["ShenWeiZhiShi"] = {
	name = "ShenWeiZhiShi",
	state = "验证通过",
	mode = "all_modes",
	general = "shenzhaoyun|gaodayihao",
	events = {sgs.PreCardUsed, sgs.CardResponded, sgs.NonTrigger},
	data = "ShenWeiZhiShi_data",
	keys = {
		"spade",
		"heart",
		"club",
		"diamond",
	},
}
sgs.ShenWeiZhiShi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShenWeiZhiShi = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if string.find(card:getSkillName(), "longhun") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "shenzhaoyun|gaodayihao", true) then
				addInfo("ShenWeiZhiShi", card:getSuitString(), 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardResponded].ShenWeiZhiShi = function(self, player, data)
	local response = data:toCardResponse()
	local card = response.m_card
	if string.find(card:getSkillName(), "longhun") and isTarget(player) then
		if isGeneral(player, "shenzhaoyun|gaodayihao", true) then
			addInfo("ShenWeiZhiShi", card:getSuitString(), 1)
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].ShenWeiZhiShi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amAlive() and amGeneral("shenzhaoyun|gaodayihao", true) and amWinner() then
		if getInfo("ShenWeiZhiShi", "spade", 0) >= 2 and getInfo("ShenWeiZhiShi", "heart", 0) >= 2 then
			if getInfo("ShenWeiZhiShi", "club", 0) >= 2 and getInfo("ShenWeiZhiShi", "diamond", 0) >= 2 then
				addFinishTag("ShenWeiZhiShi")
			end
		end
	end
end
--[[****************************************************************
	战功：神仙难救
	描述：使用贾诩在你的回合中有至少3个角色阵亡
]]--****************************************************************
sgs.glory_info["ShenXianNanJiu"] = {
	name = "ShenXianNanJiu",
	state = "",
	mode = "all_modes",
	general = "jiaxu",
	events = {sgs.NonTrigger},
	data = "ShenXianNanJiu_data",
	keys = {
		"count",
	},
}
sgs.ShenXianNanJiu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ShenXianNanJiu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" then
		local current = self.room:getCurrent()
		if current and isTarget(current) and isGeneral(current, "jiaxu", false) then
			addInfo("ShenXianNanJiu", "count", 1)
			if getInfo("ShenXianNanJiu", "count", 0) >= 3 then
				addFinishTag("ShenXianNanJiu")
			end
		end
	end
end
--[[****************************************************************
	战功：生不逢时
	描述：使用双雄对关羽使用决斗，并因这个决斗被关羽杀死
]]--****************************************************************
sgs.glory_info["ShengBuFengShi"] = {
	name = "ShengBuFengShi",
	state = "验证通过",
	mode = "all_modes",
	general = "yanliangwenchou",
	events = {sgs.PreCardUsed, sgs.NonTrigger, sgs.CardFinished},
	data = "ShengBuFengShi_data",
	keys = {
		"duel",
		"duel_card",
	},
}
sgs.ShengBuFengShi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShengBuFengShi = function(self, player, data)
	local use = data:toCardUse()
	local duel = use.card
	if duel:isKindOf("Duel") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "yanliangwenchou", true) then
				for _,target in sgs.qlist(use.to) do
					if isGeneral(target, "guanyu", false) then
						setInfo("ShengBuFengShi", "duel", 1)
						setInfo("ShengBuFengShi", "duel_card", duel:getEffectiveId())
						return 
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].ShengBuFengShi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isGeneral(player, "guanyu", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		local who = death.who
		if who and isTarget(who) and isGeneral(who, "yanliangwenchou", true) then
			local duel = death.damage.card
			if duel and duel:isKindOf("Duel") then
				if getInfo("ShengBuFengShi", "duel", 0) == 1 then
					if getInfo("ShengBuFengShi", "duel_card", -1) == duel:getEffectiveId() then
						setInfo("ShengBuFengShi", "duel_card", -1)
						setInfo("ShengBuFengShi", "duel", 0)
						addFinishTag("ShengBuFengShi")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].ShengBuFengShi = function(self, player, data)
	local use = data:toCardUse()
	local duel = use.card
	if duel:isKindOf("Duel") and getInfo("ShengBuFengShi", "duel", 0) == 1 then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			setInfo("ShengBuFengShi", "duel", 0)
			setInfo("ShengBuFengShi", "duel_card", -1)
		end
	end
end
--[[****************************************************************
	战功：十倍奉还
	描述：使用法正在一局游戏中发动眩惑获得其他角色至少3张桃
]]--****************************************************************
sgs.glory_info["ShiBeiFengHuan"] = {
	name = "ShiBeiFengHuan",
	state = "验证通过",
	mode = "all_modes",
	general = "fazheng",
	events = {sgs.ChoiceMade},
	data = "ShiBeiFengHuan_data",
	keys = {
		"count",
	},
}
sgs.ShiBeiFengHuan_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ShiBeiFengHuan = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "cardChosen" and string.find(msg[2], "xuanhuo") then
			if isTarget(player) and isGeneral(player, "fazheng", false) then
				local id = tonumber(msg[3])
				local peach = sgs.Sanguosha:getCard(id)
				if peach and peach:isKindOf("Peach") then
					addInfo("ShiBeiFengHuan", "count", 1)
					if getInfo("ShiBeiFengHuan", "count", 0) >= 3 then
						addFinishTag("ShiBeiFengHuan")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：石城侯使
	描述：用韩当在一局游戏中发动技能弓骑弃置他人共计3张牌
]]--****************************************************************
sgs.glory_info["ShiChengHouShi"] = {
	name = "ShiChengHouShi",
	state = "验证通过",
	mode = "all_modes",
	general = "handang",
	events = {sgs.ChoiceMade},
	data = "ShiChengHouShi_data",
	keys = {
		"count",
	},
}
sgs.ShiChengHouShi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ShiChengHouShi = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "playerChosen" and msg[2] == "gongqi" and isTarget(player) and isGeneral(player, "handang", false) then
			addInfo("ShiChengHouShi", "count", 1)
			if getInfo("ShiChengHouShi", "count", 0) >= 3 then
				addFinishTag("ShiChengHouShi")
			end
		end
	end
end
--[[****************************************************************
	战功：失礼了
	描述：使用☆SP貂蝉在一局游戏中至少发动3次离魂并获胜
]]--****************************************************************
sgs.glory_info["ShiLiLe"] = {
	name = "ShiLiLe",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_diaochan",
	events = {sgs.PreCardUsed, sgs.NonTrigger},
	data = "ShiLiLe_data",
	keys = {
		"count",
	},
}
sgs.ShiLiLe_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShiLiLe = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("LihunCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "bgm_diaochan", true) then
				addInfo("ShiLiLe", "count", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].ShiLiLe = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("bgm_diaochan", true) and amWinner() then
		if getInfo("ShiLiLe", "count", 0) >= 3 then
			addFinishTag("ShiLiLe")
		end
	end
end
--[[****************************************************************
	战功：嗜血成性
	描述：使用魏延在1回合内发动狂骨回复至少3点体力
]]--****************************************************************
sgs.glory_info["ShiXieChengXing"] = {
	name = "ShiXieChengXing",
	state = "验证通过",
	mode = "all_modes",
	general = "weiyan",
	events = {sgs.DamageDone, sgs.EventPhaseStart},
	data = "ShiXieChengXing_data",
	keys = {
		"point",
	},
}
sgs.ShiXieChengXing_data = {}
sgs.ai_event_callback[sgs.DamageDone].ShiXieChengXing = function(self, player, data)
	local damage = data:toDamage()
	local victim = damage.to
	if victim and victim:objectName() == player:objectName() then
		local source = damage.from
		if source and isTarget(source) and isGeneral(source, "weiyan", false) then
			if source:getTag("InvokeKuanggu"):toBool() then
				local point = math.min(damage.damage, source:getLostHp())
				if point > 0 then
					addInfo("ShiXieChengXing", "point", point)
					if getInfo("ShiXieChengXing", "point", 0) >= 3 then
						addFinishTag("ShiXieChengXing")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].ShiXieChengXing = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("ShiXieChengXing", "point", 0)
	end
end
--[[****************************************************************
	战功：恃勇轻敌
	描述：使用华雄在一局游戏中，在没有马岱在场的情况下由于体力上限减至0而死亡
]]--****************************************************************
sgs.glory_info["ShiYongQingDi"] = {
	name = "ShiYongQingDi",
	state = "验证通过",
	mode = "all_modes",
	general = "huaxiong",
	events = {sgs.NonTrigger},
	data = "ShiYongQingDi_data",
	keys = {},
}
sgs.ShiYongQingDi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ShiYongQingDi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) and isGeneral(player, "huaxiong", false) then
		if player:getMaxHp() == 0 and player:isDead() then
			local allplayers = self.room:getPlayers()
			for _,p in sgs.qlist(allplayers) do
				if isGeneral(p, "madai", false) then
					return 
				end
			end
			addFinishTag("ShiYongQingDi")
		end
	end
end
--[[****************************************************************
	战功：手眼通天
	描述：使用司马懿在1局游戏中有至少2次发动反馈都抽到对方1张桃
]]--****************************************************************
sgs.glory_info["ShouYanTongTian"] = {
	name = "ShouYanTongTian",
	state = "验证通过",
	mode = "all_modes",
	general = "simayi|jinxuandi",
	events = {sgs.ChoiceMade},
	data = "ShouYanTongTian_data",
	keys = {
		"count",
	},
}
sgs.ShouYanTongTian_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ShouYanTongTian = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then --cardChosen:fankui:94:sgs1:sgs1
		if msg[1] == "cardChosen" and string.find(msg[2], "fankui") then
			if isTarget(player) and isGeneral(player, "simayi|jinxuandi", false) then
				local id = tonumber(msg[3])
				local peach = sgs.Sanguosha:getCard(id)
				if peach and peach:isKindOf("Peach") then
					addInfo("ShouYanTongTian", "count", 1)
					if getInfo("ShouYanTongTian", "count", 0) >= 2 then
						addFinishTag("ShouYanTongTian")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：蜀之终结者
	描述：使用邓艾在一回合内发动急袭至少4次
]]--****************************************************************
sgs.glory_info["ShuZhiZhongJieZhe"] = {
	name = "ShuZhiZhongJieZhe",
	state = "验证通过",
	mode = "all_modes",
	general = "dengai|dengshizai",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "ShuZhiZhongJieZhe_data",
	keys = {
		"count",
	}
}
sgs.ShuZhiZhongJieZhe_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ShuZhiZhongJieZhe = function(self, player, data)
	local use = data:toCardUse()
	local snatch = use.card
	if snatch:isKindOf("Snatch") and snatch:getSkillName() == "jixi" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "dengai|dengshizai", false) then
				addInfo("ShuZhiZhongJieZhe", "count", 1)
				if getInfo("ShuZhiZhongJieZhe", "count", 0) >= 4 then
					addFinishTag("ShuZhiZhongJieZhe")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].ShuZhiZhongJieZhe = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("ShuZhiZhongJieZhe", "count", 0)
	end
end
--[[****************************************************************
	战功：四海归心
	描述：使用神曹操在一局游戏中受到2点伤害之后发动2次归心
]]--****************************************************************
sgs.glory_info["SiHaiGuiXin"] = {
	name = "SiHaiGuiXin",
	state = "验证通过",
	mode = "all_modes",
	general = "shencaocao",
	events = {sgs.DamageDone, sgs.ChoiceMade, sgs.DamageComplete},
	data = "SiHaiGuiXin_data",
	keys = {
		"guixin",
		"count",
	},
}
sgs.SiHaiGuiXin_data = {}
sgs.ai_event_callback[sgs.DamageDone].SiHaiGuiXin = function(self, player, data)
	local damage = data:toDamage()
	if damage.damage >= 2 then
		local victim = damage.to
		if victim and victim:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(victim, "shencaocao", true) then
				setInfo("SiHaiGuiXin", "guixin", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].SiHaiGuiXin = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:guixin:yes" and isTarget(player) and isGeneral(player, "shencaocao", true) then
		if getInfo("SiHaiGuiXin", "guixin", 0) == 1 then
			addInfo("SiHaiGuiXin", "count", 1)
			if getInfo("SiHaiGuiXin", "count", 0) >= 2 then
				addFinishTag("SiHaiGuiXin")
			end
		end
	end
end
sgs.ai_event_callback[sgs.DamageComplete].SiHaiGuiXin = function(self, player, data)
	local damage = data:toDamage()
	local victim = damage.to
	if victim and victim:objectName() == player:objectName() and isTarget(player) then
		setInfo("SiHaiGuiXin", "guixin", 0)
		setInfo("SiHaiGuiXin", "count", 0)
	end
end
--[[****************************************************************
	战功：四世三公
	描述：使用袁术在1回合内消灭场上4个势力中的3个
]]--****************************************************************
sgs.glory_info["SiShiSanGong"] = {
	name = "SiShiSanGong",
	state = "验证通过",
	mode = "all_modes",
	general = "yuanshu",
	events = {sgs.NonTrigger, sgs.EventPhaseChanging},
	data = "SiShiSanGong_data",
	keys = {
		"kingdoms",
	},
}
sgs.SiShiSanGong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].SiShiSanGong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local kingdom = death.who:getKingdom()
		local kingdoms = getInfo("SiShiSanGong", "kingdoms", "")
		kingdoms = kingdoms:split("|")
		for _,k in ipairs(kingdoms) do
			if k == kingdom then
				return 
			end
		end
		table.insert(kingdoms, kingdom)
		setInfo("SiShiSanGong", "kingdoms", table.concat(kingdoms, "|"))
		if #kingdoms >= 3 then
			addFinishTag("SiShiSanGong")
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].SiShiSanGong = function(self, player, data)
	local change = data:toPhaseChange()
	if change.to == sgs.Player_NotActive or change.from == sgs.Player_NotActive then
		if isTarget(player) then
			setInfo("SiShiSanGong", "kingdoms", "")
		end
	end
end
--[[****************************************************************
	战功：伺机待发
	描述：使用吕蒙将手牌囤积到20张
]]--****************************************************************
sgs.glory_info["SiJiDaiFa"] = {
	name = "SiJiDaiFa",
	state = "验证通过",
	mode = "all_modes",
	general = "lvmeng",
	events = {sgs.CardsMoveOneTime},
	data = "SiJiDaiFa_data",
	keys = {},
}
sgs.SiJiDaiFa_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].SiJiDaiFa = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "lvmeng", false) and player:getHandcardNum() >= 20 then
				addFinishTag("SiJiDaiFa")
			end
		end
	end
end
--[[****************************************************************
	战功：岁月静好
	描述：使用☆SP大乔在一局游戏中发动安娴五次并获胜
]]--****************************************************************
sgs.glory_info["SuiYueJingHao"] = {
	name = "SuiYueJingHao",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_daqiao",
	events = {sgs.ChoiceMade, sgs.NonTrigger},
	data = "SuiYueJingHao_data",
	keys = {
		"anxian_times",
	},
}
sgs.SuiYueJingHao_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].SuiYueJingHao = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:anxian:yes" and isTarget(player) and isGeneral(player, "bgm_daqiao", true) then
		addInfo("SuiYueJingHao", "anxian_times", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].SuiYueJingHao = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("bgm_daqiao", true) and amWinner() then
		if getInfo("SuiYueJingHao", "anxian_times", 0) >= 5 then
			addFinishTag("SuiYueJingHao")
		end
	end
end
--[[****************************************************************
	战功：桃园之梦
	描述：使用神关羽在一局游戏中阵亡后发动武魂判定结果为桃园结义
]]--****************************************************************
sgs.glory_info["TaoYuanZhiMeng"] = {
	name = "TaoYuanZhiMeng",
	state = "验证通过",
	mode = "all_modes",
	general = "shenguanyu",
	events = {sgs.NonTrigger, sgs.FinishRetrial, sgs.Death},
	data = "TaoYuanZhiMeng_data",
	keys = {
		"wuhun",
	},
}
sgs.TaoYuanZhiMeng_data = {}
sgs.ai_event_callback[sgs.NonTrigger].TaoYuanZhiMeng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) and isGeneral(player, "shenguanyu") then
		if player:hasSkill("wuhun") then
			setInfo("TaoYuanZhiMeng", "wuhun", 1)
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].TaoYuanZhiMeng = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "wuhun" and judge.card:isKindOf("GodSalvation") then
		if getInfo("TaoYuanZhiMeng", "wuhun", 0) == 1 then
			addFinishTag("TaoYuanZhiMeng")
		end
	end
end
sgs.ai_event_callback[sgs.Death].TaoYuanZhiMeng = function(self, player, data)
	local death = data:toDeath()
	local who = death.who
	if who and who:objectName() == player:objectName() and isTarget(player) then
		setInfo("TaoYuanZhiMeng", "wuhun", 0)
	end
end
--[[****************************************************************
	战功：桃园之义
	描述：在一局游戏中，场上同时存在刘备、关羽、张飞三人且为队友，而你是其中一个并最后获胜
]]--****************************************************************
sgs.glory_info["TaoYuanZhiYi"] = {
	name = "TaoYuanZhiYi",
	state = "验证通过",
	mode = "all_modes",
	general = "liubei|guanyu|zhangfei",
	events = {sgs.NonTrigger},
	data = "TaoYuanZhiYi_data",
	keys = {},
}
sgs.TaoYuanZhiYi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].TaoYuanZhiYi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() then
		local me = getTarget()
		local allplayers = self.room:getPlayers()
		local liubei, guanyu, zhangfei = nil, nil, nil
		for _,p in sgs.qlist(allplayers) do
			if isSameCamp(me, p) then
				if isGeneral(p, "liubei", false) then
					liubei = p
				end
				if isGeneral(p, "guanyu", false) then
					guanyu = p
				end
				if isGeneral(p, "zhangfei", false) then
					zhangfei = p
				end
			end
		end
		if amGeneral("liubei", false) and guanyu and zhangfei then
			addFinishTag("TaoYuanZhiYi")
		elseif amGeneral("guanyu", false) and liubei and zhangfei then
			addFinishTag("TaoYuanZhiYi")
		elseif amGeneral("zhangfei", false) and liubei and guanyu then
			addFinishTag("TaoYuanZhiYi")
		end
	end
end
--[[****************************************************************
	战功：天火燎原
	描述：使用卧龙诸葛亮在1回合内发动火计造成至少6点伤害
]]--****************************************************************
sgs.glory_info["TianHuoLiaoYuan"] = {
	name = "TianHuoLiaoYuan",
	state = "",
	mode = "all_modes",
	general = "wolong",
	events = {sgs.NonTrigger},
	data = "TianHuoLiaoYuan_data",
	keys = {
		"count",
	},
}
sgs.TianHuoLiaoYuan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].TianHuoLiaoYuan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) and isGeneral(player, "wolong", true) then
		local damage = self.room:getTag("gloryData"):toDamage()
		local trick = damage.card
		if trick and trick:isKindOf("FireAttack") and trick:getSkillName() == "huoji" then
			addInfo("TianHuoLiaoYuan", "count", damage.damage)
			if getInfo("TianHuoLiaoYuan", "count", 0) >= 6 then
				addFinishTag("TianHuoLiaoYuan")
			end
		end
	end
end
--[[****************************************************************
	战功：天命难违
	描述：使用司马懿被自己挂的闪电劈死，不包括改判
]]--****************************************************************
sgs.glory_info["TianMingNanWei"] = {
	name = "TianMingNanWei",
	state = "",
	mode = "all_modes",
	general = "simayi|jinxuandi",
	events = {sgs.CardFinished, sgs.StartJudge, sgs.FinishRetrial, sgs.NonTrigger, sgs.CardsMoveOneTime},
	data = "TianMingNanWei_data",
	keys = {
		"lightning",
		"lightning_card",
		"judge_card",
		"damage",
	},
}
sgs.TianMingNanWei_data = {}
sgs.ai_event_callback[sgs.CardFinished].TianMingNanWei = function(self, player, data)
	local use = data:toCardUse()
	local trick = use.card
	if trick:isKindOf("Lightning") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "simayi|jinxuandi", false) then
				setInfo("TianMingNanWei", "lightning", 1)
				setInfo("TianMingNanWei", "lightning_card", trick:getEffectiveId())
			end
		end
	end
end
sgs.ai_event_callback[sgs.StartJudge].TianMingNanWei = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "lightning" and isTarget(player) and isGeneral(player, "simayi|jinxuandi", false) then
		local who = judge.who
		if who and who:objectName() == player:objectName() then
			if getInfo("TianMingNanWei", "lightning", 0) == 1 then
				setInfo("TianMingNanWei", "judge_card", judge.card:getEffectiveId())
			end
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].TianMingNanWei = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "lightning" and isTarget(player) and isGeneral(player, "simayi|jinxuandi", false) then
		local who = judge.who
		if who and who:objectName() == player:objectName() then
			if getInfo("TianMingNanWei", "lightning", 0) == 1 then
				if getInfo("TianMingNanWei", "judge_card", -1) == judge.card:getEffectiveId() then
					if judge:isBad() then
						setInfo("TianMingNanWei", "damage", 1)
					end
				else
					setInfo("TianMingNanWei", "lightning", 0)
					setInfo("TianMingNanWei", "lightning_card", -1)
					setInfo("TianMingNanWei", "judge_card", -1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].TianMingNanWei = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) and isGeneral(player, "simayi|jinxuandi", false) then
		if getInfo("TianMingNanWei", "lightning", 0) == 1 then
			setInfo("TianMingNanWei", "lightning", 0)
			if getInfo("TianMingNanWei", "damage", 0) == 1 then
				setInfo("TianMingNanWei", "damage", 0)
				local death = self.room:getTag("gloryData"):toDeath()
				local reason = death.damage
				if reason then
					local trick = reason.card
					if trick and trick:getEffectiveId() == getInfo("TianMingNanWei", "lightning_card", -1) then
						addFinishTag("TianMingNanWei")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].TianMingNanWei = function(self, player, data)
	local move = data:toMoveOneTime()
	local source = move.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if getInfo("TianMingNanWei", "lightning", 0) == 1 then
			local lightning = getInfo("TianMingNanWei", "lightning_card", -1)
			for index, id in sgs.qlist(move.card_ids) do
				if move.from_places:at(index) == sgs.Player_PlaceDelayedTrick then
					if id == lightning then
						setInfo("TianMingNanWei", "lightning", 0)
						setInfo("TianMingNanWei", "lightning_card", -1)
						return 
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：天命之罚
	描述：在一局游戏中，使用司马懿更改闪电判定牌至少劈中其他角色两次
]]--****************************************************************
sgs.glory_info["TianMingZhiFa"] = {
	name = "TianMingZhiFa",
	state = "验证通过",
	mode = "all_modes",
	general = "simayi|jinxuandi",
	events = {sgs.ChoiceMade, sgs.FinishRetrial},
	data = "TianMingZhiFa_data",
	keys = {
		"retrial",
		"retrial_card",
		"count",
	},
}
sgs.TianMingZhiFa_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].TianMingZhiFa = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg == 8 then
		if msg[1] == "cardResponded" and msg[6] == "lightning" and msg[8] ~= "_nil_" then
			if isTarget(player) and isGeneral(player, "simayi|jinxuandi", false) then
				if player:objectName() ~= msg[4] then
					setInfo("TianMingZhiFa", "retrial", 1)
					setInfo("TianMingZhiFa", "retrial_card", tonumber(string.sub(msg[8], 2, -2)))
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].TianMingZhiFa = function(self, player, data)
	local judge = data:toJudge()
	if judge.reason == "lightning" and getInfo("TianMingZhiFa", "retrial", 0) == 1 then
		setInfo("TianMingZhiFa", "retrial", 0)
		local id = getInfo("TianMingZhiFa", "retrial_card", -1)
		setInfo("TianMingZhiFa", "retrial_card", -1)
		if id == judge.card:getEffectiveId() and judge:isBad() then
			addInfo("TianMingZhiFa", "count", 1)
			if getInfo("TianMingZhiFa", "count", 0) >= 2 then
				addFinishTag("TianMingZhiFa")
			end
		end
	end
end
--[[****************************************************************
	战功：天下归心
	描述：使用神曹操在一局游戏中发动归心获得至少10张牌
]]--****************************************************************
sgs.glory_info["TianXiaGuiXin"] = {
	name = "TianXiaGuiXin",
	state = "验证通过",
	mode = "all_modes",
	general = "shencaocao",
	events = {sgs.ChoiceMade},
	data = "TianXiaGuiXin_data",
	keys = {
		"count",
	},
}
sgs.TianXiaGuiXin_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].TianXiaGuiXin = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "cardChosen" and msg[2] == "guixin" then
			if isTarget(player) and isGeneral(player, "shencaocao", true) then
				addInfo("TianXiaGuiXin", "count", 1)
				if getInfo("TianXiaGuiXin", "count", 0) >= 10 then
					addFinishTag("TianXiaGuiXin")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：铁锁连舟
	描述：使用庞统在1回合内发动连环横置至少6名角色
]]--****************************************************************
sgs.glory_info["TieSuoLianZhou"] = {
	name = "TieSuoLianZhou",
	state = "验证通过",
	mode = "all_modes",
	general = "pangtong",
	events = {sgs.CardEffect, sgs.EventPhaseStart},
	data = "TieSuoLianZhou_data",
	keys = {
		"count",
	},
}
sgs.TieSuoLianZhou_data = {}
sgs.ai_event_callback[sgs.CardEffect].TieSuoLianZhou = function(self, player, data)
	local effect = data:toCardEffect()
	if effect.card:isKindOf("IronChain") and not player:isChained() then
		local source = effect.from
		if source and isTarget(source) and isGeneral(source, "pangtong", false) then
			local target = effect.to
			if target and target:objectName() == player:objectName() then
				addInfo("TieSuoLianZhou", "count", 1)
				if getInfo("TieSuoLianZhou", "count", 0) >= 6 then
					addFinishTag("TieSuoLianZhou")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].TieSuoLianZhou = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("TieSuoLianZhou", "count", 0)
	end
end
--[[****************************************************************
	战功：通晓兵法
	描述：使用马谡在一局游戏中发动心战获得桃和无中生有至少各2张
]]--****************************************************************
sgs.glory_info["TongXiaoBingFa"] = {
	name = "TongXiaoBingFa",
	state = "验证通过",
	mode = "all_modes",
	general = "masu",
	events = {sgs.ChoiceMade},
	data = "TongXiaoBingFa_data",
	keys = {
		"peach",
		"ex_nihilo",
	},
}
sgs.TongXiaoBingFa_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].TongXiaoBingFa = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "AGChosen" and msg[2] == "xinzhan" then
			if isTarget(player) and isGeneral(player, "masu", false) then
				local id = tonumber(msg[3])
				local card = sgs.Sanguosha:getCard(id)
				if card:isKindOf("Peach") then
					addInfo("TongXiaoBingFa", "peach", 1)
				elseif card:isKindOf("ExNihilo") then
					addInfo("TongXiaoBingFa", "ex_nihilo", 1)
				else
					return 
				end
				if getInfo("TongXiaoBingFa", "peach", 0) >= 2 then
					if getInfo("TongXiaoBingFa", "ex_nihilo", 0) >= 2 then
						addFinishTag("TongXiaoBingFa")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：微妙玄通
	描述：使用虞翻在一局游戏中发动直言令其他角色摸到装备牌至少3张
]]--****************************************************************
sgs.glory_info["WeiMiaoXuanTong"] = {
	name = "WeiMiaoXuanTong",
	state = "验证通过",
	mode = "all_modes",
	general = "yufan",
	events = {sgs.ChoiceMade},
	data = "WeiMiaoXuanTong_data",
	keys = {
		"count",
	},
}
sgs.WeiMiaoXuanTong_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].WeiMiaoXuanTong = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "playerChosen" and msg[2] == "zhiyan" and msg[#msg] ~= getTargetName() then
			if isTarget(player) and isGeneral(player, "yufan", false) then
				local pile = self.room:getDrawPile()
				local id = pile:first()
				local equip = sgs.Sanguosha:getCard(id)
				if equip:isKindOf("EquipCard") then
					addInfo("WeiMiaoXuanTong", "count", 1)
					if getInfo("WeiMiaoXuanTong", "count", 0) >= 3 then
						addFinishTag("WeiMiaoXuanTong")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：魏文帝
	描述：使用曹丕在1局游戏中发动行殇获得锦囊牌至少6张
]]--****************************************************************
sgs.glory_info["WeiWenDi"] = {
	name = "WeiWenDi",
	state = "验证通过",
	mode = "all_modes",
	general = "caopi",
	events = {sgs.CardsMoveOneTime},
	data = "WeiWenDi_data",
	keys = {
		"xingshang",
		"count",
	},
}
sgs.WeiWenDi_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].WeiWenDi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:xingshang:yes" and isTarget(player) and isGeneral(player, "caopi", false) then
		setInfo("WeiWenDi", "xingshang", 1)
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].WeiWenDi = function(self, player, data)
	local move = data:toMoveOneTime()
	local reason = move.reason
	if reason.m_reason == sgs.CardMoveReason_S_REASON_RECYCLE then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if reason.m_playerId == player:objectName() and isGeneral(player, "caopi", false) then
				if getInfo("WeiWenDi", "xingshang", 0) == 1 then
					setInfo("WeiWenDi", "xingshang", 0)
					local count = 0
					for index, id in sgs.qlist(move.card_ids) do
						local trick = sgs.Sanguosha:getCard(id)
						if trick:isKindOf("TrickCard") then
							count = count + 1
						end
					end
					if count > 0 then
						addInfo("WeiWenDi", "count", count)
						if getInfo("WeiWenDi", "count", 0) >= 6 then
							addFinishTag("WeiWenDi")
						end
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：惟贤惟德
	描述：使用刘备或旧刘备在一个回合内发动仁德给的牌不少于10张
]]--****************************************************************
sgs.glory_info["WeiXianWeiDe"] = {
	name = "WeiXianWeiDe",
	state = "验证通过",
	mode = "all_modes",
	general = "liubei",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "WeiXianWeiDe_data",
	keys = {
		"count",
	},
}
sgs.WeiXianWeiDe_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].WeiXianWeiDe = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("RendeCard") or card:isKindOf("NosRendeCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "liubei", false) then
				addInfo("WeiXianWeiDe", "count", card:subcardsLength())
				if getInfo("WeiXianWeiDe", "count", 0) >= 10 then
					addFinishTag("WeiXianWeiDe")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].WeiXianWeiDe = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("WeiXianWeiDe", "count", 0)
	end
end
--[[****************************************************************
	战功：文姬归汉
	描述：在主公是曹操的情况下，使用SP蔡文姬做内奸取得胜利
]]--****************************************************************
sgs.glory_info["WenJiGuiHan"] = {
	name = "WenJiGuiHan",
	state = "验证通过",
	mode = "roles",
	general = "sp_caiwenji",
	events = {sgs.NonTrigger},
	data = "WenJiGuiHan_data",
	keys = {},
}
sgs.WenJiGuiHan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].WenJiGuiHan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("sp_caiwenji") and amRenegade() then
		local lord = self.room:getLord()
		if lord and isGeneral(lord, "caocao", false) and amWinner() then
			addFinishTag("WenJiGuiHan")
		end
	end
end
--[[****************************************************************
	战功：稳重行军
	描述：使用于禁在一局游戏中发动“毅重”抵御至少4次黑色杀
]]--****************************************************************
sgs.glory_info["WenZhongXingJun"] = {
	name = "WenZhongXingJun",
	state = "验证通过",
	mode = "all_modes",
	general = "yujin",
	events = {sgs.SlashEffected},
	data = "WenZhongXingJun_data",
	keys = {
		"count",
	},
}
sgs.WenZhongXingJun_data = {}
sgs.ai_event_callback[sgs.SlashEffected].WenZhongXingJun = function(self, player, data)
	local effect = data:toSlashEffect()
	if effect.slash:isBlack() then
		local target = effect.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if player:hasSkill("yizhong") and isGeneral(player, "yujin", false) and not player:getArmor() then
				addInfo("WenZhongXingJun", "count", 1)
				if getInfo("WenZhongXingJun", "count", 0) >= 4 then
					addFinishTag("WenZhongXingJun")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：我看好你
	描述：使用徐庶在一局游戏中发动举荐至少6次
]]--****************************************************************
sgs.glory_info["WoKanHaoNi"] = {
	name = "WoKanHaoNi",
	state = "验证通过",
	mode = "all_modes",
	general = "xushu",
	events = {sgs.PreCardUsed},
	data = "WoKanHaoNi_data",
	keys = {
		"count",
	},
}
sgs.WoKanHaoNi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].WoKanHaoNi = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("JujianCard") or card:isKindOf("NosJujianCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xushu", false) then
				addInfo("WoKanHaoNi", "count", 1)
				if getInfo("WoKanHaoNi", "count", 0) >= 6 then
					addFinishTag("WoKanHaoNi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：吴国之母
	描述：使用吴国太在一局游戏中发动补益使至少3名不同的吴国武将脱离频死状态
]]--****************************************************************
sgs.glory_info["WuGuoZhiMu"] = {
	name = "WuGuoZhiMu",
	state = "",
	mode = "all_modes",
	general = "wuguotai",
	events = {sgs.ChoiceMade, sgs.HpRecover},
	data = "WuGuoZhiMu_data",
	keys = {
		"buyi",
		"targets",
	},
}
sgs.WuGuoZhiMu_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].WuGuoZhiMu = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:buyi:yes" then
		if isTarget(player) and isGeneral(player, "wuguotai", true) then
			setInfo("WuGuoZhiMu", "buyi", 1)
		end
	elseif getInfo("WuGuoZhiMu", "buyi", 0) == 1 then
		msg = msg:split(":")
		if #msg > 0 then
			local id = nil
			if msg[1] == "cardChosen" and msg[2] == "buyi" then --cardChosen:buyi:11:sgs1:sgs2
				id = tonumber(msg[3])
			elseif msg[1] == "cardShow" and msg[2] == "buyi" then --cardShow:buyi:_71_
				id = tonumber(string.sub(msg[3], 2, -2))
			end
			if id and id ~= -1 then
				local card = sgs.Sanguosha:getCard(id)
				if card:isKindOf("BasicCard") then
					setInfo("WuGuoZhiMu", "buyi", 0)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.HpRecover].WuGuoZhiMu = function(self, player, data)
	if player:hasFlag("Global_Dying") and player:getHp() > 0 then
		local recover = data:toRecover()
		local source = recover.who
		if source and isTarget(source) and isGeneral(source, "wuguotai", true) then
			if getInfo("WuGuoZhiMu", "buyi", 0) == 1 then
				setInfo("WuGuoZhiMu", "buyi", 0)
				if player:getKingdom() == "wu" then
					local targets = getInfo("WuGuoZhiMu", "targets", "")
					targets = targets:split("|")
					local name = player:objectName()
					for _,n in ipairs(targets) do
						if n == name then
							return 
						end
					end
					table.insert(targets, name)
					setInfo("WuGuoZhiMu", "targets", table.concat(targets, "|"))
					if #targets >= 3 then
						addFinishTag("WuGuoZhiMu")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：武姬
	描述：使用关银屏在一局游戏中发动技能虎啸3次，血祭1次
]]--****************************************************************
sgs.glory_info["WuJi"] = {
	name = "WuJi",
	state = "验证通过",
	mode = "all_modes",
	general = "guanyinping",
	events = {sgs.PreCardUsed},
	data = "WuJi_data",
	keys = {
		"huxiao_times",
		"xueji_times",
	},
}
sgs.WuJi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].WuJi = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "guanyinping", false) then
			local card = use.card
			if card:isKindOf("Slash") then
				if player:getMark("huxiao") > 0 then
					addInfo("WuJi", "huxiao_times", 1)
				end
			elseif card:isKindOf("XuejiCard") then
				addInfo("WuJi", "xueji_times", 1)
			else
				return 
			end
			if getInfo("WuJi", "huxiao_times", 0) >= 3 and getInfo("WuJi", "xueji_times", 0) >= 1 then
				addFinishTag("WuJi")
			end
		end
	end
end
--[[****************************************************************
	战功：无尽的鞭挞
	描述：使用黄盖1个回合内发动至少8次苦肉
]]--****************************************************************
sgs.glory_info["WuJinDeBianTa"] = {
	name = "WuJinDeBianTa",
	state = "验证通过",
	mode = "all_modes",
	general = "huanggai",
	events = {sgs.PreCardUsed, sgs.EventPhaseStart},
	data = "WuJinDeBianTa_data",
	keys = {
		"count",
	},
}
sgs.WuJinDeBianTa_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].WuJinDeBianTa = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("KurouCard") or card:isKindOf("NosKurouCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "huanggai", false) then
				addInfo("WuJinDeBianTa", "count", 1)
				if getInfo("WuJinDeBianTa", "count", 0) >= 8 then
					addFinishTag("WuJinDeBianTa")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].WuJinDeBianTa = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("WuJinDeBianTa", "count", 0)
	end
end
--[[****************************************************************
	战功：无尽的挣扎
	描述：使用周瑜在1局游戏中使用反间杀死至少3名角色
]]--****************************************************************
sgs.glory_info["WuJinDeZhengZha"] = {
	name = "WuJinDeZhengZha",
	state = "",
	mode = "all_modes",
	general = "zhouyu",
	events = {sgs.NonTrigger},
	data = "WuJinDeZhengZha_data",
	keys = {
		"count",
	},
}
sgs.WuJinDeZhengZha_data = {}
sgs.ai_event_callback[sgs.NonTrigger].WuJinDeZhengZha = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "zhouyu", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		local card = death.damage.card
		if card then
			if card:isKindOf("FanjianCard") or card:isKindOf("NosFanjianCard") or card:isKindOf("NeoFanjianCard") then
				addInfo("WuJinDeZhengZha", "count", 1)
				if getInfo("WuJinDeZhengZha", "count", 0) >= 3 then
					addFinishTag("WuJinDeZhengZha")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：无谋竖子
	描述：使用神吕布在一局游戏中发动无谋至少8次
]]--****************************************************************
sgs.glory_info["WuMouShuZi"] = {
	name = "WuMouShuZi",
	state = "验证通过",
	mode = "all_modes",
	general = "shenlvbu",
	events = {sgs.PreCardUsed},
	data = "WuMouShuZi_data",
	keys = {
		"count",
	},
}
sgs.WuMouShuZi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].WuMouShuZi = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isNDTrick() then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "shenlvbu", false) and player:hasSkill("wumou") then
				addInfo("WuMouShuZi", "count", 1)
				if getInfo("WuMouShuZi", "count", 0) >= 8 then
					addFinishTag("WuMouShuZi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：无言以对
	描述：使用徐庶在一局游戏中发动“无言”躲过南蛮入侵或万箭齐发累计4次
]]--****************************************************************
sgs.glory_info["WuYanYiDui"] = {
	name = "WuYanYiDui",
	state = "验证通过",
	mode = "all_modes",
	general = "xushu",
	events = {sgs.CardEffected, sgs.NonTrigger},
	data = "WuYanYiDui_data",
	keys = {
		"avoid_savage_assault_times",
		"avoid_archery_attack_times",
	},
}
sgs.WuYanYiDui_data = {}
sgs.ai_event_callback[sgs.CardEffected].WuYanYiDui = function(self, player, data)
	local effect = data:toCardEffect()
	local trick = effect.card
	if trick:isKindOf("AOE") then
		local target = effect.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xushu", false) and player:hasSkill("noswuyan") then
				if trick:isKindOf("SavageAssault") then
					addInfo("WuYanYiDui", "avoid_savage_assault_times", 1)
				elseif trick:isKindOf("ArcheryAttack") then
					addInfo("WuYanYiDui", "avoid_archery_attack_times", 1)
				end
				local count = getInfo("WuYanYiDui", "avoid_savage_assault_times", 0)
				count = count + getInfo("WuYanYiDui", "avoid_archery_attack_times", 0)
				if count >= 4 then
					addFinishTag("WuYanYiDui")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].WuYanYiDui = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageInflicted" and isTarget(player) and isGeneral(player, "xushu", false) then
		local damage = self.room:getTag("gloryData"):toDamage()
		local trick = damage.card
		if trick and trick:isKindOf("AOE") and player:hasSkill("wuyan") then
			if trick:isKindOf("SavageAssault") then
				addInfo("WuYanYiDui", "avoid_savage_assault_times", 1)
			elseif trick:isKindOf("ArcheryAttack") then
				addInfo("WuYanYiDui", "avoid_archery_attack_times", 1)
			end
			local count = getInfo("WuYanYiDui", "avoid_savage_assault_times", 0)
			count = count + getInfo("WuYanYiDui", "avoid_archery_attack_times", 0)
			if count >= 4 then
				addFinishTag("WuYanYiDui")
			end
		end
	end
end
--[[****************************************************************
	战功：武圣显灵
	描述：使用关羽在1局游戏中发动武圣至少杀死3名角色
]]--****************************************************************
sgs.glory_info["WuShengXianLing"] = {
	name = "WuShengXianLing",
	state = "验证通过",
	mode = "all_modes",
	general = "guanyu",
	events = {sgs.NonTrigger},
	data = "WuShengXianLing_data",
	keys = {
		"count",
	},
}
sgs.WuShengXianLing_data = {}
sgs.ai_event_callback[sgs.NonTrigger].WuShengXianLing = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "guanyu", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		local slash = death.damage.card
		if slash and slash:isKindOf("Slash") and slash:getSkillName() == "wusheng" then
			addInfo("WuShengXianLing", "count", 1)
			if getInfo("WuShengXianLing", "count", 0) >= 3 then
				addFinishTag("WuShengXianLing")
			end
		end
	end
end
--[[****************************************************************
	战功：西凉铁骑
	描述：使用SP马超在一局游戏中至少发动5次铁骑并判定为红色
]]--****************************************************************
sgs.glory_info["XiLiangTieJi"] = {
	name = "XiLiangTieJi",
	state = "验证通过",
	mode = "all_modes",
	general = "sp_machao",
	events = {sgs.FinishRetrial},
	data = "XiLiangTieJi_data",
	keys = {
		"count",
	},
}
sgs.XiLiangTieJi_data = {}
sgs.ai_event_callback[sgs.FinishRetrial].XiLiangTieJi = function(self, player, data)
	local judge = data:toJudge()
	if string.find(judge.reason, "tieji") and judge:isGood() then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "sp_machao", true) then
				addInfo("XiLiangTieJi", "count", 1)
				if getInfo("XiLiangTieJi", "count", 0) >= 5 then
					addFinishTag("XiLiangTieJi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：先知续命
	描述：使用郭嘉在一局游戏中利用技能“天妒”收进至少4个桃
]]--****************************************************************
sgs.glory_info["XianZhiXuMing"] = {
	name = "XianZhiXuMing",
	state = "验证通过",
	mode = "all_modes",
	general = "guojia",
	events = {sgs.ChoiceMade},
	data = "XianZhiXuMing_data",
	keys = {
		"judge_card",
		"count",
	},
}
sgs.XianZhiXuMing_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].XianZhiXuMing = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and msg[2] == "tiandu" then
			if isTarget(player) and isGeneral(player, "guojia", false) then
				if msg[3] == "yes" then
					if getInfo("XianZhiXuMing", "judge_card", -1) ~= -1 then
						setInfo("XianZhiXuMing", "judge_card", -1)
						addInfo("XianZhiXuMing", "count", 1)
						if getInfo("XianZhiXuMing", "count", 0) >= 4 then
							addFinishTag("XianZhiXuMing")
						end
					end
				else
					setInfo("XianZhiXuMing", "judge_card", -1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.FinishRetrial].XianZhiXuMing = function(self, player, data)
	local judge = data:toJudge()
	local card = judge.card
	if card:isKindOf("Peach") then
		local who = judge.who
		if who and who:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "guojia", false) and player:hasSkill("tiandu") then
				setInfo("XianZhiXuMing", "judge_card", card:getEffectiveId())
			end
		end
	end
end
--[[****************************************************************
	战功：先主假子
	描述：使用刘封在一局游戏中发动陷嗣使得“逆”的数量达到8张并获得胜利
]]--****************************************************************
sgs.glory_info["XianZhuJiaZi"] = {
	name = "XianZhuJiaZi",
	state = "验证通过",
	mode = "all_modes",
	general = "liufeng",
	events = {sgs.CardUsed, sgs.NonTrigger},
	data = "XianZhuJiaZi_data",
	keys = {
		"xiansi",
	},
}
sgs.XianZhuJiaZi_data = {}
sgs.ai_event_callback[sgs.CardUsed].XianZhuJiaZi = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("XiansiCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if getInfo("XianZhuJiaZi", "xiansi", 0) == 0 then
				if isGeneral(player, "liufeng", false) and player:getPile("counter"):length() >= 8 then
					setInfo("XianZhuJiaZi", "xiansi", 1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].XianZhuJiaZi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("liufeng", false) and amWinner() then
		if getInfo("XianZhuJiaZi", "xiansi", 0) == 1 then
			addFinishTag("XianZhuJiaZi")
		end
	end
end
--[[****************************************************************
	战功：险中求胜
	描述：使用夏侯霸在自己只剩下1体力的情况下获得游戏胜利
]]--****************************************************************
sgs.glory_info["XianZhongQiuSheng"] = {
	name = "XianZhongQiuSheng",
	state = "验证通过",
	mode = "all_modes",
	general = "xiahouba",
	events = {sgs.NonTrigger},
	data = "XianZhongQiuSheng_data",
	keys = {},
}
sgs.XianZhongQiuSheng_data = {}
sgs.ai_event_callback[sgs.NonTrigger].XianZhongQiuSheng = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and getTarget():getHp() == 1 and amWinner() then
		if amGeneral("xiahouba", false) then
			addFinishTag("XianZhongQiuSheng")
		end
	end
end
--[[****************************************************************
	战功：小旋风
	描述：使用凌统在一局游戏中发动技能“旋风”弃掉其他角色累计15张牌
]]--****************************************************************
sgs.glory_info["XiaoXuanFeng"] = {
	name = "XiaoXuanFeng",
	state = "验证通过",
	mode = "all_modes",
	general = "lingtong",
	events = {sgs.ChoiceMade},
	data = "XiaoXuanFeng_data",
	keys = {
		"count",
	},
}
sgs.XiaoXuanFeng_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].XiaoXuanFeng = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "cardChosen" and msg[2] == "xuanfeng" then
			if isTarget(player) and isGeneral(player, "lingtong", false) then
				addInfo("XiaoXuanFeng", "count", 1)
				if getInfo("XiaoXuanFeng", "count", 0) >= 15 then
					addFinishTag("XiaoXuanFeng")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：心如寒冰
	描述：使用张春华在一局游戏中至少触发“绝情”10次以上
]]--****************************************************************
sgs.glory_info["XinRuHanBing"] = {
	name = "XinRuHanBing",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangchunhua",
	events = {sgs.Predamage},
	data = "XinRuHanBing_data",
	keys = {
		"count",
	},
}
sgs.XinRuHanBing_data = {}
sgs.ai_event_callback[sgs.Predamage].XinRuHanBing = function(self, player, data)
	local damage = data:toDamage()
	local source = damage.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "zhangchunhua", false) and player:hasSkill("jueqing") then
			addInfo("XinRuHanBing", "count", 1)
			if getInfo("XinRuHanBing", "count", 0) >= 10 then
				addFinishTag("XinRuHanBing")
			end
		end
	end
end
--[[****************************************************************
	战功：兴家赤族
	描述：使用诸葛恪在一局游戏中发动技能黩武令两名角色进入濒死状态
]]--****************************************************************
sgs.glory_info["XingJiaChiZu"] = {
	name = "XingJiaChiZu",
	state = "验证通过",
	mode = "all_modes",
	general = "zhugeke",
	events = {sgs.Dying},
	data = "XingJiaChiZu_data",
	keys = {
		"targets",
	},
}
sgs.XingJiaChiZu_data = {}
sgs.ai_event_callback[sgs.Dying].XingJiaChiZu = function(self, player, data)
	local dying = data:toDying()
	local victim = dying.who
	if victim and victim:objectName() == player:objectName() then
		local reason = dying.damage
		local source = reason.from
		if source and isTarget(source) and isGeneral(source, "zhugeke", false) then
			if reason.reason == "duwu" then
				local name = player:objectName()
				local targets = getInfo("XingJiaChiZu", "targets", ""):split("|")
				for _,n in ipairs(targets) do
					if n == name then
						return 
					end
				end
				table.insert(targets, name)
				setInfo("XingJiaChiZu", "targets", table.concat(targets, "|"))
				if #targets >= 2 then
					addFinishTag("XingJiaChiZu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：星落五丈原
	描述：使用诸葛亮，在司马懿为敌方时阵亡
]]--****************************************************************
sgs.glory_info["XingLuoWuZhangYuan"] = {
	name = "XingLuoWuZhangYuan",
	state = "验证通过",
	mode = "all_modes",
	general = "zhugeliang|wolong",
	events = {sgs.NonTrigger},
	data = "XingLuoWuZhangYuan_data",
	keys = {},
}
sgs.XingLuoWuZhangYuan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].XingLuoWuZhangYuan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and isTarget(player) and isGeneral(player, "zhugeliang|wolong", false) then
		local players = self.room:getPlayers()
		for _,p in sgs.qlist(players) do
			if isGeneral(p, "simayi|jinxuandi", false) and not isSameCamp(p, player) then
				addFinishTag("XingLuoWuZhangYuan")
				return 
			end
		end
	end
end
--[[****************************************************************
	战功：须臾之间
	描述：使用凌统在一局游戏中发动旋风至少弃置敌方角色装备区的牌至少8张
]]--****************************************************************
sgs.glory_info["XuYuZhiJian"] = {
	name = "XuYuZhiJian",
	state = "验证通过",
	mode = "all_modes",
	general = "lingtong",
	events = {sgs.ChoiceMade},
	data = "XuYuZhiJian_data",
	keys = {
		"count",
	},
}
sgs.XuYuZhiJian_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].XuYuZhiJian = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "cardChosen" and msg[2] == "xuanfeng" then
			if isTarget(player) and isGeneral(player, "lingtong", false) then
				local id = tonumber(msg[3])
				if self.room:getCardPlace(id) == sgs.Player_PlaceEquip then
					local target = self.room:getCardOwner(id)
					if target and not isSameCamp(player, target) then
						addInfo("XuYuZhiJian", "count", 1)
						if getInfo("XuYuZhiJian", "count", 0) >= 8 then
							addFinishTag("XuYuZhiJian")
						end
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：雪恨敌耻
	描述：使用☆SP夏侯惇在一局游戏中，发动雪恨杀死一名角色
]]--****************************************************************
sgs.glory_info["XueHenDiChi"] = {
	name = "XueHenDiChi",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_xiahoudun",
	events = {sgs.NonTrigger},
	data = "XueHenDiChi_data",
	keys = {},
}
sgs.XueHenDiChi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].XueHenDiChi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "bgm_xiahoudun", true) then
		local death = self.room:getTag("gloryData"):toDeath()
		local slash = death.damage.card
		if slash and slash:isKindOf("Slash") and slash:getSkillName() == "xuehen" then
			addFinishTag("XueHenDiChi")
		end
	end
end
--[[****************************************************************
	战功：掩其无备
	描述：使用张辽在1局游戏中发动至少10次突袭
]]--****************************************************************
sgs.glory_info["YanQiWuBei"] = {
	name = "YanQiWuBei",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangliao",
	events = {sgs.PreCardUsed, sgs.ChoiceMade},
	data = "YanQiWuBei_data",
	keys = {
		"count",
	},
}
sgs.YanQiWuBei_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].YanQiWuBei = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("TuxiCard") or card:isKindOf("NosTuxiCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "zhangliao", false) then
				addInfo("YanQiWuBei", "count", 1)
				if getInfo("YanQiWuBei", "count", 0) >= 10 then
					addFinishTag("YanQiWuBei")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].YanQiWuBei = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "playerChosen" and msg[2] == "koftuxi" then
			if isTarget(player) and isGeneral(player, "zhangliao", false) then
				addInfo("YanQiWuBei", "count", 1)
				if getInfo("YanQiWuBei", "count", 0) >= 10 then
					addFinishTag("YanQiWuBei")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：燕人的咆哮
	描述：使用张飞在1局游戏中发动丈八蛇矛特效杀死至少1名角色
]]--****************************************************************
sgs.glory_info["YanRenDePaoXiao"] = {
	name = "YanRenDePaoXiao",
	state = "验证通过",
	mode = "all_modes",
	general = "zhangfei",
	events = {sgs.NonTrigger},
	data = "YanRenDePaoXiao_data",
	keys = {},
}
sgs.YanRenDePaoXiao_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YanRenDePaoXiao = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "zhangfei", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		local slash = death.damage.card
		if slash and slash:isKindOf("Slash") and slash:getSkillName() == "spear" then
			addFinishTag("YanRenDePaoXiao")
		end
	end
end
--[[****************************************************************
	战功：严整溃围
	描述：使用☆SP曹仁在一局游戏中发动溃围摸牌至少11张并发动严整至少4次
]]--****************************************************************
sgs.glory_info["YanZhengKuiWei"] = {
	name = "YanZhengKuiWei",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_caoren",
	events = {sgs.ChoiceMade, sgs.PreCardUsed},
	data = "YanZhengKuiWei_data",
	keys = {
		"kuiwei_draw",
		"yanzheng_times",
	},
}
sgs.YanZhengKuiWei_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].YanZhengKuiWei = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:kuiwei:yes" and isTarget(player) and isGeneral(player, "bgm_caoren", true) then
		local count = getInfo("YanZhengKuiWei", "kuiwei_draw", 0) + 2
		local alives = self.room:getAlivePlayers()
		for _,p in sgs.qlist(alives) do
			if p:getWeapon() then
				count = count + 1
			end
		end
		setInfo("YanZhengKuiWei", "kuiwei_draw", count)
		if count >= 11 and getInfo("YanZhengKuiWei", "yanzheng_times", 0) >= 4 then
			addFinishTag("YanZhengKuiWei")
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].YanZhengKuiWei = function(self, player, data)
	local use = data:toCardUse()
	local null = use.card
	if null:isKindOf("Nullification") and null:getSkillName() == "yanzheng" then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "bgm_caoren", true) then
				addInfo("YanZhengKuiWei", "yanzheng_times", 1)
				if getInfo("YanZhengKuiWei", "yanzheng_times", 0) >= 4 then
					if getInfo("YanZhengKuiWei", "kuiwei_draw", 0) >= 11 then
						addFinishTag("YanZhengKuiWei")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：义薄云天
	描述：使用SP关羽在觉醒后杀死两个反贼并最后获胜
]]--****************************************************************
sgs.glory_info["YiBoYunTian"] = {
	name = "YiBoYunTian",
	state = "验证通过",
	mode = "roles",
	general = "sp_guanyu",
	events = {sgs.NonTrigger},
	data = "YiBoYunTian_data",
	keys = {
		"kill",
	},
}
sgs.YiBoYunTian_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YiBoYunTian = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and isGeneral(player, "sp_guanyu", true) and player:getMark("danji") > 0 then
			local death = self.room:getTag("gloryData"):toDeath()
			if death.who:getRole() == "rebel" then
				addInfo("YiBoYunTian", "kill", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amGeneral("sp_guanyu", true) then
		if getInfo("YiBoYunTian", "kill", 0) >= 2 and amWinner() then
			addFinishTag("YiBoYunTian")
		end
	end
end
--[[****************************************************************
	战功：一夫当关
	描述：使用典韦在1局游戏中发动至少5次强袭
]]--****************************************************************
sgs.glory_info["YiFuDangGuan"] = {
	name = "YiFuDangGuan",
	state = "验证通过",
	mode = "all_modes",
	general = "dianwei|guzhielai",
	events = {sgs.PreCardUsed},
	data = "YiFuDangGuan_data",
	keys = {
		"count",
	},
}
sgs.YiFuDangGuan_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].YiFuDangGuan = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("QiangxiCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "dianwei|guzhielai", false) then
				addInfo("YiFuDangGuan", "count", 1)
				if getInfo("YiFuDangGuan", "count", 0) >= 5 then
					addFinishTag("YiFuDangGuan")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：移花接木
	描述：使用大乔在一局游戏中累计发动5次流离
]]--****************************************************************
sgs.glory_info["YiHuaJieMu"] = {
	name = "YiHuaJieMu",
	state = "验证通过",
	mode = "all_modes",
	general = "daqiao",
	events = {sgs.PreCardUsed},
	data = "YiHuaJieMu_data",
	keys = {
		"count",
	},
}
sgs.YiHuaJieMu_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].YiHuaJieMu = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("LiuliCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "daqiao", false) then
				addInfo("YiHuaJieMu", "count", 1)
				if getInfo("YiHuaJieMu", "count", 0) >= 5 then
					addFinishTag("YiHuaJieMu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：一骑当先
	描述：使用乐进在一局游戏中发动骁果杀死至少2名角色并获胜
]]--****************************************************************
sgs.glory_info["YiJiDangXian"] = {
	name = "YiJiDangXian",
	state = "验证通过",
	mode = "all_modes",
	general = "yuejin",
	events = {sgs.NonTrigger},
	data = "YiJiDangXian_data",
	keys = {
		"kill",
	},
}
sgs.YiJiDangXian_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YiJiDangXian = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and isGeneral(player, "yuejin", false) then
			local death = self.room:getTag("gloryData"):toDeath()
			if death.damage.reason == "xiaoguo" then
				addInfo("YiJiDangXian", "kill", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amGeneral("yuejin", false) and amWinner() then
		if getInfo("YiJiDangXian", "kill", 0) >= 2 then
			addFinishTag("YiJiDangXian")
		end
	end
end
--[[****************************************************************
	战功：以死安大局
	描述：使用马谡在一局游戏中发动“挥泪”使一名角色弃置8张牌
]]--****************************************************************
sgs.glory_info["YiSiAnDaJu"] = {
	name = "YiSiAnDaJu",
	state = "验证通过",
	mode = "all_modes",
	general = "masu",
	events = {sgs.NonTrigger},
	data = "YiSiAnDaJu_data",
	keys = {},
}
sgs.YiSiAnDaJu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YiSiAnDaJu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and player:getCardCount(true) >= 8 then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if isTarget(victim) and isGeneral(victim, "masu", false) and victim:hasSkill("huilei") then
			if player:objectName() ~= victim:objectName() then
				addFinishTag("YiSiAnDaJu")
			end
		end
	end
end
--[[****************************************************************
	战功：医者仁心
	描述：使用华佗在一局游戏中对4个身份的人都发动过青囊并最后获胜
]]--****************************************************************
sgs.glory_info["YiZheRenXin"] = {
	name = "YiZheRenXin",
	state = "",
	mode = "roles",
	general = "huatuo",
	events = {sgs.PreCardUsed, sgs.NonTrigger},
	data = "YiZheRenXin_data",
	keys = {
		"lord",
		"loyalist",
		"renegade",
		"rebel",
	},
}
sgs.YiZheRenXin_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].YiZheRenXin = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("QingnangCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "huatuo", false) then
				for _,target in sgs.qlist(use.to) do
					setInfo("YiZheRenXin", target:getRole(), 1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].YiZheRenXin = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("huatuo", false) and amWinner() then
		for _,role in ipairs({"lord", "loyalist", "renegade", "rebel"}) do
			if getInfo("YiZheRenXin", role, 0) ~= 1 then
				return 
			end
		end
		addFinishTag("YiZheRenXin")
	end
end
--[[****************************************************************
	战功：因祸得福
	描述：使用孙尚香在1局游戏中累计失去至少5张已装备的装备牌
]]--****************************************************************
sgs.glory_info["YinHuoDeFu"] = {
	name = "YinHuoDeFu",
	state = "验证通过",
	mode = "all_modes",
	general = "sunshangxiang",
	events = {sgs.CardsMoveOneTime},
	data = "YinHuoDeFu_data",
	keys = {
		"count",
	},
}
sgs.YinHuoDeFu_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].YinHuoDeFu = function(self, player, data)
	local move = data:toMoveOneTime()
	local source = move.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "sunshangxiang", false) then
			local count = 0
			for index, place in sgs.qlist(move.from_places) do
				if place == sgs.Player_PlaceEquip then
					count = count + 1
				end
			end
			if count > 0 then
				addInfo("YinHuoDeFu", "count", count)
				if getInfo("YinHuoDeFu", "count", 0) >= 5 then
					addFinishTag("YinHuoDeFu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：隐忍不发
	描述：使用神司马懿在一局游戏中发动忍戒至少10次并获胜
]]--****************************************************************
sgs.glory_info["YinRenBuFa"] = {
	name = "YinRenBuFa",
	state = "验证通过",
	mode = "all_modes",
	general = "shensimayi",
	events = {sgs.Damaged, sgs.CardsMoveOneTime, sgs.NonTrigger},
	data = "YinRenBuFa_data",
	keys = {
		"renjie_times",
	},
}
sgs.YinRenBuFa_data = {}
sgs.ai_event_callback[sgs.Damaged].YinRenBuFa = function(self, player, data)
	local damage = data:toDamage()
	local victim = damage.to
	if victim and victim:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "shensimayi", true) and player:hasSkill("renjie") then
			addInfo("YinRenBuFa", "renjie_times", 1)
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].YinRenBuFa = function(self, player, data)
	local move = data:toMoveOneTime()
	local source = move.from
	if source and source:objectName() == player:objectName() and isTarget(player) and player:hasSkill("renjie") then
		if player:getPhase() == sgs.Player_Discard and isGeneral(player, "shensimayi", true) then
			local basic = bit32.band(move.reason.m_reason, sgs.CardMoveReason_S_MASK_BASIC_REASON)
			if basic == sgs.CardMoveReason_S_REASON_DISCARD then
				addInfo("YinRenBuFa", "renjie_times", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].YinRenBuFa = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("shensimayi", true) and amWinner() then
		if getInfo("YinRenBuFa", "renjie_times", 0) >= 10 then
			addFinishTag("YinRenBuFa")
		end
	end
end
--[[****************************************************************
	战功：有难你当
	描述：使用小乔在一局游戏中发动“天香”导致一名其他角色死亡
]]--****************************************************************
sgs.glory_info["YouNanNiDang"] = {
	name = "YouNanNiDang",
	state = "验证通过",
	mode = "all_modes",
	general = "xiaoqiao",
	events = {sgs.PreCardUsed, sgs.NonTrigger, sgs.DamageComplete},
	data = "YouNanNiDang_data",
	keys = {
		"tianxiang",
		"target",
	},
}
sgs.YouNanNiDang_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].YouNanNiDang = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("TianxiangCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "xiaoqiao", false) then
				setInfo("YouNanNiDang", "tianxiang", 1)
				local target = use.to:first()
				setInfo("YouNanNiDang", "target", target:objectName())
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].YouNanNiDang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and getInfo("YouNanNiDang", "tianxiang", 0) == 1 then
		local death = self.room:getTag("gloryData"):toDeath()
		local reason = death.damage
		if player:objectName() == getInfo("YouNanNiDang", "target", "") then
			addFinishTag("YouNanNiDang")
		end
	end
end
sgs.ai_event_callback[sgs.DamageComplete].YouNanNiDang = function(self, player, data)
	local damage = data:toDamage()
	if damage.transfer and damage.transfer_reason == "tianxiang" then
		setInfo("YouNanNiDang", "tianxiang", 0)
		setInfo("YouNanNiDang", "target", "")
	end
end
--[[****************************************************************
	战功：有勇有谋
	描述：使用伏完在一局游戏中发动谋溃弃掉3张闪
]]--****************************************************************
sgs.glory_info["YouYongYouMou"] = {
	name = "YouYongYouMou",
	state = "验证通过",
	mode = "all_modes",
	general = "fuwan",
	events = {sgs.ChoiceMade},
	data = "YouYongYouMou_data",
	keys = {
		"count",
	},
}
sgs.YouYongYouMou_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].YouYongYouMou = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "cardChosen" and msg[2] == "moukui" then
			if isTarget(player) and isGeneral(player, "fuwan", false) then
				local id = tonumber(msg[3])
				local jink = sgs.Sanguosha:getCard(id)
				if jink and jink:isKindOf("Jink") then
					addInfo("YouYongYouMou", "count", 1)
					if getInfo("YouYongYouMou", "count", 0) >= 3 then
						addFinishTag("YouYongYouMou")
					end
				end
			end
		end
	end
end
--[[****************************************************************
	战功：与世不侵
	描述：使用伏皇后在一局游戏中发动惴恐拼点赢至少4次
]]--****************************************************************
sgs.glory_info["YuShiBuQin"] = {
	name = "YuShiBuQin",
	state = "验证通过",
	mode = "all_modes",
	general = "fuhuanghou",
	events = {sgs.Pindian},
	data = "YuShiBuQin_data",
	keys = {
		"count",
	},
}
sgs.YuShiBuQin_data = {}
sgs.ai_event_callback[sgs.Pindian].YuShiBuQin = function(self, player, data)
	local pindian = data:toPindian()
	if string.find(pindian.reason, "zhuikong") and pindian.success then
		local source = pindian.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "fuhuanghou", false) then
				addInfo("YuShiBuQin", "count", 1)
				if getInfo("YuShiBuQin", "count", 0) >= 4 then
					addFinishTag("YuShiBuQin")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：战神之怒
	描述：使用神吕布在一局游戏中发动至少4次神愤、3次无前
]]--****************************************************************
sgs.glory_info["ZhanShenZhiNu"] = {
	name = "ZhanShenZhiNu",
	state = "验证通过",
	mode = "all_modes",
	general = "shenlvbu",
	events = {sgs.PreCardUsed},
	data = "ZhanShenZhiNu_data",
	keys = {
		"shenfen_times",
		"wuqian_times",
	},
}
sgs.ZhanShenZhiNu_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ZhanShenZhiNu = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if isGeneral(player, "shenlvbu", false) then
			local card = use.card
			if card:isKindOf("ShenfenCard") then
				addInfo("ZhanShenZhiNu", "shenfen_times", 1)
			elseif card:isKindOf("WuqianCard") then
				addInfo("ZhanShenZhiNu", "wuqian_times", 1)
			else
				return 
			end
			if getInfo("ZhanShenZhiNu", "shenfen_times", 0) >= 4 then
				if getInfo("ZhanShenZhiNu", "wuqian_times", 0) >= 3 then
					addFinishTag("ZhanShenZhiNu")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：昭烈之怒
	描述：在一局游戏中，使用☆SP刘备发动昭烈杀死至少2人
]]--****************************************************************
sgs.glory_info["ZhaoLieZhiNu"] = {
	name = "ZhaoLieZhiNu",
	state = "验证通过",
	mode = "all_modes",
	general = "bgm_liubei",
	events = {sgs.NonTrigger},
	data = "ZhaoLieZhiNu_data",
	keys = {
		"kill",
	},
}
sgs.ZhaoLieZhiNu_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ZhaoLieZhiNu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "bgm_liubei", true) then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.damage.reason == "zhaolie" then
			addInfo("ZhaoLieZhiNu", "kill", 1)
			if getInfo("ZhaoLieZhiNu", "kill", 0) >= 2 then
				addFinishTag("ZhaoLieZhiNu")
			end
		end
	end
end
--[[****************************************************************
	战功：真命天子
	描述：使用刘协在一局游戏中发动密诏4次，天命4次，并最终胜利
]]--****************************************************************
sgs.glory_info["ZhenMingTianZi"] = {
	name = "ZhenMingTianZi",
	state = "验证通过",
	mode = "all_modes",
	general = "liuxie",
	events = {sgs.PreCardUsed, sgs.ChoiceMade, sgs.NonTrigger},
	data = "ZhenMingTianZi_data",
	keys = {
		"mizhao_times",
		"tianming_times",
	},
}
sgs.ZhenMingTianZi_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ZhenMingTianZi = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("MizhaoCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "liuxie", false) then
				addInfo("ZhenMingTianZi", "mizhao_times", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].ZhenMingTianZi = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:tianming:yes" and isTarget(player) and isGeneral(player, "liuxie", false) then
		addInfo("ZhenMingTianZi", "tianming_times", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].ZhenMingTianZi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amGeneral("liuxie", false) and amWinner() then
		if getInfo("ZhenMingTianZi", "mizhao_times", 0) >= 4 then
			if getInfo("ZhenMingTianZi", "tianming_times", 0) >= 4 then
				addFinishTag("ZhenMingTianZi")
			end
		end
	end
end
--[[****************************************************************
	战功：指囷相赠
	描述：使用鲁肃在1局游戏中发动好施分给其他角色至少15张牌
]]--****************************************************************
sgs.glory_info["ZhiQunXiangZeng"] = {
	name = "ZhiQunXiangZeng",
	state = "验证通过",
	mode = "all_modes",
	general = "lusu",
	events = {sgs.PreCardUsed},
	data = "ZhiQunXiangZeng_data",
	keys = {
		"count",
	},
}
sgs.ZhiQunXiangZeng_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ZhiQunXiangZeng = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("HaoshiCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "lusu", false) then
				addInfo("ZhiQunXiangZeng", "count", card:subcardsLength())
				if getInfo("ZhiQunXiangZeng", "count", 0) >= 15 then
					addFinishTag("ZhiQunXiangZeng")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：智之化身
	描述：使用黄月英在一局游戏发动至少20次集智
]]--****************************************************************
sgs.glory_info["ZhiZhiHuaShen"] = {
	name = "ZhiZhiHuaShen",
	state = "验证通过",
	mode = "all_modes",
	general = "huangyueying",
	events = {sgs.ChoiceMade},
	data = "ZhiZhiHuaShen_data",
	keys = {
		"count",
	},
}
sgs.ZhiZhiHuaShen_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ZhiZhiHuaShen = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "skillInvoke" and string.find(msg[2], "jizhi") and msg[3] == "yes" then
			if isTarget(player) and isGeneral(player, "huangyueying", false) then
				addInfo("ZhiZhiHuaShen", "count", 1)
				if getInfo("ZhiZhiHuaShen", "count", 0) >= 20 then
					addFinishTag("ZhiZhiHuaShen")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：周苛之节
	描述：使用庞德在1局游戏中发动猛进至少5次
]]--****************************************************************
sgs.glory_info["ZhouKeZhiJie"] = {
	name = "ZhouKeZhiJie",
	state = "验证通过",
	mode = "all_modes",
	general = "pangde|panglingming",
	events = {sgs.ChoiceMade},
	data = "ZhouKeZhiJie_data",
	keys = {
		"count",
	},
}
sgs.ZhouKeZhiJie_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].ZhouKeZhiJie = function(self, player, data)
	local msg = data:toString() or ""
	if msg == "skillInvoke:mengjin:yes" and isTarget(player) and isGeneral(player, "pangde|panglingming", false) then
		addInfo("ZhouKeZhiJie", "count", 1)
		if getInfo("ZhouKeZhiJie", "count", 0) >= 5 then
			addFinishTag("ZhouKeZhiJie")
		end
	end
end
--[[****************************************************************
	战功：宗室遍四海
	描述：使用刘表在一局游戏中利用技能“宗室”提高4手牌上限
]]--****************************************************************
sgs.glory_info["ZongShiBianSiHai"] = {
	name = "ZongShiBianSiHai",
	state = "验证通过",
	once_only = true,
	mode = "all_modes",
	general = "liubiao",
	events = {sgs.EventPhaseStart},
	data = "ZongShiBianSiHai_data",
	keys = {},
}
sgs.ZongShiBianSiHai_data = {}
sgs.ai_event_callback[sgs.EventPhaseStart].ZongShiBianSiHai = function(self, player, data)
	if player:getPhase() == sgs.Player_Discard and isTarget(player) and isGeneral(player, "liubiao", false) then
		if player:hasSkill("zongshi") then
			local alives = self.room:getAlivePlayers()
			local kingdoms = {}
			local count = 0
			for _,p in sgs.qlist(alives) do
				local kingdom = p:getKingdom()
				if not kingdoms[kingdom] then
					kingdoms[kingdom] = true
					count = count + 1
				end
			end
			if count >= 4 then
				addFinishTag("ZongShiBianSiHai")
			end
		end
	end
end
--[[****************************************************************
	战功：走马荐诸葛
	描述：使用旧徐庶在一局游戏中至少有3次举荐诸葛且用于举荐的牌里必须有马
]]--****************************************************************
sgs.glory_info["ZouMaJianZhuGe"] = {
	name = "ZouMaJianZhuGe",
	state = "验证通过",
	mode = "all_modes",
	general = "nos_xushu",
	events = {sgs.PreCardUsed},
	data = "ZouMaJianZhuGe_data",
	keys = {
		"count",
	},
}
sgs.ZouMaJianZhuGe_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].ZouMaJianZhuGe = function(self, player, data)
	local use = data:toCardUse()
	local card = use.card
	if card:isKindOf("JujianCard") or card:isKindOf("NosJujianCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			local target = use.to:first()
			if isGeneral(player, "nos_xushu", true) and isGeneral(target, "zhugeliang|wolong", false) then
				local ids = card:getSubcards()
				local flag = false
				for _,id in sgs.qlist(ids) do
					local horse = sgs.Sanguosha:getCard(id)
					if horse:isKindOf("Horse") then
						flag = true
						break
					end
				end
				if flag then
					addInfo("ZouMaJianZhuGe", "count", 1)
					if getInfo("ZouMaJianZhuGe", "count", 0) >= 3 then
						addFinishTag("ZouMaJianZhuGe")
					end
				end
			end
		end
	end
end