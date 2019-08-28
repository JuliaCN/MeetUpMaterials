# V5RPC.jl: Julia与仿真足球机器人5v5竞赛

## 简介
Fira 5v5是一项较为普及的仿真机器人赛事，比赛双方使用程序设计语言编写比赛策略，控制己方的5个轮式机器人进行足球比赛。因为原有的比赛平台已有多年历史，需要改进，西北工业大学V5++团队开发了一个新的开源仿真平台[Simuro5v5](https://github.com/npuv5pp/Simuro5v5)，并已经开始在国内的赛事上应用。

新平台使用的比赛策略接口为[V5RPC](https://github.com/npuv5pp/V5RPC)，它是一个基于C/S架构的自定义通信协议，相比老平台的DLL策略加载方式具有许多优良特性，如跨平台、可网络对战、稳定性好等。

[V5RPC.jl](https://github.com/azurefx/V5RPC.jl)是这个接口在开发阶段的原型，使用Julia快速实现。Julia 1.3 rc1的发布完善了UDP套接字的接口，因此我发布了这个包的第一个可用版本，使Julia编写的策略可以无缝接入比赛平台。我此次的演讲一方面是提供了Julia在网络IO方面比较好的例子，另一方面也展示了Julia在科学计算领域以外的有趣应用和潜力。

## 关于示例项目
演讲中使用的代码可以在此存储库中下载。将当前工作目录切换到`demo`文件夹后，执行
```julia
(v1.x) pkg> activate .

(demo) pkg> instantiate
```
可以初始化该项目，随后执行
```julia
julia> include("run.jl")
```
即可运行示例代码。默认的代码会在UDP`20000`和`20001`端口分别启动两个策略。打开比赛平台后，依次点击`Game`>`Strategy`>`Begin`加载策略，然后点击`New Match`和`Resume`按钮即可开始比赛。详细的操作方法可以查看比赛平台的文档。

使用`V5RPC.jl`编写策略的方法很简单，只需三步：
1. 定义自己的策略类型，作为`Strategy`的子类型。例如
```julia
mutable struct MyStrategy <: Strategy
    # Place your global state here
end
```
2. 为策略类型实现需要用到的方法。例如
```julia
function V5RPC.get_instruction(::MyStrategy, ::V5RPC.Field)
    # Write your strategy code
end
```
3. 构造一个`V5Server`，并用`run`运行它。例如
```julia
run(V5Server(MyStrategy(), 20000))
```
剩下的事情由`V5RPC.jl`完成。

`V5RPC.jl`中的`run`方法可以加上`@async`作为一个`Task`启动。如要停止一个`Task`的运行，可以使用`schedule`方法在协程内引发一个`InterruptException`异常。

示例代码中注释掉的绘图部分需要额外依赖`Makie.jl`包，它是一个可以使用GPU的高性能绘图库，适合绘制实时更新的图表。
