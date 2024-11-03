### A Pluto.jl notebook ###
# v0.20.1

#> [frontmatter]

using Markdown
using InteractiveUtils

# ╔═╡ e9fbbd5d-6cea-4e1c-807b-6dc3939d3628
# ╠═╡ show_logs = false
using Pkg; Pkg.activate(".")

# ╔═╡ 92f32d6f-de53-4794-8451-5a3ca62ef828
using PlutoUI, LuxorGraphPlot; PlutoUI.TableOfContents()

# ╔═╡ b9970d7f-9a69-424e-89c0-bbfcfe5f12d7
using OMEinsum

# ╔═╡ c3cc1bd0-68e6-430c-b306-696c51165b9c
using Yao

# ╔═╡ 332085f3-ef12-4a7d-9714-e8f4a88d5a28
using GenericTensorNetworks

# ╔═╡ 1845d970-4f90-4714-bc74-6e38b27160f4
using TensorInference

# ╔═╡ ca6bee1f-d3d3-4620-aba9-363e5b856c69
md"""
# Tensor network ecosystem in Julia
"""

# ╔═╡ a481f737-c83a-4f55-b1b5-cbb33ddbc9f4
md"""
# Large scale tensor network and its contraction order
"""

# ╔═╡ c12e790f-769c-4277-b41d-81d08c0e134c
md"""
## OMEinsum.jl: a package for large scale tensor contraction

`OMEinsum` is a google summer of code (GSoC) project at 2019 (Andreas Peter and Jin-Guo Liu). It features:
- Hyper-optimized contraction order
- Automatic differentiation and GPU support

"""

# ╔═╡ ec23abba-eaf0-4e7a-bf7e-b50ffbe9532f
md"""
## Define an `EinCode`
"""

# ╔═╡ 1f6d1be8-5157-4115-b5d6-e4ad6d474dd5
md"A contraction order, or an *einsum code*, is specified with a string literal started with `ein`"

# ╔═╡ 0a83fd07-6dd3-4228-b435-c7f0c1ddbc12
code = ein"ij,jk->ik"  # returns an EinCode object

# ╔═╡ 1cf11208-acb2-4bbb-8342-140775c4a7c0
md"`getixsv` and `getiyv` to obtain input/output indices:"

# ╔═╡ e82c8140-c80e-4683-a72a-c8dec034c0a9
getixsv(code)

# ╔═╡ 8f153a7f-3977-44ce-8c9c-7540f6c84e2c
getiyv(code)

# ╔═╡ c4e8f71a-3118-4455-a9a5-b427e2d19ba0
md"""
The pseudocode reads
```julia
for i = 1:n_i
    for j = 1:n_j
        for k = 1:n_k
        	R[i, k] += A[i, j] * B[j, k]
		end
	end
end
```
"""

# ╔═╡ 9a66d58a-7958-4cf9-ba68-688323b74feb
md"einsum codes can be called liked a function:"

# ╔═╡ 4e849834-1f00-4283-ad7c-f7a783d77ab4
A, B = randn(3,3), randn(3, 3);

# ╔═╡ 0ddf1061-d53c-4561-943b-f4460ee58962
R = code(A, B)

# ╔═╡ 6af3c70e-5a7e-4ab8-baf1-d666fea321cb
md"""
## Contracting multiple tensors
"""

# ╔═╡ 3b9821b6-851d-4509-aa7c-7ac7c8d57399
code_long = ein"ij,jk,kl,lm->im"

# ╔═╡ 56cfb6d5-1866-4318-a578-7b30660b1f45
show_einsum(code_long; layout=StressLayout(optimal_distance=15))

# ╔═╡ 95b29cc5-41e6-4ce6-a4d7-25337b96eaa4
md"Einsum codes can take multiple tensors as input:"

# ╔═╡ cee4366b-a6f0-4a75-bcab-82b77b31b451
C, D = randn(3, 3), randn(3, 3)

# ╔═╡ 15c74390-bb16-4ea6-8e6e-70f9628304c4
code_long(A, B, C, D)

# ╔═╡ 008b26e8-862b-4e4a-8d76-fd671defca4f
md"""
## The matrix product state in physics
"""

# ╔═╡ 1d6f4700-99f2-40b2-a8ed-8640de7c5039
md"The following einsum code contracts multiple tensors to a *matrix product state*:"

# ╔═╡ 27c769f8-52ec-496c-bea7-cc210af9df99
code_mps = ein"aj,jbk,kcl,ldm,me->abcde"

# ╔═╡ f93ed0d4-bb49-462e-88ad-3995c2a9532c
tensors = [randn(2,20), randn(20,2,40), randn(40,2,40), randn(40,2,20), randn(20,2)];

# ╔═╡ ca5d4d5b-dfe3-4fd8-a5b2-6cbe70ef84a4
code_mps(tensors...) |> size  # `|>` is the pipe operator, same as applying a single variable function 

# ╔═╡ 6884f655-aac8-4f22-8de7-e2624f1e9246
show_einsum(code_mps; layout=StressLayout(optimal_distance=10))

# ╔═╡ 4d412abe-17b3-46bf-99fe-b133b20610ee
md"""
## The difference between `einsum` and Einstein's notation
"""

# ╔═╡ d1a325de-7ff3-43b5-87db-1615f746c5a2
md"An index in `einsum` can appear arbitrary times, not just 2!"

# ╔═╡ 3c423eb5-b64a-4256-a41c-7d675d7396c8
code_withbatch = ein"ijb,jkb->ikb" # b appears three times

# ╔═╡ b43d4f75-59d4-49af-a07d-7cc5f4aee7e6
md"""
`code_withbatch(A, B, R)` means
```julia
for i = 1:n_i
    for j = 1:n_j
        for k = 1:n_k
			for b = 1:n_b
        		R[i, k, b] += A[i, j, b] * B[j, k, b]
			end
		end
	end
end
```
"""

# ╔═╡ 6ce21263-bf2c-41b1-ac1f-5b4b29c94465
md"## Optimize the contraction order"

# ╔═╡ 609fb332-8067-4ffc-b678-7dbd3c879051
md"`OMEinsum` offers handy tools for complexity analysis and optimization in tensor contraction."

# ╔═╡ 095e3032-21f5-45d2-8b95-9df36047724c
size.(tensors)

# ╔═╡ a0369e77-e8ca-41a2-9bf0-864cefa57a6a
code_mps

