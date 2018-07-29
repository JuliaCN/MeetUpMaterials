# Tutorial for high performance matrix computations, in Julia

## Table of Contents
#### Performance Tips
* How to `@time` and `@benchmark` a piece of code
* Use `@simd`, `@inbounds` and `@inline` to speed up codes
* Use `StaticArrays.jl` for small matrices of fixed size to avoid allocation
* Improve type stability

#### Matrices
* Use `LinearMaps.jl` to view a linear function as a matrix
* Sparse Matrices

    * CSC Sparse Matrix
    * General Permutation Matrix
    * Identity Matrix

* Tensor Operations

## Preparations
* install latest [julia](https://julialang.org/)
* install required packages, open a julia REPL, type

    * Pkg.add("BenchmarkTools")
    * Pkg.add("TensorOperations")
    * Pkg.add("Yao")
    * Pkg.add("LinearMaps")
    * Pkg.add("IJulia")
    * Pkg.clone("https://github.com/GiggleLiu/Expokit.jl.git")

* type `jupyter notebook`, and open the notebook "juliamatrix.ipynb"

