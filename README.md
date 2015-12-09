# FinderSyncDemo
Finder Sync Demo for Mac OS X

注意事项：
1.Finder Sync的menu不仅可以代码创建，也可以通过viewController从xib文件创建
2.Finder Sync的toolBar menu 和右键menu 发送消息时FIFinderSyncController 的selectedItemsURLs可能不同,右键menu时selectedItemsURLs最多会是你选中的前10个,要特别注意。
3.Finder Sync在debug时要注意不要冲突，尽量删掉你的APP的其他备份，有问题时重启Finder也是需要的。
4.不要再项目设置里把Code sign设置为Don't code sign！不然将无法启动这个扩展，你可以把它设为"-"。

![Screenshot](https://raw.githubusercontent.com/BokkkRottt/FinderSyncDemo/master/屏幕截图%202015-12-09%2017.34.24.png "Demo Screenshot")
