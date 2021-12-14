### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ a858ec12-ae05-433c-8850-84630ae10896
begin
	using PlutoUI, CoordinateTransformations, Rotations, Viznet, Compose, StaticArrays
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
	
	# up down layout
	function updown(a, b; width=nothing)
		HTML("""<table class="nohover" style="border:none" $(width === nothing ? "" : "width=$(width)px")>
<tr>
	<td>$(html(a))</td>
</tr>
<tr>
	<td>$(html(b))</td>
</tr></table>
""")
	end
	
	function highlight(str)
		HTML("""<span style="background-color:yellow">$(str)</span>""")
	end
end;

# ╔═╡ 9c3b4290-138c-406c-a980-966dd93b11d2
using SymEngine # install with `] add SymEngine`

# ╔═╡ 7209ba2c-94d9-4102-9772-68e11c9f9fa5
using OMEinsum

# ╔═╡ a5ca245f-d67b-48a5-a70e-afdc3ee840ec
using Zygote

# ╔═╡ 62e98e87-800d-4780-9fd7-70b82f2a0c3e
using CUDA

# ╔═╡ 70cd5e7d-9200-444f-b974-0238c74c6013
using OMEinsumContractionOrders

# ╔═╡ bb3d0c31-787c-44d6-a415-4f85a20eac5d
html"<button onclick='present();'>present</button>"

# ╔═╡ b526ffe6-5c4a-450e-99ba-fc44fc4f6f72
html"""
<script>
document.body.style.cursor = "pointer";
</script>
"""

# ╔═╡ bac7b9bb-8d9a-418e-b8d5-ffb00796dd22
md"## Your animal friends"

# ╔═╡ ab5c94d0-a69e-476c-9548-b522c5c48fc3
rand_animal(size...) = Basic.(Symbol.('🐀' .+ rand(0:60, size...)))

# ╔═╡ e08fdfd1-a521-4434-af61-bfed3e42c61a
md"This is a vector"

# ╔═╡ dddaf055-f769-4b80-8a97-ff1e76ad99a8
v1 = rand_animal(3)

# ╔═╡ b3cba07a-84cd-4796-aa01-01e4719e8ff0
md"This is a matrix"

# ╔═╡ 1aef6d34-41f0-4717-9b13-f81f19e8825f
m1 = rand_animal(3, 3)

# ╔═╡ 399afc64-039f-43da-9994-05f4cc44d633
md"This is a tensor of rank 4"

# ╔═╡ 7a9e9466-03fd-4955-8e5d-5cba4544e7c7
t1 = rand_animal(2, 2, 2, 2)

# ╔═╡ b4088ca7-fadd-4491-a15b-9648004b238c
md"## Matrix-matrix multiplication"

# ╔═╡ 39149c34-76c1-46eb-9c1c-a0e7e2e51d17
md"This is an einsum notation, defined by `@ein_str` string literal."

# ╔═╡ ae4ef95d-0a65-4a80-8abd-1a684c60b30d
code_mm = ein"ij,jk->ik"

# ╔═╡ b3240fff-de5d-475b-9875-9440e61a858a
mm_1 = rand_animal(3, 3)

# ╔═╡ 700874d1-1dbf-4ac8-91d7-523733a176e7
mm_2 = rand_animal(3, 3)

# ╔═╡ a1b9e48d-7bb5-461c-b161-aae154fcb799
md"You can call it"

# ╔═╡ 1e9ca8b5-81bc-4946-a8c4-c08afe903d8b
ein"ij,jk->ik"(mm_1, mm_2)

# ╔═╡ 31e06d5b-2efa-41a8-987f-5e75c87a3eff
md"It is equivalent to"

# ╔═╡ 7a7dd9a1-fed7-428c-899e-90cbe3b6d699
let
	mm_out = zeros(Basic, 3, 3)
	for i=1:3
		for j=1:3
			for k=1:3
				mm_out[i,k] += mm_1[i,j] * mm_2[j, k]
			end
		end
	end
	mm_out
end

# ╔═╡ ed6fa023-43b1-4f5c-be3f-f93f16dfe285
md"It can also be constructed as"

# ╔═╡ 778d16ea-67f1-4903-9767-28682b99527c
EinCode([['i', 'j'], ['j', 'k']], ['i', 'k'])

# ╔═╡ 5cf51764-3138-4fd9-8bcd-c399ba4306f7
md"or"

