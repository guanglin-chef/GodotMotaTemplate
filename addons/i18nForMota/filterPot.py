import polib
import re

# 加载.pot文件
pot = polib.pofile("../../locale/message.pot")

# 编译正则表达式
pattern = re.compile(r'([\u4e00-\u9fa5\uff00-\uffef\u3000-\u303f\u2026]+)')

# 过滤条目
# filtered_entries = [entry for entry in pot if entry.msgid and pattern.search(entry.msgid)]
filtered_entries=[]
path_prefix='../'
for entry in pot:
    # 检查msgid是否匹配正则表达式
    if entry.msgid and pattern.search(entry.msgid):
        # 修改源文件路径（occurrences）
        if entry.occurrences:
            modified_occurrences = []
            for filepath, line_num in entry.occurrences:
                # 在每个文件路径前添加前缀
                modified_filepath = path_prefix + filepath
                if line_num=='':line_num='0' # 之后在考虑匹配一下标成正确的行号
                modified_occurrences.append((modified_filepath, line_num))
            
            # 更新条目的occurrences
            entry.occurrences = modified_occurrences
        
        filtered_entries.append(entry)

# 创建新的PO文件
new_pot = polib.POFile()
new_pot.metadata = pot.metadata.copy()
new_pot.encoding = pot.encoding

for entry in filtered_entries:
    new_pot.append(entry)

# 保存文件
new_pot.save("../../locale/message.pot")
print(f"原条目数: {len(pot)}, 过滤后: {len(new_pot)}")