# ORB-SLAM3 ROS Parameter Evaluation: `ORBextractor.nLevels`

## 🧭 Project Context

This is a fork of [`orb_slam3_ros`](https://github.com/thien94/orb_slam3_ros), a ROS wrapper for the official ORB-SLAM3 system.  
We extend it to evaluate the influence of the `ORBextractor.nLevels` parameter under real-world conditions using the **EuRoC MAV dataset**.

## 🎯 Objective

Evaluate how changing the number of pyramid levels (`ORBextractor.nLevels`) in ORB feature extraction affects SLAM accuracy.

We ran experiments with:
- `nLevels = 8` (default)
- `nLevels = 1` (more aggressive, faster, but potentially less robust)

Each configuration is tested on **EuRoC sequences** using ROS bags and analyzed through RMSE of Absolute Pose Error (APE).

## 📁 Dataset

- **Easy**: `MH_01_easy.bag`
- **Hard**: `MH_05_difficult.bag`
- Both downloaded from the [EuRoC MAV Dataset](https://projects.asl.ethz.ch/datasets/doku.php?id=kmavvisualinertialdatasets)

## 🔧 Workflow

1. Modify the `config/EuRoC.yaml` file to set desired `nLevels`
2. Rebuild the workspace
3. Use the provided automated Bash script to:
   - Launch the SLAM system
   - Play a dataset (`rosbag`)
   - Wait for `KeyFrameTrajectory.txt`
   - Convert trajectory to TUM format
   - Run `evo_ape` for RMSE analysis  
   ⚠️ **Note**: You need to manually start `roscore` in a separate terminal
4. Repeat for 50–100 runs to collect statistically meaningful data

## 🛠️ Scripts

- `auto_runORBSLAM3_n1_test.sh`: Automates SLAM launch, evaluation, and data extraction
- `rmse_distribution_stats.py`: Parses and visualizes RMSE distributions from multiple runs

## 📂 Output Files

Each result file contains 50 RMSE values from repeated runs:

| Parameter       | Sequence        | File Name               |
|----------------|-----------------|--------------------------|
| `n=1`          | MH_01_easy      | `rmse_n1_easy.txt`      |
| `n=1`          | MH_05_difficult | `rmse_n1_hard.txt`      |
| `n=8`          | MH_01_easy      | `rmse_n8_easy.txt`      |
| `n=8`          | MH_05_difficult | `rmse_n8_hard.txt`      |

(Optionally, combined distributions may be saved as `rmse_easy_result` and `rmse_hard_result`.)

## 📊 Results

The RMSE distributions below demonstrate the effect of varying `nLevels`:
|easy dataset comparison|
![RMSE Distribution](./rmse_easy_result)

|difficult dataset comparison|
![RMSE Distribution](./rmse_hard_result)
- **`nLevels = 8`** results in lower RMSE and more stable trajectories
- **`nLevels = 1`** leads to slightly higher RMSE and greater variance, especially in harder sequences

## 🧪 Run the Experiments

```bash
# Run SLAM with desired configuration (edit config and rebuild beforehand)
./auto_runORBSLAM3_n1_test.sh

# Analyze results and generate plots
python3 rmse_distribution_stats.py