# ╔═╡ f23efdd0-47dd-49b8-88c5-3debd35cd55a
EinCode([[1, 2], [2, 3]], [1, 3])

# ╔═╡ 005fddc2-1378-426c-b4b7-80a09baf8ec7
let n = Basic(:n)
	# NOTE: `flop` counts the number of iterations!
	flop(code_mm, Dict('i'=>n, 'j'=>n, 'k'=>n))
end

# ╔═╡ dfcb8259-7f6f-40b1-ae75-15eaaabe7279
md"or, for convenience"

# ╔═╡ db6ba19e-2425-4ddc-a67a-d68ebadfd0b2
flop(code_mm, uniformsize(code_mm, Basic(:n)))

# ╔═╡ 3dbb855a-4045-4433-93c8-43997161807b
md"##  This is summation"

# ╔═╡ fbb23079-6b77-412e-8648-e0bf10fabab5
sum_1 = rand_animal(3)

# ╔═╡ 7ae59add-d3d4-42bf-83fd-989c2848225a
ein"i->"(sum_1)

# ╔═╡ 14ad6f1c-cabf-47c8-ad39-81bcd92bf840
sum_2 = rand_animal(2, 2, 3)

# ╔═╡ d14e10af-5179-476d-ab8a-63d1837e866d
ein"ijk->k"(sum_2)

# ╔═╡ 61545cc3-f486-4dea-83f8-448eb23646fb
flop(ein"ijk->k", uniformsize(ein"ijk->k", Basic(:n)))

# ╔═╡ 2790a9b1-f706-4167-8b7c-8d8432b2511a
md"## Repeating a vector"

# ╔═╡ f8cc753b-8ba0-4212-80ef-1ced60866389
rp_1 = rand_animal(3)

# ╔═╡ 051de93e-f189-4a75-bd82-ebd646eb7eda
ein"i->ij"(rp_1; size_info=Dict('j'=>4))

# ╔═╡ 68e643ba-f852-4b9e-9799-13f193df3bfe
let
	rp_out = zeros(Basic, 3, 4)
	for i=1:3
		for j=1:4
			rp_out[i, j] += rp_1[i]
		end
	end
	rp_out
end

# ╔═╡ d00afc01-ecb0-454e-8cac-342d5b75101e
md"## Star contraction"

# ╔═╡ b7b777bc-3f38-4a4f-a438-454187602962
star_1 = rand_animal(2, 2)

# ╔═╡ e4ffef2b-9b19-40ed-8547-63673a3ea649
star_2 = rand_animal(2, 2)

# ╔═╡ 6c2955de-be35-4fd9-a5c8-ef430ed0013a
star_3 = rand_animal(2, 2)

# ╔═╡ 579222f1-da51-4afa-9087-2c0799bbe6ad
ein"ai, aj, ak->ijk"(star_1, star_2, star_3)

# ╔═╡ b22796e6-d163-4bbb-b4d4-bbaf57e63f8f
let
	star_out = zeros(Basic, 2, 2, 2)
	for i=1:2
		for j=1:2
			for k=1:2
				for a=1:2
					star_out[i, j, k] += star_1[a,i] * star_2[a,j] * star_3[a,k]
				end
			end
		end
	end
	star_out
end

# ╔═╡ 955d364d-5225-4833-95d5-18265e319523
md"## Automatic differentiation"

# ╔═╡ d7c25437-2bc9-473d-846e-d9f8a4ca7d9c
a, b = randn(2, 2), randn(2);

# ╔═╡ 1f57a827-c57b-4d1e-ac73-e41d6206052a
Zygote.gradient(x->ein"i->"(ein"ij,j->i"(x, b))[], a)[1]

# ╔═╡ 5dbedaab-48d8-4abe-8046-eee0e4cd4093
let
	A, B, C = randn(2,2,2,2), randn(2,2,2,2,2), randn(2,2,2,2,2)
	size_dict = uniformsize(ein"ijkl,lmkcd,asedf->dfas", 2)
	O = ein"ijkl,lmkcd,asedf->dfas"(A, B, C; size_info=size_dict)

	Ō = randn(2,2,2,2)
	# exchange input/output labels and tensors
	Ā = ein"dfas,lmkcd,asedf->ijkl"(Ō, B, C; size_info=size_dict)
	B̄ = ein"ijkl,dfas,asedf->lmkcd"(A, Ō, C; size_info=size_dict)
	C̄ = ein"ijkl,lmkcd,dfas->asedf"(A, B, Ō; size_info=size_dict)
	Ā, B̄, C̄
