# 战功荣耀

这是太阳神三国杀的一个功能扩展包，用于统计玩家的战功，增加游戏乐趣。

由于曾经有网友表示很怀念神杀V1版本和V2早期版本的战功包，对当时不支持原战功包的神杀版本有所不满；因此为满足其需求，安抚其情绪，特制作此扩展包。

这个扩展包在内容上只是对原战功包（作者：haveatry823）中各项游戏功能的再现。另外，由于某些技术上的原因，其中有关战绩统计的部分尚未彻底完成。

# 有关技能钥匙

收人头攒技能，然后开局失去1点体力获得一个技能，都是原战功包里就有的功能。

此扩展包只是做了一点名称和描述上的美化，于是形成了“技能钥匙”的概念。——但本质还是一样的。

可以在 lua/ai/glory-ai.lua 中的“控制参数”中修改 EnableExtraSkill 项的值来开启或关闭此功能。

至于已获得的技能钥匙的数量，可以在 glory/data/glory-data.ini 的最后一行找到。

# 注意事项

只有当一局游戏正常结束时，该局之中所获得战功才会被实际记录到数据文件中。

由于部分战功涉及多个时机，因此某些通过抛出异常等特殊的程序行为实现的技能，可能会导致战功记录不准确。

# 下载链接

- 对应神杀版本：[V2 - 20150405](https://github.com/DGAH-works/glory/archive/20150405.zip)（愚人版·清明补丁）
