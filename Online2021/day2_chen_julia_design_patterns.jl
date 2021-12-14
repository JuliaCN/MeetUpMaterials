### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ a42271da-64ce-4b30-ab2e-8da84b41101c
using BenchmarkTools, PlutoUI

# ╔═╡ 1bf02c40-5a49-11ec-35ff-a9b7c53995bb
md"""
# Julia 代码中的典型设计模式

陈久宁 2021.12.11

大纲

- 多重派发与函数式编程
- 类型稳定
- 向量化与 for 循环
- 编译期计算
"""

# ╔═╡ 312f7bd4-07e2-4d5d-a8d9-6d1153e875b9
md"""
## 多重派发与函数式编程

多重派发与函数式编程是 Julia 的核心编程风格。

!!! warning "Julia 没有面向对象"
    Julia 没有面向对象！ Julia 没有面向对象！ Julia 没有面向对象！
"""

# ╔═╡ 317cc64a-e4f2-43d6-a758-93870c1b4065
md"""
## 多重派发

多重派发： 由所有位置参数的类型来共同决定调用的方法。 基本规则是调用 “最具体” 的方法。
"""

# ╔═╡ 5d2cbb44-8d69-4acc-88e3-bf7f47e6afe4
begin
	f(x, y) = "f(::Any, ::Any) is called"
	f(x::Int, y::Int) = "f(::Int, ::Int) is called"
	f(x::AbstractArray, y::AbstractArray) = "f(::AbstractArray, ::AbstractArray) is called"
	f(x::AbstractString, y::AbstractString) = "f(::AbstractString, ::AbstractString) is called"
end

# ╔═╡ c194fe61-5a64-44e3-b075-2ac9f4584818
with_terminal() do
	@show f(1, 2)
	@show f(1.0, 2.0)
	@show f(1, 2.0)
	nothing
end

# ╔═╡ 0e4dcbed-366e-4079-81f9-8a03b51f4770
md"""
!!! note "方法歧义"
	我们说一个参数比另一个参数更具体， 是在一个偏序的意义上确定的, 例如： `Int <: Any`, `Array <: AbstractArray`。 当存在多个参数的时候， 比较这一组参数是否比另一组参数更具体， 则相当于把这个偏序关系推广到高维空间上： Julia 只做最严格意义上的比较， 即第一组参数的所有类型都比第二组参数的所有类型都具体的情况下， 才存在确定的大小关系。 下面这种代码就会导致 Julia 无法判断：
    ```julia
    foo(x,      y::Int) = 1
    foo(x::Int, y     ) = 2
    foo(1, 2) # 应该调用哪个？
    ```
    因此 Julia 会直接抛出 `ERROR: MethodError: f(::Int64, ::Int64) is ambiguous` 的异常。
"""

# ╔═╡ 2df3566d-2356-452e-94a8-d8cf68bc960b
md"""

### Method instance

几个名词：

- 函数 (function): 这里定义了函数 `f`， 即所有方法的集合。
- 方法 (method): 提供了``4``个函数 `f` 的方法。 方法里面的参数类型可以是具体类型（`Int`)也可以是抽象类型(`AbstractArray`, `Any`). 当参数类型是抽象类型的时候， 这个方法实际上是一个模板函数（类比 C++）。
- 方法实例 (method instance): Julia 根据我们写的方法 (method) 中生成和编译的可调用的函数对象 (blob)， 调用一个函数实际上调用的是方法实例而不是方法。

方法实例会在第一次调用的时候进行生成（也就是编译）：

```julia
julia> using MethodAnalysis

julia> methodinstance(f, (Int, Int)) # 还没有调用 f(2, 3) 时并不存在方法实例

julia> f(2, 3) # 第一次调用 f(::Int, ::Int) 方法
"f(::Int, ::Int) is called"

julia> methodinstance(f, (Int, Int)) # 再一次查询， 发现生成了对应的方法实例
MethodInstance for f(::Int64, ::Int64)

julia> f(rand(2, 2), rand(3, 3)) # 第一次调用 f(::AbstractArray, ::AbstractArray) 方法
"f(::AbstractArray, ::AbstractArray) is called"

julia> methodinstances(f) # 拿到的其实是 `f(::Matrix{Float64}, ::Matrix{Float64}`
2-element Vector{Core.MethodInstance}:
 MethodInstance for f(::Matrix{Float64}, ::Matrix{Float64})
 MethodInstance for f(::Int64, ::Int64)
```

!!! note "编译延迟 latency， 也称 Time-to-first-plot (TTFP)"
	Julia 之所以第一次执行一个函数的过程很慢， 是因为第一次调用的时候在背后进行了很多次的方法实例的生成。
"""