end;

# ╔═╡ 015b2b71-b6aa-4b6e-b6bf-75776c0f3c90
md"## Speed up your code with GPU"

# ╔═╡ 7f8a6c77-75a6-4063-9fc6-409397bb6306
md"""
* step 1: import CUDA library.
* step 2: upload your array to GPU with `CuArray` function.
"""

# ╔═╡ dcc74a07-e7e4-48a5-9942-4f7a9714db9b
let
	cuarr1, cuarr2 = CuArray(randn(2, 2)), CuArray(randn(2))
	result = ein"ij,j->i"(cuarr1, cuarr2)
	typeof(result)
end

# ╔═╡ 6f9df5fe-70de-4bab-8fd6-e0173f06d6e4
md"Note: if you do not have a Nvidia GPU, the above code will give you an error, please do not panic."

# ╔═╡ f3b5656d-5608-4325-a884-65bceddb4963
md"""## Summary
* Einsum can be defined as: iterating over unique indices, accumulate product of corresponding input tensor elements to the output tensor.
* Einsum's representation power
    * ein"ij,jk->ik" is matrix multiplication
    * ein"i->" and ein"ijk->k" is summation
    * ein"i->ij" is repeating axis
    * ein"ai,aj,ak->ijk" is a star contraction
* The time complexity of an einsum notation is ``O(n^{(\#~ of ~ unique ~ labels)})``
* Features in OMEinsum
    * Automatic differentiation
    * GPU
    * Generic programming
"""

# ╔═╡ a9d59880-0cc1-441b-9329-f58d39c23f16
md"# Contraction order matters"

# ╔═╡ 3c50281e-ae20-40ea-85ea-dcccfbd2756e
md"## Multiplying a sequence of matrices"

# ╔═╡ 7f6c0836-7c9e-4726-9512-dc2e5ad86e1f
code_seq_1 = ein"ij,jk,kl,lm->im"

# ╔═╡ 0efbdbad-a1e1-4aab-a9e7-143a05c934eb
seq_1 = rand_animal(2,2)

# ╔═╡ e2275f15-a57b-4a74-9826-2c723aad096c
seq_2 = rand_animal(2,2)

# ╔═╡ ebfe52bb-76c1-4b39-8f8c-0dec56cc80f3
seq_3 = rand_animal(2,2)

# ╔═╡ 744576a6-6d31-48a6-a71c-cb6246b76bef
seq_4 = rand_animal(2,2)

# ╔═╡ e92b78f1-8ac6-421f-930b-e092402845cd
ein"ij,jk,kl,lm->im"(seq_1, seq_2, seq_3, seq_4)

# ╔═╡ 623551e9-48bb-4976-920e-12396a596975
flop(code_seq_1, uniformsize(code_seq_1, Basic(:n)))

# ╔═╡ d4a3557a-9de2-4500-b09e-5b3c249906fc
code_seq_2 = ein"(ij,jk),(kl,lm)->im"

# ╔═╡ 5ff2bdd9-a708-4ee3-92fa-b8fbae6bd3e3
flop(code_seq_2, uniformsize(code_seq_2, Basic(:n)))

# ╔═╡ 484b3561-6ed3-40bf-b94d-526f508c4755
md"## The Song Shan Lake Spring School (SSSS) Challenge"

# ╔═╡ d4040b3f-5595-4fe9-9356-6438017820fa
md"[Song Shan Lake Spring School Github](https://github.com/QuantumBFS/SSSS)"

# ╔═╡ ca083761-51d9-4144-ad79-5281e3ca4522
md"In 2019, Lei Wang, Pan Zhang, Roger and me released a challenge in the Song Shan Lake Spring School, the one gives the largest number of solutions to the challenge quiz can take a macbook home ([@LinuxDaFaHao](https://github.com/LinuxDaFaHao)). Students submitted many [solutions to the problem](https://github.com/QuantumBFS/SSSS/blob/master/Challenge.md). The second part of the quiz is"

# ╔═╡ 8482d4d2-b377-4d36-a395-5db79ccb136c
md"""
θ = $(@bind θ2 Slider(0.0:0.01:π; default=0.5))

ϕ = $(@bind ϕ2 Slider(0.0:0.01:2π; default=0.3))
"""

