
在启用插件后，右侧会多一个MT栏, 增强godot编辑复杂字段的能力

`ok`保存内容, `^`进入webview弹框编辑

需要被插件支持的类和其页都要**自身或其某层父类**中有添加
```py
## MT插件支持
@export var meta_addon_mt_parse_property = true
```

要分页的类定义函数`func meta_addon_mt_pages():pass`

定义了函数`func meta_addon_mt_plain():pass`的类将编辑其`@export var text = "";`字符串字段

定义了函数`func meta_addon_mt_text():pass`的类将编辑其`@export var text = PackedStringArray(["12","34"]);`字符串数组字段



## webview


**更改弹框大小**  
在此文件的同目录创建webview.cmd文件. 内容填`start msedge --app="data:text/html,<html><body><script>window.moveTo(200,100);window.resizeTo(1600,960);window.location='http://127.0.0.1:24862/addons/mota/webview/build/blockly.html';</script></body></html>"`  
把其中的`resizeTo(1000,700)`改成合适的大小, 可以通过双击webview.cmd文件来测试直到满意, 然后在`菜单>项目>项目设置>插件 中点两次复选框来重启mota插件使更改生效`

**更换为chrome来查看webview窗口** (不能按钮弹框可用此方法解决)  
+ 方案1(不推荐): 在自己浏览器中输入`http://127.0.0.1:24862/addons/mota/webview/build/blockly.html`, 每次需要点按钮时不去点, 而是切到这个网页并刷新一次
+ 方案2(推荐): 参考`更改弹框大小`创建webview.cmd文件. 然后把其中的`start msedge`改成你的chrome.exe的完整路径名, 最后结果类似与`"C:\Program Files\Google\Chrome\Application\chrome.exe" --app="data:text/html,<html><body><script>window.moveTo(200,100);window.resizeTo(1600,960);window.location='http://127.0.0.1:24862/addons/mota/webview/build/blockly.html';</script></body></html>"`

> ~~更改.g4文件后, 在webview/src目录`node g4tojs.js`编译后才能生效~~  
目前已经更改为不再依赖node, 编辑g4就会生效, EventAction.js现在仅供查看用
