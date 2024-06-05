#!/bin/bash

# Function to start the process
start_process() {
    nohup python ns3_stable_solve.py --sb-model-name "train-saved-aurora-ns3-lin" --tf-model-name "aurora-ns3-lin" --test --iterations=1000 > /dev/null 2>&1 &
    # nohup python ns3_stable_solve.py --tf-model-name "test-model" --test --iterations=100 > /dev/null 2>&1 &
    process_pid=$!
    echo "Started process with PID: $process_pid"
}

# Function to check CPU usage
check_cpu_usage() {
    local cpu_idle
    cpu_idle=$(mpstat 1 1 | awk '/^Average/ {print 100 - $12}')
    local cpu_usage=$(echo $cpu_idle | awk '{print int($1)}')
    echo "Current CPU usage: $cpu_usage%"
    if [[ $cpu_usage -lt 5 ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check for the file and its contents
check_file() {
    if [[ -f "./current_iteration/train-saved-aurora-ns3-lin" ]]; then
        if grep -q "1000" "./current_iteration/train-saved-aurora-ns3-lin"; then
            echo "File contains 1000. Skipping restart."
            return 1
        fi
    fi
    return 0
}

# Function to kill the process
kill_process() {
    kill $process_pid
    ps aux | grep ns3 | grep -v grep | awk '{print $2}' | xargs kill
    echo "Killed process with PID: $process_pid"
}

# Start the initial process
start_process

# Main loop to monitor CPU usage
while true; do
    sleep 60  # Wait for 60 seconds before checking CPU usage
    if check_cpu_usage; then
        if check_file; then
            echo "File check condition met. Exiting script."
            exit 0
        else
            kill_process
            start_process
        fi
    fi
done