# ╔═╡ 7288ba08-f845-428e-a02c-cccfe4d160cb
md"""
In the $(highlight("Buckyball")) structure shown in the figure, we attach an ising spin ``s_i=\pm 1`` on each vertex. The neighboring spins interact with an $(highlight("anti-ferromagnetic")) coupling of unit strength. Count the $(highlight("degeneracy")) of configurations that minimizes the energy
```math
E(\{s_1,s_2,\ldots,s_n\}) = \sum_{i,j \in edges}s_i s_j
```
"""

# ╔═╡ 87613668-8585-49fe-b43a-8bb4be430287
# returns atom locations
function fullerene()
	φ = (1+√5)/2
	res = NTuple{3,Float64}[]
	for (x, y, z) in ((0.0, 1.0, 3φ), (1.0, 2 + φ, 2φ), (φ, 2.0, 2φ + 1.0))
		for (α, β, γ) in ((x,y,z), (y,z,x), (z,x,y))
			for loc in ((α,β,γ), (α,β,-γ), (α,-β,γ), (α,-β,-γ), (-α,β,γ), (-α,β,-γ), (-α,-β,γ), (-α,-β,-γ))
				if loc ∉ res
					push!(res, loc)
				end
			end
		end
	end
	return res
end;

# ╔═╡ dec4a621-8d5c-4c20-a9ae-d7f765852950
let
	tb = textstyle(:default)
	Compose.set_default_graphic_size(14cm, 8cm)
	cam_position = SVector(0.0, 0.0, 0.5)
	rot = RotY(θ2)*RotX(ϕ2)
	cam_transform = PerspectiveMap() ∘ inv(AffineMap(rot, rot*cam_position))
	Nx = Ny = Nz = 4
	nb = nodestyle(:circle; r=0.01)
	eb = bondstyle(:default; r=0.01)
	x(i,j,k) = cam_transform(SVector(i,j,k) .* 0.03).data
	fl = fullerene()
	fig = canvas() do
		for (i,j,k) in fl
			nb >> x(i,j,k)
			for (i2,j2,k2) in fl
				(i2-i)^2+(j2-j)^2+(k2-k)^2 < 5.0 && eb >> (x(i,j,k), x(i2,j2,k2))
			end
		end
		tb >> ((0.4, 0.2), "60 vertices\n90 edges")
		nb >> (0.4, -0.1)
		tb >> ((0.55, -0.1), "Ising spin (s=±1)")
		eb >> ((0.37, -0.05), (0.43, -0.05))
		tb >> ((0.54, -0.05), "AFM coupling")
	end
	img = Compose.compose(Compose.context(0.3,0.5, 1.2/1.4, 1.5), fig)
	img
end

# ╔═╡ 004ebf76-0bce-4e4d-99f6-ef60816ecc07
c60_xy = fullerene();

# ╔═╡ f3ad225a-0b42-460e-a82c-b799d5da8f13
c60_edges = [[i,j] for (i,(i2,j2,k2)) in enumerate(c60_xy), (j,(i1,j1,k1)) in enumerate(c60_xy) if i<j && (i2-i1)^2+(j2-j1)^2+(k2-k1)^2 < 5.0];

# ╔═╡ 21c55a1d-018f-480a-91e6-c46f3a516fe3
c60_code = EinCode(c60_edges, Int[])

# ╔═╡ e731f0ed-948d-49ea-81ad-5bb8d66802ae
length(getixsv(c60_code))  # number of input tensors

# ╔═╡ 6746d834-9c40-4e32-b0f4-a6d716df277a
getiyv(c60_code)  # labels for the output tensor

# ╔═╡ 7107b506-58e3-4d5a-8899-4dccff1c6591
length(uniquelabels(c60_code))  # number of unique labels

# ╔═╡ ce134b9f-d4be-4728-b883-01b1c2ec9158
flop(c60_code, uniformsize(c60_code, Basic(:n)))

# ╔═╡ 738e9ed9-c6b3-4b90-8475-1923a3485447
md"## Find a good contraction order"

# ╔═╡ 41f07437-6f81-4da7-b4f2-037d9f36daff
# optimize use the `TreeSA` optimizer
c60_optcode = optimize_code(c60_code, uniformsize(c60_code, 2), TreeSA())

