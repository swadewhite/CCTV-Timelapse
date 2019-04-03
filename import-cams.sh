#!/bin/bash

# Here is where you put all the ffmpeg/cctv streams. Make this script run every hour in crontab (It didn't run reliably when run continuously).

STREAM1=https://56cf3370d8dd3.streamlock.net:1935/live/cedar1.stream/playlist.m3u8 #URL of the first stream.
STREAM2=https://56cf3370d8dd3.streamlock.net:1935/live/cedar2.stream/playlist.m3u8 #URL of the second stream.
STREAM3=https://56cf3370d8dd3.streamlock.net:1935/live/cedar3.stream/playlist.m3u8 #URL of the third stream.

nohup ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM1 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam1/Cam1_%Y-%m-%d_%H:%M:%S.mkv" &>/dev/null & \
nohup ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM2 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam2/Cam2_%Y-%m-%d_%H:%M:%S.mkv" &>/dev/null & \
nohup ffmpeg -reconnect_delay_max 99 -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -i $STREAM3 -c copy -t 01:00:00 -segment_format mkv -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "/home/swade/CCTV_Footage/Cedar_Point/Cam3/Cam3_%Y-%m-%d_%H:%M:%S.mkv" &>/dev/null & \
