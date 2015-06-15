#!/system/bin/sh
TIMESTAMP=`date +'%Y-%m-%d-%H-%M-%S'`

# Version info for digicl
DIGICL_VER=`getprop ro.build.version.sdk`.1.1

# LEVEL: 0 (Default), 1 (All), 9(FUT)
COPYLEVEL=0

# Build emulated storage paths when appropriate
# See storage config details at http://source.android.com/tech/storage/
if [ -n "$EMULATED_STORAGE_SOURCE" ]; then
        WRITE_PATH="$EMULATED_STORAGE_SOURCE/0"
        READ_PATH="$EMULATED_STORAGE_TARGET/0"
else
        WRITE_PATH="$EXTERNAL_STORAGE"
        READ_PATH="$EXTERNAL_STORAGE"
fi

# Set Internal storage as default path
PATH_TARGET=$WRITE_PATH/logs_backup/logs_backup-$TIMESTAMP
PATH_SEND=$READ_PATH/logs_backup/logs_backup-$TIMESTAMP

# to seperate copy to internal/external storage
while getopts iealf OPTION
do
    case "$OPTION"  in
    e)
        # to external storage
        if [ ! -n "$EXTERNAL_ADD_STORAGE" ]; then
            # broadcast finished intent
            # Error code -3 : EXTERNAL_ADD_STORAGE is not declared.
            echo am broadcast -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -3
            am broadcast -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -3

            echo EXTERNAL_ADD_STORAGE is not declared.
            exit 0
        fi
            PATH_TARGET=$EXTERNAL_ADD_STORAGE/logs_backup/logs_backup-$TIMESTAMP
            PATH_SEND=$PATH_TARGET
        ;;
    a)
        echo "Copy all logs..."
        COPYLEVEL=1
        ;;
    f)
        # running digicl.sh for FUT (copy default logs, but except  blue_coredump)
        echo "Copy FUT logs..."
        COPYLEVEL=9
        ;;
    esac
done


echo "COPYLEVEL = $COPYLEVEL"
echo PATH_TARGET = $PATH_TARGET

mkdir -p "$PATH_TARGET"

# prevent media scanning
touch "$PATH_TARGET/../.nomedia"

# Check if the target path is writable
if [ ! -e "$PATH_TARGET/../.nomedia" ]; then
    # broadcast finished intent
    # Error code -2 : Unable to wrtie $PATH_TARGET.
    echo am broadcast -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -1
    am broadcast -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -2

    echo Unable to wrtie $PATH_TARGET.
    exit 0
fi

PHONE_DATE=$(date | grep -v "dummy")
echo "PHONE_DATE = $PHONE_DATE"
PRODUCT_NAME=$(getprop ro.product.name | grep -v "dummy")
echo "PRODUCT_NAME = $PRODUCT_NAME"
PHONE_FINGER=$(getprop ro.build.fingerprint | grep -v "dummy")
echo "PHONE_FINGER = $PHONE_FINGER"
PHONE_SWV=$(getprop ro.lge.swversion | grep -v "dummy")
echo "PHONE_SWV = $PHONE_SWV"
PHONE_FACTORYV=$(getprop ro.lge.factoryversion | grep -v "dummy")
echo "PHONE_FACTORYV = $PHONE_FACTORYV"
PHONE_HWVER=$(getprop ro.lge.hw.revision | grep -v "dummy")
echo "PHONE_HWVER = $PHONE_FACTORYV"
PHONE_PCB=$(cat /sys/devices/platform/msm_adc/pcb_revision | grep -v "dummy")
echo "PHONE_PCB = $PHONE_PCB"
PHONE_BUILD_TYPE=$(getprop ro.build.type | grep -v "dummy")
echo "PHONE_BUILD_TYPE = $PHONE_BUILD_TYPE"

INFO_FILE_NAME="$PRODUCT_NAME"_"$PHONE_BUILD_TYPE".txt


echo "> Profile of phone...."
echo "=======> $INFO_FILE_NAME"
echo "[ Device Date & TIME at pulling logs]" > $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_DATE" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ PRODUCT_NAME ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PRODUCT_NAME" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ PHONE_BUILD_TYPE ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_BUILD_TYPE" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ Factory Version ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_FACTORYV" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ SW Version ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_SWV" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ HW Version ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_HWVER  ($PHONE_PCB)" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ Fingerprint ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_FINGER" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ digicl.sh Version]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $DIGICL_VER" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo -------------------------------------------
echo ">> extract log files to $PATH_TARGET <<"
echo -------------------------------------------

# Android Log
echo "> Retrieving Android Log files(/data/logger, /data/log)..."
cp -r /data/logger $PATH_TARGET/logger
cp /proc/last_kmsg $PATH_TARGET/logger/last_kmsg.log

# ANR
echo "> Retrieving ANR Logs(/data/anr)..."
cp -r /data/anr $PATH_TARGET/anr

# TOMBSTONES
echo "> Retrieving Tombstones Log(/data/tombstones, /tombstones)..."
cp -r /data/tombstones $PATH_TARGET/tombstones

# Art Tool Report Log : Report*.xml, CrashedReport20120701_233950.rpt
echo "> Retrieving art report files(/data/data/com.lge.art/files/Report/)..."
cp -r /data/data/com.lge.art/files/Report $PATH_TARGET/art

# Multimedia database
echo "> Retrieving MediaDB files(/data/data/com.android.providers.media/databases/)..."
cp -r /data/data/com.android.providers.media/databases $PATH_TARGET/MediaDB

# DROPBOX
echo "> Retrieving DROPBOX Log(/data/system/dropbox)..."
mkdir $PATH_TARGET/dropbox
dumpsys dropbox --print > $PATH_TARGET/dropbox/dropbox_print.txt

