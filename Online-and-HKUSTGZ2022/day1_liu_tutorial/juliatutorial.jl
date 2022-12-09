### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ ee916ff8-c4f8-4dfb-83c5-12d1ab95f111
using Pkg

# ╔═╡ cf0eb0cd-bcb7-4f7c-b462-bef13d3c2a97
using Libdl

# ╔═╡ c73baba2-9ec7-461e-b4e7-fd162606e134
using BenchmarkTools

# ╔═╡ 9954c036-d4d3-42c9-acbf-22623f84f254
using PyCall

# ╔═╡ 832f83a0-94af-4649-80a0-21dd75d01da7
using MethodAnalysis

# ╔═╡ 9cc6445c-cc12-4a75-8415-9591c5491e6e
using Test

# ╔═╡ 49797f42-1477-47d6-8b35-3a742f2e64bd
using TropicalNumbers

# ╔═╡ d5d44e77-934f-4f0c-af1b-d89f0778142d
using Yao

# ╔═╡ 7d242d2a-d190-4a11-b218-60650ba70533
using PlutoUI

# ╔═╡ 52c27043-31c2-4e90-b6a5-d858aa7056d4
using AbstractTrees

# ╔═╡ 1cc46cad-91c8-4812-95b3-02c9979adbbc
using Luxor

# ╔═╡ 713939c6-4fe6-11ed-3e49-6bcc498b82f2
md"""
# 给 Julia 开发者的入门教程
"""

# ╔═╡ 8225e1a9-ee2f-454d-b4c1-84568b10bb1b
md"""
# 元信息
* 12 月 3 日 - 新手教程
* 12 月 4 日 - **黑客松 （hackathon）, 香港科技大学广州**
![](https://cn.julialang.org/meetup-website/assets/hackathon.png)
* 12 月 5-9 日晚 - 主题报告

    * 国际之夜（英语）
    * 语言与编译器之夜
    * 科学之夜
    * 量子之夜
    * 新人之夜

会议网址是： [https://cn.julialang.org/meetup-website/2022/](https://cn.julialang.org/meetup-website/2022/)

$(html"<img src='https://discourse.juliacn.com/uploads/default/original/2X/1/1cf10a356b5bbb37bb20cc765ab72f27d5e1366d.png' style='margin-left:-300px;'/>")
"""

# ╔═╡ 915a6f21-1d94-4aed-aaa3-3a58a34264d3
md"""## 看教程之前
以下内容不会在教程中涉及，但是非常重要。

1. 如何配置 Julia 语言环境 (Julia, VSCode, Revise, 软件源)
    * [How to develop a Julia package](https://julialang.org/contribute/developing_package/) - Chris Rackauchas
    * [Julia 模块-远程开发](https://discourse.juliacn.com/t/topic/6806) - 王至宏

2. 您最好对 Git 和 [GitHub](https://github.com/) 有基本的了解， 以便理解 Julia 的软件包管理系统。 相关资料：[Missing Semester](https://missing.csail.mit.edu/2020/)
"""

# ╔═╡ b92957bf-eeb2-4d2a-933d-77baad5c6eef
md"""离线使用此教程的小贴士：你需要配置 [Pluto notebook](https://github.com/fonsp/Pluto.jl) 以在便本地打开该教程， 该教程将会上传到会议网站。
"""

# ╔═╡ b89ac84e-4d15-4c9c-b809-35465d2e0435
md"""## 调查
你用什么编程语言?
"""

# ╔═╡ 8e7f15fd-ae65-4559-972a-2c9720ac1547
md"# Julia 是什么样的语言?"

# ╔═╡ 73ce1dff-a3ff-431b-9acb-7af6c00b35f6
md"""
## 源代码开放的现代高性能语言

Julia 于2012年在 MIT 诞生。Julia 语言的解释/编译器的源代码是开放的，被托管在 [Github 仓库](https://github.com/JuliaLang/julia) 中，其软件协议为可商用的 MIT 协议。 不仅 Julia 语言如此， 大多 Julia 的软件包系统也依托 Github 管理， 其协议也大多为开源。

Julia 语言被设计出来的目的是为了兼顾代码执行速度与开发效率.

* 执行速度: C, C++, Fortran
* 开发效率: Python, $(html"Matlab")
"""

# ╔═╡ a72f4263-b034-4aa8-8611-d53166cbb718
md"""
# Julia 的软件生态
"""

# ╔═╡ bc2508c7-ec41-4325-9ce0-c7737c99db64
md"所有的软件包都可以在[JuliaHub](https://juliahub.com/ui/Packages)上找到相关统计。"

# ╔═╡ 706af77e-ce1f-4334-8dbb-d6d5cbcdef18
md"""
## 科学计算生态
"""

