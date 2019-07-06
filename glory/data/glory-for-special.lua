--[[
	太阳神三国杀游戏工具扩展包·战功荣耀（模式专属战功部分）
	适用版本：V2 - 愚人版（版本号：20150401）清明补丁（版本号：20150405）
]]--
--[[****************************************************************
	----------------------------------------------------------------
							3v3模式战功
	----------------------------------------------------------------
]]--****************************************************************
--[[****************************************************************
	战功：暴发户
	描述：一回合内获得至少10张手牌 (3v3)
]]--****************************************************************
sgs.glory_info["BaoFaHu"] = {
	name = "BaoFaHu",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.CardsMoveOneTime, sgs.EventPhaseStart},
	data = "BaoFaHu_data",
	keys = {
		"count",
	},
}
sgs.BaoFaHu_data = {}
sgs.ai_event_callback[sgs.CardsMoveOneTime].BaoFaHu = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceHand and player:getPhase() ~= sgs.Player_NotActive then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			addInfo("BaoFaHu", "count", move.card_ids:length())
			if getInfo("BaoFaHu", "count", 0) >= 10 then
				addFinishTag("BaoFaHu")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].BaoFaHu = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		setInfo("BaoFaHu", "count", 0)
	end
end
--[[****************************************************************
	战功：背水一战
	描述：身为主帅，在本方两名前锋阵亡的情况下，杀死对方3人后获胜 (3v3)
]]--****************************************************************
sgs.glory_info["BeiShuiYiZhan"] = {
	name = "BeiShuiYiZhan",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.NonTrigger},
	data = "BeiShuiYiZhan_data",
	keys = {
		"kill",
	},
}
sgs.BeiShuiYiZhan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].BeiShuiYiZhan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		if isTarget(player) and isLeader(player) then
			local death = self.room:getTag("gloryData"):toDeath()
			if not isSameCamp(death.who, player) then
				local others = self.room:getOtherPlayers(player)
				for _,p in sgs.qlist(others) do
					if isSameCamp(p, player) then
						return 
					end
				end
				addInfo("BeiShuiYiZhan", "kill", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amLeader() and amWinner() then
		if getInfo("BeiShuiYiZhan", "kill", 0) >= 3 then
			addFinishTag("BeiShuiYiZhan")
		end
	end
end
--[[****************************************************************
	战功：持久战
	描述：在自己的第5回合结束后获得胜利 (3v3)
]]--****************************************************************
sgs.glory_info["ChiJiuZhan"] = {
	name = "ChiJiuZhan",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.TurnStart, sgs.NonTrigger},
	data = "ChiJiuZhan_data",
	keys = {
		"turn",
	},
}
sgs.ChiJiuZhan_data = {}
sgs.ai_event_callback[sgs.TurnStart].ChiJiuZhan = function(self, player, data)
	if isTarget(player) then
		addInfo("ChiJiuZhan", "turn", 1)
	end
end
sgs.ai_event_callback[sgs.NonTrigger].ChiJiuZhan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("ChiJiuZhan", "turn", 0) >= 5 then
			addFinishTag("ChiJiuZhan")
		end
	end
end
--[[****************************************************************
	战功：舍生取义
	描述：身为前锋，被本方角色杀死累计10次 (3v3)
]]--****************************************************************
sgs.glory_info["SheShengQuYi"] = {
	name = "SheShengQuYi",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.NonTrigger},
	data = "SheShengQuYi_data",
	keys = {
		--"Global_times",
	},
}
sgs.SheShengQuYi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].SheShengQuYi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if victim and isTarget(victim) and isMember(victim) and isSameCamp(player, victim) then
			addInfo("SheShengQuYi", "Global_times", 1)
			if getInfo("SheShengQuYi", "Global_times", 0) >= 10 then
				setInfo("SheShengQuYi", "Global_times", 0)
				addFinishTag("SheShengQuYi")
			end
		end
	end