# ╔═╡ d035ecfc-805e-49f1-ad3c-65f768b490d6
md"""
问： 当第一次执行下面代码的时候， 会生成哪些方法实例？

```julia
foo(v::AbstractVector) = 1
foo(v::AbstractMatrix) = 2
sum_foo(X, Y) = foo(X) + foo(Y)

sum_foo(rand(2), rand(3, 4))
```

答： 生成3个方法的实例

```julia
foo(::Vector{Float64})
foo(::Matrix{Float64})
sum_foo(::Vector{Float64}, Matrix{Float64})
```

问： 当我们再执行 `sum_foo(rand(3, 4), rand(2))` 的时候， 会触发代码编译吗？

答： 会触发 `sum_foo(::Matrix{Float64}, ::Vector{Float64})` 的编译。
"""

# ╔═╡ 36918219-4bd1-4e73-a8c2-644586d1a584
md"""

### Method invalidation

除了生成方法实例以外， Julia 也存在 method invalidation 的一个过程， 即将之前的编译结果标记为无效化的过程。 例如：

```julia
foo(x) = 1
# 编译了 foo(::Array{Float64}) = 1
foo(rand(3))

# foo(::Array{Float64}) = 1 被无效化了
foo(x::AbstractArray) = 2
# 并生成新的 foo(::Array{Float64}) = 2 的方法实例
foo(rand(3)) 
```

Method invalidation 是一个传播性的行为： 当一个方法实例被标记为失效之后， 所以依赖于它的更复杂的方法也都会被标记为失效。 当我们 `using` 了一大堆包的时候， 就很容易出现上述行为， 从而导致 Julia 的预编译结果没办法被利用， 从而第一次执行某个大函数的时候会触发一大堆代码的重新编译。

!!! note "Method invalidation 是不可避免的"
	Method invalidation 的存在是由于 Julia 允许我们动态地加载和定义新的函数和方法导致的， 为了保证程序的正确性必须将一些过时的编译结果进行无效化标记。 

一般来说， 在大部分写代码的过程中不需要去特意关注 Method Invalidation， 而是在事后利用相关的工具 ([MethodAnalysis.jl](https://github.com/timholy/MethodAnalysis.jl), [SnoopCompile.jl](https://github.com/timholy/SnoopCompile.jl)) 找到最影响编译延迟的方法， 然后通过避免不必要的 invalidation 来修复它。 例如 [timholy](https://github.com/timholy) 在 Julia 1.6 里面引入了大量  通过减少 invalidation 来降低编译延迟的[修复](https://github.com/JuliaLang/julia/pulls?q=is%3Apr+is%3Aclosed+label%3Alatency+invalidation)
"""