# ╔═╡ cdf5ffd0-28a8-4a53-81b4-19037bb3e7cb
OMEinsum.getixsv(code_mps)

# ╔═╡ 344020d5-88b3-45db-8641-5ae1f690871f
md"Bond dimensions of tensors to contract is recorded in a `dictionary`"

# ╔═╡ c4eac832-3629-41bf-8dc9-5b2a6d3d914b
# extract sizes into a dictionary
size_dict = OMEinsum.get_size_dict(getixsv(code_mps), tensors)

# ╔═╡ c1e2fcdb-c12f-4743-ab7e-c0d2feb5ab2f
md"Given the contraction order and bond dimensions, one can easily estimate contraction complexity"

# ╔═╡ 3c84890c-0371-44cb-a9c7-ae76adeb0307
# The complexity is too high
contraction_complexity(code_mps, size_dict)

# ╔═╡ 98cafa86-1fa5-43b9-b479-3f0893fecbb8
md"""
- Time complexity is the number of "`*`" operations.
- Space complexity is the maximum size of intermediate tensors.
- Read-write complexity is the number of element read and write.
"""

# ╔═╡ a40cbf4b-4f5d-443c-8463-b4e9b5e6edcd
LocalResource("contractionorder.png")

# ╔═╡ 419e2c5d-08aa-4cbd-9857-8535c170179e
code_inner_product = ein"aj,jbk,kcl,ldm,me,an,nbo,ocp,pdq,qe->"

# ╔═╡ d7a7e5d5-5eae-4d92-8ce0-309702d0c777
tensors_inner = [tensors..., conj.(tensors)...]

# ╔═╡ c6b639a2-d5f4-47b6-84db-83682cc9b722
size_dict_inner = OMEinsum.get_size_dict(getixsv(code_inner_product), tensors_inner)

# ╔═╡ b176805b-ef1f-4cec-922a-f653ace76ce4
contraction_complexity(code_inner_product, size_dict_inner)

# ╔═╡ e564c83b-2b20-4c1a-87a4-1abc3c504c0c
md"Given the contraction order and bond dimensions, ne can use `optimize_code` to obtain a optimized order"

# ╔═╡ f80aa1e7-1a92-4a52-a070-d382fa36dcb3
optcode = optimize_code(code_inner_product, size_dict_inner, TreeSA())

# ╔═╡ 2656103c-fe7f-4a76-9f89-57aadc892824
# ╠═╡ show_logs = false
videofile = viz_contraction(optcode; framerate=2);

# ╔═╡ 05171dfb-a005-448d-856a-4f1d417451b0
LocalResource(videofile, :width=>400)

# ╔═╡ 750ab594-9990-4ad1-a8c8-e66ea058909d
contraction_complexity(optcode, size_dict_inner)

# ╔═╡ 9411e8b2-aa55-487f-b666-5eb1e3a821d9
md"## The available optimization methods"

# ╔═╡ 5ceb3861-c2bd-4e2f-9007-6285d1347027
md"Several types of optimization methods are offered:"

# ╔═╡ dce59830-0885-40fb-9693-b9f070f2388b
subtypes(CodeOptimizer)

# ╔═╡ 63e793e3-6eb1-4c65-8041-99beb33dc1fa
md"""
- `GreedyMethod`: fast but not optimal
- `ExactTreewidth`: optimal but exponential time
- `TreeSA`: heuristic local search, close to optimal, **slicing** supported
- `KaHyParBipartite` and `SABipartite`: min-cut based bipartition, better heuristic for extremely large tensor networks
"""

# ╔═╡ 1484dee3-df3f-4aaa-8c32-78eea3133e8f
md"""
## Theoretical optimal contraction order

*Theorem*: The optimal space complexity of tensor network contraction is equal to the *tree width* of its *line graph* $L(G)$.
"""

# ╔═╡ 3fc75abf-5f97-4534-87aa-7c5944e58d64
md"![](https://arrogantgao.github.io/assets/treewidth_figs/treedecomposition_square.png)"

# ╔═╡ 90f342ba-0a56-4702-afd5-6a8c49964b19
md"""
Please check out the blog: Finding the Optimal Tree Decomposition with Minimal Treewidth, [https://arrogantgao.github.io/blogs/treewidth/](https://arrogantgao.github.io/blogs/treewidth/)

And also Xuan-Zhao Gao's talk tomorrow.
"""

# ╔═╡ decce1ca-cd63-494c-8db5-c46990fdb740
md"## Further improve the memory efficiency: the slicing technique"

# ╔═╡ 754640f1-5621-460d-87de-8c90665db8c4
md"""
Slicing is a technique to **reduce memory cost** by unfolding some variables.
"""

# ╔═╡ 095d5fa0-6f85-4f4e-9ec0-18768f6839fb
nodestore() do ns
	r = 10
	dx = 50
	dy = 50
	nodes = []
	for (i, j) in [(0, 0), (0, 1), (1, 1), (1, 0)]
		push!(nodes, circle!((i*dx, j*dy), r))
	end
	edges = []
	for i=1:4
		push!(edges, Connection(nodes[i], nodes[mod1(i+1, 4)]))
	end
	
	nodes2 = []
	for (i, j) in [(0, 0), (0, 1), (1, 1), (1, 0)]
		push!(nodes2, circle!((170 + i*dx, j*dy), r))
	end
	edges2 = []
	for i=1:3
		push!(edges2, Connection(nodes2[i], nodes2[mod1(i+1, 4)]))
	end
	with_nodes(ns; padding_right=150, padding_top=40, padding_bottom=40) do
		LuxorGraphPlot.Luxor.fontsize(14)
		stroke.(nodes)
		stroke.(nodes2)
		stroke.(edges[1:3])
		stroke.(edges2[1:3])
		LuxorGraphPlot.Luxor.sethue("red")
		stroke(edges[end])
		LuxorGraphPlot.text("i", (nodes[1].loc + nodes[4].loc)/2 + LuxorGraphPlot.Point(0, 15))
		LuxorGraphPlot.Luxor.sethue("black")
		LuxorGraphPlot.text("=", 100, 30)
		LuxorGraphPlot.text("for i = 1: n_i", 140, -20)
		LuxorGraphPlot.text("end", 140, 80)
	end
end

# ╔═╡ 25f8e2f2-022e-4c65-aff3-4af8fe43a5dc
md"""
# Yao.jl: Tensor network for quantum circuit simulation
"""

