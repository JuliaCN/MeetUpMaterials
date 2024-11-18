### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ cc16fd92-9768-11ef-19f3-0d98e73a81c7
using ShortCodes,PlutoUI

# ╔═╡ fd3e3c9b-f6bb-4945-8d03-33db9c6ebc30
struct TwoCol{A, B}
	left::A
	right::B
end

# ╔═╡ 631a3d91-fb97-4341-a1d6-aa1b5915905a
function Base.show(io, mime::MIME"text/html", tc::TwoCol)
	write(io,
		"""
		<div style="display: flex;">
			<div style="flex: 40%;">
		""")
	show(io, mime, tc.left)
	write(io,
		"""
			</div>
			<div style="flex: 60%;">
		""")
	show(io, mime, tc.right)
	write(io,
		"""
			</div>
		</div>
	""")
end

# ╔═╡ 00ca88e3-cccb-4f91-942d-5e49751ab513
html"""<style>
main {
    max-width: 80%;
    margin-left: 10%;
    margin-right: 10% !important;
}
"""

# ╔═╡ 1094fd86-9fde-4407-855e-bc97a8b48971
md"""
# Quantum speed limit 101 with Julia

**Huai-Ming Yu, Nov. 1, 2024**

JuliaCN 2024 meetup @ HKUST GZ
"""

# ╔═╡ 913f2ce4-393e-49ce-9f2c-4ab15f66d32c
html"<button onclick='present()'>🚀 Let's start!</button>"

# ╔═╡ 6c1e4504-067f-4611-a8b4-62463a049eab
md"""
## Time: a left-out problem in quantum mechanics
!!! info "The Heisenberg’s uncertainty principles"
	$$\Delta x \ \Delta p \gtrsim \hbar,\qquad \Delta E\  \Delta t \gtrsim \hbar$$

##### 🤔 I was trained to obtain the first one with the algebra relations of operators and the Cauchy-Schwarz inequality, but what about the second one? 
##### 😧 Time in textbook QM is not an Hermitian operator!  
##### 😑 Life time? Arrival time? Or tunneling time?
"""


# ╔═╡ 5edf29dc-a28e-4606-aec7-71077626f9b7


# ╔═╡ 2671d436-4ca4-49d3-bd27-6f7e27f89372


# ╔═╡ 62b0fc12-ae02-46f8-b5d7-c962382049e5


# ╔═╡ bd734aa0-b4d2-42eb-afee-f50c0652c8be


# ╔═╡ e0139eb4-d5b3-49b7-a493-63b6d18d7ef2


# ╔═╡ d584e79b-a654-4dcd-84a6-5897af89213f
md"S. Deffner, S. Campbell, Quantum Speed Limits: From Heisenberg’s Uncertainty Principle To Optimal Quantum Control, [Journal Of Physics A: Mathematical And Theoretical (2017)](https://doi.org/10.1088/1751-8121/aa86c6)."

# ╔═╡ 1001de8e-55ae-426f-a919-4163e89cb90a
md"""
## Time: a left-out problem in quantum mechanics
"""

# ╔═╡ ef64cb6d-e6ed-4a40-8501-4a8870c07d38
TwoCol(LocalResource("./img/meme1.jpeg", :width=>200),
	md"""
	\
	**Simultaneous measurements**\
	of time and energy?
	\
	\
	\
	``\qquad \Delta E\  \Delta t \gtrsim \hbar``
	"""
)

# ╔═╡ 10c7cae2-c987-42b4-9894-47a9d071d784
TwoCol(LocalResource("./img/meme2.jpeg", :width=>200),
	md"""
	\
	**Intrinsic time scale** of \
	quantum dynamics
	\
	\
	\
	``\qquad \Delta t \gtrsim \hbar/\Delta E ``
	"""
)

# ╔═╡ 8cb2edf5-6545-4d00-a4ab-0643f6b40d4b
md"""
# From the uncertainty relations to the quantum speed limit
!!! info "(Original) definition of the quantum speed limit time"
	The minimum time $\tau_{\mathrm{QSL}}$ for a quantum system to evolve between two distinguishable (orthogonal) states, i.e., 

	$$\begin{eqnarray}
	\tau_{\mathrm{QSL}} &:=& \min t \nonumber \\
	& & \mathrm{subject~to}~\braket{\psi(0)|\psi(t)}=0.
	\end{eqnarray}$$

### It is helpful in:
- Improving precision in quantum metrology
- Utilizing quantum optimal control algorithms
- Finding the maximal rate of entropy production
- ...

### Early pioneers:
- Mandelstam and Tamm (MT bound, 1945)
- Margolus and Levitin (ML bound, 1998)
- Levitin and Toffoli (the unified bound, 2009)
- ...
"""