# ╔═╡ 647b241c-b08c-4a0c-9b40-c0398ad6b6ca
c60_elimination_order = OMEinsum.label_elimination_order(c60_optcode)

# ╔═╡ 0739e08b-0873-415e-a77b-07b83eae9fb6
md"contraction step = $(@bind nstep_c60 Slider(0:60; show_value=true, default=0))"

# ╔═╡ 739e3777-b8fc-4cd4-a92e-960f355a74ad
md"The resulting contraction order produces time complexity = $(flop(c60_optcode, uniformsize(c60_optcode, Basic(:n))))"

# ╔═╡ 78da91e7-1b76-46df-ae9a-6d611c2638e1
let
	θ2 = 0.5
	ϕ2 = 0.8
	mask = zeros(Bool,length(c60_elimination_order))
	mask[c60_elimination_order[1:nstep_c60]] .= true
	Compose.set_default_graphic_size(12cm, 12cm)
	cam_position = SVector(0.0, 0.0, 0.5)
	rot = RotY(θ2)*RotX(ϕ2)
	cam_transform = PerspectiveMap() ∘ inv(AffineMap(rot, rot*cam_position))
	Nx = Ny = Nz = 4
	tb = textstyle(:default)
	nb1 = nodestyle(:circle, fill("red"); r=0.01)
	nb2 = nodestyle(:circle, fill("white"), stroke("black"); r=0.01)
	eb = bondstyle(:default; r=0.01)
	x(i,j,k) = cam_transform(SVector(i,j,k) .* 0.03).data
	
	fig = canvas() do
		for (s, (i,j,k)) in enumerate(c60_xy)
			(mask[s] ? nb1 : nb2) >> x(i,j,k)
		end
		for (i, j) in c60_edges
			eb >> (x(c60_xy[i]...), x(c60_xy[j]...))
		end
		nb1 >> (-0.1, 0.45)
		tb >> ((-0.0, 0.45), "contracted")
		nb2 >> (-0.1, 0.50)
		tb >> ((-0.0, 0.50), "remaining")
	end
	Compose.compose(Compose.context(0.5,0.35, 1.0, 1.0), fig)
end

# ╔═╡ 2bff8d2e-838e-4581-8d2a-1dbde609eccc
md"The partition function"

# ╔═╡ 174b14a9-91fe-4c6e-861d-b669fe791138
Z = c60_optcode([(J = 1.0; β = 1.0; expJ = exp(β*J); [1/expJ expJ; expJ 1/expJ]) for i=1:90]...)[]

# ╔═╡ 63001407-5b10-4b0d-b4ec-98138d24b927
log(Z) / 60

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
Compose = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
CoordinateTransformations = "150eb455-5306-5404-9cee-2592286d6298"
OMEinsum = "ebe7aa44-baf0-506c-a96f-8464559b3922"
OMEinsumContractionOrders = "6f22d1fd-8eed-4bb7-9776-e7d684900715"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Rotations = "6038ab10-8711-5258-84ad-4b1120ba62dc"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
Viznet = "52a3aca4-6234-47fd-b74a-806bdf78ede9"
Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[compat]
CUDA = "~3.5.0"
Compose = "~0.9.2"
CoordinateTransformations = "~0.6.2"
OMEinsum = "~0.6.5"
OMEinsumContractionOrders = "~0.6.1"
PlutoUI = "~0.7.23"
Rotations = "~1.1.0"
StaticArrays = "~1.2.13"
SymEngine = "~0.8.7"
Viznet = "~0.3.3"
Zygote = "~0.6.32"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BFloat16s]]
deps = ["LinearAlgebra", "Printf", "Random", "Test"]
git-tree-sha1 = "a598ecb0d717092b5539dbbe890c98bac842b072"
uuid = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
version = "0.2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BatchedRoutines]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "8ee75390ba4bbfaf9aa48c121857b0da9a914265"
uuid = "a9ab73d0-e05c-5df1-8fde-d6a4645b8d8e"
version = "0.2.1"

[[deps.BetterExp]]
git-tree-sha1 = "dd3448f3d5b2664db7eceeec5f744535ce6e759b"
uuid = "7cffe744-45fd-4178-b173-cf893948b8b7"
version = "0.1.0"