# ╔═╡ 43b1bc1e-8236-4fb7-b706-6ae2b3ae474f
md"""
### Stub methods

虽然绝大部分人并不需要去考虑如何修复 method invalidation, 但是可以通过 stub method 来降低 method invalidation 的影响。 在 Julia 中， 我们希望实现的函数尽可能支持不同的输入类型， 所以我们经常会遇到类似于下面这种代码：

```julia
function foo(X::AbstractArray, n::Real)
    X .* n # 实际实现可能会更复杂一些
end
```

一般来说， 我们会让用户(caller)来决定传进来的 `n` 的类型 ([Style guide: Handle excess argument diversity in the caller](https://docs.julialang.org/en/v1/manual/style-guide/#Handle-excess-argument-diversity-in-the-caller))， 例如：

```julia
X = rand(4, 4)
n = rand(1:10)

# 在函数调用的外部进行类型转换
foo(Float32.(X), Float32(n))
```

但实际上依然存在一些场景, `foo` 要求 `n` 必须是一个 `Float32` 类型， 那么为了泛型的考虑， 我们可能会写出类似于下面的代码：

```julia
function foo(X, n::Real)
    n = Float32(n)
    X = Float32.(X)
    X .* n
end
```

这种代码是存在的， 例如当我们进行 CUDA 编程时， 我们会希望数据类型是 `Float32` 类型， 从而更好地利用显卡的单精度计算单元。

不过， 从编译延迟的角度来理解： 当 Julia 调用 `foo(X, ::Int)` 和 `foo(X, ::Int32)` 时， 会编译两个比较大的方法实例。 因此一个很自然地改进方式是将代码拆分成两部分：

```julia
# stub method: 一般来说非常小
foo(X::AbstractArray, n::Real) = foo(CuArray{Float32}(X), Float32(n))
function foo(X::CuArray{Float32}, n::Float32)
    X .* n # 真正地计算发生在这里, 是一个比较大的方法
end
```

这样做代码拆分的好处是： 真正的计算函数 `foo(X::CuArray{Float32}, n::Float32)` 虽然编译可能需要很久， 但是只需要编译一次就可以了。 关于不同的输入类型的方法的编译都交给 stub method 去做了， 这个代码一般非常小。 从某种意义上， 这种代码相当于告诉 Julia 如何组织和复用代码编译的结果， 它也可以在一定程度上降低 method invalidation 对编译延迟的影响。

!!! warning "不要滥用 stub method"
    总的来说， 一般原则是让用户 caller 来决定输入的类型， 而不是在实现内部决定输入类型。 上面这种强制类型转换的 stub method 只在确实有必要的情况下才使用。
"""

# ╔═╡ d911e626-41ca-4efd-aafa-9e956c7527aa
md"""
小结：

- 我们写 Julia 代码时， 实现的是函数 (function) 和 方法 (method)。
- 代码编译过程中， Julia 内部存在方法实例 (method instance) 的概念 和 method invalidation 的机制。 需要编译的方法实例越多就意味着越高的编译延迟 （第一次调用某个函数的等待时间）。
- 将大的函数拆分成一些小函数， 并且对核心实现加上一定的类型标记， 可以有效避免 method invalidation 的扩散。
"""

# ╔═╡ 6278892c-b9e3-439e-81ad-142e31a19fe2
md"""
## 函数式编程

函数式编程的基本风格是： 1) 尽可能写纯函数 2） 高阶函数 （`map`, `reduce` 等函数） 的使用。

当我们说 `f(x)` 是一个纯函数， 意思是： 只要 `x` 不变， `f(x)` 的结果是确定的。 例如：

```julia
f(x::Vector) = sum(x) # 纯函数
f(x::Vector) = push!(x) # 不是纯函数
```

高阶函数允许接受另一个函数作为输入， 例如计算数组的平方和 ``\sum_i x_i^2`` 在 Julia 下有非常多的方式：
"""

# ╔═╡ 77ff6646-5f57-4d09-80d8-8afb3e5edef4
md"""
高阶函数的好处在于可以复用一些代码机制从而使得很多在其他语言里必须存在的函数， 在 Julia 下并不需要专门给出一个实现（随手敲一个出来就好了）。 执行效率差不多的情况下， 你会选择什么方式?
"""

# ╔═╡ 637562f3-336a-4224-942a-e8f43026e580
md"""

将函数作为输入， 本身也可以对高阶函数进行多重派发， 例如：
"""

# ╔═╡ c27185b8-1e7c-4a1b-9bce-630602092e38
begin
	relu_v1(x) = max(x, zero(x))
	relu_v2(x) =  max(x, zero(x))

	# 当调用 sum(relu_v1, v) 的时候会调用这个方法
	function Base.sum(::typeof(relu_v1), v::Vector)
		rst = zero(eltype(v))
		@inbounds @simd for i in eachindex(v)
			x = v[i]
			rst += ifelse(x>zero(x), x, zero(x))
		end
		return rst
	end
end

