#!/bin/bash

# Here is where you put all the ffmpeg/cctv streams. Make this script run every hour in crontab (It didn't run reliably when run continuously).

STREAM1=https://56cf3370d8dd3.streamlock.net:1935/live/cedar1.stream/playlist.m3u8 #URL of the first stream.
STREAM2=https://56cf3370d8dd3.streamlock.net:1935/live/cedar2.stream/playlist.m3u8 #URL of the second stream.
STREAM3=https://56cf3370d8dd3.streamlock.net:1935/live/cedar3.stream/playlist.m3u8 #URL of the third stream.
L_PATH=/home/swade/CCTV_Footage/Cedar_Point #Path to where the local files will be stored.
S_PATH=/mnt/Backups/CCTV_Footage/Cedar_Point #Path to the NAS where the files will be moved. (If not using a NAS, just set this path to the same as L_PATH)

# Create a new folder with a date stamp.
mkdir "$S_PATH/Cam1/$(date +'%Y-%m-%d')"
mkdir "$S_PATH/Cam2/$(date +'%Y-%m-%d')"
mkdir "$S_PATH/Cam3/$(date +'%Y-%m-%d')"

# Create a new folder for converted files.
mkdir "$S_PATH/Cam1/$(date +'%Y-%m-%d')/Converted"
mkdir "$S_PATH/Cam2/$(date +'%Y-%m-%d')/Converted"
mkdir "$S_PATH/Cam3/$(date +'%Y-%m-%d')/Converted"

# Create a new folder for archived files.
mkdir "$S_PATH/Cam1/$(date +'%Y-%m-%d')/Archive"
mkdir "$S_PATH/Cam2/$(date +'%Y-%m-%d')/Archive"
mkdir "$S_PATH/Cam3/$(date +'%Y-%m-%d')/Archive"

# Copy videos from the previous hour to the NAS. (for transcoding)
find "$L_PATH/Cam1/Cam1_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "$S_PATH/Cam1/$(date +'%Y-%m-%d')"
find "$L_PATH/Cam2/Cam2_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "$S_PATH/Cam2/$(date +'%Y-%m-%d')"
find "$L_PATH/Cam3/Cam3_"*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "$S_PATH/Cam3/$(date +'%Y-%m-%d')"

ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM1 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam1/Cam1_$(date +'%Y-%m-%d_%H:%M:%S').mkv" &>/dev/null & \
ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM2 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam2/Cam2_$(date +'%Y-%m-%d_%H:%M:%S').mkv" &>/dev/null & \
ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM3 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam3/Cam3_$(date +'%Y-%m-%d_%H:%M:%S').mkv" &>/dev/null & \
