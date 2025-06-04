#!/bin/bash

# === seeting ===
EASY_BAG_PATH="/home/lab605/EuRoC/MH_01_easy.bag"
HARD_BAG_PATH="/home/lab605/EuRoC/MH_05_difficult.bag"
EASY_GT_PATH="/home/lab605/EuRoC/gt_MH01.tum"
HARD_GT_PATH="/home/lab605/EuRoC/gt_MH05.tum"
LAUNCH_FILE="euroc_stereo_inertial.launch"
ROS_PACKAGE="orb_slam3_ros"
LOOP_COUNT=100  # loop count
EASY_RMSE_FILE="rmse_easy.txt"
HARD_RMSE_FILE="rmse_hard.txt"
KF_SRC="$HOME/.ros/KeyFrameTrajectory.txt"
KF_FILE="KeyFrameTrajectory.txt"
TUM_FILE="kf_tum.txt"
APE_LOG="ape_log.txt"

# === initialization ===
source ~/catkin_ws/devel/setup.bash
rosparam set use_sim_time true
> "$EASY_RMSE_FILE"
> "$HARD_RMSE_FILE"

# === run easy dataset ===
echo "==================== start running easy dataset ===================="
for i in $(seq 1 $LOOP_COUNT); do
    echo "==================== round $i (easy) ===================="
    echo "starting from：$(date "+%Y-%m-%d %H:%M:%S")"

    # activate ORB-SLAM3
    echo "[INFO] activate ORB-SLAM3..."
    roslaunch $ROS_PACKAGE $LAUNCH_FILE > /dev/null 2>&1 &
    LAUNCH_PID=$!
    sleep 5

    echo "[INFO] playing rosbag..."
    rosbag play "$EASY_BAG_PATH" --clock > /dev/null 2>&1
    echo "[INFO] rosbag finished"
    sleep 2

    echo "[INFO] terminate ORB-SLAM3（auto-crtl + c）..."
    kill -SIGINT $LAUNCH_PID
    wait $LAUNCH_PID

    # wait fot KeyFrameTrajectory.txt update
    echo "[INFO] wait KeyFrameTrajectory.txt writting..."
    FOUND=0
    PREV_HASH=""
    for j in $(seq 1 30); do
        if [ -f "$KF_SRC" ]; then
            CURR_HASH=$(md5sum "$KF_SRC" | awk '{print $1}')
            if [ "$CURR_HASH" != "$PREV_HASH" ]; then
                cp "$KF_SRC" "$KF_FILE"
                echo "[INFO] KeyFrameTrajectory.txt updated and copied "
                FOUND=1
                break
            fi
            PREV_HASH="$CURR_HASH"
        fi
        sleep 1
    done

    if [ $FOUND -eq 0 ]; then
        echo "[ERROR] time exceed，can't find content"
        continue
    fi

    echo "[INFO] transform TUM format..."
    awk 'NF==8 {
        printf "%.9f %.7f %.7f %.7f %.7f %.7f %.7f %.7f\n", $1, $2, $3, $4, $5, $6, $7, $8
    }' "$KF_FILE" > "$TUM_FILE"

    echo "[INFO] running evo_ape..."
    rm -f "$APE_LOG"
    evo_ape tum "$EASY_GT_PATH" "$TUM_FILE" --align --logfile "$APE_LOG" > /dev/null

    if grep -q "rmse" "$APE_LOG"; then
        echo "[INFO] getting RMSE result..."
        grep -m 1 "rmse" "$APE_LOG" | awk '{print $2}' | tee -a "$EASY_RMSE_FILE"
    else
        echo "[ERROR] evo_ape no effective result"
    fi

    echo ""
    sleep 3
done

echo "✅ easy dataset finished，RMSE result stored  $EASY_RMSE_FILE"

# === run hard dataset ===
echo "==================== starting hard dataset ===================="
for i in $(seq 1 $LOOP_COUNT); do
    echo "==================== rounf $i  (hard) ===================="
    echo "starting from ：$(date "+%Y-%m-%d %H:%M:%S")"

    # activate ORB-SLAM3
    echo "[INFO] activate ORB-SLAM3..."
    roslaunch $ROS_PACKAGE $LAUNCH_FILE > /dev/null 2>&1 &
    LAUNCH_PID=$!
    sleep 5

    echo "[INFO] playing rosbag..."
    rosbag play "$HARD_BAG_PATH" --clock > /dev/null 2>&1
    echo "[INFO] rosbag finished"
    sleep 2

    echo "[INFO] ends ORB-SLAM3（auto ctrl+c）..."
    kill -SIGINT $LAUNCH_PID
    wait $LAUNCH_PID

    # wait for update KeyFrameTrajectory.txt 
    echo "[INFO] waitting for update KeyFrameTrajectory.txt ..."
    FOUND=0
    PREV_HASH=""
    for j in $(seq 1 30); do
        if [ -f "$KF_SRC" ]; then
            CURR_HASH=$(md5sum "$KF_SRC" | awk '{print $1}')
            if [ "$CURR_HASH" != "$PREV_HASH" ]; then
                cp "$KF_SRC" "$KF_FILE"
                echo "[INFO]  KeyFrameTrajectory.txt updated and copied"
                FOUND=1
                break
            fi
            PREV_HASH="$CURR_HASH"
        fi
        sleep 1
    done

    if [ $FOUND -eq 0 ]; then
        echo "[ERROR] waitting exceed, cant't find the content"
        continue
    fi

    echo "[INFO] transform to TUM format..."
    awk 'NF==8 {
        printf "%.9f %.7f %.7f %.7f %.7f %.7f %.7f %.7f\n", $1, $2, $3, $4, $5, $6, $7, $8
    }' "$KF_FILE" > "$TUM_FILE"

    echo "[INFO] running evo_ape..."
    rm -f "$APE_LOG"
    evo_ape tum "$HARD_GT_PATH" "$TUM_FILE" --align --logfile "$APE_LOG" > /dev/null

    if grep -q "rmse" "$APE_LOG"; then
        echo "[INFO] get RMSE result..."
        grep -m 1 "rmse" "$APE_LOG" | awk '{print $2}' | tee -a "$HARD_RMSE_FILE"
    else
        echo "[ERROR] evo_ape no effective result"
    fi

    echo ""
    sleep 3
done

echo "✅ hard dataset finished，RMSE result stored $HARD_RMSE_FILE"