# ╔═╡ e49d57c4-d215-4409-b7ad-f7206b2aec89
md"`Yao` is a framework for quantum circuit simulation in Julia Language."

# ╔═╡ 33f37f98-53e9-45b4-919a-2b9b1481f4ce
md"""
## Simulate a quantum circuit
"""

# ╔═╡ 5b263f0a-5885-4968-b14b-07bb5bc2f1a9
md"Let us initialize a *quantum Fourier transformation* circuit."

# ╔═╡ 920a9962-e83f-473c-977a-eab34ec26872
Basic(:π) # Basic is a symbolic type

# ╔═╡ d96500ba-ade4-4666-a37b-222673960117
md"The Hadamard gate"

# ╔═╡ 5956ee36-d0b8-4231-a5ae-b18d5c02842e
vizcircuit(H)

# ╔═╡ ddb5868a-7406-4f6f-971d-16394f4cea3b
mat(Basic, H) # Basic is a symbolic type

# ╔═╡ 5af0aca3-acd3-4172-b922-91c5568fbb35
md"""
The CPhase gate
"""

# ╔═╡ d336e16b-4af8-4564-9205-3ae51e61c33e
vizcircuit(control(2, 2, 1=>shift(Basic(:θ))))

# ╔═╡ bbe08769-858a-445f-a162-34cd7134ffd1
mat(Basic, control(2, 2, 1=>shift(Basic(:θ)))) # 2 qubits in total. Control: qubit-2, target: qubit-1

# ╔═╡ f32a5030-8c21-4859-82e8-8953cf8b534f
function qft_circuit(n::Int)
    c = chain(n)  # initialize a circuit with `n` qubits
    for i = 1:n
		# `put(num_bits, location => gate)`, put a gate at location.
		# `H` is a Hadamard gate.
        push!(c, put(n, i=>H))  # use `push!` to add a gate
        for j = i+1:n
			# `control(num_bits, control_bits, target_location => gate)`, control gate
            push!(c, control(n, j, i => shift(π/2^(j-i))))
        end
    end
    return c
end

# ╔═╡ 7b87b462-4c32-40f7-ae8f-f68df3d42e45
qft = qft_circuit(4);

# ╔═╡ 10242d23-2a97-43d5-874f-db283dfbd274
vizcircuit(qft)

# ╔═╡ 49dfaa9b-bcbc-4f60-8496-34561e57d098
md"""
## Map gates to tensors
"""

# ╔═╡ 9671c446-775e-4cb3-8e95-7c32480eeb07
md"Quantum gates have a tensor network representation:"

# ╔═╡ a3f038a5-8f09-4c33-bf71-ed07e03037b3
nodestore() do ns
	dx = 30
	r = 10
	sr = 3
	dots0 = [dot!(0, 0), dot!(2dx, 0)]
	c0 = box!((dx, 0), 2r, 2r)
	cons0 = [Connection(dots0[1], c0), Connection(c0, dots0[2])]

	DX = 170
	dots = [dot!(DX, 0), dot!(DX+2dx, 0)]
	c = circle!((DX+dx, 0), r)
	cons = [Connection(dots[1], c), Connection(c, dots[2])]

	with_nodes(ns; padding_left=20, padding_right=20) do
		LuxorGraphPlot.fontsize(14)
		stroke(c0)
		stroke(c)
		LuxorGraphPlot.text("H", c0)
		LuxorGraphPlot.text("H", c)
		LuxorGraphPlot.text("maps to", 80, 3)
		stroke.(cons0)
		stroke.(cons)
		LuxorGraphPlot.text("i", DX-10, 3.5)
		LuxorGraphPlot.text("j", DX+2dx+10, 3.5)
	end
end

# ╔═╡ 6173ea8a-a9e7-40e8-badb-601f8e96bd7d
nodestore() do ns
	dx = 30
	r = 10
	sr = 3
	dy = 40
	dots0 = [dot!(0, 0), dot!(2dx, 0), dot!(0, dy), dot!(2dx, dy)]
	c0 = box!((dx, 0), 2r, 2r)
	scs0 = [circle!((dx, dy), sr)]
	cons0 = [Connection(dots0[1], c0), Connection(dots0[2], c0), Connection(dots0[3], dots0[4]), Connection(scs0[1], c0)]

	DX = 170
	dots = [dot!(DX, 0), dot!(DX+2dx, 0), dot!(DX, dy), dot!(DX+2dx, dy)]
	c = circle!((DX+dx, 0.5dy), r)
	scs = [circle!((DX+dx, 0), sr), circle!((DX+dx, dy), sr)]
	cons = [Connection(dots[1], dots[2]), Connection(dots[3], dots[4]), Connection(scs[1], c), Connection(scs[2], c)]

	with_nodes(ns; padding_top=20, padding_bottom=23, padding_left=20) do
		stroke(c)
		fill.(scs)
		LuxorGraphPlot.fontsize(14)
		LuxorGraphPlot.text("θ", c)
		stroke.(cons)
		LuxorGraphPlot.text("i", DX+dx-1.5, -8)
		LuxorGraphPlot.text("j", DX+dx-1.5, dy+17)
		
		LuxorGraphPlot.text("maps to", 90, 23)

		stroke(c0)
		fill.(scs0)
		LuxorGraphPlot.text("θ", c0)
		stroke.(cons0)
	end
end

# ╔═╡ f4e57c8d-57d3-4ee1-9cfe-06bfac8ac87f
mat(control(2, 1, 2=>shift(Basic(:π)/2)))

# ╔═╡ cb012a72-f5d8-41b7-9146-0cb184269801
reshape(ein"ij->ijij"([1 1; 1 exp(im*Basic(:π)/2)]), 4, 4)

# ╔═╡ d2833db0-7f86-493b-b96e-8747f782f129
md"## Convert a circuit to a tensor network"

# ╔═╡ 29a41d88-7531-4914-866f-bc4185bde8c2
vizcircuit(qft)

# ╔═╡ ae35e03a-0da9-496f-b942-ff312fb2b366
md"""
The inputs state $|0\rangle$ is represented as:
"""

# ╔═╡ faafeff1-c964-440c-a2e8-640fd323f5ae
nodestore() do ns
	dx = 30
	r = 10
	sr = 3
	dots = [dot!(dx, 0)]
	c = circle!((0, 0), sr)
	cons = [Connection(dots[1], c)]

	with_nodes(ns; padding_left=20, padding_right=20) do
		stroke(c)
		stroke.(cons)
		LuxorGraphPlot.text("i", dx+10, 3)
	end
