mkdir -p log/
# 1. Compile Stage
vcs -full64 -sverilog \
    +lint=all \
    +libext+.v \
    +timescale=1ns/1ps \
    testfixture.v top.v \
    -debug_all \
    -l log/compile.log \
    -o log/simv

# 2. Simulation Execution
./simv \
    +vcs+lic+wait \
    +ntb_random_seed=1234 \
    +vcs+finish+1000 \
    -l log/sim.log
