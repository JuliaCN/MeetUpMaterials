# Tutorial

## 内容
* Julia 是什么样的语言
* Julia 的软件生态
* Julia 为什么快？
* 多重派发
* Julia 的软件包开发

## 食用方法
在终端中打开这个文件夹
```bash
git clone https://github.com/JuliaCN/MeetUpMaterials.git

cd MeetUpMaterials/HKUST-GZ2022/day1_liu_tutorial
```

```julia
# 先安装 Pluto
julia> using Pkg; Pkg.add("Pluto")

julia> using Pluto

julia> Pluto.run(; notebook="juliatutorial.jl")
```
