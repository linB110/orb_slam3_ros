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
- **Hard**: e.g., `MH_04_difficult.bag`
- Both downloaded from the [EuRoC MAV Dataset](https://projects.asl.ethz.ch/datasets/doku.php?id=kmavvisualinertialdatasets)

## 🔧 Workflow

1. Modify the `ORBextractor.cc` file to set desired `nLevels`
2. Rebuild the workspace
3. Use the provided automated bash script to:
   - Launch the SLAM system
   - Play a dataset (`rosbag`)
   - Wait for `KeyFrameTrajectory.txt`
   - Convert trajectory to TUM format
   - Run `evo_ape` for RMSE analysis
4. Repeat this over 50 runs to collect statistical data

## 🛠️ Scripts

- `run_experiment.sh`: Automates the entire process
- `rmse_distribution_stats.py`: Parses and visualizes RMSE distributions

Output files:
- `rmse_easy_result`
- `rmse_hard_result`

## 📊 Results

The RMSE distributions show the impact of the `nLevels` setting:

![RMSE Distribution](./RMSE_experiment/rmse_distribution_comparison.png)

- `nLevels = 8` (default) has lower RMSE and tighter distribution
- `nLevels = 1` results in higher and more varied RMSE

## 🧪 Run the Experiments

```bash
# Run SLAM with desired configuration (adjust nLevels in source before build)
./run_experiment.sh
