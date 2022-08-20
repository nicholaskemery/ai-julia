struct ProdFunc{T <: Real}
    n::Int
    A::Vector{T}
    α::Vector{T}
    B::Vector{T}
    β::Vector{T}
    θ::Vector{T}
end

function ProdFunc(
    ;
    n::Int = 2,
    A::Union{Real, AbstractVector} = 10.,
    α::Union{Real, AbstractVector} = 0.5,
    B::Union{Real, AbstractVector} = 10.,
    β::Union{Real, AbstractVector} = 0.5, 
    θ::Union{Real, AbstractVector} = 0.5
)
    @assert n >= 2 "n must be at least 2"
    prodFunc = ProdFunc(
        n,
        as_Float64_Array(A, n),
        as_Float64_Array(α, n),
        as_Float64_Array(B, n),
        as_Float64_Array(β, n),
        as_Float64_Array(θ, n)
    )
    @assert all(length(getfield(prodFunc, x)) == n for x in [:A, :α, :B, :β, :θ]) "Your input params need to match the number of players"
    return prodFunc
end

ProdFunc(A, α, B, β, θ) = ProdFunc(n=length(A), A=A, α=α, B=B, β=β, θ=θ)


function f(prodFunc::ProdFunc, i::Int, Xs::Number, Xp::Number)
    p = prodFunc.B[i] * Xp^prodFunc.β[i]
    s = prodFunc.A[i] * Xs^prodFunc.α[i] * p^(-prodFunc.θ[i])
    return s, p
end

# allow direct calling of prodFunc
(prodFunc::ProdFunc)(i::Int, Xs::Number, Xp::Number) = f(prodFunc, i, Xs, Xp)

function f(prodFunc::ProdFunc, Xs::Vector, Xp::Vector)
    p = prodFunc.B .* Xp.^prodFunc.β
    s = prodFunc.A .* Xs.^prodFunc.α .* p.^(-prodFunc.θ)
    return s, p
end

(prodFunc::ProdFunc)(Xs::Vector, Xp::Vector) = f(prodFunc, Xs, Xp)

function is_symmetric(prodFunc::ProdFunc)
    all(
        all(x[1] .== x[2:prodFunc.n])
        for x in (prodFunc.A, prodFunc.α, prodFunc.B, prodFunc.β, prodFunc.θ)
    )
end