end

# ╔═╡ a991e849-b397-40c6-8036-b9aa728f4c22
md"""
The output is: 
"""

# ╔═╡ e229dd53-bf34-4048-8464-61cc35225225
nodestore() do ns
	n = 4
	dx = 40
	x0 = 20
	y0 = 20
	r = 10
	sr = 3
	dy = 40
	cs = []
	dots = []
	inputs = []
	outputs = []
	hs = []
	cons = []
	for j = 1:n
		push!(inputs, circle!((x0, y0+j*dy), sr))  # inputs
	end
	for i = 1:n
		x0 += dx
		push!(hs, circle!((x0, y0+i*dy), r))
		push!(cons, Connection(inputs[i], hs[i]))
		for j = i+1:n
			x0 += dx
			push!(cs, circle!((x0, y0+((j + i)%2 == 0 ? (j+i+1)/2 : (j + i)/2) * dy), r))
			push!(dots, circle!((x0, y0+j*dy), sr))
			push!(dots, circle!((x0, y0+i*dy), sr))
			push!(cons, Connection(dots[end], cs[end]))
			push!(cons, Connection(dots[end-1], cs[end]))
		end
	end
	for j=1:n
		push!(outputs, circle!((x0+dx, y0+j*dy), sr))  # outputs
		push!(cons, Connection(outputs[j], hs[j]))
	end
	with_nodes(ns) do
		stroke.(cs)
		LuxorGraphPlot.text.(["π/2", "π/4", "π/8", "π/2", "π/4", "π/2"], cs)
		stroke.(hs)
		LuxorGraphPlot.text.(Ref("H"), hs)
		fill.(dots)
		stroke.(inputs)
		#stroke.(outputs)
		stroke.(cons)
	end
end

# ╔═╡ c82d42d1-b542-464a-86ce-b294ba1794fd
md"""
The output indices are left open at this moment.
"""

# ╔═╡ 3190b0a1-3c67-412f-8002-f3d9c8cf64a3
md"""
## Compute the expectation value
"""

# ╔═╡ 6e7dafd6-9998-4d5a-8bc1-d99e8d1f4e47
md"""
Consider an observable $X_1X_2X_3 X_4$ as follows:
"""

# ╔═╡ 1131347f-389a-4941-ad87-07480a8f97c5
observable = chain(4, [put(4, i=>X) for i in 1:4]);

# ╔═╡ b54bc644-4586-4f46-b46c-1587c3e8b31c
md"We calculte its expectation value using two equivalent methods: quantum circuits and tensor networks.

To begin with, initialize 4 qubits in zero states"

# ╔═╡ 51c319c4-d729-4774-80b3-b00b5945fced
reg = zero_state(4)

# ╔═╡ 9f951589-a522-4d96-868a-5ab259f6ba7b
md"""
For a given state $|\psi\rangle$, the expectation value is: $\langle \psi|X_1X_2X_3X_4|\psi\rangle$\
Here, $|\psi\rangle$ is specified as `qft`$|0\rangle^{\otimes 4}$
"""

# ╔═╡ 5aa12b6b-7b98-44e1-9fe5-4c34f7950aa1
# compute <reg|qft' observable qft|reg>
expect(observable, reg=>qft)

