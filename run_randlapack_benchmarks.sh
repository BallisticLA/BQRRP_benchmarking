# Check if RANDNLA_PROJECT_DIR is not set or empty
if [[ -z "${RANDNLA_PROJECT_DIR}" ]]; then
    echo "Error: RANDNLA_PROJECT_DIR is not set or empty."
    echo "This varibale is set during the initial execution of /RandLAPACK/install.sh."
    echo "Consider installing RandLAPACK via /RandLAPACK/install.sh or setting the RANDNLA_PROJECT_DIR variable manually (not recommended)."
    exit 1
fi

RELOAD_SHELL=0
# Create the benchmark output directory if it does not exist
if [[ ! -d "$BENCHMARK_OUTPUT_DIR" ]]; then
    mkdir -p "$RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output"
    echo "Directory created at: $RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output"
    BENCHMARK_OUTPUT_DIR="$RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output"

    # We need to add the BENCHMARK_OUTPUT_DIR variable to bashrc in order to avoid potentially 
    # re-writing all of the previsouly-gatherred benchmarking data.
    echo "Adding variable $BENCHMARK_OUTPUT_DIR to ~/.bashrc."
    echo "#Added via run_randlapack_benhcmarks.sh" >> ~/.bashrc
    echo "export BENCHMARK_OUTPUT_DIR=\"$RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output\"" >> ~/.bashrc
    RELOAD_SHELL=1
fi

# Attempt to grab the CPU name
CPU_NAME=$(lscpu | grep "Model name" | awk -F ': ' '{print $2}' | tr -d '[:punct:]' | tr ' ' '_' | sed 's/^_*//g')
# Check if the CPU name was retrieved successfully
if [[ -z "$CPU_NAME" ]]; then
    echo "Failed to retrieve CPU name. Naming it after today's date."
    CPU_NAME=$(date +"%Y-%m-%d_CPU")
fi
CPU_DIR="$BENCHMARK_OUTPUT_DIR/$CPU_NAME"

# Create the directory named after the current CPU 
if [[ ! -d "$CPU_DIR" ]]; then
    mkdir -p "$CPU_DIR"
    echo "Directory created at: $CPU_DIR"
fi
# Create the directories for specific BQRRP benchmarks
if [[ ! -d "$CPU_DIR/HQRRP_plot_remake" ]]; then
    mkdir -p "$CPU_DIR/HQRRP_plot_remake"
    echo "Directory created at: $CPU_DIR/HQRRP_plot_remake"