# ╔═╡ bdae2982-eae4-43ac-b5bf-05675da5703e
md"""
## Side note: uncertainty relation
!!! info "Uncertainty relation of operators"
	For any two operators A and B:

	$$\Delta A \Delta B \ge \frac{1}{2}\mid\langle [A,B]\rangle\mid$$
	where ``\Delta O = \sqrt{\langle O^2\rangle-\langle O \rangle^2}``, ``\langle O \rangle`` is the expectation value of operator $O$.

With``[x, p] = \hbar``, we have ``\Delta E\  \Delta t \ge \hbar``.
"""



# ╔═╡ b893efc8-c6dc-49af-99b0-1aae539948ec
md"""
### Mandelstam and Tamm's uncertainty relation
The dynamics of an operator $A$:

$$\frac{\partial A}{\partial t} = \frac{i}{\hbar} [H,A]$$
By taking A the projector onto the initial state ``A=\ket{\psi(0)}\bra{\psi(0)}`` and integrate, we have

$$\frac{\Delta H t}{\hbar} \ge \frac{\pi}{2} - \arcsin{\sqrt{\langle A \rangle_t}}$$

$$\braket{\psi(0)\mid\psi(t)} = 0,\, \langle A \rangle = 0$$
!!! info "Mandelstam-Tamm Bound"
	$$t \ge \tau_{\mathrm{MT}} \equiv \frac{\pi}{2} \frac{\hbar}{\Delta H}$$

"""

# ╔═╡ d9f11c5c-99ee-4d47-8e07-74990ac43085
md"""
### Margolus and Levitin's bound


!!! info "Margolus-Levitin Bound"
	$$t \ge \tau_{\mathrm{ML}} \equiv  \frac{\pi}{2}\frac{\hbar}{\langle H\rangle}$$

"""

# ╔═╡ 9af13177-aab0-4d88-8779-bee552a09f8a
md"""

### The unified bound
!!! info ""
	$$t \ge \tau_{\mathrm{QSL}} = \mathrm{max}\left\{\frac{\pi}{2}\frac{\hbar}{\Delta H}, \frac{\pi}{2}\frac{\hbar}{\langle H\rangle} \right\}$$
Levitin and Toffoli proved that this unified bound is  tight for 2-level Hamiltonians.
"""

# ╔═╡ 47d057f3-23eb-4003-b18e-5d33e3393a70
md"""
# The QSL beyond inequality
!!! info "Operational definition of quantum speed limit (OQSL) "
	$$\begin{eqnarray}
	\tau &:=& \min_{\rho\in \mathcal{S}} t \nonumber \\
	& & \mathrm{subject~to}~e^{\mathcal{L}}(\rho) = \rho_{\mathrm{tar}}.
	\end{eqnarray}$$
	where ``\mathcal{S} := \{\rho\mid \rho \in \mathcal{Q}\,\&\, e^{\mathcal{L}}(ρ) = ρ_{\mathrm{tar}}, \, \exists t \}``, ``\mathcal{Q}`` is a meaningful set of state to the task, ``\mathcal{L}`` is a superoperator satisfying ``\partial_t \rho_t = \mathcal{L}(\rho_t)`` with ``\rho_t`` the evolved state of ``\rho``.  
"""

# ╔═╡ 5da0deac-f8ce-4ddf-a84d-8db7503da3df


# ╔═╡ 0a4574b6-7d6f-4a16-bd90-a52d546b69b8


# ╔═╡ ae6c017c-2a09-472e-a40c-ec50bf95a90b


# ╔═╡ 96e920cb-d00a-4bff-8dad-e679073bc517
md"Y. Shao, B. Liu, M. Zhang, H. Yuan, and J Liu, Operational definition of a quantum speed limit, [Phys. Rev. Research 2, 023299 (2020)](https://doi.org/10.1103/PhysRevResearch.2.023299).
"

# ╔═╡ 20079949-f7f8-4449-a6e7-f3be892df471
md"M. Zhang, H.-M. Yu, and J. Liu, Quantum speed limit for complex dynamics, [npj Quantum Inf. 9, 97 (2023)](https://doi.org/10.1038/s41534-023-00768-8)."

# ╔═╡ 6cd1bd1f-53e2-4320-8338-d509392875cc
md"""
##  Multi-level Hamiltonians
By taking the Bures angle ``\Theta`` as target
!!! info "OQSL for multi-level Hamiltonians"
	For a general multi-level system with a time-independent Hamiltonian ``H``, the OQSL is 

	$$\tau = \frac{\Theta}{E_{\mathrm{max}} - E_{\mathrm{min}}}$$ where ``E_{\mathrm{max}}`` and ``E_{\mathrm{min}}`` are the highest and lowest energies with respect to ``H``. The OQSL ``τ`` can be attained by the state 

	$$\rho_{\mathrm{opt}} = \sum_i \frac{1}{N} \ket{E_i}\bra{E_i} + \xi\ket{E_\mathrm{min}}\bra{E_\mathrm{max}}+\xi^\ast\ket{E_\mathrm{max}}\bra{E_\mathrm{min}}$$
	with the complex coefficient ``\xi`` satisfying ``\mid \xi\mid \in (0, 1/N]``.

These attainable states are **mixed states** for ``N>3``.
"""