# ╔═╡ 2f32ac4c-f741-4718-b426-43094288d617
begin
	# for 循环
	function square_sum_loop(v)
		rst = zero(eltype(v))
		@inbounds @simd for i in eachindex(v)
			rst += v[i]^2
		end
		return rst
	end

	# sum
	# f(x) = x^2
	# sum(f, v)
	squared_sum_sum(v) = sum(x->x^2, v)
	# mapreduce
	suqared_sum_mapreduce(v) = mapreduce(x->x^2, +, v)
	# one-liner
end

# ╔═╡ 852deb7d-573d-4076-85f5-d53bc221804c
with_terminal() do
	v = rand(1:10, 1000)
	@show square_sum_loop(v) == squared_sum_sum(v) == suqared_sum_mapreduce(v)
	@btime square_sum_loop($v)
	@btime squared_sum_sum($v)
	@btime suqared_sum_mapreduce($v)
	nothing
end

# ╔═╡ 8f9ac91e-1a42-43f9-8a20-1f88d48bf502
with_terminal() do
	v = rand(1:100, 10000)
	@show sum(relu_v1, v) == sum(relu_v2, v)
	@btime sum(relu_v1, $v)
	@btime sum(relu_v2, $v)
	nothing
end

# ╔═╡ 7d90ff5f-070e-4831-a2e2-08bce5cc10f2
md"""
Julia 的自动微分的工具箱， 例如 Zygote 或者 ChainRules 中， 就大量使用了这种方法。 例如:

```julia
# ChainRules.jl/src/rulesets/LinearAlgebra/dense.jl
function rrule(::typeof(dot), x::AbstractArray, y::AbstractArray)
    project_x = ProjectTo(x)
    project_y = ProjectTo(y)
    function dot_pullback(Ω̄)
        ΔΩ = unthunk(Ω̄)
        x̄ = @thunk(project_x(reshape(y .* ΔΩ', axes(x))))
        ȳ = @thunk(project_y(reshape(x .* ΔΩ, axes(y))))
        return (NoTangent(), x̄, ȳ)
    end
    return dot(x, y), dot_pullback
end
```
"""

# ╔═╡ 925ab156-86eb-4369-b03a-aeec78da325b
md"""
## 类型稳定

在介绍类型稳定之前， 我们需要知道 Julia 为什么快 （或者说 Python 为什么慢）， 以及为什么 Julia 的绝大部分性能来自于 JIT 和 LLVM 的编译优化， 但 X（任何你喜欢的动态语言） + JIT 的方式做不到 Julia 这么快。
"""

# ╔═╡ 45f19f6a-40e8-4d46-b328-8814f20b9ead
md"""
Julia 代码的完整执行过程分为编译期（生成优化的机器码）和运行期两个阶段。 为了生成优化的机器码， 编译器要求数据的类型在编译期间是确定的。 例如下面的两个小函数：
"""

# ╔═╡ 87de63f3-b67e-4665-9e8b-a7a3c2751ccc
begin
	# 返回值的类型即使不执行代码， 也知道是 Int 类型
	rand_int() = rand() > 0.5 ? 0 : 1
	# 返回值的类型只有在真正执行代码的时候才能够确定
	rand_int_or_float() = rand() > 0.5 ? 0 : 1.0
end

# ╔═╡ 7ae71b08-9896-42df-b749-525ebed9c111
with_terminal() do
	@code_warntype rand_int()
	# @code_warntype rand_int_or_float()
end

# ╔═╡ 248a5bb6-815c-4b3a-93b3-d353af2cd8fa
md"""
假如我们统计一下很多次的结果：
"""

# ╔═╡ 4990b3c8-dd81-4128-b13d-384c4588923e
function binomial_stable(n)
	rst = 0
	for i in 1:n
		rst += rand_int()
	end
	return rst
end

# ╔═╡ 8fba3f16-4554-415a-b3db-9d7cac8051f3
function binomial_unstable(n)
	rst = 0
	for i in 1:n
		rst += rand_int_or_float()
	end
	return Float64(rst)
end

# ╔═╡ 04eb9145-45ce-41d5-b88c-0af6e9a0ebc3
with_terminal() do
	@btime binomial_stable(1000)
	@btime binomial_unstable(1000)
	nothing
end

