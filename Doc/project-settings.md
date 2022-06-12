# Project Settings

注意修改尽量在Project里面改 这样修改会自动继承到每个Target中

## 头文件搜索

因为希望在Swift代码和Shader代码中共享数据结构，因此需要将共享的数据结构定义在`.h`头文件中。在工程中相应的需要添加头文件搜索路径：

### Shader

Project > Build Settings > Metal Compiler - Build Options > Header Search Paths > add `${PROJECT_NAME}` check recursive

这样项目内的所有`.h`文件都能被搜索到，修改文件位置也不会导致需要重新修改项目配置

### Swift

Project > Build Settings > Swift Compiler - General > Objective-C Bridging Header > `$(PROJECT_NAME)/Bridge/Bridging-Header.h`

在`Bridging-Header.h`这个文件中include需要的`.h`文件即可