# ╔═╡ b109f0d3-4cde-4f41-b26e-e43ed6e048fe
md"### [SciML](https://github.com/SciML) ecosystem
微分方程的求解
[![](https://camo.githubusercontent.com/97bf407cc473d22b3d9ef63c861e8dba6dd3b4579728c342c49be86b48ea180e/687474703a2f2f7777772e73746f636861737469636c6966657374796c652e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031392f30382f64655f736f6c7665725f736f6674776172655f636f6d70617273696f6e2d312e706e67)](https://camo.githubusercontent.com/97bf407cc473d22b3d9ef63c861e8dba6dd3b4579728c342c49be86b48ea180e/687474703a2f2f7777772e73746f636861737469636c6966657374796c652e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031392f30382f64655f736f6c7665725f736f6674776172655f636f6d70617273696f6e2d312e706e67)
"

# ╔═╡ f58dbbda-7445-41ba-aa23-5435dbf688c9
md"""### [JuMP](https://github.com/jump-dev) ecosystem
Linear Programming, Mixed Integer Programming, Quadratic Programming 等。
![](https://user-images.githubusercontent.com/6257240/204845810-702108b0-e5db-4b5c-9378-0aa0896af6de.png)
"""

# ╔═╡ 7a3b16e3-3870-4045-9549-9844698cf3d5
md"### [Yao](https://github.com/QuantumBFS) ecosystem
Quantum Computing
"

# ╔═╡ c5e7337a-85c6-430a-8746-9826325c80d5
md"""
![](https://github.com/Roger-luo/quantum-benchmarks/raw/master/images/pcircuit.png)
"""

# ╔═╡ f1f3f07d-bc38-4d01-b9cb-f843c160cb3f
md"""
还有更多有趣的软件生态，包括 [BioJulia](https://github.com/BioJulia),
[JuliaDynamics](https://github.com/JuliaDynamics),
[EcoJulia](https://github.com/EcoJulia),
[JuliaAstro](https://github.com/JuliaAstro),
[QuantEcon](https://github.com/QuantEcon).
"""

# ╔═╡ 2b1c00b1-eb58-4b99-829f-5b98689132ad
md"## 高性能计算生态"

# ╔═╡ 931bb099-60b9-4542-ac53-3757fb269fff
md"""
### [CUDA](https://github.com/JuliaGPU/CUDA.jl) ecosystem
CUDA programming in Julia.

![](https://juliagpu.org/assets/img/cuda-performance.png)
"""

# ╔═╡ 26348f56-c4bf-4ec8-a429-773d60525364
md"""
### [LoopVectorization](https://github.com/JuliaSIMD/LoopVectorization.jl) ecosystem
Macro(s) for vectorizing loops (SIMD).
![](https://raw.githubusercontent.com/JuliaSIMD/LoopVectorization.jl/docsassets/docs/src/assets/bench_dot_v2.svg)

TropicalGEMM: A BLAS for tropical numbers.
![](https://github.com/TensorBFS/TropicalGEMM.jl/raw/master/benchmarks/benchmark-float64.png)
"""

# ╔═╡ ff0a8030-9a18-4d27-9a87-bed9aed0d2a8
md"## 编译语言快的秘诀"

# ╔═╡ fe174dbe-5c4b-4445-b485-5c21cc1e8917
md"静态类型程序的执行很快，因为类型信息被提前知道就可以被高效的编译。"

# ╔═╡ 33a43668-4484-47d2-a7a6-09d930232252
# compile to a shared library by piping C_code to gcc;
# (only works if you have gcc installed)
run(`gcc clib/demo.c -fPIC -O3 -msse3 -shared -o clib/demo.so`)

# ╔═╡ 2a22f131-6a99-4744-8914-19c8776700e7
c_factorial(x) = Libdl.@ccall "clib/demo".c_factorial(x::Csize_t)::Int

# ╔═╡ a9c2ff4c-a32b-4bb5-aef3-cf378453587a
c_factorial(10)

# ╔═╡ 25534efa-c0f1-4c7f-9575-f0c7c8dbf634
c_factorial(1000)

# ╔═╡ 01972597-9d31-4972-a15d-51832f0f5910
@benchmark c_factorial(1000)

# ╔═╡ 917e187d-5eda-49d6-a72a-0ed3f60d82d6
md"[learn more about calling C code in Julia](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)"

# ╔═╡ ab045ed0-7cbb-4565-bd7f-239dd94ce99e
md"## 解释语言方便的秘诀"

# ╔═╡ f3695873-435d-44cb-b9fb-af34dc38bdaa
md"动态类型的语言不需要被编译"

# ╔═╡ 0f526702-f8e6-492d-bd14-e81874e6fefe
# py"..." is a string literal, it is defined as a special macro: @py_str
py"""
def factorial(n):
	x = 1
	for i in range(1, n+1):
	    x = x * i
	return x
"""

# ╔═╡ 46cf6881-650e-4ba1-a0dc-bcda67fb367b
py"factorial"(1000)

# ╔═╡ 922a2063-f516-46a5-95a9-9e0adca018aa
# `typemax` 可以获取类型的最大值
typemax(Int)

# ╔═╡ 105852eb-8f34-4d52-8ec3-68dff6997efb
md"🤔"

# ╔═╡ e6fd7a35-e45e-4cc7-ae24-7c2f8fd7c73d
md"但由于数据没有固定的类型，解释执行的语言必须用一个`Box(type, *data)`来表示一个数据。"

# ╔═╡ 79e3c220-c281-4ab0-988a-39e1b0a39d64
@benchmark $(py"factorial")(1000)

# ╔═╡ f7e5304d-7573-4e8c-b516-4c16a7432067
md"""## 双语言 **Python & C++** 的问题?
### 可维护性变差
* 配置 setup 文件更加复杂, 平台移植性变差，
* 培养新人成本过高,

### 非常适合张量运算, 但很多程序抽象发生在底层
* 蒙特卡洛 (Monte Carlo) 和模拟退火 (Simulated Annealing) 方法, 频繁多变的随机数生成和采样
* 范型张量网络 (Generic Tensor Network), 张量中的标量类型的基本元素非实数, 而是 tropical number 或者有限域 (Finite Field Algebra)
* 组合优化中的分支界定法 (branching)

![](https://user-images.githubusercontent.com/6257240/200309092-6a138366-ac52-47e5-a010-47711612632b.png)
"""

# ╔═╡ be4da897-df85-4276-bde1-7c1824cae796
md"""
## Julia 函数被编译的过程
### 1. 拿到一段 Julia 程序
"""

# ╔═╡ 13bcf3d6-2418-46e1-acde-050914064741
function jlfactorial(n::Int)
	x = 1
	for i in 1:n
    	x = x * i
	end
	return x
end

# ╔═╡ 70fc53ba-70c5-4ae4-877c-f8e47569adc4
md"""
### 2. 当遇到调用，在 Julia 的中间表示 (Intermediate Representation) 上推导数据类型
"""

# ╔═╡ 5b5e337e-c7e2-4c90-966e-62dc48a9cf28
with_terminal() do
	@code_warntype jlfactorial(10)
end

# ╔═╡ 2f36c4e6-1fc5-42e9-b097-315b28f82d5d
md"""
### 3. 将带类型的程序编译到 LLVM 中间表示上
$(html"<img src='https://upload.wikimedia.org/wikipedia/en/d/dd/LLVM_logo.png' width=200/>")
"""

# ╔═╡ fb53a9ed-df58-410a-8275-e15718514950
md"""
LLVM 是很多语言的后端，如 Julia, Rust, Swift, Kotlin 等.
"""

# ╔═╡ e5b59cc9-0d14-4d8a-bb25-738540e7ebf9
with_terminal() do 
	@code_llvm jlfactorial(10)
end

# ╔═╡ 8e109ec4-6b21-454b-ad7b-e30cef6d14bd
md"""
### 4. LLVM 在这个中间表示的基础上生成高性能的汇编/二进制码
"""

# ╔═╡ 7b8e9026-6dc1-4d28-a2a7-912399a4fd51
with_terminal() do
	@code_native jlfactorial(10)
end

# ╔═╡ 4253af25-41bd-47b6-a11e-c2902c677963
jlfactorial(1000)

# ╔═╡ ec33aba5-28c9-4be9-9804-361f65de1f7a
@benchmark jlfactorial(x) setup=(x=1000)

# ╔═╡ 0ef8831d-62c3-47b5-9f6e-3d9322da8e16
md"## 案例分析： 查看 Method instances"

# ╔═╡ 3e3a2f23-8098-4d06-b4d1-157c97e4c094
md"函数实例 (method instance)： 内存中，一个针对特定输入类型的函数被编译后的二进制码。"

# ╔═╡ 9ccbc920-ae8f-4b65-bf7e-273fce9deb99
md"有时候类型无法在编译期间被完全定下来。"

# ╔═╡ 3adea2f8-3f59-45d5-9e03-7285c7571c1d
with_terminal() do
	unstable(x) = x > 3 ? 1.0 : 3
	@code_warntype unstable(4)
end

# ╔═╡ e34c636f-ae8f-46c3-a043-08c0408b3433
md"""
## 函数应不应该属于对象？
假设我们想在 python 中实现一个加法。
```python
class X:
  def __init__(self, num):
    self.num = num

  def __add__(self, other_obj):
    return X(self.num+other_obj.num)

  def __radd__(self, other_obj):
    return X(other_obj.num + self.num)

  def __str__(self):
    return "X = " + str(self.num)

class Y:
  def __init__(self, num):
    self.num = num

  def __radd__(self, other_obj):
    return Y(self.num+other_obj.num)

  def __str__(self):
    return "Y = " + str(self.num)

print(X(3) + Y(5))


print(Y(3) + X(5))

```
"""

# ╔═╡ 5d05964f-ca08-4ef4-91d3-f78f990650b0
# Julian style
struct X{T}
	num::T
end

# ╔═╡ 8d218a48-de95-4a24-9cc2-f4970013182f
struct Y{T}
	num::T
end

# ╔═╡ 72d0e961-8699-4bd3-b2e1-3e9774536e74
Base.:(+)(a::X, b::Y) = X(a.num + b.num)

# ╔═╡ 91f32f59-f178-4041-8094-9803e868f674
Base.:(+)(a::Y, b::X) = X(a.num + b.num)

# ╔═╡ 24f9ad0c-0985-4a6b-bde9-b0a87574e188
Base.:(+)(a::X, b::X) = X(a.num + b.num)

# ╔═╡ d01b94b5-df3d-4a8f-a611-7d53499e6ee7
Base.:(+)(a::Y, b::Y) = Y(a.num + b.num)

# ╔═╡ 8c9af74a-f4ec-4b56-b560-2c8a77f5e4d9
md"""
现在我把这些代码打包做成了一个package，由个人问我他其实有个C，想拓展这个加法。
"""

# ╔═╡ 53fb47ff-c48a-41f4-9066-bd2c2af28dfd
md"""
```python
class Z:
  def __init__(self, num):
    self.num = num

  def __add__(self, other_obj):
    return Z(self.num+other_obj.num)

  def __radd__(self, other_obj):
    return Z(other_obj.num + self.num)

  def __str__(self):
    return "Z = " + str(self.num)

print(X(3) + Z(5))

print(Z(3) + X(5))
```
"""

# ╔═╡ 724e9f4a-7152-4916-8910-9696e8d4fd40
struct Z{T}
	num::T
end

# ╔═╡ 3d255fc3-7098-46f7-a103-d0da8fafff38
Base.:(+)(a::X, b::Z) = Z(a.num + b.num)

# ╔═╡ 6cfc75fe-569c-45b8-acb6-d757e57730e6
Base.:(+)(a::Z, b::X) = Z(a.num + b.num)

# ╔═╡ 7ef00148-1628-4066-b0c2-efe1c38afb67
Base.:(+)(a::Y, b::Z) = Z(a.num + b.num)

# ╔═╡ fb183df1-a578-44e2-94bc-7d04b5fe8ebb
Base.:(+)(a::Z, b::Y) = Z(a.num + b.num)

# ╔═╡ 30a44089-656a-4277-ab28-45610c329325
Base.:(+)(a::Z, b::Z) = Z(a.num + b.num)

# ╔═╡ 06c57cf8-e85c-4d4a-84fa-bd1b2cfd8301
@drawsvg begin
	x0 = -50
	for i=1:4
		y0 = 40 * i - 100
		box(Point(x0, y0), 50, 40; action=:stroke)
		box(Point(x0+50, y0), 50, 40; action=:stroke)
		setcolor("#88CC66")
		circle(Point(x0+120, y0), 15; action=:fill)
		setcolor("black")
		text("type", Point(x0, y0); halign=:center, valign=:center)
		text("*data", Point(x0+50, y0); halign=:center, valign=:middle)
		text("data", Point(x0+120, y0); halign=:center, valign=:middle)
		arrow(Point(x0+50, y0-10), Point(x0+70, y0-30), Point(x0+90, y0-30), Point(x0+110, y0-10), :stroke)
	end
end 200 200

# ╔═╡ 4e1b7044-ff2b-4eca-a549-a4cd736a93ee
X(3) + Y(5)

# ╔═╡ 17071f7d-e730-4248-8b0a-a3e7067ef1e1
Y(3) + X(5)

# ╔═╡ 8764fa70-9933-4e6d-a0a6-2567e1219c63
X(3) + Z(5)

# ╔═╡ 8e019f9b-8c9d-46d7-b10f-3985c46e2a88
Z(3) + Y(5)

# ╔═╡ c13cf4d5-f5a1-466c-b5f5-bc3fe6545e05
md"""
## Julia 的函数空间有指数大！
假如 $f$ 有 $k$ 个参数，类型空间一共定义了$t$个类型，请问函数空间有多大？
```jula
f(x::T1, y::T2, z::T3...)
```

如果是 Python 呢？
```python
class T1:
    def f(self, y, z, ...):
        self.num = num

```
"""

# ╔═╡ 36daaa7d-17a8-4523-8721-aad00f71f2e2
md"""## Julia 的类型系统
"""

# ╔═╡ 0b88d436-5a20-4936-8ced-a15bf1557ba0
md"""
类型分为
* primitive type: 无法被分解为其它类型的组合。
* abstract type： 抽象的类型，无成员变量。
* concrete type： 类型系统中的叶子节点，可为其分配内存。
"""

# ╔═╡ a8e1722b-89c3-46be-9488-33aa595c3126
md"""
例子：
"""

# ╔═╡ 30d83360-4d86-4df4-8543-8870841c45cc
# the definition of an abstract type
abstract type A end

# ╔═╡ 6e9f119e-e7c7-4549-81fb-9b85f6736b18
# the definition of a concrete type
struct C <: A
	member1::Float64
	member2::Int
end

# ╔═╡ fc0fdc48-db4c-40c7-9c45-e539512f5ee6
md"""
### Numbers
"""

# ╔═╡ d1b0b145-12e3-4a61-82d8-2a743ce02682
md"`<:`是subtype的意思， `A <: B`表示 A 是 B 的子集。"

# ╔═╡ 46cd1ee1-e269-46a7-93d3-72597b53a9a9
AbstractFloat <: Number

# ╔═╡ d61ab911-70e3-4305-8f21-99d254a39a27
md"`Any` 是任意类型的 parent"

# ╔═╡ a06e3ad6-baad-4bc6-ae84-8f6402cb4364
Number <: Any

# ╔═╡ 260aacc1-811b-495a-8e8c-645b23a97dcf
md"一个类型包括两个部分，类型名字和类型参数。"

# ╔═╡ fd424566-17a1-435c-bdbf-57f1991aacb2
# TypeName{type parameters...}
Complex{Float64}  # 由 64 位浮点数参数化的复数

# ╔═╡ 7a492b1c-4010-4a6d-99f1-ebe0944f7f56
fieldnames(Complex)

# ╔═╡ 6ef58185-0a33-40ae-b527-f416ec5460dc
Base.isprimitivetype(Float64)

# ╔═╡ cf83e44f-caf9-4c01-92f9-f31bb99cc1ee
Base.isabstracttype(AbstractFloat)

# ╔═╡ 00d52720-154f-47a4-a6be-f9ffe23b3aea
Base.isconcretetype(Complex{Float64})

# ╔═╡ eec8b97e-a8f1-45ed-bc9e-e0c7e4f65a05
md"提问： Complex 是不是 concrete type?"

# ╔═╡ 1e267a3f-e60d-49df-ba26-268423693c71
Base.isconcretetype(Complex)

# ╔═╡ ecccde43-c4f1-4a92-bda7-3940d5fd3afd
Base.isconcretetype(Complex{Float64})

# ╔═╡ c39dd2fb-dd37-40b3-b617-58e231325f9d
md"那么如何表达一个复数，它的实部和虚部都是浮点数？"

# ╔═╡ 61dbc39a-7cd7-4f30-8422-d6afe675f8bd
Complex{<:AbstractFloat}

# ╔═╡ 1e5acfcf-00e0-4595-a71d-94ad876b63de
Complex{Float64} <: Complex{<:AbstractFloat}

# ╔═╡ 6970b63a-83f9-4215-9f7a-e8d91593a192
Complex{Float64} <: Complex{AbstractFloat}

# ╔═╡ cefdbc63-367c-4af8-9bf1-e8999c37e677
md"猜猜是true还是false？"

# ╔═╡ 3309100b-a8f1-44e5-95d3-53660ea171ec
isconcretetype(Complex{AbstractFloat})

# ╔═╡ e2be9ff8-3f7f-4497-b8ae-3e5109ea0457
md"它们的区别很大！"

# ╔═╡ 9552f38a-b3ef-4010-b2b7-8384411f6922
vany = Any[]

# ╔═╡ 7897e41a-67c9-412f-9d27-eb6e9d8d4004
vany isa Vector{Any}

# ╔═╡ a6f963d9-2dff-40dc-9c11-a40a17032ce4
vany isa Vector{<:Any}

# ╔═╡ d1a5d1b1-c8f0-44c7-868c-4079667ee4e3
push!(vany, "a")

# ╔═╡ bf455f16-35a1-41b9-b39f-e55b57646475
vfloat64 = Float64[]

# ╔═╡ 948fcf3f-4d00-4849-91fa-bae0d9acefba
vfloat64 isa Vector{<:Any}

# ╔═╡ 337b770f-d97b-407a-a6c9-f5aa11e364fa
vfloat64 isa Vector{Any}

# ╔═╡ e9016f62-626e-443e-9166-dba66cdc8051
push!(vfloat64, "a")

# ╔═╡ f7e69afe-e8f5-4540-ba71-6df36faf4ce3
md"用 Union 代表两个类型的并集。"

# ╔═╡ 119c21c8-3b99-4de9-9edf-2daa7d1ccfad
Union{AbstractFloat, Complex} <: Number

# ╔═╡ cd701b2f-8dcf-4d4d-a8e4-5cc7b612dc77
Union{AbstractFloat, Complex} <: Real

# ╔═╡ 4329a285-c184-4f03-b90d-c8f74c072cd7
md"给类型起绰号"

# ╔═╡ 34d05cb5-a222-4705-9f29-4c902e0fb547
FloatAndComplex{T} = Union{T, Complex{T}} where T<:AbstractFloat

# ╔═╡ 85c3160f-962f-4b19-bfba-310054cb7fca
md"## 如何定义函数"

# ╔═╡ 69fed6cc-030b-4066-a023-0bbf1637fbbc
begin
	# fallback
	function roughly_equal(x::Number, y::Number)
		@info "(::Number, ::Number)"
		x ≈ y   # type with \approx<TAB>
	end
	function roughly_equal(x::AbstractFloat, y::Number)
		@info "(::AbstractFloat, ::Number)"
		-10 * eps(x) < x - y < 10 * eps(x)
	end
	function roughly_equal(x::Number, y::AbstractFloat)
		@info "(::Number, ::AbstractFloat)"
		-10 * eps(y) < x - y < 10 * eps(y)
	end
end

# ╔═╡ b3f72d4b-9f1f-46fd-8145-212f96c320f8
# `methods` is different from `methodinstances` in MethodAnalysis. It returns method definitions rather than compiled binaries.
methods(roughly_equal)

# ╔═╡ a79ac986-54ad-44c0-8aa6-077a6f34b6eb
roughly_equal(3.0, 3)  # case 1

# ╔═╡ 5e276fd0-887e-4de2-b502-359be36e6fb6
md"最具体的获胜"

# ╔═╡ 2ca96d5e-bc03-4c2a-aeaf-9d35c9ceb8c1
roughly_equal(3, 3)    # case 2

# ╔═╡ 5ea7d476-1217-4895-9064-b0327c7a3fdc
roughly_equal(3.0, 3.0)

# ╔═╡ 9b00810e-8dc8-4602-a185-28e60c027b99
md"""有时候，难论输赢。解决方式就是定义更加具体的实现：
```julia
function roughly_equal(x::AbstractFloat, y::AbstractFloat)
	@info "(::AbstractFloat, ::AbstractFloat)"
	-10 * eps(y) < x - y < 10 * eps(y)
end
```"""

# ╔═╡ ad965d41-ca74-4c3b-a81d-a3f0f1a2b1e4
md"猜，现在 `f` 有多少个函数实例？"

# ╔═╡ 7bce1278-ac0d-4918-aaea-fa69d8cdcf24
methodinstances(roughly_equal)

# ╔═╡ a94c8b67-94c8-4ba1-99fd-db891a805006
md"让类型参数保持一致。"

# ╔═╡ 34494ea7-d50a-48c0-8374-ca9482bc63f3
begin
	function lmul(x::Complex{T1}, y::AbstractArray{<:Complex{T2}}) where {T1<:Real, T2<:Real}
		@info "(::Complex{T1}, ::AbstractArray{<:Complex{T2}}) where {T1<:Real, T2<:Real}"
		x .* y
	end
	function lmul(x::Complex{T}, y::AbstractArray{<:Complex{T}}) where T<:Real
		@info "(::Complex{T}, ::AbstractArray{<:Complex{T}}) where T<:Real"
		x .* y
	end
end

# ╔═╡ 8cebd10b-8af7-4806-999a-204823c56eea
lmul(3.0im, randn(ComplexF64, 3, 3))

# ╔═╡ 6bccd6b6-0de1-4e4e-b6b4-99ed90580af7
lmul(3im, randn(ComplexF64, 3, 3))

# ╔═╡ 5736fc36-4e81-4672-99d2-7a23f212269c
md"""
## 小结
* Julia 的多重派发比面向对象提供了更多的抽象的可能（指数大）。
* 可以利用巧妙的类型系统设计，在指数大的函数空间中写代码。
"""

# ╔═╡ b7d2319f-3d14-4a12-ad2e-3d7845d919b8
md"""
# Julia的软件包开发
"""

# ╔═╡ 6850c93c-9bb9-49fe-8546-f3b0f45dc0f5
md"一个软件包的文件结构"

# ╔═╡ f8896020-c076-4373-895b-4332b3631380
project_folder = dirname(dirname(pathof(TropicalNumbers)))

# ╔═╡ 9447d362-04a4-4dc0-b215-4cbdbdaec9b3
md"""
## Unit Test
"""

# ╔═╡ 0223205c-2e44-4787-bf84-90abecd11542
let
	function circ(x0, text, r)
		setcolor("#88CC66")
		circle(x0, 0, r; action=:fill)
		setcolor("black")
		Luxor.text(text, x0, 0; halign=:center, valign=:middle)
	end
	@drawsvg begin
		circ(-150, "Correctness", 40)
		circ(-25, "Speed", 30)
		circ(100, "Others", 20)
		fontsize(30)
		text(">", -87, 0; halign=:center, valign=:middle)
		text(">", 37, 0; halign=:center, valign=:middle)
	end 400 100
end

# ╔═╡ 39c3a673-787e-4f00-ac71-f0279e0c9be7
@test Tropical(3.0) + Tropical(2.0) == Tropical(3.0)

# ╔═╡ bfc1690a-f5ec-4173-a9eb-ab0b1905b59c
@test_throws BoundsError [1,2][3]

# ╔═╡ c42d7cae-2d09-46cf-bb22-a09d17dd7bca
@test_broken 3 == 2

# ╔═╡ 4e8bbc37-5e4e-4669-ab13-0c88ae177490
@testset "Tropical Number addition" begin
	@test Tropical(3.0) + Tropical(2.0) == Tropical(3.0)
	@test_throws BoundsError [1][2]
	@test_broken 3 == 2
end

# ╔═╡ 56e8cee2-7a4e-4a9a-b297-b7c08b865db8
with_terminal() do
	Pkg.test("TropicalNumbers")
end

# ╔═╡ a008446c-079a-4571-a66b-c156eec72188
md"[了解更多](https://docs.julialang.org/en/v1/stdlib/Test/)"

# ╔═╡ fa78b65e-e3a2-49a8-b846-9827787de23e
md"""
## 版本控制与依赖
"""

# ╔═╡ d1b9aa30-ac64-4653-95b9-ab8695fbf34b
md"以量子计算软件包 Yao 为例， 它的依赖关系可以非常复杂。"

# ╔═╡ 5dbe18d9-e3a2-4997-a984-e13c70f34746
md"## PkgTemplates
"

# ╔═╡ 0a51a90b-72c8-4a69-a2d0-5b8d80137b92
md"""
## 案例分析: 快乐的分子
[https://github.com/CodingThrust/HappyMolecules.jl](https://github.com/CodingThrust/HappyMolecules.jl)
"""

# ╔═╡ 6b802c31-f0cd-4b92-9bb3-09aa15f01f8b
md"""
## 感谢
### 会议组织
* **刘贵欣**： 海报制作，报告人征募，活动宣传，直播
* 赵昱圣： 衣服，徽章，贴纸，证书
* 田俊，陈久宁和干则成： 会议赞助，报告人邀请和组织
* 集智小伙伴对直播与赞助的鼎力支持。
"""

# ╔═╡ d34ac2d6-bece-4643-b413-4053441af815
html"""
<h3>赞助商</h3>
<table style="width:80%" class="table-sponsor"> <tbody><tr> <td style="padding-right: 20px;"> <img src="https://cn.julialang.org/meetup-website/assets/partner.png"> <div>长期合作伙伴</div> </td><td> <div style="display:inline-block; text-align:center; margin-right:20px;"> <a href="https://swarma.org/" class="nounderline"><img src="https://cn.julialang.org/meetup-website/assets/jizhi.png" style="max-width:150px"></a> </div> <div style="display:inline-block; text-align:center"> <a href="https://www.bytedance.com/" class="nounderline"><img src="https://cn.julialang.org/meetup-website/assets/bytedance.webp" style="max-width:200px"></a> </div> </td></tr><tr> <td style="padding-right: 20px;"> <img src="https://cn.julialang.org/meetup-website/assets/gold.jpg"> <div>黄金赞助商</div> </td><td> <div style="display:inline-block; text-align:center"> <a href="https://www.tongyuan.cc/" class="nounderline"><img src="https://cn.julialang.org/meetup-website/assets/tongyuan.png" style="max-width:150px"></a> </div> </td></tr></tbody></table>
"""

# ╔═╡ 0efc54a1-3dbb-45ab-bede-77ab4669721d
md"""
## 手指肌肉训练
"""

# ╔═╡ ee8606f7-6f5d-430a-b111-84843de789d7
md"""
在 Julia REPL 中跟随这些视频输入以练习 Julia 的基础。
这些视频可以在[我的个人网站](https://giggleliu.github.io/code/#muscle_memory_1_basic_types_and_control_flow)
找到。这个notebook和相关资料将会上传到 JuliaCN org 下面的 Github repo: 

[https://github.com/JuliaCN/MeetUpMaterials](https://github.com/JuliaCN/MeetUpMaterials)
"""

# ╔═╡ 4704dbf6-e2e1-4b6b-8ed0-a9bdbbed5474
md"""
### 1. Basic types and control flow
"""

# ╔═╡ 2e124d1f-bdc2-4161-8ce1-9d2b722ab449
md"""
### 2. Array operations
"""

# ╔═╡ ea266c12-7e62-4c77-9682-0cf51c5e6695
md"""
### 3. Data types
"""

# ╔═╡ 05c7bb10-aacc-498a-b42f-52642648f92e
md"""
### 4. Function and multiple dispatch
"""

# ╔═╡ 0596e817-91b6-4a57-9323-8b998115d4ca
md"""
### 5. Performance Tips
"""

# ╔═╡ 0919dfcc-b344-4e4c-abfa-9c3914e2850b
md"## Pluto notebook 帮助函数"

# ╔═╡ 27310322-9276-49d4-bc28-d503b6354ce1
TableOfContents()

# ╔═╡ 156a1a62-e131-403f-b2a2-80f49e6a9b33
html"<button onclick=present()>Present</button>"

# ╔═╡ d0a8e05f-f147-45c7-b9b3-4a3f5bbe6dff
md"### print type tree"

# ╔═╡ 012b69d8-6304-4e91-9c0f-07fe3ad9980f
AbstractTrees.children(x::Type) = subtypes(x)

# ╔═╡ 88a8c21d-e5d3-4b88-a818-58f614d6f64e
_typestr(T) = T isa UnionAll ? _typestr(T.body) : T

# ╔═╡ 782a555d-caff-4096-a6e6-24e77565a2cf
function AbstractTrees.printnode(io::IO, x::Type{T}) where T
	print(io, _typestr(T))
end

# ╔═╡ d4a6f68e-b7da-4ca1-b43c-c2da7929cd3d
function print_type_tree(T; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, T; maxdepth)
	Text(String(take!(io)))
end

# ╔═╡ c04c4d58-0469-45cc-a217-444a2b607245
print_type_tree(Number)

# ╔═╡ e4bae9e0-c949-4f1f-8b69-14491246d2a3
print_type_tree(Number)

# ╔═╡ f1c77c14-81e7-4566-9b35-96e578e7c16d
md"### print directory tree"

# ╔═╡ 38340e67-5418-4570-a9af-d466c972ef9c
function AbstractTrees.children(path::Pair{String, String})
	base, fname = path
	full = joinpath(base, fname)
	isdir(full) || return Pair{String, String}[]
    return [base=>joinpath(fname, f) for f in readdir(full) if f !== ".git"]
end

# ╔═╡ 9f2e0149-9558-41f0-bc84-3ccb09786714
function AbstractTrees.printnode(io::IO, path::Pair{String, String})
	print(io, startswith(path.second, "./") ? path.second[3:end] : path.second)
end

# ╔═╡ 920ca137-4474-4c4d-96f7-2164b5386be3
function print_dir_tree(dir; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, dir=>"."; maxdepth)
	Text(String(take!(io)))
end

# ╔═╡ 75763b2b-d00f-46c0-b99e-257292c6bb96
print_dir_tree(project_folder)

# ╔═╡ 904364df-125e-4ea5-a7a3-cb5221022927
print_dir_tree("$(homedir())/.julia/dev/OMEinsum")

# ╔═╡ 40acbc0c-e92c-4183-b297-2ace43aa6042
md"### print dependency tree"

# ╔═╡ 26b30265-558b-49e7-b9f5-0b8af30c1273
pkg_registries = Pkg.Operations.Context().registries;

# ╔═╡ 922071fb-dac2-436e-a343-d0d22bd3c864
function AbstractTrees.children(uuid::Base.UUID)
    dep = get(Pkg.dependencies(), uuid, nothing)
    values(dep.dependencies)
end

# ╔═╡ d75c0427-12fe-4b2d-9bd1-b08f477966a6
function AbstractTrees.printnode(io::IO, uuid::Base.UUID)
    dep = get(Pkg.dependencies(), uuid, nothing)
	link = collect(Pkg.Operations.find_urls(pkg_registries, uuid))
	if length(link) > 0
    	print(io, "<a href=\"$(link[1])\">$(dep.name)</a> (v$(dep.version))")
	else
		print(io, "$(dep.name)")
	end
end

# ╔═╡ e23b935b-eab0-4256-9983-84fab6ed6632
function print_dependency_tree(pkg; maxdepth=5)
	io = IOBuffer()
	AbstractTrees.print_tree(io, Pkg.project().dependencies[string(pkg)]; maxdepth)
	HTML("<p style='font-family: Consolas; line-height: 1.2em; max-height: 300px;'>" * replace(String(take!(io)), "\n"=>"<br>") * "</p>")
end

# ╔═╡ e61c0433-58b0-46bf-956d-41caecd70316
# this utility is defined at the end of this notebook
print_dependency_tree(Yao; maxdepth=2)

# ╔═╡ 37e55165-6128-4a2a-ae2a-078e7d4016d1
md"### Mermaid diagram"

# ╔═╡ 9bb41efb-2817-4258-af2b-1fe515b6007a
macro mermaid_str(str)
	return HTML("""<script src="https://cdn.bootcss.com/mermaid/8.14.0/mermaid.min.js"></script>
<script>
  // how to do it correctly?
  mermaid.init({
    noteMargin: 10
  }, ".someClass");
</script>

<div class="mermaid someClass">
  $str
</div>
""")
end

# ╔═╡ 000b93e6-8a1d-4c67-b5da-5013c6421e2c
mermaid"""
flowchart LR;
A("一段静态类型程序") --> | 编译/很慢 | B("二进制文件") --> | 执行/快 | C(结果)
"""

# ╔═╡ ef736f15-6180-46ed-ac52-d57ac17429e8
mermaid"""
flowchart LR;
A("一段静态类型程序") --> | 解释执行/慢 | C(结果)
"""

# ╔═╡ d04b2eca-9662-4518-8bb6-8b1bf07e8984
mermaid"""
flowchart LR;
A("调用 Julia 函数") --> B{有函数实例?}
B -- 否 --> N[推导数据类型<br>并编译/不快] --> C("内存中的二进制码")
C --> |执行/快| Z("结果")
B -- 是 --> C
"""

# ╔═╡ 216d9db3-2d4a-47ef-89c6-70edfdd7bd53
mermaid"""
graph TD;
A["安装包命令 pkg> add Yao"] --> B["从 GitHub 更新 registry (如 General)"] --> C["解析依赖关系与版本并生成 Manifest.toml 文件"] --> D["从 GitHub 找到对应的软件仓库"]
D --> E["下载对应软件包的版本并安装"]
"""

# ╔═╡ 51906d13-0c53-4dce-9861-56e53fa23f63
md"### Layout"

# ╔═╡ a9a9f06e-4737-4619-b497-f488ea25fdf3
	# left right layout
	function leftright(a, b; width=600)
		HTML("""
<style>
table.nohover tr:hover td {
   background-color: white !important;
}</style>
			
<table width=$(width)px class="nohover" style="border:none">
<tr>
	<td>$(html(a))</td>
	<td>$(html(b))</td>
</tr></table>
""")
	end

# ╔═╡ 8ea2593c-2f93-47c1-aa7d-918c848f8bfb
md"""
# 多重派发

Julia 有很多特别之处，在此列举一个其中最重要的一点

$(leftright(
	html"<div style='font-size:40px; text-align: center; padding-right=50px'>Mutliple<br>多重</div>",
	html"<div style='font-size:40px; text-align: center'> Dispatch<br>派发</div>",
))


"""

# ╔═╡ 2bd08f69-02e9-4b49-b707-e30abe269229
md"### Live coding"

# ╔═╡ bb346eb2-e070-4522-a991-1bfd0c2b05dc
function livecoding(src)
	HTML("""
<div></div>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/asciinema-player@3.0.1/dist/bundle/asciinema-player.css" />
<script src="https://cdn.jsdelivr.net/npm/asciinema-player@3.0.1/dist/bundle/asciinema-player.min.js"></script>
<script>
var target = currentScript.parentElement.firstElementChild;
AsciinemaPlayer.create('$src', target);
target.firstChild.firstChild.firstChild.style.background = "#000000";
target.firstChild.firstChild.firstChild.style.color = "#FFFFFF";
</script>
""")
end

# ╔═╡ 04b5f8fc-32c1-430c-8bec-3e1a06bdda24
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/matmul/main.cast")

# ╔═╡ 2a5e9979-76d4-4a14-8242-ac7bd1f66d51
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/6.pkgdev/main.cast")

# ╔═╡ e8281692-0a68-4382-956b-cfa61d80f4ae
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/1.basic/main.cast")

# ╔═╡ 4f0a9029-5000-4a63-b387-198c58a7e8f6
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/2.array/main.cast")

# ╔═╡ b13e37b3-8c6a-471c-9d8f-997d20520664
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/3.types/main.cast")

# ╔═╡ e7729331-9750-462e-87ca-69ffca106767
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/4.multipledispatch/main.cast")

# ╔═╡ dad2eb09-06ca-4d96-8f4d-9f1b8770b92d
livecoding("https://raw.githubusercontent.com/GiggleLiu/notebooks/julia-tutorial/livecoding/5.performance/main.cast")

# ╔═╡ f213af72-6f38-417e-b20e-5a6118f4572f
md"### Luxor plot utilities"

# ╔═╡ 21341609-92c4-4a73-a066-99ebb3b72010
begin
	function drawset!(x, y; textoffset=0, dash=false, bgcolor, r, text, opacity=1.0)
		setcolor(bgcolor)
		setopacity(opacity)
		circle(x, y, r; action=:fill)
		setopacity(1.0)
		setcolor("black")
		if dash
			setdash("dashed")
			circle(x, y, r; action=:stroke)
		end
		Luxor.text(text, x, y+textoffset; halign=:center, valign=:center)
	end
	function draw_number!(x, y; textoffset=0, dash=false)
		drawset!(x, y; textoffset, dash, bgcolor="#6688CC", r=100, text="Number")
	end
	function draw_floatandcomplex!(x, y; textoffset=0, dash=false)
		drawset!(x, y; textoffset, dash, bgcolor="#AACC66", r=50, text="FloatAndComplex")
	end
	function draw_float!(x, y; textoffset=0, dash=false)
		drawset!(x, y; textoffset, dash, bgcolor="#66FF88", r=50, text="AbstractFloat", opacity=0.5)
	end
	function ring3!(x, y)
		draw_number!(x, y; textoffset=-85)
		#draw_floatandcomplex!(x, y-30; textoffset=0)
		draw_float!(x, y+30; textoffset=0)
	end
	@drawsvg begin
		ring3!(0, 0)
	end 300 300
end;

# ╔═╡ 8a2b6551-17a1-4566-9a22-e2bcf525c191
@drawsvg begin
	drawset!(0, 0; textoffset=-85, bgcolor="#6688CC", r=120, text="Number")
	drawset!(55, 0; textoffset=65, bgcolor="#88AAAA", r=58, text="Real")
	drawset!(55, 0; textoffset=35, bgcolor="#AACC66", r=50, text="AbstractFloat")
	drawset!(-55, 0; textoffset=35, bgcolor="#66FF88", r=50, text="Complex")
	drawset!(55, 0; textoffset=-10, bgcolor="red", r=5, text="Float64")
	drawset!(-55, 0; textoffset=-10, bgcolor="blue", r=5, text="Complex{Float64}")
	Luxor.text("Any", 100, -110)
end 300 300

# ╔═╡ 764b68fa-5891-4e0b-a4c9-474cf1fd9861
@drawsvg begin
	drawset!(0, 0; textoffset=-85, bgcolor="#6688CC", r=120, text="Number")
	drawset!(55, 0; textoffset=65, bgcolor="#88AAAA", r=58, text="Real")
	drawset!(55, 0; textoffset=35, bgcolor="#AACC66", r=50, text="AbstractFloat")
	drawset!(-55, 0; textoffset=40, bgcolor="#66FF88", r=50, text="Complex")
	drawset!(-55, 0; textoffset=20, bgcolor="#99DD88", r=30, dash=true, text="Complex{<:AbstractFloat}")
	drawset!(55, 0; textoffset=-10, bgcolor="red", r=5, text="Float64")
	drawset!(-55, 0; textoffset=-10, bgcolor="blue", r=5, text="Complex{Float64}")
	drawset!(-55, -25; textoffset=-10, bgcolor="black", r=5, text="Complex{AbstractFloat}")
end 300 300

# ╔═╡ 8c66252c-9639-4002-9e5b-fdf9dba8c768
@drawsvg begin
	drawset!(0, 0; textoffset=-85, bgcolor="#6688CC", r=120, text="Number")
	drawset!(55, 0; textoffset=65, bgcolor="#88AAAA", r=58, text="Real")
	drawset!(55, 0; textoffset=0, bgcolor="#AACC66", r=50, text="AbstractFloat", dash=true)
	drawset!(-55, 0; textoffset=0, bgcolor="#66FF88", r=50, text="Complex", dash=true)
	Luxor.text("Any", 100, -110)
end 300 300

# ╔═╡ a112da1a-1ffc-41ab-8387-d4340c653ba7
begin
	function doublering!(dx1, dx2)
		x1, y1, x2 = -120, 0, 120
		ring3!(x1, y1)
		ring3!(x2, y1)
		setcolor("red")
		circle(x1+dx1, y1, 5; action=:fill)
		circle(x2+dx2, y1, 5; action=:fill)
	end
	let
		@drawsvg begin
			doublering!(0, 85)
			x1, y1, x2 = -120, 0, 120
			setcolor("black")
			text("(::Number, ::Number)", 0, 115; valign=:center, halign=:center)
			arrow(Point(-30, 100), Point(x1+70, y1+70))
			arrow(Point(30, 100), Point(x2-70, y1+70))
			text("(::AbstractFloat, ::Number)", 0, -115; valign=:center, halign=:center)
			arrow(Point(-30, -100), Point(x1+20, y1-15))
			arrow(Point(30, -100), Point(x2-70, y1-70))
		end 500 300
	end
end

# ╔═╡ b3d24b7c-44f5-4ca1-9024-a9af75637d30
let
	@drawsvg begin
		doublering!(85, 85)
		x1, y1, x2 = -120, 0, 120
		setcolor("black")
		text("(::Number, ::Number)", 0, 115; valign=:center, halign=:center)
		arrow(Point(-30, 100), Point(x1+70, y1+70))
		arrow(Point(30, 100), Point(x2-70, y1+70))
		text("(::AbstractFloat, ::Number)", 0, -115; valign=:center, halign=:center)
		arrow(Point(-30, -100), Point(x1+20, y1-15))
		arrow(Point(30, -100), Point(x2-70, y1-70))
	end 500 300
end

# ╔═╡ 10b1aa40-fd50-41d0-bc9c-8c32a74ea79c
let
	@drawsvg begin
		doublering!(0, 0)
		x1, y1, x2 = -120, 0, 120
		setcolor("black")
		text("(::Number, ::AbstractFloat)", 0, 115; valign=:center, halign=:center)
		arrow(Point(-30, 100), Point(x1+70, y1+70))
		arrow(Point(30, 100), Point(x2-40, y1+55))
		text("(::AbstractFloat, ::Number)", 0, -115; valign=:center, halign=:center)
		arrow(Point(-30, -100), Point(x1+20, y1-15))
		arrow(Point(30, -100), Point(x2-70, y1-70))
	end 500 300
end

# ╔═╡ 007f4b4c-da06-4bbf-960f-60fa4166d38e
md"### display a file"

# ╔═╡ c6a89ef4-4f9b-4f43-bade-e6d22d5aa493
function showfile(filename)
	Text("FILE: $filename\n"* ("-"^80) * "\n" * read(filename, String) * "\n")
end

# ╔═╡ 99491901-8397-47da-9423-f4e07cbbc8ea
showfile("clib/demo.c")

# ╔═╡ f97538e2-ee58-4923-8ac1-d5c9131db6a4
showfile(joinpath(project_folder, "test", "runtests.jl"))

# ╔═╡ 25c66e78-9326-4471-ab3b-005201cb03ce
let project_folder = dirname(dirname(pathof(Yao)))
	showfile(joinpath(project_folder, "Project.toml"))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractTrees = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Libdl = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
MethodAnalysis = "85b6ec6f-f7df-4429-9514-a64bcd9ee824"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
TropicalNumbers = "b3a74e9c-7526-4576-a4eb-79c0d4c32334"
Yao = "5872b779-8223-5990-8dd0-5abbb0748c8c"

[compat]
AbstractTrees = "~0.4.3"
BenchmarkTools = "~1.3.2"
Luxor = "~3.5.0"
MethodAnalysis = "~0.4.11"
PlutoUI = "~0.7.48"
PyCall = "~1.94.1"
TropicalNumbers = "~0.5.5"
Yao = "~0.8.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "95e64af6ccad9d2c72f3c6f2a5498b3270d9638b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "52b3b436f8f73133d7bc3a6c71ee7ed6ab2ab754"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.3"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "c46fb7dd1d8ca1d213ba25848a5ec4e47a1a1b08"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.26"

[[deps.ArrayInterfaceGPUArrays]]
deps = ["Adapt", "ArrayInterfaceCore", "GPUArraysCore", "LinearAlgebra"]
git-tree-sha1 = "fc114f550b93d4c79632c2ada2924635aabfa5ed"
uuid = "6ba088a2-8465-4c0a-af30-387133b534db"
version = "0.2.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitBasis]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f51ef0fdfa5d8643fb1c12df3899940fc8cf2bf4"
uuid = "50ba71b6-fa0f-514d-ae9a-0916efc90dcf"
version = "0.8.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CacheServers]]
deps = ["Distributed", "Test"]
git-tree-sha1 = "b584b04f236d3677b4334fab095796a128445bf8"
uuid = "a921213e-d44a-5460-ac04-5d720a99ba71"
version = "0.2.0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "aaabba4ce1b7f8a9b34c015053d3b1edf60fa49c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.4.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.DataAPI]]
git-tree-sha1 = "e08915633fcb3ea83bf9d6126292e5bc5c739922"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.13.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceGPUArrays", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "9837d3f3a904c7a7ab9337759c0093d3abea1d81"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.22.0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "fb83fbe02fe57f2c068013aa94bcdf6760d3a7a7"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+1"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LegibleLambdas]]
deps = ["MacroTools"]
git-tree-sha1 = "7946db4829eb8de47c399f92c19790f9cc0bbd07"
uuid = "f1f30506-32fe-5131-bd72-7c197988f9e5"
version = "0.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "946607f84feb96220f480e0422d3484c49c00239"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.19"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "Random", "Requires", "Rsvg"]
git-tree-sha1 = "8fd7cb8db7dc4f575373825963079dbe54581f32"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.5.0"

