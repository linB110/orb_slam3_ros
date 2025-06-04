#!/bin/bash

input_file="KeyFrameTrajectory.tum"
output_file="KeyFrameTrajectory_fixed.tum"

if [ ! -f "$input_file" ]; then
    echo "Error: $input_file not found!"
    exit 1
fi

awk '{
    if (NF == 8) {
        t = $1 / 1e9
        printf "%.9f %s %s %s %s %s %s %s\n", t, $2, $3, $4, $5, $6, $7, $8
    }
}' "$input_file" > "$output_file"

echo "Converted timestamps saved to $output_file"
