# ORB-SLAM3 Parameter Evaluation: `ORBextractor.nLevels`

## 📌 Overview

This repository is a fork of [ORB-SLAM3](https://github.com/UZ-SLAMLab/ORB_SLAM3), extended to investigate the impact of the `ORBextractor.nLevels` parameter on trajectory accuracy using the EuRoC MAV dataset.

## 🔍 Purpose

Evaluate how the number of pyramid levels used in ORB feature extraction (`ORBextractor.nLevels`) affects Absolute Pose Error (APE) on different EuRoC sequences.

## 🧪 Experimental Setup

- **Dataset**: EuRoC MAV Dataset
  - `MH_01_easy.bag` (easy case)
  - `MH_03_medium.bag` or `MH_04_difficult.bag` (as hard case)
- **Parameter under test**: `ORBextractor.nLevels`
  - Compared values: `n = 8` (default) vs. `n = 1`
- **Metric**: RMSE from Absolute Pose Error (APE)
- **Evaluation Tool**: [evo](https://github.com/MichaelGrupp/evo)
- **Repetitions**: Each setting was tested over 50 runs for statistical robustness

## ⚙️ Methodology

For each setting:
- Launch ORB-SLAM3 via `roslaunch`
- Play the dataset with `rosbag play`
- Wait for `KeyFrameTrajectory.txt` to be generated
- Convert trajectory to TUM format
- Use `evo_ape` to compute RMSE
- Append results to output files

All steps are automated in a Bash script. RMSE results are logged separately for easy and hard sequences.

## 📊 Results

The following plot visualizes RMSE distributions for both parameter settings:

![RMSE Distribution Comparison](./RMSE_experiment/rmse_distribution_comparison.png)

- `n = 8` achieves consistently lower and more stable RMSE values
- `n = 1` results in higher error and wider spread

## 📁 Files

- `rmse_easy_result`: RMSE values for the easy sequence
- `rmse_hard_result`: RMSE values for the hard sequence
- `RMSE_experiment/`: Folder containing scripts and plots

## ▶️ Usage

### Step 1: Run Experiments

Make sure your workspace is built and sourced properly, then:

```bash
# Run automated evaluation (edit script to change nLevels value)
./run_experiment.sh