# ╔═╡ a16bf4ec-ac33-493b-a159-67612068cbd4
with_terminal() do
	@code_warntype binomial_unstable(10)
end

# ╔═╡ 5d9e26d8-7320-41b7-870b-ebc983d548ed
md"""
由于 `rand_int_or_float` 的数据类型是不确定的， 因此在执行 for 循环的时候， Julia 必须在代码运行的时候执行一些 `if` 判断来检查实际的类型， 并从而判断知道需要调用哪些函数， 除此之外还有很多额外的开销。
"""

# ╔═╡ a3bbcc93-844f-4b74-8936-decd668fed68
begin
	function binomial_unstable_v2(n)
		rst = 0
		for i in 1:n
			if rand() > 0.5
				rst += 0
			else
				rst += 1.0
			end
		end
		return rst
	end
	function binomial_unstable_v3(n)
		rst = 0.0 # 如果能够提前进行类型提升， 就可以避免不必要的分支， 触发 simd 从而加速代码执行
		for i in 1:n
			if rand() > 0.5
				rst += 0
			else
				rst += 1.0
			end
		end
		return rst
	end
end

# ╔═╡ 36c10b7e-7b43-42f6-961f-482a98052fa3
with_terminal() do
	@btime binomial_unstable(1000)
	@btime binomial_unstable_v2(1000)
	@btime binomial_unstable_v3(1000)
	nothing
end

# ╔═╡ 3126f01c-9d0f-4f6f-ba87-5d76f82169fe
md"""
除此之外， 类型不稳定的代码也会触发更多的内存分配， 从而更频繁地触发垃圾回收 (garbage collection GC) 机制而降低代码速度。
"""

# ╔═╡ 76aedce3-96d1-405d-909a-7a9f3d1f6077
begin
	relu_v3(x) = x > 0 ? x : 0
	relu_v4(x) = x > 0 ? x : zero(x)
end

# ╔═╡ 237cb556-085a-4e80-aeb9-d902437c4773
with_terminal() do
	v1 = rand(1000) .- 0.5 # Vector{Float64}
	v2 = rand(1:10, 1000) .- 5 # Vector{Int64}
	@btime sum(relu_v3, $v1)
	@btime sum(relu_v3, $v2)

	@btime sum(relu_v4, $v1)
	@btime sum(relu_v4, $v2)
	nothing
end

# ╔═╡ 5815524c-7361-483f-8dd9-3403620dcb11
with_terminal() do
	@btime sum([rand_int() for i in 1:1000])
	# 当你看到奇怪的大量 allocation 数目的时候， 大概率是因为里面涉及到了类型不稳定的代码
	@btime sum([rand_int_or_float() for i in 1:1000])
	nothing
end

# ╔═╡ 5fdb665f-6ed0-45ee-94b9-45f17d16cd05
md"""
### 什么样的 Julia 会快？

对于一个 Julia 函数和给定的输入类型， 如果 Julia 能够在不执行代码的情况下推断出全部可能的类型， 那么这个函数我们一般称之为类型稳定 (type-stable) 或者 type inferrable。 在类型稳定的前提下， Julia 可以避免很多运行时的 if 检查， 从而一方面：

1. 降低不必要的 if 判断本身的计算量
2. 当代码变得非常简单的时候， 就可以触发 SIMD 或者 AVX 等更强的性能优化手段

最主要的是： 当你告诉编译器足够多的类型信息的时候， 编译器才能够将你的代码进行编译优化。

Python 之所以慢， 是因为 Python 的机制使得必须进行运行时的类型检查。

!!! tip "写类型稳定的函数"
	高性能 Julia 代码的其中一条核心建议是： 写出类型稳定的函数。 Julia 提供 `@code_warntype`, `Test.@inferred`, JET.jl 等工具来辅助你写出类型稳定的代码。
"""