#adb shell dumpsys dropbox SYSTEM_BOOT --print > %PATH_TARGET%\dropbox\system_BOOT.txt
#adb shell dumpsys dropbox SYSTEM_RESTART --print > %PATH_TARGET%\dropbox\system_RESTART.txt
#adb shell dumpsys dropbox SYSTEM_LAST_KMSG --print > %PATH_TARGET%\dropbox\system_LAST_KMSG.txt
#adb shell dumpsys dropbox SYSTEM_RECOVERY_LOG --print > %PATH_TARGET%\dropbox\SYSTEM_RECOVERY_LOG.txt
#adb shell dumpsys dropbox APANIC_CONSOLE --print > %PATH_TARGET%\dropbox\APANIC_CONSOLE.txt
#adb shell dumpsys dropbox APANIC_THREADS --print > %PATH_TARGET%\dropbox\APANIC_THREADS.txt
#adb shell dumpsys dropbox system_app_strictmode --print > %PATH_TARGET%\dropbox\strictmode.txt
#adb shell dumpsys dropbox data_app_strictmode --print >> %PATH_TARGET%\dropbox\strictmode.txt

dumpsys dropbox SYSTEM_TOMBSTONE --print > $PATH_TARGET/dropbox/SYSTEM_TOMBSTONE.txt

dumpsys dropbox system_server_anr --print > $PATH_TARGET/dropbox/ANR.txt
dumpsys dropbox system_app_anr --print >> $PATH_TARGET/dropbox/ANR.txt
dumpsys dropbox data_app_anr --print >> $PATH_TARGET/dropbox/ANR.txt

dumpsys dropbox system_server_crash --print > $PATH_TARGET/dropbox/CRASH.txt
dumpsys dropbox system_app_crash --print >>  $PATH_TARGET/dropbox/CRASH.txt
dumpsys dropbox data_app_crash --print >> $PATH_TARGET/dropbox/CRASH.txt

#adb shell dumpsys dropbox system_server_wtf --print > %PATH_TARGET%\dropbox\WTF.txt
#adb shell dumpsys dropbox system_app_wtf --print >> %PATH_TARGET%\dropbox\WTF.txt
#adb shell dumpsys dropbox data_app_wtf --print >> %PATH_TARGET%\dropbox\WTF.txt
#adb shell dumpsys dropbox BATTERY_DISCHARGE_INFO --print > %PATH_TARGET%\dropbox\BATTERY_DISCHARGE_INFO.txt

dumpsys dropbox --file > $PATH_TARGET/dropbox/dropbox_files.txt

# Hprof_dump => ex : JNI 2000 overflow
echo "> Retrieving hprof_dump (/data/hprof_dump)..."
cp /data/hprof_dump_1701.hprof $PATH_TARGET
cp /data/hprof_dump_1801.hprof $PATH_TARGET
cp /data/hprof_dump_1901.hprof $PATH_TARGET
cp /data/hprof_dump_final.hprof $PATH_TARGET

# Smart Log
cp -r $WRITE_PATH/log $PATH_TARGET/smartlog

# dump file (Vol up + down + power key Long Click)
echo "> Retrieving dump files(/data/dump, /sdcard/dumpreports)..."
cp -r /data/dump $PATH_TARGET/dump

# running digicl.sh for FUT
if [ $COPYLEVEL == 9 ]; then
    # Dontpanic
    echo "> Retrieving Dontpanic Logs(/data/dontpanic)..."
    mkdir $PATH_TARGET/dontpanic
    for FILENAME in `ls /data/dontpanic`
    do
    if [[ $FILENAME == blue_coredump* ]]; then
        echo "skip $FILENAME"
    elif [[ $FILENAME == maps* ]]; then
        echo "skip $FILENAME"
    else
            cp -v /data/dontpanic/$FILENAME $PATH_TARGET/dontpanic/
        fi
    done

    # CKErrorReport
    echo "> Retrieving and Clearing ckerror Log(/data/system/ckerror)..."
    cp -r /data/system/ckerror $PATH_TARGET/ckerror
    rm -rf /data/system/ckerror/*

    # dumpreports
    mv $WRITE_PATH/dumpreports $PATH_TARGET/dumpreports
else
    # dontpanic
    cp -r /data/dontpanic $PATH_TARGET/dontpanic

    # CKErrorReport
    echo "> Retrieving ckerror Log(/data/system/ckerror)..."
    cp -r /data/system/ckerror $PATH_TARGET/ckerror

    # dumpreports
    cp -r $WRITE_PATH/dumpreports $PATH_TARGET/dumpreports
fi

# extra logs
if [ $COPYLEVEL == 1 ]; then
    # Modem Log
    echo "> Retrieving modem event logs(/sdcard/moca_logs)..."
    cp -r $WRITE_PATH/moca_logs $PATH_TARGET/moca_logs

    # Logs for MTK Chipset models
    echo "> Retrieving MTK logs(/sdcard/mtklog, /data/aee_exp)..."
    cp -r /data/aee_exp $PATH_TARGET/aee_exp
    cp -r $WRITE_PATH/mtklog $PATH_TARGET/mtklog
fi

# broadcast finished intent
echo am broadcast -a com.lge.android.digicl.intent.COPYLOGS_COMPLETED --es path $PATH_SEND
am broadcast -a com.lge.android.digicl.intent.COPYLOGS_COMPLETED --es path $PATH_SEND

echo "------------------------------------------------------------"
echo ">> All Logs are saved into Dir : $PATH_TARGET"
echo ">> Pull logging completed sucessfully!!!"
echo "------------------------------------------------------------"