end
--[[****************************************************************
	战功：肆无忌惮
	描述：一回合内使用至少3张南蛮入侵或万箭齐发 (3v3)
]]--****************************************************************
sgs.glory_info["SiWuJiDan"] = {
	name = "SiWuJiDan",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.PreCardUsed, sgs.EventPhaseChanging},
	data = "SiWuJiDan_data",
	keys = {
		"use_savage_assault",
		"use_archery_attack",
	},
}
sgs.SiWuJiDan_data = {}
sgs.ai_event_callback[sgs.PreCardUsed].SiWuJiDan = function(self, player, data)
	local use = data:toCardUse()
	local aoe = use.card
	if aoe:isKindOf("AOE") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if aoe:isKindOf("SavageAssault") then
				addInfo("SiWuJiDan", "use_savage_assault", 1)
			elseif aoe:isKindOf("ArcheryAttack") then
				addInfo("SiWuJiDan", "use_archery_attack", 1)
			end
			if getInfo("SiWuJiDan", "use_savage_assault", 0) + getInfo("SiWuJiDan", "use_archery_attack", 0) >= 3 then
				addFinishTag("SiWuJiDan")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].SiWuJiDan = function(self, player, data)
	local change = data:toPhaseChange()
	if change.from == sgs.Player_NotActive or change.to == sgs.Player_NotActive then
		if isTarget(player) then
			setInfo("SiWuJiDan", "use_savage_assault", 0)
			setInfo("SiWuJiDan", "use_archery_attack", 0)
		end
	end
end
--[[****************************************************************
	战功：速战速决
	描述：在自己的首回合结束前获得胜利 (3v3)
]]--****************************************************************
sgs.glory_info["SuZhanSuJue"] = {
	name = "SuZhanSuJue",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.NonTrigger, sgs.TurnStart},
	data = "SuZhanSuJue_data",
	keys = {
		"turn",
	},
}
sgs.SuZhanSuJue_data = {}
sgs.ai_event_callback[sgs.NonTrigger].SuZhanSuJue = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and getInfo("SuZhanSuJue", "turn", 0) == 0 then
		if amWinner() then
			addFinishTag("SuZhanSuJue")
		end
	end
end
sgs.ai_event_callback[sgs.TurnStart].SuZhanSuJue = function(self, player, data)
	if isTarget(player) then
		addInfo("SuZhanSuJue", "turn", 1)
	end
end
--[[****************************************************************
	战功：一鼓作气
	描述：一回合内杀死对方3名角色 (3v3)
]]--****************************************************************
sgs.glory_info["YiGuZuoQi"] = {
	name = "YiGuZuoQi",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.NonTrigger, sgs.EventPhaseChanging},
	data = "YiGuZuoQi_data",
	keys = {
		"kill",
	},
}
sgs.YiGuZuoQi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YiGuZuoQi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		if not isSameCamp(death.who, player) then
			addInfo("YiGuZuoQi", "kill", 1)
			if getInfo("YiGuZuoQi", "kill", 0) >= 3 then
				addFinishTag("YiGuZuoQi")
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].YiGuZuoQi = function(self, player, data)
	local change = data:toPhaseChange()
	if change.from == sgs.Player_NotActive or change.to == sgs.Player_NotActive then
		if isTarget(player) then
			setInfo("YiGuZuoQi", "kill", 0)
		end
	end
end
--[[****************************************************************
	战功：直捣黄龙
	描述：在对方两名前锋都没有受伤的情况下杀死对方主帅 (3v3)
]]--****************************************************************
sgs.glory_info["ZhiDaoHuangLong"] = {
	name = "ZhiDaoHuangLong",
	state = "验证通过",
	mode = "06_3v3",
	events = {sgs.NonTrigger},
	data = "ZhiDaoHuangLong_data",
	keys = {},
}
sgs.ZhiDaoHuangLong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ZhiDaoHuangLong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local death = self.room:getTag("gloryData"):toDeath()
		local victim = death.who
		if isLeader(victim) and not isSameCamp(player, victim) then
			local others = self.room:getOtherPlayers(victim, true)
			for _,p in sgs.qlist(others) do
				if isSameCamp(p, victim) then
					if p:isDead() or p:isWounded() then
						return 
					end
				end
			end
			addFinishTag("ZhiDaoHuangLong")
		end
	end
end
--[[****************************************************************
	----------------------------------------------------------------
							1v1模式战功
	----------------------------------------------------------------
]]--****************************************************************
--[[****************************************************************
	战功：兵不血刃
	描述：对方3名武将都在他们各自的回合阵亡 (1v1)
]]--****************************************************************
sgs.glory_info["BingBuXueRen"] = {
	name = "BingBuXueRen",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "BingBuXueRen_data",
	keys = {
		"count",
	},
}
sgs.BingBuXueRen_data = {}
sgs.ai_event_callback[sgs.NonTrigger].BingBuXueRen = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and not isTarget(player) then
		local current = self.room:getCurrent()
		if current and current:objectName() == player:objectName() then
			addInfo("BingBuXueRen", "count", 1)
			if getInfo("BingBuXueRen", "count", 0) >= 3 then
				addFinishTag("BingBuXueRen")
			end
		end
	end
