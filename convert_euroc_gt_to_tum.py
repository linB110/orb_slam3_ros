import csv

input_file = '/home/lab605/EuRoC/mav0/state_groundtruth_estimate0/data.csv'
output_file = '/home/lab605/EuRoC/groundtruth_tum.txt'

with open(input_file, 'r') as fin, open(output_file, 'w') as fout:
    reader = csv.reader(fin)
    for row in reader:
        if row[0].startswith('#') or len(row) < 8:
            continue  # skip header or malformed lines

        timestamp_ns = int(row[0])
        timestamp_sec = timestamp_ns / 1e9

        tx, ty, tz = row[1], row[2], row[3]
        qw, qx, qy, qz = row[4], row[5], row[6], row[7]

        fout.write(f"{timestamp_sec:.9f} {tx} {ty} {tz} {qx} {qy} {qz} {qw}\n")

print("✅ Ground truth converted to TUM format at:", output_file)
