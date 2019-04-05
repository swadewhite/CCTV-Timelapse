#!/bin/bash

# Here is where you put all the ffmpeg/cctv streams. Make this script run every hour in crontab (It didn't run reliably when run continuously).

STREAM1=https://56cf3370d8dd3.streamlock.net:1935/live/cedar1.stream/playlist.m3u8 #URL of the first stream.
STREAM2=https://56cf3370d8dd3.streamlock.net:1935/live/cedar2.stream/playlist.m3u8 #URL of the second stream.
STREAM3=https://56cf3370d8dd3.streamlock.net:1935/live/cedar3.stream/playlist.m3u8 #URL of the third stream.
L_PATH=/home/swade/CCTV_Footage/Cedar_Point #Path to where the local files will be stored.
S_PATH=/mnt/Backups/CCTV_Footage/Cedar_Point #Path to the NAS where the files will be moved. (If not using a NAS, just set this path to the same as L_PATH)
T_DATE=`date '+%Y-%m-%d'`

# Create a new folder with a date stamp.
mkdir "$S_PATH/Cam1/$T_DATE"
mkdir "$S_PATH/Cam2/$T_DATE"
mkdir "$S_PATH/Cam3/$T_DATE"

# Create a new folder for converted files.
mkdir "$S_PATH/Cam1/$T_DATE/Converted"
mkdir "$S_PATH/Cam2/$T_DATE/Converted"
mkdir "$S_PATH/Cam3/$T_DATE/Converted"

# Create a new folder for archived files.
mkdir "$S_PATH/Cam1/$T_DATE/Archive"
mkdir "$S_PATH/Cam2/$T_DATE/Archive"
mkdir "$S_PATH/Cam3/$T_DATE/Archive"

# Copy videos from the previous hour to the NAS. (for transcoding)
find "$L_PATH/Cam1/Cam1_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo cp -t "$S_PATH/Cam1/$T_DATE"
find "$L_PATH/Cam2/Cam2_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo cp -t "$S_PATH/Cam2/$T_DATE"
find "$L_PATH/Cam3/Cam3_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo cp -t "$S_PATH/Cam3/$T_DATE"

# Move videos from the previous hour to the NAS. (archive)
find "$L_PATH/Cam1/Cam1_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "$S_PATH/Cam1/$T_DATE/Archive"
find "$L_PATH/Cam2/Cam2_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "$S_PATH/Cam2/$T_DATE/Archive"
find "$L_PATH/Cam3/Cam3_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "$S_PATH/Cam3/$T_DATE/Archive"


ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM1 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam1/Cam1_$T_DATE.mkv" &>/dev/null & \
ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM2 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam2/Cam2_$T_DATE.mkv" &>/dev/null & \
ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM3 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam3/Cam3_$T_DATE.mkv" &>/dev/null & \