# ╔═╡ 21a2b3c6-8be9-4331-8992-1ff91968894e
md"""
## 向量化代码 vs for 循环

关于更多的细节可以阅读我今年做的 Julia 小课堂材料 [广播和向量化代码](https://johnnychen94.github.io/Julia_and_its_applications/4_1_broadcasting.jl.html)

因为 Julia 的广播运算 `.` 可以应用到任意函数上， 所以 Julia 的向量化手段非常方便好用， 例如：

```julia
abs.(X)

# 等价于
Z = similar(X)
@inbounds @simd for i in eachindex(X, Z)
    Z[i] = abs(X[i])
end
```

换句话说， 广播的本质是 for 循环展开。

在 Python/MATLAB 中， 向量化代码是一个主要的性能优化手段， 这背后有两个主要原因：

- 向量化代码在另一个更快的语言（例如C）里面展开这个 for 循环， 因此不会受到 Python 语言本身的速度限制。
- 在 C 里面实现的函数的数值类型是明确的， 因此也能够在编译期就知道具体的数值类型， 从而触发更高效的编译优化手段。
"""

# ╔═╡ 24dc8c31-0791-4997-ac30-29da2fa31861
md"""
!!! warning "向量化是高效的在 Julia 下并不一定成立"
	在 Python/MATLAB 下， 向量化是绕过语言本身性能开销的几乎唯一手段。 在 Julia 下， 因为 for 循环本身非常快， 因此并不一定需要向量化 （特别是对 CPU 代码来说）。

很多时候， 向量化的代价是更高的内存占用， 例如下面两个实现在数学上是等价的， 但是在计算效率上是不同的。
"""

# ╔═╡ fd467bf6-3e8e-421a-a7d8-eb21e793be6e
sum_addmul_vec(X, Y, Z) = sum(X .* Y .+ Z)

# ╔═╡ 89cd0284-06ad-4bb4-90c8-1d3a3eec4815
function sum_addmul_loop(X, Y, Z)
	rst = zero(eltype(X))
	@inbounds @simd for i in eachindex(X, Y, Z)
		rst += X[i]*Y[i]+Z[i]
	end
	return rst
end

# ╔═╡ 6eb92b60-cb0b-4b24-b81d-46d7952e8b0b
with_terminal() do
	X, Y, Z = rand(1000), rand(1000), rand(1000)
	@show sum_addmul_vec(X, Y, Z) ≈ sum_addmul_loop(X, Y, Z)
	# 广播： 中间结果是矩阵， 需要先存储下来
	@btime sum_addmul_vec($X, $Y, $Z)
	# loop： 中间结果是标量， 0 内存开销
	@btime sum_addmul_loop($X, $Y, $Z)
	nothing
end

# ╔═╡ 659c4b3d-2acc-4245-852a-1393374f31e2
md"""
正是因为这个原因， Julia 下很多函数虽然是为矩阵设计的， 但是背后仅仅只是给标量实现， 例如深度学习中的激活函数 `relu(x) = max(x, 0)`。 这样设计的目的是为了在允许地情况下更好地利用 for 循环展开, 例如上面的代码就可以写

```diff
- sum_addmul_vec(X, Y, Z) = sum(X .* Y .+ Z)
+ addmul(x, y, z) = x * y + z
```
"""

# ╔═╡ 6b05af17-cebe-472a-83af-94ec963136bf
md"""
## 编译期计算

我们前面提到的类型稳定和多重派发很大程度上就是将 if 判断从代码的运行时转移到代码的编译时， 从而提升代码的执行效率。

编译期计算的主要思路是告诉 Julia 编译器足够多的类型信息， 例如：

```julia
# Julia 自带的 Val 就是这么定义的
struct Val{X} where X end
```

里面并不存储任何实际的数据： 它将值 `X` 作为编译期可以知道的类型信息告诉 Julia 了。

下面我们以 `fibonacci` 数列为例来演示编译期计算是如何加速代码的。
"""

# ╔═╡ 2df9928d-8b3e-4f9f-87ae-b1ce10b9b8f3
fib(n) = n > 2 ? fib(n-1) + fib(n-2) : 1

# ╔═╡ 6c971aca-d101-4016-8a38-9a024acb424e
md"""
我们知道这个运算是很低效的， 比如说每一次调用 `fib(10)` 的时候都会重复计算很多很多次 `fib(3)`.
"""

# ╔═╡ 54ce8b91-63cb-4d80-8945-f8bb310cf06a
with_terminal() do
	@btime fib(5)
	@btime fib(20)
