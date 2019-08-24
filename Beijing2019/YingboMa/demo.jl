# Stiff 1
using ParameterizedFunctions, OrdinaryDiffEq, Plots
plotly()
rober = @ode_def Rober begin
  dy₁ = -k₁*y₁+k₃*y₂*y₃
  dy₂ =  k₁*y₁-k₂*y₂^2-k₃*y₂*y₃
  dy₃ =  k₂*y₂^2
end k₁ k₂ k₃
prob = ODEProblem(rober,[1.0;0.0;0.0],(0.0,1e11),(0.04,3e7,1e4))
sol = solve(prob, Rosenbrock23())
plot(sol, xscale=:log10, tspan=(1e-6, 1e5), layout=(3,1))

#######################################
#######################################
#######################################
# Stiff 2

using OrdinaryDiffEq, Plots
function orego(du,u,p,t)
  s,q,w = p
  y1,y2,y3 = u
  du[1] = s*(y2+y1*(1-q*y1-y2))
  du[2] = (y3-(1+y1)*y2)/s
  du[3] = w*(y1-y3)
end
p = [77.27,8.375e-6,0.161]
prob = ODEProblem(orego,[1.0,2.0,3.0],(0.0,360.0),p)
sol = solve(prob, Rodas5())
plot(sol)
# phase space

#######################################
#######################################
#######################################
# Stiff SDE

using StochasticDiffEq
function orego(du,u,p,t)
  s,q,w = p
  y1,y2,y3 = u
  du[1] = s*(y2+y1*(1-q*y1-y2))
  du[2] = (y3-(1+y1)*y2)/s
  du[3] = w*(y1-y3)
end
function g(du,u,p,t)
  du[1] = 0.1u[1]
  du[2] = 0.1u[2]
  du[3] = 0.1u[3]
end
p = [77.27,8.375e-6,0.161]
prob = SDEProblem(orego,g,[1.0,2.0,3.0],(0.0,30.0),p)
sol = solve(prob,SOSRI())
plot(sol)

#######################################
#######################################
#######################################
# DAE

function f(out, da, a, p, t)
   L1, m1, L2, m2, g = p

   u1, v1, x1, y1, T1,
   u2, v2, x2, y2, T2 = a

   du1, dv1, dx1, dy1, dT1,
   du2, dv2, dx2, dy2, dT2 = da

   out[1]  = x2*T2/(m2*L2) - du2
   out[2]  = y2*T2/(m2*L2) - g - dv2
   out[3]  = u2 - dx2
   out[4]  = v2 - dy2
   out[5]  = u2^2 + v2^2 -y2*g + T2/m2

   out[6]  = x1*T1/(m1*L1) - x2*T2/(m2*L2) - du1
   out[7]  = y1*T1/(m1*L1) - g - y2*T2/(m2*L2) - dv1
   out[8]  = u1 - dx1
   out[9]  = v1 - dy1
   out[10] = u1^2 + v1^2 + T1/m1 +
                (-x1*x2 - y1*y2)/(m1*L2)*T2 - y1*g
   nothing
end

# Release pendulum from top right
u0 = zeros(10)
u0[3] = 1.0
u0[8] = 1.0
du0 = zeros(10)
du0[2] = 9.8
du0[7] = 9.8

p = [1,1,1,1,9.8]
tspan = (0.,100.)

differential_vars = [true, true, true, true, false,
                     true, true, true, true, false]
prob = DAEProblem(f, du0, u0, tspan, p, differential_vars = differential_vars)
using Sundials
sol = solve(prob, IDA())
plot(sol, vars=((x1,y1,x2,y2)->(x1, y1),3,4,8,9), lab="")
plot!(sol, vars=((x1,y1,x2,y2)->(x1+x2, y1+y2),3,4,8,9), xlims=(-2.2, 2.2), aspect_ratio=1, lab="")

#######################################
#######################################
#######################################
# DDE
using DiffEqProblemLibrary.DDEProblemLibrary, LinearAlgebra
using Plots
using DelayDiffEq
DDEProblemLibrary.importddeproblems()
prob = DDEProblemLibrary.prob_dde_RADAR5_waltman_5
sol = solve(prob, MethodOfSteps(Rosenbrock23(linsolve=LinSolveFactorize(lu))); reltol = 1e-6, abstol = [1e-18, 1e-18, 1e-18, 1e-18, 1e-6, 1e-6])
plot(sol)

#######################################
#######################################
#######################################
# Stiff PDE

using OrdinaryDiffEq, Sundials, Plots

# initial condition
function init_brusselator_2d(xyd)
    N = length(xyd)
    u = zeros(N, N, 2)
    for I in CartesianIndices((N, N))
        x = xyd[I[1]]
        y = xyd[I[2]]
        u[I,1] = 22*(y*(1-y))^(3/2)
        u[I,2] = 27*(x*(1-x))^(3/2)
    end
    u
end

N = 32

xyd_brusselator = range(0,stop=1,length=N)

u0 = vec(init_brusselator_2d(xyd_brusselator))

tspan = (0, 22.)

p = (3.4, 1., 10., xyd_brusselator)

brusselator_f(x, y, t) = ifelse((((x-0.3)^2 + (y-0.6)^2) <= 0.1^2) &&
                                (t >= 1.1), 5., 0.)
function brusselator_2d_loop(du, u, p, t)
    A, B, α, xyd = p
    dx = step(xyd)
    N = length(xyd)
    α = α/dx^2
    limit = a -> let N=N
        a == N+1 ? 1 :
        a == 0 ? N :
        a
    end
    II = LinearIndices((N, N, 2))

    @inbounds begin
        for I in CartesianIndices((N, N))
            x = xyd[I[1]]
            y = xyd[I[2]]
            i = I[1]
            j = I[2]
            ip1 = limit(i+1)
            im1 = limit(i-1)
            jp1 = limit(j+1)
            jm1 = limit(j-1)

            ii1 = II[i,j,1]
            ii2 = II[i,j,2]

            du[II[i,j,1]] = α*(u[II[im1,j,1]] + u[II[ip1,j,1]] + u[II[i,jp1,1]] + u[II[i,jm1,1]] - 4u[ii1]) +
            B + u[ii1]^2*u[ii2] - (A + 1)*u[ii1] + brusselator_f(x, y, t)

            du[II[i,j,2]] = α*(u[II[im1,j,2]] + u[II[ip1,j,2]] + u[II[i,jp1,2]] + u[II[i,jm1,2]] - 4u[II[i,j,2]]) +
            A*u[ii1] - u[ii1]^2*u[ii2]
        end
    end
    nothing
end
gr()
function plot_sol(sol)
    off = N^2
    for t in sol.t[1]:0.1:sol.t[end]
        solt = sol(t)
        plt1 = surface(reshape(solt[1:off], N, N), zlims=(0, 5), leg=false)
        surface!(plt1, reshape(solt[off+1:end], N, N), zlims=(0, 5), leg=false)
        display(plt1)
        sleep(0.05)
    end
    nothing
end

prob2 = ODEProblem(brusselator_2d_loop, u0, tspan, p)

using Sundials
sol2 = @time solve(prob2, CVODE_BDF(linear_solver=:GMRES))

plot_sol(sol2)