# ╔═╡ 631b6fc1-0846-4edb-920c-c6233d388666
md"""
## More remarks on OQSLs
- #### Time-dependent Hamiltonians
For time-dependent Hamiltonians, ``\tau`` satisfies

$$\int^\tau_0 E_{\mathrm{max}}(t) - E_{\mathrm{min}}(t) \mathrm{d} t = \Theta$$

- #### Open systems
- #### Controlled systems
"""

# ╔═╡ 677753f2-2a5b-4424-903d-1e947d623b48
md"""
## Complex dynamics and the methodology of CRC
"""

# ╔═╡ 8edba843-eb9c-4b8a-a855-9142c6c1177e
md"""
-  Evaluation of complex dynamics is too time-consuming
"""

# ╔═╡ ea306383-a362-437f-bb7f-39ae1529d37a
LocalResource("./img/CRC.png", :width=>800)

# ╔═╡ 0a41a63c-2fba-4a9d-8737-d1a8b2ec9c4d
md"""
#### Classification, Regression, and Calibration 
"""

# ╔═╡ 24a6f12b-32d0-46b7-a2ba-68ad609462b3
md"""
# Numerical evaluations of QSLs with the Julia ecosystem.
- ###  Linear algebra, e.g. Krylov-based algorithms, etc.
- ### Optimization methods, AD
- ### Tensor networks
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ShortCodes = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"

[compat]
PlutoUI = "~0.7.60"
ShortCodes = "~0.3.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.1"
manifest_format = "2.0"
project_hash = "759c4bfedb93a77ecc037fb10422077342c69b53"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "1d322381ef7b087548321d3f878cb4c9bd8f8f9b"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.14.1"

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

    [deps.JSON3.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.ShortCodes]]
deps = ["Base64", "CodecZlib", "Downloads", "JSON3", "Memoize", "URIs", "UUIDs"]
git-tree-sha1 = "5844ee60d9fd30a891d48bab77ac9e16791a0a57"
uuid = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"
version = "0.3.6"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "159331b30e94d7b11379037feeb9b690950cace8"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─cc16fd92-9768-11ef-19f3-0d98e73a81c7
# ╟─fd3e3c9b-f6bb-4945-8d03-33db9c6ebc30
# ╟─631a3d91-fb97-4341-a1d6-aa1b5915905a
# ╟─00ca88e3-cccb-4f91-942d-5e49751ab513
# ╟─1094fd86-9fde-4407-855e-bc97a8b48971
# ╟─913f2ce4-393e-49ce-9f2c-4ab15f66d32c
# ╟─6c1e4504-067f-4611-a8b4-62463a049eab
# ╟─5edf29dc-a28e-4606-aec7-71077626f9b7
# ╟─2671d436-4ca4-49d3-bd27-6f7e27f89372
# ╟─62b0fc12-ae02-46f8-b5d7-c962382049e5
# ╟─bd734aa0-b4d2-42eb-afee-f50c0652c8be
# ╟─e0139eb4-d5b3-49b7-a493-63b6d18d7ef2
# ╟─d584e79b-a654-4dcd-84a6-5897af89213f
# ╟─1001de8e-55ae-426f-a919-4163e89cb90a
# ╟─ef64cb6d-e6ed-4a40-8501-4a8870c07d38
# ╟─10c7cae2-c987-42b4-9894-47a9d071d784
# ╟─8cb2edf5-6545-4d00-a4ab-0643f6b40d4b
# ╟─bdae2982-eae4-43ac-b5bf-05675da5703e
# ╟─b893efc8-c6dc-49af-99b0-1aae539948ec
# ╟─d9f11c5c-99ee-4d47-8e07-74990ac43085
# ╟─9af13177-aab0-4d88-8779-bee552a09f8a
# ╟─47d057f3-23eb-4003-b18e-5d33e3393a70
# ╟─5da0deac-f8ce-4ddf-a84d-8db7503da3df
# ╟─0a4574b6-7d6f-4a16-bd90-a52d546b69b8
# ╟─ae6c017c-2a09-472e-a40c-ec50bf95a90b
# ╟─96e920cb-d00a-4bff-8dad-e679073bc517
# ╟─20079949-f7f8-4449-a6e7-f3be892df471
# ╟─6cd1bd1f-53e2-4320-8338-d509392875cc
# ╟─631b6fc1-0846-4edb-920c-c6233d388666
# ╟─677753f2-2a5b-4424-903d-1e947d623b48
# ╟─8edba843-eb9c-4b8a-a855-9142c6c1177e
# ╟─ea306383-a362-437f-bb7f-39ae1529d37a
# ╟─0a41a63c-2fba-4a9d-8737-d1a8b2ec9c4d
# ╟─24a6f12b-32d0-46b7-a2ba-68ad609462b3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
