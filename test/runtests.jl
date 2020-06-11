using Distributed
addprocs(2)

using Test
using MLJTuning
using MLJBase

# Display Number of processes and if necessary number
# of Threads
@info "nworkers: $(nworkers())"
@static if VERSION >= v"1.3.0-DEV.573"
    @info "nthreads: $(Threads.nthreads())"
else
    @info "Running julia $(VERSION). Multithreading tests excluded. "
end

include("test_utilities.jl")

print("Loading some models for testing...")
# load `Models` module containing models implementations for testing:
include("models.jl") #incluse in main process to precompile
@everywhere include("models.jl")
print("\r                                           \r")

@testset "utilities" begin
    @test include("utilities.jl")
end

@testset "tuned_models.jl" begin
    @test include("tuned_models.jl")
end

@testset "range_methods" begin
    @test include("range_methods.jl")
end

@testset "grid" begin
    @test include("strategies/grid.jl")
end

@testset "random search" begin
    @test include("strategies/random_search.jl")
end

@testset "learning curves" begin
        @test include("learning_curves.jl")
end

# @testset "julia bug" begin
#     @test include("julia_bug.jl")
# end