end
--[[****************************************************************
	战功：毫发无伤
	描述：在本方所有武将满体力的情况下胜利 (1v1)
]]--****************************************************************
sgs.glory_info["HaoFaWuShang"] = {
	name = "HaoFaWuShang",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "HaoFaWuShang_data",
	keys = {},
}
sgs.HaoFaWuShang_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HaoFaWuShang = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amWinner() then
		local me = getTarget()
		if me:getLostHp() == 0 then
			local list = me:getTag("1v1Arrange"):toStringList()
			local rule = sgs.GetConfig("1v1/Rule", "2013")
			if rule == "2013" then
				if #list >= 5 then
					addFinishTag("HaoFaWuShang")
				end
			else
				if #list >= 2 then
					addFinishTag("HaoFaWuShang")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：护国军师
	描述：以诸葛亮、司马懿、周瑜为上场武将的情况下获胜 (1v1)
]]--****************************************************************
sgs.glory_info["HuGuoJunShi"] = {
	name = "HuGuoJunShi",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "HuGuoJunShi_data",
	keys = {
		"zhugeliang",
		"simayi",
		"zhouyu",
	},
}
sgs.HuGuoJunShi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].HuGuoJunShi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameStart" then
		local list = player:getTag("1v1Arrange"):toStringList()
		table.insert(list, player:getGeneralName())
		for _,name in ipairs(list) do
			if string.find(name, "zhugeliang") or name == "wolong" then
				setInfo("HuGuoJunShi", "zhugeliang", 1)
			elseif string.find(name, "simayi") or name == "jinxuandi" then
				setInfo("HuGuoJunShi", "simayi", 1)
			elseif string.find(name, "zhouyu") then
				setInfo("HuGuoJunShi", "zhouyu", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amGeneral("zhugeliang|wolong", false) then
			setInfo("HuGuoJunShi", "zhugeliang", 1)
		end
		if amGeneral("simayi|jinxuandi", false) then
			setInfo("HuGuoJunShi", "simayi", 1)
		end
		if amGeneral("zhouyu", false) then
			setInfo("HuGuoJunShi", "zhouyu", 1)
		end
		if amWinner() and getInfo("HuGuoJunShi", "zhugeliang", 0) == 1 then
			if getInfo("HuGuoJunShi", "simayi", 0) == 1 then
				if getInfo("HuGuoJunShi", "zhouyu", 0) == 1 then
					addFinishTag("HuGuoJunShi")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：巾帼英雄
	描述：选择3名女性武将并且获胜 (1v1)
]]--****************************************************************
sgs.glory_info["JinGuoYingXiong"] = {
	name = "JinGuoYingXiong",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "JinGuoYingXiong_data",
	keys = {
		"female",
	},
}
sgs.JinGuoYingXiong_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JinGuoYingXiong = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameStart" then
		local list = player:getTag("1v1Arrange"):toStringList()
		table.insert(list, player:getGeneralName())
		for _,name in ipairs(list) do
			local general = sgs.Sanguosha:getGeneral(name)
			if general and general:isFemale() then
				addInfo("JinGuoYingXiong", "female", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("JinGuoYingXiong", "female", 0) >= 3 then
			addFinishTag("JinGuoYingXiong")
		end
	end
end
--[[****************************************************************
	战功：惊天逆转
	描述：在本方剩余1名武将时，杀死对方3名武将获胜 (1v1)
]]--****************************************************************
sgs.glory_info["JingTianNiZhuan"] = {
	name = "JingTianNiZhuan",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "JingTianNiZhuan_data",
	keys = {
		"kill",
	},
}
sgs.JingTianNiZhuan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].JingTianNiZhuan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) then
		local list = player:getTag("1v1Arrange"):toStringList()
		if #list == 0 then
			local death = self.room:getTag("gloryData"):toDeath()
			if death.who:objectName() ~= player:objectName() then
				addInfo("JingTianNiZhuan", "kill", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("JingTianNiZhuan", "kill", 0) >= 3 then
			addFinishTag("JingTianNiZhuan")
		end
	end
end
--[[****************************************************************
	战功：谋略过人
	描述：选择了3名3血武将并且获胜 (1v1)
]]--****************************************************************
sgs.glory_info["MouLveGuoRen"] = {
	name = "MouLveGuoRen",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "MouLveGuoRen_data",
	keys = {
		"maxhp3",
	}
}
sgs.MouLveGuoRen_data = {}
sgs.ai_event_callback[sgs.NonTrigger].MouLveGuoRen = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameStart" then
		local list = player:getTag("1v1Arrange"):toStringList()
		table.insert(list, player:getGeneralName())
		for _,name in ipairs(list) do
			local general = sgs.Sanguosha:getGeneral(name)
			if general and general:getMaxHp() == 3 then
				addInfo("MouLveGuoRen", "maxhp3", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("MouLveGuoRen", "maxhp3", 0) >= 3 then
			addFinishTag("MouLveGuoRen")
		end
	end
end
--[[****************************************************************
	战功：勇猛过人
	描述：选择了3名4血武将并且获胜 (1v1)
]]--****************************************************************
sgs.glory_info["YongMengGuoRen"] = {
	name = "YongMengGuoRen",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "YongMengGuoRen_data",
	keys = {
		"maxhp4",
	},
}
sgs.YongMengGuoRen_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YongMengGuoRen = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameStart" then
		local list = player:getTag("1v1Arrange"):toStringList()
		table.insert(list, player:getGeneralName())
		for _,name in ipairs(list) do
			local general = sgs.Sanguosha:getGeneral(name)
			if general and general:getMaxHp() == 4 then
				addInfo("YongMengGuoRen", "maxhp4", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" and amWinner() then
		if getInfo("YongMengGuoRen", "maxhp4", 0) >= 3 then
			addFinishTag("YongMengGuoRen")
		end
	end
end
--[[****************************************************************
	战功：有勇无谋
	描述：以吕布、张飞、许褚为上场武将的情况下获胜 (1v1)
]]--****************************************************************
sgs.glory_info["YouYongWuMou"] = {
	name = "YouYongWuMou",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "YouYongWuMou_data",
	keys = {
		"lvbu",
		"zhangfei",
		"xuchu",
	},
}
sgs.YouYongWuMou_data = {}
sgs.ai_event_callback[sgs.NonTrigger].YouYongWuMou = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameStart" then
		local list = player:getTag("1v1Arrange"):toStringList()
		table.insert(list, player:getGeneralName())
		for _,name in ipairs(list) do
			if string.find(name, "lvbu") then
				setInfo("YouYongWuMou", "lvbu", 1)
			elseif string.find(name, "zhangfei") then
				setInfo("YouYongWuMou", "zhangfei", 1)
			elseif string.find(name, "xuchu") then
				setInfo("YouYongWuMou", "xuchu", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amGeneral("lvbu", false) then
			setInfo("YouYongWuMou", "lvbu", 1)
		end
		if amGeneral("zhangfei", false) then
			setInfo("YouYongWuMou", "zhangfei", 1)
		end
		if amGeneral("xuchu", false) then
			setInfo("YouYongWuMou", "xuchu", 1)
		end
		if amWinner() and getInfo("YouYongWuMou", "lvbu", 0) == 1 then
			if getInfo("YouYongWuMou", "zhangfei", 0) == 1 then
				if getInfo("YouYongWuMou", "xuchu", 0) == 1 then
					addFinishTag("YouYongWuMou")
				end
			end
		end
	end
end
--[[****************************************************************
	战功：智勇双全
	描述：以关羽、赵云、黄忠为上场武将的情况下获胜 (1v1)
]]--****************************************************************
sgs.glory_info["ZhiYongShuangQuan"] = {
	name = "ZhiYongShuangQuan",
	state = "验证通过",
	mode = "02_1v1",
	events = {sgs.NonTrigger},
	data = "ZhiYongShuangQuan_data",
	keys = {
		"guanyu",
		"zhaoyun",
		"huangzhong",
	},
}
sgs.ZhiYongShuangQuan_data = {}
sgs.ai_event_callback[sgs.NonTrigger].ZhiYongShuangQuan = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameStart" then
		local list = player:getTag("1v1Arrange"):toStringList()
		table.insert(list, player:getGeneralName())
		for _,name in ipairs(list) do
			if string.find(name, "guanyu") then
				setInfo("ZhiYongShuangQuan", "guanyu", 1)
			elseif string.find(name, "zhaoyun") or name == "gaodayihao" then
				setInfo("ZhiYongShuangQuan", "zhaoyun", 1)
			elseif string.find(name, "huangzhong") then
				setInfo("ZhiYongShuangQuan", "huangzhong", 1)
			end
		end
	elseif cmd == "gloryGameOverJudge" then
		if amGeneral("guanyu", false) then
			setInfo("ZhiYongShuangQuan", "guanyu", 1)
		end
		if amGeneral("zhaoyun|gaodayihao", false) then
			setInfo("ZhiYongShuangQuan", "zhaoyun", 1)
		end
		if amGeneral("huangzhong", false) then
			setInfo("ZhiYongShuangQuan", "huangzhong", 1)
		end
		if amWinner() and getInfo("ZhiYongShuangQuan", "guanyu", 0) == 1 then
			if getInfo("ZhiYongShuangQuan", "zhaoyun", 0) == 1 then
				if getInfo("ZhiYongShuangQuan", "huangzhong", 0) == 1 then
					addFinishTag("ZhiYongShuangQuan")
				end
			end
		end
	end
end
--[[****************************************************************
	----------------------------------------------------------------
							虎牢关模式战功
	----------------------------------------------------------------
]]--****************************************************************
--[[****************************************************************
	战功：屌丝的逆袭
	描述：身为虎牢关联军的先锋，第一回合就爆了虎牢布的菊花（使吕布变身为暴怒战神）
]]--****************************************************************
sgs.glory_info["DiaoSiDeNiXi"] = {
	name = "DiaoSiDeNiXi",
	state = "验证通过",
	once_only = true,
	mode = "04_1v3",
	events = {sgs.NonTrigger, sgs.EventPhaseStart},
	data = "DiaoSiDeNiXi_data",
	keys = {
		"turn",
	},
}
sgs.DiaoSiDeNiXi_data = {}
sgs.ai_event_callback[sgs.NonTrigger].DiaoSiDeNiXi = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryDamageDone_Source" and isTarget(player) and player:getSeat() == 2 then
		if getInfo("DiaoSiDeNiXi", "turn", 0) == 0 then
			local damage = self.room:getTag("gloryData"):toDamage()
			local lvbu = damage.to
			if lvbu:getRole() == "lord" then
				if lvbu:getHp() - damage.damage <= 4 then
					addFinishTag("DiaoSiDeNiXi")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.EventPhaseStart].DiaoSiDeNiXi = function(self, player, data)
	if player:getPhase() == sgs.Player_NotActive and isTarget(player) then
		addInfo("DiaoSiDeNiXi", "turn", 1)
	end
end
--[[****************************************************************
	----------------------------------------------------------------
								隐藏战功
	----------------------------------------------------------------
]]--****************************************************************
--[[****************************************************************
	战功：神话
	描述：使用马谡，通过发动一次“心战”技能获得三张【桃】或三张【无中生有】
]]--****************************************************************
sgs.glory_info["vShenHua"] = {
	name = "vShenHua",
	state = "验证通过",
	mode = "all_modes",
	general = "masu",
	events = {sgs.ChoiceMade, sgs.CardFinished},
	data = "vShenHua_data",
	keys = {
		"peach",
		"ex_nihilo",
	},
}
sgs.vShenHua_data = {}
sgs.ai_event_callback[sgs.ChoiceMade].vShenHua = function(self, player, data)
	local msg = data:toString():split(":")
	if #msg > 0 then
		if msg[1] == "AGChosen" and msg[2] == "xinzhan" then
			if isTarget(player) and isGeneral(player, "masu", false) then
				local id = tonumber(msg[3])
				local card = sgs.Sanguosha:getCard(id)
				if card:isKindOf("Peach") then
					addInfo("vShenHua", "peach", 1)
				elseif card:isKindOf("ExNihilo") then
					addInfo("vShenHua", "ex_nihilo", 1)
				else
					return 
				end
				if getInfo("vShenHua", "peach", 0) >= 3 then
					addFinishTag("vShenHua")
				elseif getInfo("vShenHua", "ex_nihilo", 0) >= 3 then
					addFinishTag("vShenHua")
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.CardFinished].vShenHua = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("XinzhanCard") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			setInfo("vShenHua", "peach", 0)
			setInfo("vShenHua", "ex_nihilo", 0)
		end
	end
end
--[[****************************************************************
	战功：传说
	描述：使用陆逊，在装备连弩的一个回合中，连续使用了44张【杀】并杀死至少一名其他角色
]]--****************************************************************
sgs.glory_info["vChuanShuo"] = {
	name = "vChuanShuo",
	state = "验证通过",
	mode = "all_modes",
	general = "luxun|luboyan",
	events = {sgs.EventPhaseChanging, sgs.CardsMoveOneTime, sgs.PreCardUsed, sgs.NonTrigger},
	data = "vChuanShuo_data",
	keys = {
		"crossbow",
		"slash",
		"kill",
	},
}
sgs.vChuanShuo_data = {}
sgs.ai_event_callback[sgs.EventPhaseChanging].vChuanShuo = function(self, player, data)
	local change = data:toPhaseChange()
	if change.from == sgs.Player_NotActive then
		if isTarget(player) then
			if player:hasWeapon("crossbow") or player:hasWeapon("vscrossbow") then
				setInfo("vChuanShuo", "crossbow", 1)
			else
				setInfo("vChuanShuo", "crossbow", 0)
			end
			setInfo("vChuanShuo", "slash", 0)
			setInfo("vChuanShuo", "kill", 0)
		end
	elseif change.to == sgs.Player_NotActive then
		if isTarget(player) then
			if isGeneral(player, "luxun|luboyan", false) then
				if getInfo("vChuanShuo", "slash", 0) >= 44 and getInfo("vChuanShuo", "crossbow", 0) == 1 then
					if getInfo("vChuanShuo", "kill", 0) >= 1 then
						addFinishTag("vChuanShuo")
						return 
					end
				end
			end
			setInfo("vChuanShuo", "crossbow", 0)
			setInfo("vChuanShuo", "slash", 0)
			setInfo("vChuanShuo", "kill", 0)
		end
	end
end
sgs.ai_event_callback[sgs.CardsMoveOneTime].vChuanShuo = function(self, player, data)
	local move = data:toMoveOneTime()
	if move.to_place == sgs.Player_PlaceEquip then
		local target = move.to
		if target and target:objectName() == player:objectName() and isTarget(player) then
			for index, id in sgs.qlist(move.card_ids) do
				local weapon = sgs.Sanguosha:getCard(id)
				if weapon:isKindOf("Crossbow") or weapon:isKindOf("VSCrossbow") then
					setInfo("vChuanShuo", "crossbow", 1)
					return 
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].vChuanShuo = function(self, player, data)
	local use = data:toCardUse()
	if use.card:isKindOf("Slash") then
		local source = use.from
		if source and source:objectName() == player:objectName() and isTarget(player) then
			if isGeneral(player, "luxun|luboyan", false) then
				addInfo("vChuanShuo", "slash", 1)
				if getInfo("vChuanShuo", "slash", 0) >= 44 and getInfo("vChuanShuo", "crossbow", 0) == 1 then
					if getInfo("vChuanShuo", "kill", 0) >= 1 then
						addFinishTag("vChuanShuo")
					end
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].vChuanShuo = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge_Killer" and isTarget(player) and isGeneral(player, "luxun|luboyan", false) then
		local death = self.room:getTag("gloryData"):toDeath()
		if death.who:objectName() ~= player:objectName() then
			addInfo("vChuanShuo", "kill", 1)
			if getInfo("vChuanShuo", "slash", 0) >= 44 and getInfo("vChuanShuo", "crossbow", 0) == 1 then
				if getInfo("vChuanShuo", "kill", 0) >= 1 then
					addFinishTag("vChuanShuo")
					return 
				end
			end
		end
	end
