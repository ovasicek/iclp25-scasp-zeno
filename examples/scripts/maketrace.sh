# !/bin/bash


if [ $# -eq 2 ]; then
    command_to_run="$1"
    log_file="$2"
else
    echo "Usage: $0 command_to_run file_to_log_to"
    exit 1
fi

echo "$ $command_to_run" > "$log_file"
echo >> "$log_file"
echo >> "$log_file"

/usr/bin/time -f "\n  real      %E\n  real [s]  %e\n  user [s]  %U\n  sys  [s]  %S\n  mem  [KB] %M\n  avgm [KB] %K" $command_to_run >> "$log_file" 2>&1
