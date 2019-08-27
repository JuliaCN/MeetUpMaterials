# A tutorial about using Yao

Setup Julia and Jupyter notebook environment following the instructions in
https://datatofish.com/add-julia-to-jupyter/,

Then open a shell and type

```bash
$ jupyter notebook YaoTutorial.ipynb
```

## live coding

##### Notes for Clip 1
* Quantum Block Intermediate Representation (QBIR) for QFT
* get matrix representation of a block
* dagger a block
* analyze properties
* apply a blocks to a register
* measure a register
* block arithmatics
* tuning the structure
* using GPU

[![asciicast](https://asciinema.org/a/GL4za0yb0fO3Vth2Z0JjJsMmj.svg)](https://asciinema.org/a/GL4za0yb0fO3Vth2Z0JjJsMmj?speed=2)

##### Notes for Clip 2
* Constructing a hamiltonian
* get the expectation value
* solve the ground state through
    * exact diagonalization (with KrylovKit)
    * imaginary time evolution
    * VQE approach (with autodiff)

[![asciicast](https://asciinema.org/a/99Cb0bi7khmrr9HrCR1tUbGaw.svg)](https://asciinema.org/a/99Cb0bi7khmrr9HrCR1tUbGaw?speed=2)

## References
##### Find Yao
https://github.com/QuantumBFS/Yao.jl

##### Find Quantum algorihtms
https://github.com/QuantumBFS/QuAlgorithmZoo.jl

## How To contribute
* submit an issue to report a bug, or ask for a feature request,
* help us polish documentations, write more tests