end
--[[****************************************************************
	战功：不可能完成的任务
	描述：使用于禁，在第一个回合结束之前，还未使用任何牌就启用“托管”功能直至游戏结束，然后在队友全部阵亡的条件下存活并获得胜利
]]--****************************************************************
sgs.glory_info["vBuKeNengWanChengDeRenWu"] = {
	name = "vBuKeNengWanChengDeRenWu",
	state = "验证通过",
	once_only = true,
	mode = "all_modes",
	general = "yujin",
	events = {sgs.TurnStart, sgs.EventPhaseChaning, sgs.PreCardUsed, sgs.ChoiceMade, sgs.NonTrigger},
	data = "vBuKeNengWanChengDeRenWu_data",
	keys = {
		"turn",
		"start",
		"fail",
	},
}
sgs.vBuKeNengWanChengDeRenWu_data = {}
sgs.ai_event_callback[sgs.TurnStart].vBuKeNengWanChengDeRenWu = function(self, player, data)
	if isTarget(player) then
		addInfo("vBuKeNengWanChengDeRenWu", "turn", 1)
	end
end
sgs.ai_event_callback[sgs.EventPhaseChanging].vBuKeNengWanChengDeRenWu = function(self, player, data)
	local change = data:toPhaseChange()
	if change.to == sgs.NotActive and isTarget(player) and isGeneral(player, "yujin", false) then
		if player:getState() == "trust" and getInfo("vBuKeNengWanChengDeRenWu", "turn", 0) == 0 then
			if getInfo("vBuKeNengWanChengDeRenWu", "start", 0) == 0 then
				if getInfo("vBuKeNengWanChengDeRenWu", "fail", 0) == 0 then
					setInfo("vBuKeNengWanChengDeRenWu", "start", 1)
				end
			end
		end
	end
