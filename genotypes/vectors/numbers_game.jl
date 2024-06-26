export create_genotypes, DummyNGGenotypeCreator, NumbersGameVectorGenotypeCreator
export BiasedNumbersGameVectorGenotypeCreator

using ....Abstract

Base.@kwdef struct DummyNGGenotypeCreator <: GenotypeCreator
end

function create_genotypes(
    ::DummyNGGenotypeCreator, n_population::Int, state::State
)
    genotypes = BasicVectorGenotype{Float64}[]
    for i in 1:3
        for j in 1:3
            genes = Float64[i, j]
            genotype = BasicVectorGenotype(genes)
            push!(genotypes, genotype)
        end
    end

    return genotypes
end

Base.@kwdef struct NumbersGameVectorGenotypeCreator{T <: Real} <: GenotypeCreator
    length::Int = 5
    init_range::Tuple{T, T} = (0.0, .1)
    mutation_granularity::Float64 = 0.01
end

function create_genotypes(
    genotype_creator::NumbersGameVectorGenotypeCreator, n_population::Int, state::State   
)
    genotypes = BasicVectorGenotype{Float64}[]
    for _ in 1:n_population
        genes = zeros(Float64, genotype_creator.length)
        init_start = genotype_creator.init_range[1]
        init_end = genotype_creator.init_range[2]
        for i in 1:genotype_creator.length
            genes[i] = rand(state.rng, init_start:genotype_creator.mutation_granularity:init_end)
        end
        genotype = BasicVectorGenotype(genes)
        push!(genotypes, genotype)
    end

    return genotypes
end

Base.@kwdef struct BiasedNumbersGameVectorGenotypeCreator{T <: Real} <: GenotypeCreator
    length::Int
    init_range::Tuple{T, T}
    bias::Vector{T}
end

function create_genotypes(
    genotype_creator::BiasedNumbersGameVectorGenotypeCreator, n_population::Int, state::State   
)
    genotypes = BasicVectorGenotype{Float64}[]
    for _ in 1:n_population
        genes = zeros(Float64, genotype_creator.length)
        init_start = genotype_creator.init_range[1]
        init_end = genotype_creator.init_range[2]
        for i in 1:genotype_creator.length
            genes[i] = rand(state.rng, init_start:0.001:init_end) + genotype_creator.bias[i]
        end
        genotype = BasicVectorGenotype(genes)
        push!(genotypes, genotype)
    end

    return genotypes
end