[[deps.LuxurySparse]]
deps = ["InteractiveUtils", "LinearAlgebra", "Random", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "660da52355791ea967982f86fd15aa8b4c9eae6d"
uuid = "d05aeea4-b7d4-55ac-b691-9e7fabb07ba2"
version = "0.7.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MLStyle]]
git-tree-sha1 = "060ef7956fef2dc06b0e63b294f7dbfbcbdc7ea2"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.16"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.MethodAnalysis]]
deps = ["AbstractTrees"]
git-tree-sha1 = "69d5c89c5d3af15e73d0cdb7482411c156e3f810"
uuid = "85b6ec6f-f7df-4429-9514-a64bcd9ee824"
version = "0.4.11"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "53b8b07b721b77144a0fbbbc2675222ebf40a02d"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.94.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "ffc098086f35909741f71ce21d03dadf0d2bfa76"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.11"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.TropicalNumbers]]
git-tree-sha1 = "bfafb870d4a18d84d2ade80cf857440ab3d0a2df"
uuid = "b3a74e9c-7526-4576-a4eb-79c0d4c32334"
version = "0.5.5"

[[deps.TupleTools]]
git-tree-sha1 = "3c712976c47707ff893cf6ba4354aa14db1d8938"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.3.0"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Yao]]
deps = ["BitBasis", "LinearAlgebra", "LuxurySparse", "Reexport", "YaoAPI", "YaoArrayRegister", "YaoBlocks", "YaoSym"]
git-tree-sha1 = "58573a875eb3705c752de1ac3e4e228e7cfbc781"
uuid = "5872b779-8223-5990-8dd0-5abbb0748c8c"
version = "0.8.5"

[[deps.YaoAPI]]
git-tree-sha1 = "4732ed765411aef7983123961d34cd9e9729da4f"
uuid = "0843a435-28de-4971-9e8b-a9641b2983a8"
version = "0.4.3"

[[deps.YaoArrayRegister]]
deps = ["Adapt", "BitBasis", "DocStringExtensions", "LegibleLambdas", "LinearAlgebra", "LuxurySparse", "MLStyle", "Random", "SparseArrays", "StaticArrays", "StatsBase", "TupleTools", "YaoAPI"]
git-tree-sha1 = "ef1054c7d6dd71c184c068c04ce862f86f9a468b"
uuid = "e600142f-9330-5003-8abb-0ebd767abc51"
version = "0.9.3"

[[deps.YaoBlocks]]
deps = ["BitBasis", "CacheServers", "ChainRulesCore", "DocStringExtensions", "ExponentialUtilities", "InteractiveUtils", "LegibleLambdas", "LinearAlgebra", "LuxurySparse", "MLStyle", "Random", "SparseArrays", "StaticArrays", "StatsBase", "TupleTools", "YaoAPI", "YaoArrayRegister"]
git-tree-sha1 = "6d991dc024d604c2cdb6746ea71d8781c10b1a03"
uuid = "418bc28f-b43b-5e0b-a6e7-61bbc1a2c1df"
version = "0.13.5"

[[deps.YaoSym]]
deps = ["BitBasis", "LinearAlgebra", "LuxurySparse", "Requires", "SparseArrays", "YaoArrayRegister", "YaoBlocks"]
git-tree-sha1 = "118e2c434e810dd52a3564a1b99f7fd3a2bbb63e"
uuid = "3b27209a-d3d6-11e9-3c0f-41eb92b2cb9d"
version = "0.6.2"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "e9190f9fb03f9c3b15b9fb0c380b0d57a3c8ea39"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.8+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
"""

# ╔═╡ Cell order:
# ╟─713939c6-4fe6-11ed-3e49-6bcc498b82f2
# ╟─8225e1a9-ee2f-454d-b4c1-84568b10bb1b
# ╟─915a6f21-1d94-4aed-aaa3-3a58a34264d3
# ╟─b92957bf-eeb2-4d2a-933d-77baad5c6eef
# ╟─b89ac84e-4d15-4c9c-b809-35465d2e0435
# ╟─8e7f15fd-ae65-4559-972a-2c9720ac1547
# ╟─73ce1dff-a3ff-431b-9acb-7af6c00b35f6
# ╟─a72f4263-b034-4aa8-8611-d53166cbb718
# ╟─bc2508c7-ec41-4325-9ce0-c7737c99db64
# ╟─706af77e-ce1f-4334-8dbb-d6d5cbcdef18
# ╟─b109f0d3-4cde-4f41-b26e-e43ed6e048fe
# ╟─f58dbbda-7445-41ba-aa23-5435dbf688c9
# ╟─7a3b16e3-3870-4045-9549-9844698cf3d5
# ╟─c5e7337a-85c6-430a-8746-9826325c80d5
# ╟─f1f3f07d-bc38-4d01-b9cb-f843c160cb3f
# ╟─2b1c00b1-eb58-4b99-829f-5b98689132ad
# ╟─931bb099-60b9-4542-ac53-3757fb269fff
# ╟─26348f56-c4bf-4ec8-a429-773d60525364
# ╟─ff0a8030-9a18-4d27-9a87-bed9aed0d2a8
# ╟─fe174dbe-5c4b-4445-b485-5c21cc1e8917
# ╟─000b93e6-8a1d-4c67-b5da-5013c6421e2c
# ╠═99491901-8397-47da-9423-f4e07cbbc8ea
# ╠═33a43668-4484-47d2-a7a6-09d930232252
# ╠═cf0eb0cd-bcb7-4f7c-b462-bef13d3c2a97
# ╠═2a22f131-6a99-4744-8914-19c8776700e7
# ╠═a9c2ff4c-a32b-4bb5-aef3-cf378453587a
# ╠═25534efa-c0f1-4c7f-9575-f0c7c8dbf634
# ╠═c73baba2-9ec7-461e-b4e7-fd162606e134
# ╠═01972597-9d31-4972-a15d-51832f0f5910
# ╟─917e187d-5eda-49d6-a72a-0ed3f60d82d6
# ╟─ab045ed0-7cbb-4565-bd7f-239dd94ce99e
# ╟─f3695873-435d-44cb-b9fb-af34dc38bdaa
# ╟─ef736f15-6180-46ed-ac52-d57ac17429e8
# ╠═9954c036-d4d3-42c9-acbf-22623f84f254
# ╠═0f526702-f8e6-492d-bd14-e81874e6fefe
# ╠═46cf6881-650e-4ba1-a0dc-bcda67fb367b
# ╠═922a2063-f516-46a5-95a9-9e0adca018aa
# ╟─105852eb-8f34-4d52-8ec3-68dff6997efb
# ╟─e6fd7a35-e45e-4cc7-ae24-7c2f8fd7c73d
# ╟─06c57cf8-e85c-4d4a-84fa-bd1b2cfd8301
# ╠═79e3c220-c281-4ab0-988a-39e1b0a39d64
# ╟─f7e5304d-7573-4e8c-b516-4c16a7432067
# ╟─d04b2eca-9662-4518-8bb6-8b1bf07e8984
# ╟─be4da897-df85-4276-bde1-7c1824cae796
# ╠═13bcf3d6-2418-46e1-acde-050914064741
# ╟─70fc53ba-70c5-4ae4-877c-f8e47569adc4
# ╠═5b5e337e-c7e2-4c90-966e-62dc48a9cf28
# ╟─2f36c4e6-1fc5-42e9-b097-315b28f82d5d
# ╟─fb53a9ed-df58-410a-8275-e15718514950
# ╠═e5b59cc9-0d14-4d8a-bb25-738540e7ebf9
# ╟─8e109ec4-6b21-454b-ad7b-e30cef6d14bd
# ╠═7b8e9026-6dc1-4d28-a2a7-912399a4fd51
# ╠═4253af25-41bd-47b6-a11e-c2902c677963
# ╠═ec33aba5-28c9-4be9-9804-361f65de1f7a
# ╟─0ef8831d-62c3-47b5-9f6e-3d9322da8e16
# ╟─3e3a2f23-8098-4d06-b4d1-157c97e4c094
# ╟─04b5f8fc-32c1-430c-8bec-3e1a06bdda24
# ╟─9ccbc920-ae8f-4b65-bf7e-273fce9deb99
# ╠═3adea2f8-3f59-45d5-9e03-7285c7571c1d
# ╟─8ea2593c-2f93-47c1-aa7d-918c848f8bfb
# ╟─e34c636f-ae8f-46c3-a043-08c0408b3433
# ╠═5d05964f-ca08-4ef4-91d3-f78f990650b0
# ╠═8d218a48-de95-4a24-9cc2-f4970013182f
# ╠═72d0e961-8699-4bd3-b2e1-3e9774536e74
# ╠═91f32f59-f178-4041-8094-9803e868f674
# ╠═24f9ad0c-0985-4a6b-bde9-b0a87574e188
# ╠═d01b94b5-df3d-4a8f-a611-7d53499e6ee7
# ╠═4e1b7044-ff2b-4eca-a549-a4cd736a93ee
# ╠═17071f7d-e730-4248-8b0a-a3e7067ef1e1
# ╟─8c9af74a-f4ec-4b56-b560-2c8a77f5e4d9
# ╟─53fb47ff-c48a-41f4-9066-bd2c2af28dfd
# ╠═724e9f4a-7152-4916-8910-9696e8d4fd40
# ╠═3d255fc3-7098-46f7-a103-d0da8fafff38
# ╠═6cfc75fe-569c-45b8-acb6-d757e57730e6
# ╠═7ef00148-1628-4066-b0c2-efe1c38afb67
# ╠═fb183df1-a578-44e2-94bc-7d04b5fe8ebb
# ╠═30a44089-656a-4277-ab28-45610c329325
# ╠═8764fa70-9933-4e6d-a0a6-2567e1219c63
# ╠═8e019f9b-8c9d-46d7-b10f-3985c46e2a88
# ╟─c13cf4d5-f5a1-466c-b5f5-bc3fe6545e05
# ╟─36daaa7d-17a8-4523-8721-aad00f71f2e2
# ╟─0b88d436-5a20-4936-8ced-a15bf1557ba0
# ╟─a8e1722b-89c3-46be-9488-33aa595c3126
# ╠═30d83360-4d86-4df4-8543-8870841c45cc
# ╠═6e9f119e-e7c7-4549-81fb-9b85f6736b18
# ╟─fc0fdc48-db4c-40c7-9c45-e539512f5ee6
# ╠═c04c4d58-0469-45cc-a217-444a2b607245
# ╟─8a2b6551-17a1-4566-9a22-e2bcf525c191
# ╟─d1b0b145-12e3-4a61-82d8-2a743ce02682
# ╠═46cd1ee1-e269-46a7-93d3-72597b53a9a9
# ╟─d61ab911-70e3-4305-8f21-99d254a39a27
# ╠═a06e3ad6-baad-4bc6-ae84-8f6402cb4364
# ╟─260aacc1-811b-495a-8e8c-645b23a97dcf
# ╠═fd424566-17a1-435c-bdbf-57f1991aacb2
# ╠═7a492b1c-4010-4a6d-99f1-ebe0944f7f56
# ╠═6ef58185-0a33-40ae-b527-f416ec5460dc
# ╠═cf83e44f-caf9-4c01-92f9-f31bb99cc1ee
# ╠═00d52720-154f-47a4-a6be-f9ffe23b3aea
# ╟─eec8b97e-a8f1-45ed-bc9e-e0c7e4f65a05
# ╠═1e267a3f-e60d-49df-ba26-268423693c71
# ╠═ecccde43-c4f1-4a92-bda7-3940d5fd3afd
# ╟─c39dd2fb-dd37-40b3-b617-58e231325f9d
# ╠═61dbc39a-7cd7-4f30-8422-d6afe675f8bd
# ╠═1e5acfcf-00e0-4595-a71d-94ad876b63de
# ╠═6970b63a-83f9-4215-9f7a-e8d91593a192
# ╟─764b68fa-5891-4e0b-a4c9-474cf1fd9861
# ╟─cefdbc63-367c-4af8-9bf1-e8999c37e677
# ╠═3309100b-a8f1-44e5-95d3-53660ea171ec
# ╟─e2be9ff8-3f7f-4497-b8ae-3e5109ea0457
# ╠═9552f38a-b3ef-4010-b2b7-8384411f6922
# ╠═7897e41a-67c9-412f-9d27-eb6e9d8d4004
# ╠═a6f963d9-2dff-40dc-9c11-a40a17032ce4
# ╠═d1a5d1b1-c8f0-44c7-868c-4079667ee4e3
# ╠═bf455f16-35a1-41b9-b39f-e55b57646475
# ╠═948fcf3f-4d00-4849-91fa-bae0d9acefba
# ╠═337b770f-d97b-407a-a6c9-f5aa11e364fa
# ╠═e9016f62-626e-443e-9166-dba66cdc8051
# ╟─f7e69afe-e8f5-4540-ba71-6df36faf4ce3
# ╠═119c21c8-3b99-4de9-9edf-2daa7d1ccfad
# ╠═cd701b2f-8dcf-4d4d-a8e4-5cc7b612dc77
# ╟─8c66252c-9639-4002-9e5b-fdf9dba8c768
# ╟─4329a285-c184-4f03-b90d-c8f74c072cd7
# ╠═34d05cb5-a222-4705-9f29-4c902e0fb547
# ╟─85c3160f-962f-4b19-bfba-310054cb7fca
# ╠═69fed6cc-030b-4066-a023-0bbf1637fbbc
# ╠═b3f72d4b-9f1f-46fd-8145-212f96c320f8
# ╠═a79ac986-54ad-44c0-8aa6-077a6f34b6eb
# ╟─a112da1a-1ffc-41ab-8387-d4340c653ba7
# ╟─5e276fd0-887e-4de2-b502-359be36e6fb6
# ╠═2ca96d5e-bc03-4c2a-aeaf-9d35c9ceb8c1
# ╟─b3d24b7c-44f5-4ca1-9024-a9af75637d30
# ╠═5ea7d476-1217-4895-9064-b0327c7a3fdc
# ╟─10b1aa40-fd50-41d0-bc9c-8c32a74ea79c
# ╟─9b00810e-8dc8-4602-a185-28e60c027b99
# ╠═832f83a0-94af-4649-80a0-21dd75d01da7
# ╟─ad965d41-ca74-4c3b-a81d-a3f0f1a2b1e4
# ╠═7bce1278-ac0d-4918-aaea-fa69d8cdcf24
# ╟─a94c8b67-94c8-4ba1-99fd-db891a805006
# ╠═34494ea7-d50a-48c0-8374-ca9482bc63f3
# ╠═8cebd10b-8af7-4806-999a-204823c56eea
# ╠═6bccd6b6-0de1-4e4e-b6b4-99ed90580af7
# ╟─5736fc36-4e81-4672-99d2-7a23f212269c
# ╟─b7d2319f-3d14-4a12-ad2e-3d7845d919b8
# ╟─6850c93c-9bb9-49fe-8546-f3b0f45dc0f5
# ╠═f8896020-c076-4373-895b-4332b3631380
# ╠═75763b2b-d00f-46c0-b99e-257292c6bb96
# ╟─9447d362-04a4-4dc0-b215-4cbdbdaec9b3
# ╟─0223205c-2e44-4787-bf84-90abecd11542
# ╠═9cc6445c-cc12-4a75-8415-9591c5491e6e
# ╠═49797f42-1477-47d6-8b35-3a742f2e64bd
# ╠═39c3a673-787e-4f00-ac71-f0279e0c9be7
# ╠═bfc1690a-f5ec-4173-a9eb-ab0b1905b59c
# ╠═c42d7cae-2d09-46cf-bb22-a09d17dd7bca
# ╠═4e8bbc37-5e4e-4669-ab13-0c88ae177490
# ╠═f97538e2-ee58-4923-8ac1-d5c9131db6a4
# ╠═56e8cee2-7a4e-4a9a-b297-b7c08b865db8
# ╟─a008446c-079a-4571-a66b-c156eec72188
# ╟─fa78b65e-e3a2-49a8-b846-9827787de23e
# ╠═25c66e78-9326-4471-ab3b-005201cb03ce
# ╟─216d9db3-2d4a-47ef-89c6-70edfdd7bd53
# ╟─d1b9aa30-ac64-4653-95b9-ab8695fbf34b
# ╠═d5d44e77-934f-4f0c-af1b-d89f0778142d
# ╠═e61c0433-58b0-46bf-956d-41caecd70316
# ╟─5dbe18d9-e3a2-4997-a984-e13c70f34746
# ╟─2a5e9979-76d4-4a14-8242-ac7bd1f66d51
# ╟─0a51a90b-72c8-4a69-a2d0-5b8d80137b92
# ╟─6b802c31-f0cd-4b92-9bb3-09aa15f01f8b
# ╟─d34ac2d6-bece-4643-b413-4053441af815
# ╟─0efc54a1-3dbb-45ab-bede-77ab4669721d
# ╟─ee8606f7-6f5d-430a-b111-84843de789d7
# ╟─4704dbf6-e2e1-4b6b-8ed0-a9bdbbed5474
# ╟─e8281692-0a68-4382-956b-cfa61d80f4ae
# ╟─2e124d1f-bdc2-4161-8ce1-9d2b722ab449
# ╟─4f0a9029-5000-4a63-b387-198c58a7e8f6
# ╟─ea266c12-7e62-4c77-9682-0cf51c5e6695
# ╟─b13e37b3-8c6a-471c-9d8f-997d20520664
# ╟─05c7bb10-aacc-498a-b42f-52642648f92e
# ╟─e7729331-9750-462e-87ca-69ffca106767
# ╟─0596e817-91b6-4a57-9323-8b998115d4ca
# ╟─dad2eb09-06ca-4d96-8f4d-9f1b8770b92d
# ╟─0919dfcc-b344-4e4c-abfa-9c3914e2850b
# ╠═7d242d2a-d190-4a11-b218-60650ba70533
# ╠═27310322-9276-49d4-bc28-d503b6354ce1
# ╟─156a1a62-e131-403f-b2a2-80f49e6a9b33
# ╟─d0a8e05f-f147-45c7-b9b3-4a3f5bbe6dff
# ╠═52c27043-31c2-4e90-b6a5-d858aa7056d4
# ╠═012b69d8-6304-4e91-9c0f-07fe3ad9980f
# ╠═782a555d-caff-4096-a6e6-24e77565a2cf
# ╠═88a8c21d-e5d3-4b88-a818-58f614d6f64e
# ╠═d4a6f68e-b7da-4ca1-b43c-c2da7929cd3d
# ╠═e4bae9e0-c949-4f1f-8b69-14491246d2a3
# ╟─f1c77c14-81e7-4566-9b35-96e578e7c16d
# ╠═38340e67-5418-4570-a9af-d466c972ef9c
# ╠═9f2e0149-9558-41f0-bc84-3ccb09786714
# ╠═920ca137-4474-4c4d-96f7-2164b5386be3
# ╠═904364df-125e-4ea5-a7a3-cb5221022927
# ╟─40acbc0c-e92c-4183-b297-2ace43aa6042
# ╠═ee916ff8-c4f8-4dfb-83c5-12d1ab95f111
# ╠═26b30265-558b-49e7-b9f5-0b8af30c1273
# ╠═922071fb-dac2-436e-a343-d0d22bd3c864
# ╠═d75c0427-12fe-4b2d-9bd1-b08f477966a6
# ╠═e23b935b-eab0-4256-9983-84fab6ed6632
# ╟─37e55165-6128-4a2a-ae2a-078e7d4016d1
# ╠═9bb41efb-2817-4258-af2b-1fe515b6007a
# ╟─51906d13-0c53-4dce-9861-56e53fa23f63
# ╠═a9a9f06e-4737-4619-b497-f488ea25fdf3
# ╟─2bd08f69-02e9-4b49-b707-e30abe269229
# ╠═bb346eb2-e070-4522-a991-1bfd0c2b05dc
# ╟─f213af72-6f38-417e-b20e-5a6118f4572f
# ╠═1cc46cad-91c8-4812-95b3-02c9979adbbc
# ╠═21341609-92c4-4a73-a066-99ebb3b72010
# ╟─007f4b4c-da06-4bbf-960f-60fa4166d38e
# ╠═c6a89ef4-4f9b-4f43-bade-e6d22d5aa493
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