end

# ╔═╡ 75ae99ca-5b1d-4ab1-9f87-a71a936d02ec
md"""
一个自然的想法就是将之前已经计算过的结果记录下来， 从而通过查表来知道结果。
"""

# ╔═╡ c65822e0-9ca5-4437-8ce3-4e32ab8f0664
function fib_cached(n)
	# 当前也可以构造一个全局的缓存
	context = Vector{Union{Missing, Int}}(missing, n)
	@inbounds context[1] = 1
	@inbounds context[2] = 1
	
	function _fib(n, context)
		val = @inbounds context[n]
		if ismissing(val)
			rst = _fib(n-1, context) + _fib(n-2, context)
			context[n] = rst
		else
			rst = val
		end
		return rst
	end
	return _fib(n, context)
end

# ╔═╡ 852eb1fe-fc18-4233-a2d1-b3cf81a1c1e2
with_terminal() do
    @btime fib_cached(5) # slower
    @btime fib_cached(20) # faster
end

# ╔═╡ 445439eb-af9b-40ee-bafd-4fd458ab19dc
md"""
这里构造的表是在代码执行的时候现场构建的， 因此 `Vector` 本身会带来一定的开销。

如果能够让 Julia 在代码编译的时候就把这个表查完的话， 那么我们在实际运行代码的时候就不需要反复构造这个表了。
"""

# ╔═╡ 1bd23fda-22a0-4c92-81d9-9172d7f4c0a0
# N 的信息告诉了编译器
struct StaticInt{N} end

# ╔═╡ 617dc0f8-6d16-46bd-a8f8-8143d4ef2977
begin
	fib_static(n::Int) = _fib_static(StaticInt{n}()) # type-unstable
	@generated function _fib_static(::StaticInt{n}) where n
		if n > 2
			return :(_fib_static(StaticInt{$n-1}()) + _fib_static(StaticInt{$n-2}()))
		else
			return :1
		end
	end
end

# ╔═╡ a3a8ee09-3545-488d-8d1a-e1dc356618d2
with_terminal() do
    @btime fib_static($(Ref(5))[]) # slower
    @btime fib_static($(Ref(20))[]) # faster than faster!
end

# ╔═╡ 7112c1d3-9960-4739-af52-5a1d5c8fe493
md"""
这里使用 `$(Ref(x))[]` 的原因是因为否则的话 Julia 编译器会直接作弊从而拿到一个虚假的数值
"""

# ╔═╡ 16dbe4e0-29d9-46fc-aaf8-69db36473809
with_terminal() do
	# 你需要 250GHz 的 CPU 才能够在 1个时钟周期 0.04ns 内执行完一条指令； 这显然是不现实的。
	# 换句话说， 任何低于 0.2ns 的结果都是虚假的结果。
    @btime fib_static(5)
    @btime fib_static(20)
end

# ╔═╡ 89c4f0d1-b49a-4b5b-bd09-679c2e19907d
md"""
`@generated` 允许 Julia 在代码编译的时候根据输入的类型信息来构造新的表达式作为返回结果， 这里我们直接根据类型信息 `n` 来将 fibonacci 的结果在编译期间直接计算出来了， 因此在实际函数调用的时候， 我们拿到了一个接近于 ``0`` 开销的函数调用。

See also [Metaprogramming: generated functions](https://docs.julialang.org/en/v1/manual/metaprogramming/#Generated-functions)
"""