[[deps.CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[deps.CUDA]]
deps = ["AbstractFFTs", "Adapt", "BFloat16s", "CEnum", "CompilerSupportLibraries_jll", "ExprTools", "GPUArrays", "GPUCompiler", "LLVM", "LazyArtifacts", "Libdl", "LinearAlgebra", "Logging", "Printf", "Random", "Random123", "RandomNumbers", "Reexport", "Requires", "SparseArrays", "SpecialFunctions", "TimerOutputs"]
git-tree-sha1 = "2c8329f16addffd09e6ca84c556e2185a4933c64"
uuid = "052768ef-5323-5732-b1bb-66c8b64840ba"
version = "3.5.0"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRules]]
deps = ["ChainRulesCore", "Compat", "LinearAlgebra", "Random", "RealDot", "Statistics"]
git-tree-sha1 = "feeac82d7ef2bc0e531433a1f1bd65b4d8dd53c8"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.16.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "c6461fc7c35a4bb8d00905df7adafcff1fe3a6bc"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Dierckx]]
deps = ["Dierckx_jll"]
git-tree-sha1 = "5fefbe52e9a6e55b8f87cb89352d469bd3a3a090"
uuid = "39dd38d3-220a-591b-8e3c-4c3a8c710a94"
version = "0.5.1"

[[deps.Dierckx_jll]]
deps = ["CompilerSupportLibraries_jll", "Libdl", "Pkg"]
git-tree-sha1 = "a580560f526f6fc6973e8bad2b036514a4e3b013"
uuid = "cd4c43a9-7502-52ba-aa6d-59fb2a88580b"
version = "0.0.1+0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "9bc5dac3c8b6706b58ad5ce24cffd9861f07c94f"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.9.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "84f04fe68a3176a583b864e492578b9466d87f1e"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.6"