end
sgs.ai_event_callback[sgs.PreCardUsed].vBuKeNengWanChengDeRenWu = function(self, player, data)
	local use = data:toCardUse()
	local source = use.from 
	if source and source:objectName() == player:objectName() and isTarget(player) then
		if player:getState() == "trust" then
			if getInfo("vBuKeNengWanChengDeRenWu", "start", 0) == 0 then
				if getInfo("vBuKeNengWanChengDeRenWu", "turn", 0) == 0 then
					if getInfo("vBuKeNengWanChengDeRenWu", "fail", 0) == 0 then
						if isGeneral(player, "yujin", false) then
							setInfo("vBuKeNengWanChengDeRenWu", "start", 1)
						end
					end
				end
			end
		else
			if getInfo("vBuKeNengWanChengDeRenWu", "start", 0) == 0 then
				if not use.card:isKindOf("SkillCard") then
					setInfo("vBuKeNengWanChengDeRenWu", "fail", 1)
				end
			else
				setInfo("vBuKeNengWanChengDeRenWu", "fail", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.ChoiceMade].vBuKeNengWanChengDeRenWu = function(self, player, data)
	if isTarget(player) and getInfo("vBuKeNengWanChengDeRenWu", "start", 0) == 1 then
		if player:getState() == "trust" then
			if getInfo("vBuKeNengWanChengDeRenWu", "start", 0) == 0 then
				if getInfo("vBuKeNengWanChengDeRenWu", "turn", 0) == 0 then
					if getInfo("vBuKeNengWanChengDeRenWu", "fail", 0) == 0 then
						if isGeneral(player, "yujin", false) then
							setInfo("vBuKeNengWanChengDeRenWu", "start", 1)
						end
					end
				end
			end
		else
			if getInfo("vBuKeNengWanChengDeRenWu", "start", 0) == 1 then
				setInfo("vBuKeNengWanChengDeRenWu", "fail", 1)
			end
		end
	end
end
sgs.ai_event_callback[sgs.NonTrigger].vBuKeNengWanChengDeRenWu = function(self, player, data)
	local cmd = data:toString()
	if cmd == "gloryGameOverJudge" and amAlive() and amGeneral("yujin", false) and amWinner() then
		local me = getTarget()
		if me:getState() == "trust" and getInfo("vBuKeNengWanChengDeRenWu", "fail", 0) == 0 then
			local others = self.room:getOtherPlayers(me)
			for _,p in sgs.qlist(others) do
				if isSameCamp(p, me) then
					return 
				end
			end
			addFinishTag("vBuKeNengWanChengDeRenWu")
		end
	end
end
--[[****************************************************************
	战功：战功之鬼
	描述：在“珍贵的经验”模式下选择以正确的姿势投降……
]]--****************************************************************
sgs.glory_info["vSuperMan"] = {
	name = "vSuperMan",
	state = "验证通过",
	mode = "all_modes",
	events = {},
	data = "vSuperMan_data",
	keys = {},
}
sgs.vSuperMan_data = {}