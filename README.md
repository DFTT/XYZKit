# XYZKit
通用控件、扩展、工具类等的集合

### 功能列表
- [x] ```XYZKit/Core```一些UIKit/Foundation的扩展, 便于开发时使用, 持续补充中...
- [x] ```XYZEmptyBoard```一个空视图, 样式通用
- [x] ```XYZFloatDragView```一个可拖拽的悬浮窗, 处理了SafeArea / 自动吸边
- [x] ```XYZSMSCodeInputView```一个验证码输入视图
- [x] ```XYZbadgeView```小红点角标
- [x] ```XYZMsgBuffer```消息缓冲, 避免高频触发action导致的性能问题(target -> 缓冲器 -> action)
- [x] ```XYZLinkView```文本中部分文字区域可点击(基于UITextView)
- [x] ```XYZGuideView```新功能引导, 蒙层掏洞之类的
- [ ] ```XYZCellLogUtil```cell展现/点击日志工具类


### 安装
可以根据需要自主选择需要导致的模块
```
source 'https://github.com/DFTT/XYZPodspecs.git'
# 仅导入 Core
pod 'XYZKit'
# XYZEmptyBoard
pod 'XYZKit/XYZEmptyBoard'
# XYZFloatDragView
pod 'XYZKit/XYZFloatDragView'
# XYZSMSCodeInputView
pod 'XYZKit/XYZSMSCodeInputView'
# XYZBadgeView
pod 'XYZKit/XYZBadgeView'
```