[[deps.ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "8756f9935b7ccc9064c6eef0bff0ad643df733a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.7"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "2b72a5624e289ee18256111657663721d59c143e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.24"

[[deps.GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"

[[deps.GPUArrays]]
deps = ["Adapt", "LinearAlgebra", "Printf", "Random", "Serialization", "Statistics"]
git-tree-sha1 = "7772508f17f1d482fe0df72cabc5b55bec06bbe0"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.1.2"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "2cac236070c2c4b36de54ae9146b55ee2c34ac7a"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.13.10"

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

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools", "Test"]
git-tree-sha1 = "006127162a51f0effbdfaab5ac0c83f8eb7ea8f3"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "7cc22e69995e2329cc047a879395b2b74647ab5f"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "4.7.0"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c5fc4bef251ecd37685bea1c4068a9cfa41e8b9a"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.13+0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MPC_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "MPFR_jll", "Pkg"]
git-tree-sha1 = "9618bed470dcb869f944f4fe4a9e76c4c8bf9a11"
uuid = "2ce0c516-f11f-5db3-98ad-e0e1048fbd70"
version = "1.2.1+0"

[[deps.MPFR_jll]]
deps = ["Artifacts", "GMP_jll", "Libdl"]
uuid = "3a97d323-0669-5f0c-9066-3539efd106a3"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OMEinsum]]
deps = ["AbstractTrees", "BatchedRoutines", "CUDA", "ChainRulesCore", "Combinatorics", "LinearAlgebra", "MacroTools", "Requires", "Test", "TupleTools"]
git-tree-sha1 = "c172922074434ef8dda952da7178208ad832637a"
uuid = "ebe7aa44-baf0-506c-a96f-8464559b3922"
version = "0.6.5"

[[deps.OMEinsumContractionOrders]]
deps = ["BetterExp", "OMEinsum", "Requires", "SparseArrays", "Suppressor"]
git-tree-sha1 = "68fd9479e9c0a8a161787b2c0d05368444de1b87"
uuid = "6f22d1fd-8eed-4bb7-9776-e7d684900715"
version = "0.6.1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

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
git-tree-sha1 = "5152abbdab6488d5eec6a01029ca6697dff4ec8f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.23"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra"]
git-tree-sha1 = "adf644ef95a5e26c8774890a509a55b7791a139f"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Libdl", "Random", "RandomNumbers"]
git-tree-sha1 = "0e8b146557ad1c6deb1367655e052276690e71a3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.4.2"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "8f82019e525f4d5c669692772a6f4b0a58b06a6a"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.2.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "dbf5f991130238f10abbf4f2d255fb2837943c43"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.1.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[deps.SymEngine]]
deps = ["Compat", "Libdl", "LinearAlgebra", "RecipesBase", "SpecialFunctions", "SymEngine_jll"]
git-tree-sha1 = "6cf88a0b98c758a36e6e978a41e8a12f6f5cdacc"
uuid = "123dc426-2d89-5057-bbad-38513e3affd8"
version = "0.8.7"

[[deps.SymEngine_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "MPC_jll", "MPFR_jll", "Pkg"]
git-tree-sha1 = "3cd0f249ae20a0093f839738a2f2c1476d5581fe"
uuid = "3428059b-622b-5399-b16f-d347a77089a4"
version = "0.8.1+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "7cb456f358e8f9d102a8b25e8dfedf58fa5689bc"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.13"

[[deps.TupleTools]]
git-tree-sha1 = "3c712976c47707ff893cf6ba4354aa14db1d8938"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Viznet]]
deps = ["Compose", "Dierckx"]
git-tree-sha1 = "7a022ae6ac8b153d47617ed8c196ce60645689f1"
uuid = "52a3aca4-6234-47fd-b74a-806bdf78ede9"
version = "0.3.3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "IRTools", "InteractiveUtils", "LinearAlgebra", "MacroTools", "NaNMath", "Random", "Requires", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "76475a5aa0be302c689fd319cd257cd1a512fb3c"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.32"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

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
# ╟─bb3d0c31-787c-44d6-a415-4f85a20eac5d
# ╟─b526ffe6-5c4a-450e-99ba-fc44fc4f6f72
# ╟─a858ec12-ae05-433c-8850-84630ae10896
# ╟─bac7b9bb-8d9a-418e-b8d5-ffb00796dd22
# ╠═9c3b4290-138c-406c-a980-966dd93b11d2
# ╠═ab5c94d0-a69e-476c-9548-b522c5c48fc3
# ╟─e08fdfd1-a521-4434-af61-bfed3e42c61a
# ╠═dddaf055-f769-4b80-8a97-ff1e76ad99a8
# ╟─b3cba07a-84cd-4796-aa01-01e4719e8ff0
# ╠═1aef6d34-41f0-4717-9b13-f81f19e8825f
# ╟─399afc64-039f-43da-9994-05f4cc44d633
# ╠═7a9e9466-03fd-4955-8e5d-5cba4544e7c7
# ╟─b4088ca7-fadd-4491-a15b-9648004b238c
# ╠═7209ba2c-94d9-4102-9772-68e11c9f9fa5
# ╟─39149c34-76c1-46eb-9c1c-a0e7e2e51d17
# ╠═ae4ef95d-0a65-4a80-8abd-1a684c60b30d
# ╠═b3240fff-de5d-475b-9875-9440e61a858a
# ╠═700874d1-1dbf-4ac8-91d7-523733a176e7
# ╟─a1b9e48d-7bb5-461c-b161-aae154fcb799
# ╠═1e9ca8b5-81bc-4946-a8c4-c08afe903d8b
# ╟─31e06d5b-2efa-41a8-987f-5e75c87a3eff
# ╠═7a7dd9a1-fed7-428c-899e-90cbe3b6d699
# ╟─ed6fa023-43b1-4f5c-be3f-f93f16dfe285
# ╠═778d16ea-67f1-4903-9767-28682b99527c
# ╟─5cf51764-3138-4fd9-8bcd-c399ba4306f7
# ╠═f23efdd0-47dd-49b8-88c5-3debd35cd55a
# ╠═005fddc2-1378-426c-b4b7-80a09baf8ec7
# ╟─dfcb8259-7f6f-40b1-ae75-15eaaabe7279
# ╠═db6ba19e-2425-4ddc-a67a-d68ebadfd0b2
# ╟─3dbb855a-4045-4433-93c8-43997161807b
# ╠═fbb23079-6b77-412e-8648-e0bf10fabab5
# ╠═7ae59add-d3d4-42bf-83fd-989c2848225a
# ╠═14ad6f1c-cabf-47c8-ad39-81bcd92bf840
# ╠═d14e10af-5179-476d-ab8a-63d1837e866d
# ╠═61545cc3-f486-4dea-83f8-448eb23646fb
# ╟─2790a9b1-f706-4167-8b7c-8d8432b2511a
# ╠═f8cc753b-8ba0-4212-80ef-1ced60866389
# ╠═051de93e-f189-4a75-bd82-ebd646eb7eda
# ╠═68e643ba-f852-4b9e-9799-13f193df3bfe
# ╟─d00afc01-ecb0-454e-8cac-342d5b75101e
# ╠═b7b777bc-3f38-4a4f-a438-454187602962
# ╠═e4ffef2b-9b19-40ed-8547-63673a3ea649
# ╠═6c2955de-be35-4fd9-a5c8-ef430ed0013a
# ╠═579222f1-da51-4afa-9087-2c0799bbe6ad
# ╠═b22796e6-d163-4bbb-b4d4-bbaf57e63f8f
# ╟─955d364d-5225-4833-95d5-18265e319523
# ╠═a5ca245f-d67b-48a5-a70e-afdc3ee840ec
# ╠═d7c25437-2bc9-473d-846e-d9f8a4ca7d9c
# ╠═1f57a827-c57b-4d1e-ac73-e41d6206052a
# ╠═5dbedaab-48d8-4abe-8046-eee0e4cd4093
# ╟─015b2b71-b6aa-4b6e-b6bf-75776c0f3c90
# ╟─7f8a6c77-75a6-4063-9fc6-409397bb6306
# ╠═62e98e87-800d-4780-9fd7-70b82f2a0c3e
# ╠═dcc74a07-e7e4-48a5-9942-4f7a9714db9b
# ╟─6f9df5fe-70de-4bab-8fd6-e0173f06d6e4
# ╟─f3b5656d-5608-4325-a884-65bceddb4963
# ╟─a9d59880-0cc1-441b-9329-f58d39c23f16
# ╟─3c50281e-ae20-40ea-85ea-dcccfbd2756e
# ╠═7f6c0836-7c9e-4726-9512-dc2e5ad86e1f
# ╠═0efbdbad-a1e1-4aab-a9e7-143a05c934eb
# ╠═e2275f15-a57b-4a74-9826-2c723aad096c
# ╠═ebfe52bb-76c1-4b39-8f8c-0dec56cc80f3
# ╠═744576a6-6d31-48a6-a71c-cb6246b76bef
# ╠═e92b78f1-8ac6-421f-930b-e092402845cd
# ╠═623551e9-48bb-4976-920e-12396a596975
# ╠═d4a3557a-9de2-4500-b09e-5b3c249906fc
# ╠═5ff2bdd9-a708-4ee3-92fa-b8fbae6bd3e3
# ╟─484b3561-6ed3-40bf-b94d-526f508c4755
# ╟─d4040b3f-5595-4fe9-9356-6438017820fa
# ╟─ca083761-51d9-4144-ad79-5281e3ca4522
# ╟─dec4a621-8d5c-4c20-a9ae-d7f765852950
# ╟─8482d4d2-b377-4d36-a395-5db79ccb136c
# ╟─7288ba08-f845-428e-a02c-cccfe4d160cb
# ╠═87613668-8585-49fe-b43a-8bb4be430287
# ╠═004ebf76-0bce-4e4d-99f6-ef60816ecc07
# ╠═f3ad225a-0b42-460e-a82c-b799d5da8f13
# ╠═21c55a1d-018f-480a-91e6-c46f3a516fe3
# ╠═e731f0ed-948d-49ea-81ad-5bb8d66802ae
# ╠═6746d834-9c40-4e32-b0f4-a6d716df277a
# ╠═7107b506-58e3-4d5a-8899-4dccff1c6591
# ╠═ce134b9f-d4be-4728-b883-01b1c2ec9158
# ╟─738e9ed9-c6b3-4b90-8475-1923a3485447
# ╠═70cd5e7d-9200-444f-b974-0238c74c6013
# ╠═41f07437-6f81-4da7-b4f2-037d9f36daff
# ╠═647b241c-b08c-4a0c-9b40-c0398ad6b6ca
# ╟─0739e08b-0873-415e-a77b-07b83eae9fb6
# ╟─739e3777-b8fc-4cd4-a92e-960f355a74ad
# ╟─78da91e7-1b76-46df-ae9a-6d611c2638e1
# ╟─2bff8d2e-838e-4581-8d2a-1dbde609eccc
# ╠═174b14a9-91fe-4c6e-861d-b669fe791138
# ╠═63001407-5b10-4b0d-b4ec-98138d24b927
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