# ╔═╡ e3c89826-a0ca-49c7-933b-3d6ad588c723


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.2.2"
PlutoUI = "~0.7.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "940001114a0147b6e4d10624276d56d531dd9b49"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.2.2"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─1bf02c40-5a49-11ec-35ff-a9b7c53995bb
# ╠═a42271da-64ce-4b30-ab2e-8da84b41101c
# ╟─312f7bd4-07e2-4d5d-a8d9-6d1153e875b9
# ╟─317cc64a-e4f2-43d6-a758-93870c1b4065
# ╠═5d2cbb44-8d69-4acc-88e3-bf7f47e6afe4
# ╠═c194fe61-5a64-44e3-b075-2ac9f4584818
# ╟─0e4dcbed-366e-4079-81f9-8a03b51f4770
# ╟─2df3566d-2356-452e-94a8-d8cf68bc960b
# ╟─d035ecfc-805e-49f1-ad3c-65f768b490d6
# ╟─36918219-4bd1-4e73-a8c2-644586d1a584
# ╟─43b1bc1e-8236-4fb7-b706-6ae2b3ae474f
# ╟─d911e626-41ca-4efd-aafa-9e956c7527aa
# ╟─6278892c-b9e3-439e-81ad-142e31a19fe2
# ╠═2f32ac4c-f741-4718-b426-43094288d617
# ╠═852deb7d-573d-4076-85f5-d53bc221804c
# ╟─77ff6646-5f57-4d09-80d8-8afb3e5edef4
# ╟─637562f3-336a-4224-942a-e8f43026e580
# ╠═c27185b8-1e7c-4a1b-9bce-630602092e38
# ╠═8f9ac91e-1a42-43f9-8a20-1f88d48bf502
# ╟─7d90ff5f-070e-4831-a2e2-08bce5cc10f2
# ╟─925ab156-86eb-4369-b03a-aeec78da325b
# ╟─45f19f6a-40e8-4d46-b328-8814f20b9ead
# ╠═87de63f3-b67e-4665-9e8b-a7a3c2751ccc
# ╠═7ae71b08-9896-42df-b749-525ebed9c111
# ╟─248a5bb6-815c-4b3a-93b3-d353af2cd8fa
# ╠═4990b3c8-dd81-4128-b13d-384c4588923e
# ╠═8fba3f16-4554-415a-b3db-9d7cac8051f3
# ╠═04eb9145-45ce-41d5-b88c-0af6e9a0ebc3
# ╠═a16bf4ec-ac33-493b-a159-67612068cbd4
# ╟─5d9e26d8-7320-41b7-870b-ebc983d548ed
# ╠═a3bbcc93-844f-4b74-8936-decd668fed68
# ╠═36c10b7e-7b43-42f6-961f-482a98052fa3
# ╟─3126f01c-9d0f-4f6f-ba87-5d76f82169fe
# ╠═76aedce3-96d1-405d-909a-7a9f3d1f6077
# ╠═237cb556-085a-4e80-aeb9-d902437c4773
# ╠═5815524c-7361-483f-8dd9-3403620dcb11
# ╟─5fdb665f-6ed0-45ee-94b9-45f17d16cd05
# ╟─21a2b3c6-8be9-4331-8992-1ff91968894e
# ╟─24dc8c31-0791-4997-ac30-29da2fa31861
# ╠═fd467bf6-3e8e-421a-a7d8-eb21e793be6e
# ╠═89cd0284-06ad-4bb4-90c8-1d3a3eec4815
# ╠═6eb92b60-cb0b-4b24-b81d-46d7952e8b0b
# ╟─659c4b3d-2acc-4245-852a-1393374f31e2
# ╟─6b05af17-cebe-472a-83af-94ec963136bf
# ╠═2df9928d-8b3e-4f9f-87ae-b1ce10b9b8f3
# ╟─6c971aca-d101-4016-8a38-9a024acb424e
# ╠═54ce8b91-63cb-4d80-8945-f8bb310cf06a
# ╟─75ae99ca-5b1d-4ab1-9f87-a71a936d02ec
# ╠═c65822e0-9ca5-4437-8ce3-4e32ab8f0664
# ╠═852eb1fe-fc18-4233-a2d1-b3cf81a1c1e2
# ╟─445439eb-af9b-40ee-bafd-4fd458ab19dc
# ╠═1bd23fda-22a0-4c92-81d9-9172d7f4c0a0
# ╠═617dc0f8-6d16-46bd-a8f8-8143d4ef2977
# ╠═a3a8ee09-3545-488d-8d1a-e1dc356618d2
# ╟─7112c1d3-9960-4739-af52-5a1d5c8fe493
# ╠═16dbe4e0-29d9-46fc-aaf8-69db36473809
# ╟─89c4f0d1-b49a-4b5b-bd09-679c2e19907d
# ╠═e3c89826-a0ca-49c7-933b-3d6ad588c723
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