# ╔═╡ 607ba3e1-a95d-4c05-825e-37ea538df099
extended_circuit = chain(qft, observable, qft'); vizcircuit(extended_circuit)

# ╔═╡ baff0c2b-3721-44b2-a84c-7a83eed0daf9
md"Similarly, the expectation value can be calculated by contracting a tensor network with specified input and output states"

# ╔═╡ ccffa22f-b5e1-4c36-b93b-cba41bbbca41
# initial states is specified by a dictionary (location => state).
# lines with no specified states are left open.
input_states = Dict([i=>zero_state(1) for i in 1:4])

# ╔═╡ 6083f736-e001-4961-8010-047f18ea1861
md"`yao2einsum` converts the given circuit into a tensor network, with the contraction order optimized selectively"

# ╔═╡ 507e2118-ba05-4e7a-9b3b-54d4818401c7
qft_net = yao2einsum(extended_circuit; initial_state = input_states, final_state = input_states, optimizer = TreeSA(nslices=2))

# ╔═╡ 72c31b7e-1bc0-4518-9a67-be6a0593a431
# we use the stress graph layout.
show_einsum(qft_net.code; layout=StressLayout(optimal_distance=20))

# ╔═╡ cd81e14e-7f1c-416b-8dd2-3ab1546995aa
contraction_complexity(qft_net)

# ╔═╡ bdef27a3-0c0f-4349-a134-0020e0e1efd0
contract(qft_net) # Alternative way to calculate <reg|qft' observable qft|reg>

# ╔═╡ 5e11bfc0-d1c9-4a86-9eef-9c20488c8f93
md"# GenericTensorNetworks.jl: Tensor networks for combinatorial optimization"

# ╔═╡ 53d3630c-c660-4c9a-9a1b-443613c17f6d
md"`GenericTensorNetworks.jl` implements generic tensor networks to compute solution space properties of a class of hard combinatorial problems"

# ╔═╡ 889a4baf-842c-4429-b472-394eb35d8600
graph = random_diagonal_coupled_graph(7, 6, 0.8) # Create a mxn random masked diagonal coupled square lattice graph, with number of vertices equal to ⌊m×n×ρ⌉

# ╔═╡ 30419d46-e9d8-4c34-8c30-9c02edc91c36
show_graph(graph, StressLayout())

# ╔═╡ d2ef3090-4786-4391-8b8a-c7d9a7f1b511
md"## Independent set problem"

# ╔═╡ c0022c3e-a56c-4363-8d6e-e70f0178a754
LocalResource("idp.png", :width=>200)

# ╔═╡ b9c74fbd-9836-46ac-b832-42731fcfc7ed
md"""
An *independent set* is a set of vertices in a graph where no two vertices are adjacent.
- Independent sets: $\{\}, \{a\}, \{b\}, \{c\},\{d\},\{e\}, \{a,e\}, \{b, d\}, \{b, e\}, \{d, e\}, \{b, d, e\}$
- Maximum independent set (MIS): ${b, d, e}$, size $\alpha(G) = 3$.
"""

# ╔═╡ d9a7c4da-f633-4662-91af-ae97f525c248
md"""
## The maximum independent set (MIS) problem is in NP complete
- The *MIS problem* is to find all MIS or to calculate the size of MIS.
- It is in NP-complete - unlikely to solve in polynomial time.
"""

# ╔═╡ 2fca90fd-16b4-4621-85c7-96b1ba7f82b8
show_graph(graph, StressLayout(optimal_distance=20))

# ╔═╡ 8ebfc7a9-973e-421b-88fe-0adc3fbd076f
problem = GenericTensorNetworks.IndependentSet(graph)  # Independent set problem

# ╔═╡ f8d7ade9-183c-4965-851f-3b729ba4c4c7
md"""
## Map an independent set problem to an energy model
"""

# ╔═╡ 37442c16-ac1a-4c2f-b54b-91abac834a22
md"""
Independent sets are encoded in the *eigenstates* of the following Hamiltonian and MIS corresponds to the _ground state_:

$$H(\mathbf{n}) = \underbrace{- \sum_{v \in V} n_v}_{\text{weights}} + \underbrace{\sum_{(v, w) \in E}  \infty n_v n_w}_{\text{independence constraints}}.$$

-  $n_v$ is the occupation number of vertex $v$.
  -  $n_v = 1$: vertex $v$ is in the independent set
  -  $n_v = 0$: otherwise.

The set: $\{b, d, e\}$ can be represented by $n_b = n_d = n_e = 1$ and $n_a = n_c = 0$.
"""

# ╔═╡ 81ae7d6f-ec4b-48de-a86f-613476d71122
md"""
## Partiton function is a tensor network
"""

# ╔═╡ ef57dd09-b249-4f03-bf19-0947ba8e173a
md"""
*Partition function*:

$$Z = \sum_{\mathbf{n} \in \{0, 1\}^{|V|}} e^{-\beta H(\mathbf{n})}.$$
"""

# ╔═╡ 0144e548-4517-48f4-ad8d-1b06ac12df1c
md"""
The Partition function is a sum product network and thus a tensor network

$$\begin{align*}
Z &= \sum_{\mathbf{n} \in \{0, 1\}^{|V|}} \exp\left(\beta \sum_{v \in V} n_v - \underbrace{\beta \sum_{(v, w) \in E} \infty n_v n_w}_{\text{independence constraint}}\right) \\
&= \sum_{\mathbf{n} \in \{0, 1\}^{|V|}} \prod_{v\in V}\exp\left(\beta  n_v\right)  \prod_{(v, w) \in E}\exp\left(- \beta \cdot \infty n_v n_w\right)
\end{align*}$$
"""

# ╔═╡ f01b2afd-89bf-4775-a80b-1e336c7fcc60
generic_tn = GenericTensorNetwork(problem, optimizer=TreeSA())

# ╔═╡ 6d14bc3f-026a-4e6a-9734-cb987a528af3
# `fieldnames` lists the members of an object
fieldnames(generic_tn |> typeof)

# ╔═╡ 3edc1c09-671e-4076-aeaf-a4c85c4cdba3
md"Convert an indepent set problem to a tensor network, with contraction order optimized"

# ╔═╡ 7110cb89-3395-44c3-aa42-e255e03d4cd2
show_einsum(generic_tn.code, layout=StressLayout(optimal_distance=20))

# ╔═╡ a9fe85ec-770f-4680-af55-f84495837ea3
# PartitionFunction(beta): The partition function
Z = solve(generic_tn, PartitionFunction(3.0))[]

# ╔═╡ 487eef09-197a-4381-aeed-1e7c5c9c785d
md"""
## The partition function can be represented as a polynomial
"""

# ╔═╡ feff13a6-bc70-419b-ba52-7dc2cd0728ad
md"""
By letting $x = e^\beta$, we obtain the *independence polynomial*:
```math
I(x) = a_0 + a_1 x + \ldots + a_{\alpha(G)} x^{\alpha(G)}
```
"""

# ╔═╡ 9e9a7534-a2ef-451b-a935-2b0b4db4912f
solve(generic_tn, GraphPolynomial())

# ╔═╡ 5aa727d6-884e-47ec-9939-37a0926fbb81
md"""
## The optimal solution size: MIS size
"""

# ╔═╡ f180a681-8c05-4a05-aac9-0c9f26c3d0b7
md"""
$\lim_{x\rightarrow \infty}\frac{\log(I(x))}{\log(x)} = \alpha(G)$
"""

# ╔═╡ 334dd61b-787a-4a2c-b507-448791df917a
# SizeMax(): The maximum solution size
res_size = solve(generic_tn, SizeMax())[]  # MIS size

# ╔═╡ 4beeff1a-2a15-485f-82dd-0691e9dcbd14
md"""
## Visualize the solutions
"""

# ╔═╡ a57f47ca-d280-4edf-8829-8ff36e906624
# CountingMax(2): Count solutions with largest 2 sizes
# in the output, x = e^β
res_count = solve(generic_tn, CountingMax(2))[]

# ╔═╡ 103bfdb6-7d4b-4a5f-963e-df8df3f94c6b
# ConfigsMax(2; tree_storage=true): Enumerate all solutions with maximum 2 sizes, using the compact tree storage to reduce the memory size.
configs_raw = solve(generic_tn, ConfigsMax(2; tree_storage=true))[]  # The corresponding configurations

# ╔═╡ 796f0ab7-c0c6-41e1-b83c-331a2be6c302
configs = read_config(configs_raw)

# ╔═╡ 776ffe52-bbe2-4ad2-b3e8-8644d34e0b50
show_configs(problem, StressLayout(optimal_distance=20), fill(configs[2][1], 1, 1))

# ╔═╡ 47378ab1-5883-4ec8-ad60-2d54720c0f4c
# `show_landscape` visualize the solutions (vertices) with the maximum 2 sizes
# solutions are connected if and only if they have hamming distance < 2.
show_landscape((x, y)->hamming_distance(x, y) <= 2, configs_raw; layout_method=:stress)

# ╔═╡ d9d22920-601f-4135-b529-bcc01caae23a
md"# TensorInference.jl: Tensor network for probabilistic inference"

# ╔═╡ a73e8709-95ab-4d9c-9312-a0731d598f18
md"""
Solutions to the most common probabilistic inference tasks, including:
- *Probability of evidence* (PR): Calculates the total probability of the observed evidence across all possible states of the unobserved variables
- *Marginal inference* (MAR): Computes the probability distribution of a subset of variables, ignoring the states of all other variables
- *Maximum a Posteriori Probability estimation* (MAP): Finds the most probable state of a subset of unobserved variables given some observed evidence
- *Marginal Maximum a Posteriori* (MMAP): Finds the most probable state of a subset of variables, averaging out the uncertainty over the remaining ones
"""

# ╔═╡ 102aabd3-048c-4701-a384-27b525e80f9c
md"""
## The ASIA network

The graph below corresponds to the *ASIA network*, a simple Bayesian model
used extensively in educational settings. It was introduced by Lauritzen in 1988.

```
┌───┐           ┌───┐
│ A │         ┌─┤ S ├─┐
└─┬─┘         │ └───┘ │
  │           │       │
  ▼           ▼       ▼
┌───┐       ┌───┐   ┌───┐
│ T │       │ L │   │ B │
└─┬─┘       └─┬─┘   └─┬─┘
  │   ┌───┐   │       │
  └──►│ E │◄──┘       │
      └─┬─┘           │
┌───┐   │   ┌───┐     │
│ X │◄──┴──►│ D │◄────┘
└───┘       └───┘

Box: variables
Arrow: variable dependency, e.g. A -> B indicates relation P(B|A).
```

The table below explains the meanings of each random variable used in the
ASIA network model.

| **Random variable**  | **Meaning**                     |
|        :---:         | :---                            |
|        ``A``         | Recent trip to Asia             |
|        ``T``         | Patient has tuberculosis        |
|        ``S``         | Patient is a smoker             |
|        ``L``         | Patient has lung cancer         |
|        ``B``         | Patient has bronchitis          |
|        ``E``         | Patient hast ``T`` and/or ``L`` |
|        ``X``         | Chest X-Ray is positive         |
|        ``D``         | Patient has dyspnoea            |
"""

# ╔═╡ b0bc1b88-ccd9-4dd8-a9fe-7969ee698aeb
md"""
## Load a model from a file
"""

# ╔═╡ d2d7984e-9298-42ac-92b2-99b612c6ec7e
md"""
Load the ASIA network model from the `asia.uai` file located in the examples
directory. See [Model file format (.uai)](@ref) for a description of the
format of this file.
"""

# ╔═╡ c3181124-4c6a-478e-9886-02e085251ec3
model = read_model_file(pkgdir(TensorInference, "examples", "asia-network", "model.uai"))

# ╔═╡ d4dfc2d6-b967-4a6b-a64b-dba24b3318bc
md"""
## Compute marginal probabilities
"""

# ╔═╡ b96a17ae-c2b8-428b-a965-ecd09bd2fee1
# Create a tensor network representation of the loaded model.
inference_tn = TensorNetworkModel(model; optimizer=TreeSA())

# ╔═╡ 00b47a54-cae5-4a41-9d1a-cad8e4264c3f
# Retrieve all the variables in the model.
get_vars(inference_tn)

# ╔═╡ 325f8bb8-6097-49fb-99e7-a1cb34f27116
# Calculate the partition function
probability(inference_tn) |> first

# ╔═╡ 90e23bda-0665-4252-9675-81af96dfa04b
# Calculate the marginal probabilities of each random variable in the model.
marginals(inference_tn)

# ╔═╡ 8d3b719e-699b-40f8-be10-845519263475
md"""
## Compute maximum likely assignment to variables from an evidence
"""

# ╔═╡ f419f822-088f-40fa-b1c5-93d0bdaa0137
md"""
Set the evidence: Assume that the "X-ray" result (variable 7) is negative.
Since setting the evidence may affect the contraction order of the tensor
network, recompute it.
"""

# ╔═╡ 3fd46c0c-8154-4876-b635-a43dae5e22ce
inference_tn2 = TensorNetworkModel(model, evidence = Dict(7 => 0))

# ╔═╡ e31fdb85-42ff-4169-867c-fafc35c19ebe
md"""
Calculate the maximum log-probability among all configurations.
"""

# ╔═╡ 5ad55ef1-52ea-4de9-943b-57c5aed16fad
maximum_logp(inference_tn2)

# ╔═╡ e98b27e1-14a5-4f94-97ad-ea25350bee86
md"""
## Sample from probability distribution
"""

# ╔═╡ 86a1f5d6-3bb5-42f2-845f-4b615356b888
md"Generate 10 samples from the posterior distribution."

# ╔═╡ e77c4eae-6ff8-4906-aabc-683460537718
sample(inference_tn2, 10)

# ╔═╡ 2c6c1627-df8e-4d88-a7fe-4233558536ab
md"Retrieve both the maximum log-probability and the most probable configuration."

# ╔═╡ bcc4c2dd-41e3-44c2-8495-080063368cd4
logp, cfg = most_probable_config(inference_tn2)

# ╔═╡ 3c4eb3fb-bc6a-4f30-99ab-52c480340a24
md"""
Compute the most probable values of certain variables (e.g., 4 and 7) while
marginalizing over others. This is known as Maximum a Posteriori (MAP)
estimation.
"""

# ╔═╡ 091843c7-7968-4563-a71d-e89fad1d07c3
mmap = MMAPModel(model, evidence=Dict(7=>0), queryvars=[4,7])

# ╔═╡ 7425e5cd-2c3e-41b3-99a0-450d3eb54ff3
md"Get the most probable configurations for variables 4 and 7."

# ╔═╡ fb14fb1b-f868-4af8-97d1-1f9923651120
most_probable_config(mmap)

# ╔═╡ 4117497a-6055-41ce-92b6-dd2a0a151366
md"""
Compute the total log-probability of having lung cancer. The results suggest
that the probability is roughly half.
"""

# ╔═╡ 40d35ecd-8c2c-49be-b150-6ac7639fdee7
log_probability(mmap, [1, 0]), log_probability(mmap, [0, 0])

# ╔═╡ Cell order:
# ╟─ca6bee1f-d3d3-4620-aba9-363e5b856c69
# ╟─e9fbbd5d-6cea-4e1c-807b-6dc3939d3628
# ╟─92f32d6f-de53-4794-8451-5a3ca62ef828
# ╟─a481f737-c83a-4f55-b1b5-cbb33ddbc9f4
# ╟─c12e790f-769c-4277-b41d-81d08c0e134c
# ╠═b9970d7f-9a69-424e-89c0-bbfcfe5f12d7
# ╟─ec23abba-eaf0-4e7a-bf7e-b50ffbe9532f
# ╟─1f6d1be8-5157-4115-b5d6-e4ad6d474dd5
# ╠═0a83fd07-6dd3-4228-b435-c7f0c1ddbc12
# ╟─1cf11208-acb2-4bbb-8342-140775c4a7c0
# ╠═e82c8140-c80e-4683-a72a-c8dec034c0a9
# ╠═8f153a7f-3977-44ce-8c9c-7540f6c84e2c
# ╟─c4e8f71a-3118-4455-a9a5-b427e2d19ba0
# ╟─9a66d58a-7958-4cf9-ba68-688323b74feb
# ╠═4e849834-1f00-4283-ad7c-f7a783d77ab4
# ╠═0ddf1061-d53c-4561-943b-f4460ee58962
# ╟─6af3c70e-5a7e-4ab8-baf1-d666fea321cb
# ╠═3b9821b6-851d-4509-aa7c-7ac7c8d57399
# ╠═56cfb6d5-1866-4318-a578-7b30660b1f45
# ╟─95b29cc5-41e6-4ce6-a4d7-25337b96eaa4
# ╠═cee4366b-a6f0-4a75-bcab-82b77b31b451
# ╠═15c74390-bb16-4ea6-8e6e-70f9628304c4
# ╟─008b26e8-862b-4e4a-8d76-fd671defca4f
# ╟─1d6f4700-99f2-40b2-a8ed-8640de7c5039
# ╠═27c769f8-52ec-496c-bea7-cc210af9df99
# ╠═f93ed0d4-bb49-462e-88ad-3995c2a9532c
# ╠═ca5d4d5b-dfe3-4fd8-a5b2-6cbe70ef84a4
# ╠═6884f655-aac8-4f22-8de7-e2624f1e9246
# ╟─4d412abe-17b3-46bf-99fe-b133b20610ee
# ╟─d1a325de-7ff3-43b5-87db-1615f746c5a2
# ╠═3c423eb5-b64a-4256-a41c-7d675d7396c8
# ╟─b43d4f75-59d4-49af-a07d-7cc5f4aee7e6
# ╟─6ce21263-bf2c-41b1-ac1f-5b4b29c94465
# ╟─609fb332-8067-4ffc-b678-7dbd3c879051
# ╠═095e3032-21f5-45d2-8b95-9df36047724c
# ╠═a0369e77-e8ca-41a2-9bf0-864cefa57a6a
# ╠═cdf5ffd0-28a8-4a53-81b4-19037bb3e7cb
# ╟─344020d5-88b3-45db-8641-5ae1f690871f
# ╠═c4eac832-3629-41bf-8dc9-5b2a6d3d914b
# ╟─c1e2fcdb-c12f-4743-ab7e-c0d2feb5ab2f
# ╠═3c84890c-0371-44cb-a9c7-ae76adeb0307
# ╟─98cafa86-1fa5-43b9-b479-3f0893fecbb8
# ╟─a40cbf4b-4f5d-443c-8463-b4e9b5e6edcd
# ╠═419e2c5d-08aa-4cbd-9857-8535c170179e
# ╠═d7a7e5d5-5eae-4d92-8ce0-309702d0c777
# ╠═c6b639a2-d5f4-47b6-84db-83682cc9b722
# ╠═b176805b-ef1f-4cec-922a-f653ace76ce4
# ╟─e564c83b-2b20-4c1a-87a4-1abc3c504c0c
# ╠═f80aa1e7-1a92-4a52-a070-d382fa36dcb3
# ╠═2656103c-fe7f-4a76-9f89-57aadc892824
# ╠═05171dfb-a005-448d-856a-4f1d417451b0
# ╠═750ab594-9990-4ad1-a8c8-e66ea058909d
# ╟─9411e8b2-aa55-487f-b666-5eb1e3a821d9
# ╟─5ceb3861-c2bd-4e2f-9007-6285d1347027
# ╠═dce59830-0885-40fb-9693-b9f070f2388b
# ╟─63e793e3-6eb1-4c65-8041-99beb33dc1fa
# ╟─1484dee3-df3f-4aaa-8c32-78eea3133e8f
# ╟─3fc75abf-5f97-4534-87aa-7c5944e58d64
# ╟─90f342ba-0a56-4702-afd5-6a8c49964b19
# ╟─decce1ca-cd63-494c-8db5-c46990fdb740
# ╟─754640f1-5621-460d-87de-8c90665db8c4
# ╟─095d5fa0-6f85-4f4e-9ec0-18768f6839fb
# ╟─25f8e2f2-022e-4c65-aff3-4af8fe43a5dc
# ╟─e49d57c4-d215-4409-b7ad-f7206b2aec89
# ╠═c3cc1bd0-68e6-430c-b306-696c51165b9c
# ╟─33f37f98-53e9-45b4-919a-2b9b1481f4ce
# ╟─5b263f0a-5885-4968-b14b-07bb5bc2f1a9
# ╠═920a9962-e83f-473c-977a-eab34ec26872
# ╟─d96500ba-ade4-4666-a37b-222673960117
# ╟─5956ee36-d0b8-4231-a5ae-b18d5c02842e
# ╠═ddb5868a-7406-4f6f-971d-16394f4cea3b
# ╟─5af0aca3-acd3-4172-b922-91c5568fbb35
# ╟─d336e16b-4af8-4564-9205-3ae51e61c33e
# ╠═bbe08769-858a-445f-a162-34cd7134ffd1
# ╠═f32a5030-8c21-4859-82e8-8953cf8b534f
# ╠═7b87b462-4c32-40f7-ae8f-f68df3d42e45
# ╠═10242d23-2a97-43d5-874f-db283dfbd274
# ╟─49dfaa9b-bcbc-4f60-8496-34561e57d098
# ╟─9671c446-775e-4cb3-8e95-7c32480eeb07
# ╟─a3f038a5-8f09-4c33-bf71-ed07e03037b3
# ╟─6173ea8a-a9e7-40e8-badb-601f8e96bd7d
# ╠═f4e57c8d-57d3-4ee1-9cfe-06bfac8ac87f
# ╠═cb012a72-f5d8-41b7-9146-0cb184269801
# ╟─d2833db0-7f86-493b-b96e-8747f782f129
# ╟─29a41d88-7531-4914-866f-bc4185bde8c2
# ╟─ae35e03a-0da9-496f-b942-ff312fb2b366
# ╟─faafeff1-c964-440c-a2e8-640fd323f5ae
# ╟─a991e849-b397-40c6-8036-b9aa728f4c22
# ╟─e229dd53-bf34-4048-8464-61cc35225225
# ╟─c82d42d1-b542-464a-86ce-b294ba1794fd
# ╟─3190b0a1-3c67-412f-8002-f3d9c8cf64a3
# ╟─6e7dafd6-9998-4d5a-8bc1-d99e8d1f4e47
# ╠═1131347f-389a-4941-ad87-07480a8f97c5
# ╟─b54bc644-4586-4f46-b46c-1587c3e8b31c
# ╠═51c319c4-d729-4774-80b3-b00b5945fced
# ╟─9f951589-a522-4d96-868a-5ab259f6ba7b
# ╠═5aa12b6b-7b98-44e1-9fe5-4c34f7950aa1
# ╠═607ba3e1-a95d-4c05-825e-37ea538df099
# ╟─baff0c2b-3721-44b2-a84c-7a83eed0daf9
# ╠═ccffa22f-b5e1-4c36-b93b-cba41bbbca41
# ╟─6083f736-e001-4961-8010-047f18ea1861
# ╠═507e2118-ba05-4e7a-9b3b-54d4818401c7
# ╠═72c31b7e-1bc0-4518-9a67-be6a0593a431
# ╠═cd81e14e-7f1c-416b-8dd2-3ab1546995aa
# ╠═bdef27a3-0c0f-4349-a134-0020e0e1efd0
# ╟─5e11bfc0-d1c9-4a86-9eef-9c20488c8f93
# ╟─53d3630c-c660-4c9a-9a1b-443613c17f6d
# ╠═332085f3-ef12-4a7d-9714-e8f4a88d5a28
# ╠═889a4baf-842c-4429-b472-394eb35d8600
# ╠═30419d46-e9d8-4c34-8c30-9c02edc91c36
# ╟─d2ef3090-4786-4391-8b8a-c7d9a7f1b511
# ╟─c0022c3e-a56c-4363-8d6e-e70f0178a754
# ╟─b9c74fbd-9836-46ac-b832-42731fcfc7ed
# ╟─d9a7c4da-f633-4662-91af-ae97f525c248
# ╟─2fca90fd-16b4-4621-85c7-96b1ba7f82b8
# ╠═8ebfc7a9-973e-421b-88fe-0adc3fbd076f
# ╟─f8d7ade9-183c-4965-851f-3b729ba4c4c7
# ╟─37442c16-ac1a-4c2f-b54b-91abac834a22
# ╟─81ae7d6f-ec4b-48de-a86f-613476d71122
# ╟─ef57dd09-b249-4f03-bf19-0947ba8e173a
# ╟─0144e548-4517-48f4-ad8d-1b06ac12df1c
# ╠═f01b2afd-89bf-4775-a80b-1e336c7fcc60
# ╠═6d14bc3f-026a-4e6a-9734-cb987a528af3
# ╟─3edc1c09-671e-4076-aeaf-a4c85c4cdba3
# ╠═7110cb89-3395-44c3-aa42-e255e03d4cd2
# ╠═a9fe85ec-770f-4680-af55-f84495837ea3
# ╟─487eef09-197a-4381-aeed-1e7c5c9c785d
# ╟─feff13a6-bc70-419b-ba52-7dc2cd0728ad
# ╠═9e9a7534-a2ef-451b-a935-2b0b4db4912f
# ╟─5aa727d6-884e-47ec-9939-37a0926fbb81
# ╟─f180a681-8c05-4a05-aac9-0c9f26c3d0b7
# ╠═334dd61b-787a-4a2c-b507-448791df917a
# ╟─4beeff1a-2a15-485f-82dd-0691e9dcbd14
# ╠═a57f47ca-d280-4edf-8829-8ff36e906624
# ╠═103bfdb6-7d4b-4a5f-963e-df8df3f94c6b
# ╠═796f0ab7-c0c6-41e1-b83c-331a2be6c302
# ╠═776ffe52-bbe2-4ad2-b3e8-8644d34e0b50
# ╠═47378ab1-5883-4ec8-ad60-2d54720c0f4c
# ╟─d9d22920-601f-4135-b529-bcc01caae23a
# ╟─a73e8709-95ab-4d9c-9312-a0731d598f18
# ╟─102aabd3-048c-4701-a384-27b525e80f9c
# ╟─b0bc1b88-ccd9-4dd8-a9fe-7969ee698aeb
# ╠═1845d970-4f90-4714-bc74-6e38b27160f4
# ╟─d2d7984e-9298-42ac-92b2-99b612c6ec7e
# ╠═c3181124-4c6a-478e-9886-02e085251ec3
# ╟─d4dfc2d6-b967-4a6b-a64b-dba24b3318bc
# ╠═b96a17ae-c2b8-428b-a965-ecd09bd2fee1
# ╠═00b47a54-cae5-4a41-9d1a-cad8e4264c3f
# ╠═325f8bb8-6097-49fb-99e7-a1cb34f27116
# ╠═90e23bda-0665-4252-9675-81af96dfa04b
# ╟─8d3b719e-699b-40f8-be10-845519263475
# ╟─f419f822-088f-40fa-b1c5-93d0bdaa0137
# ╠═3fd46c0c-8154-4876-b635-a43dae5e22ce
# ╟─e31fdb85-42ff-4169-867c-fafc35c19ebe
# ╠═5ad55ef1-52ea-4de9-943b-57c5aed16fad
# ╟─e98b27e1-14a5-4f94-97ad-ea25350bee86
# ╟─86a1f5d6-3bb5-42f2-845f-4b615356b888
# ╠═e77c4eae-6ff8-4906-aabc-683460537718
# ╟─2c6c1627-df8e-4d88-a7fe-4233558536ab
# ╠═bcc4c2dd-41e3-44c2-8495-080063368cd4
# ╟─3c4eb3fb-bc6a-4f30-99ab-52c480340a24
# ╠═091843c7-7968-4563-a71d-e89fad1d07c3
# ╟─7425e5cd-2c3e-41b3-99a0-450d3eb54ff3
# ╠═fb14fb1b-f868-4af8-97d1-1f9923651120
# ╟─4117497a-6055-41ce-92b6-dd2a0a151366
# ╠═40d35ecd-8c2c-49be-b150-6ac7639fdee7