fi
if [[ ! -d "$CPU_DIR/BQRRP_subroutines_speed" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_subroutines_speed"
    echo "Directory created at: $CPU_DIR/BQRRP_subroutines_speed"
fi
if [[ ! -d "$CPU_DIR/BQRRP_runtime_breakdown" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_runtime_breakdown"
    echo "Directory created at: $CPU_DIR/BQRRP_runtime_breakdown"
fi
if [[ ! -d "$CPU_DIR/BQRRP_pivot_quality" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_pivot_quality"
    echo "Directory created at: $CPU_DIR/BQRRP_pivot_quality"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_block_size" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_block_size"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_block_size"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_mat_size" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_mat_size"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_mat_size"
fi
if [[ ! -d "$CPU_DIR/HQRRP_speed_comparisons_block_size" ]]; then
    mkdir -p "$CPU_DIR/HQRRP_speed_comparisons_block_size"
    echo "Directory created at: $CPU_DIR/HQRRP_speed_comparisons_block_size"
fi
if [[ ! -d "$CPU_DIR/HQRRP_runtime_breakdown" ]]; then
    mkdir -p "$CPU_DIR/HQRRP_runtime_breakdown"
    echo "Directory created at: $CPU_DIR/HQRRP_runtime_breakdown"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_block_size_small" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_block_size_small"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_block_size_small"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular"
fi

# GPU prepwork and benchmarking
if [ "$RANDNLA_PROJECT_GPU_AVAIL" = "auto" ]; then
    GPU_NAME=$(lspci | grep -Ei 'vga|3d|display' | grep -Ei 'nvidia|amd' | head -n 1 | awk -F ': ' '{print $2}' | tr -d '[:punct:]' | tr ' ' '_')
    GPU_DIR="$BENCHMARK_OUTPUT_DIR/$GPU_NAME"
    # Create the directory named after the current GPU 
    if [[ ! -d "$GPU_DIR" ]]; then
        mkdir -p "$GPU_DIR"
        echo "Directory created at: $GPU_DIR"
    fi
    if [[ ! -d "$GPU_DIR/BQRRP_runtime_breakdown_gpu" ]]; then
        mkdir -p "$GPU_DIR/BQRRP_runtime_breakdown_gpu"
        echo "Directory created at: $GPU_DIR/BQRRP_runtime_breakdown_gpu"
    fi
    if [[ ! -d "$GPU_DIR/BQRRP_speed_comparisons_block_size_gpu" ]]; then
        mkdir -p "$GPU_DIR/BQRRP_speed_comparisons_block_size_gpu"
        echo "Directory created at: $GPU_DIR/BQRRP_speed_comparisons_block_size_gpu"
    fi

    # Ask the user if they want to continue or skip GPU benchmarks
    read -p "RandLAPACK appears to have been built with GPU support. Commence BQRRP GPU benchmarking? (y/n): " user_input
    if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
        echo "Skipping GPU benchmarks."
    else
        # As of early 2025, GPU benchmarks in RandLAPACK are integrated as part of the testing infactsructure.
        # This shall change in the near future.
        ctest --test-dir $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/ -R "BQRRP_GPU_block_sizes_powers_of_two_2k"
        ctest --test-dir $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/ -R "BQRRP_GPU_block_sizes_powers_of_two_4k"
        ctest --test-dir $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/ -R "BQRRP_GPU_block_sizes_powers_of_two_8k"
        ctest --test-dir $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/ -R "BQRRP_GPU_block_sizes_powers_of_two_16k"
        ctest --test-dir $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/ -R "BQRRP_GPU_block_sizes_powers_of_two_32k"
        echo -e "GPU benchmarks complete\n"

        # Move the GPU benchmarks results into an appropriate directory
        mv $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/test/BQRRP_GPU_speed_comparisons_block_size* $GPU_DIR/BQRRP_speed_comparisons_block_size_gpu/
        mv $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/test/BQRRP_GPU_runtime_breakdown_cholqr*     $GPU_DIR/BQRRP_runtime_breakdown_gpu/
        mv $RANDNLA_PROJECT_DIR/build/RandLAPACK-build/test/BQRRP_GPU_runtime_breakdown_qrf*        $GPU_DIR/BQRRP_runtime_breakdown_gpu/
    fi
fi

# Ask the user if they want to continue or skip CPU benchmarks
read -p "Directory structure preparation complete. Commence BQRRP CPU benchmarking? (y/n): " user_input
if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
    echo "Skipping CPU benchmarks."
else
    # PRELIMINARY INFO GATHERING BEFORE RUNNING BENCHMAKRS
    # Set the list of the numbers of threads that will be used in our CPU benchmarks
    # Check the number of CPU sockets
    CPU_SOCKETS=$(awk -F': ' '/physical id/ { print $2 }' /proc/cpuinfo | sort -u | wc -l)
    # Determine the maximum number of OpenMP threads that can be used on a given system
    #MAX_THREADS=$((2 * CPU_SOCKETS * $(nproc --all)))
    MAX_THREADS=$((2 * $(nproc --all)))
    
    THREADS_LIST=()
    # Case used for the AMD system with exceptionally large core count
    if [[ $MAX_THREADS -eq 448 ]]; then
        THREADS_LIST=("4" "16" "64" "128" "448")
    elif [[ $MAX_THREADS -eq 128 ]]; then
        THREADS_LIST=("4" "16" "64" "128")
    else 
        # Judging by the number of max threads estimated, neither the Sapphire Rapids, nor the Zen4c systems are in use.
        # Ask the user if they want to continue benchmarking & request them to enter the number of threads manually.
        read -p "Judging by the number of max threads estimated, neither the Sapphire Rapids, nor the Zen4c systems are in use. Continue BQRRP CPU benchmarking? (y/n): " user_input
        if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
            echo "Skipping CPU benchmarks."
            if [ $RELOAD_SHELL -eq 1 ]; then
                # Source from bash and spawn a new shell so that the variable change takes place
                bash -c "source ~/.bashrc && exec bash"
            fi
            exit 0
        else
            # Prompt the user to enter the list of threads manually.
            echo "Enter the list of thread counts separated by spaces (e.g., 4 16 64 128 448):"
            read -a THREADS_LIST
        fi
    fi
    
    NUMACTL_VAR=""
    # Check if we can/should use numactl
    if [[ $CPU_SOCKETS -gt 1 ]]; then 
        # Check if numactl is available
        if command -v numactl &> /dev/null; then
            NUMACTL_VAR="numactl --interleave=all"
            echo "numactl is installed."
        else
            echo "numactl is not installed"
            read -p "Without numactl, algorithms performance may vary greatly from that reported in the BQRRP paper. Continue anyway? (y/n): " user_input
            if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
                echo "Skipping CPU benchmarks. Please install numactl."
                if [ $RELOAD_SHELL -eq 1 ]; then
                    # Source from bash and spawn a new shell so that the variable change takes place
                    bash -c "source ~/.bashrc && exec bash"
                fi
                exit 1
            fi
        fi
    fi
    
    # Make a shortcut variable
    EXECUTION_DIR=$RANDNLA_PROJECT_DIR/build/benchmark-build

    # Get the benchmark commencement date
    DATETIME=$(date "+%Y-%m-%d-%H:%M:%S")

    # PERFORMING BENCHMARK RUNS
    # HQRRP plot remake benchmarks
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/HQRRP_plot_remake/$DATETIME hqrrp_const 20 1 1 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/HQRRP_plot_remake/$DATETIME hqrrp_const 20 1 1 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000;"
    done
    echo -e "HQRRP plot remake benchmarks complete\n"

    # BQRRP subroutines speed
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_subroutines_speed CPU_DIR/BQRRP_subroutines_speed/$DATETIME 3 65536 256 512 1024 2048 4096 8192;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_subroutines_speed $CPU_DIR/BQRRP_subroutines_speed/$DATETIME 3 65536 256 512 1024 2048 4096 8192;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_subroutines_speed CPU_DIR/BQRRP_subroutines_speed/$DATETIME 3 64000 250 500 1000 2000 4000 8000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_subroutines_speed $CPU_DIR/BQRRP_subroutines_speed/$DATETIME 3 64000 250 500 1000 2000 4000 8000;"
    echo -e "BQRRP subroutines speed complete\n"

    # BQRRP runtime breakdown
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_runtime_breakdown CPU_DIR/BQRRP_runtime_breakdown/$DATETIME cholqr 3 65536 65536 256 512 1024 2048 4096 8192;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_runtime_breakdown $CPU_DIR/BQRRP_runtime_breakdown/$DATETIME cholqr 3 65536 65536 256 512 1024 2048 4096 8192;"
    
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_runtime_breakdown CPU_DIR/BQRRP_runtime_breakdown/$DATETIME geqrf  3 65536 65536 256 512 1024 2048 4096 8192;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_runtime_breakdown $CPU_DIR/BQRRP_runtime_breakdown/$DATETIME geqrf  3 65536 65536 256 512 1024 2048 4096 8192;"
    echo -e "BQRRP runtime breakdown complete\n"

    # Kahan matrix spectrum
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/Kahan_spectrum CPU_DIR/BQRRP_pivot_quality/$DATETIME 16384 16384;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/Kahan_spectrum $CPU_DIR/BQRRP_pivot_quality/$DATETIME 16384 16384;"

    # BQRRP pivot quality
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_pivot_quality CPU_DIR/BQRRP_pivot_quality/$DATETIME 16384 16384 64;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_pivot_quality $CPU_DIR/BQRRP_pivot_quality/$DATETIME 16384 16384 64;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_pivot_quality CPU_DIR/BQRRP_pivot_quality/$DATETIME 16384 16384 4096;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_pivot_quality $CPU_DIR/BQRRP_pivot_quality/$DATETIME 16384 16384 4096;"
    echo -e "BQRRP pivot quality complete\n"

    # BQRRP performance varying block size
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 3 65536 65536 256 512 1024 2048 4096 8192;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 3 65536 65536 256 512 1024 2048 4096 8192;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 3 64000 64000 250 500 1000 2000 4000 8000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 3 64000 64000 250 500 1000 2000 4000 8000;"
    echo -e "BQRRP performance varying block size complete\n"

    # BQRRP performance varying mat size
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/BQRRP_speed_comparisons_mat_size/$DATETIME default 3 1 32 8000 16000 32000;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/BQRRP_speed_comparisons_mat_size/$DATETIME default 3 1 32 8000 16000 32000;"
    done
    echo -e "BQRRP performance varying mat size complete\n"

    # HQRRP performance varying block size
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/HQRRP_speed_comparisons_block_size/$DATETIME hqrrp 3 32000 32000 5 10 25 50 125 250 500 1000 2000 4000 8000;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/HQRRP_speed_comparisons_block_size/$DATETIME hqrrp 3 32000 32000 5 10 25 50 125 250 500 1000 2000 4000 8000;"
    done
    echo -e "HQRRP performance varying block size complete\n"

    # HQRRP runtime breakdown
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/HQRRP_runtime_breakdown CPU_DIR/HQRRP_runtime_breakdown/$DATETIME 3 32000 32000 5 10 25 50 125 250 500 1000 2000 4000 8000;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/HQRRP_runtime_breakdown $CPU_DIR/HQRRP_runtime_breakdown/$DATETIME 3 32000 32000 5 10 25 50 125 250 500 1000 2000 4000 8000;"
    done
    echo -e "HQRRP runtime breakdown complete\n"

    # BQRRP performance varying block size small
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 1000 1000 5 10 25 50 125 250 500 1000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 1000 1000 5 10 25 50 125 250 500 1000;"
    
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 2000 2000 5 10 25 50 125 250 500 1000 2000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 2000 2000 5 10 25 50 125 250 500 1000 2000;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 4000 4000 5 10 25 50 125 250 500 1000 4000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 4000 4000 5 10 25 50 125 250 500 1000 4000;"
    echo -e "BQRRP performance varying block size small complete\n"

    # BQRRP performance varying mat size rectangular: tall and wide
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 3 2 32 8000 16000 32000 64000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 3 2 32 8000 16000 32000 64000;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 3 0.5 32 8000 16000 32000 64000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 3 0.5 32 8000 16000 32000 64000;"
    echo -e "BQRRP performance varying mat size rectangular: tall and wide complete\n"
fi

if [ $RELOAD_SHELL -eq 1 ]; then
    # Source from bash and spawn a new shell so that the variable change takes place
    bash -c "source ~/.bashrc && exec bash"
fi
