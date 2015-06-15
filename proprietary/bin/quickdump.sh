#!/system/bin/sh
FFLAG=false

getopts f OPTION
case "$OPTION" in
f)
    FFLAG=true
    ;;
esac

# Check if QuickDump is enabled
PROP_QUICKDUMP=`getprop persist.service.qdump.enable`
if [  "1" -ne "$PROP_QUICKDUMP" ] && [ $FFLAG == false ]; then
    exit 0
fi

# Build emulated storage paths when appropriate
# See storage config details at http://source.android.com/tech/storage/
if [ -n "$EMULATED_STORAGE_SOURCE" ]; then
    WRITE_PATH="$EMULATED_STORAGE_SOURCE/0"
    READ_PATH="$EMULATED_STORAGE_TARGET/0"
else
    WRITE_PATH="$EXTERNAL_STORAGE"
    READ_PATH="$EXTERNAL_STORAGE"
fi

TIMESTAMP=`date +'%Y-%m-%d-%H-%M-%S'`

# path for dumpreports, quickdump
PATH_DUMPREPORTS=$WRITE_PATH/dumpreports
PATH_QUICKDUMP=$PATH_DUMPREPORTS/quickdump-$TIMESTAMP
READ_PATH_DUMPREPORTS=$READ_PATH/dumpreports
READ_PATH_QUICKDUMP_READ=$READ_PATH_DUMPREPORTS/quickdump-$TIMESTAMP

# output file names
DUMPREPORT=$PATH_QUICKDUMP/dumpreport-$TIMESTAMP
SCREENSHOT=$PATH_QUICKDUMP/screenshot-$TIMESTAMP.png

echo PATH_QUICKDUMP = $PATH_QUICKDUMP

# create directories if needed
if [ ! -e "$PATH_QUICKDUMP" ]; then
    mkdir -p "$PATH_QUICKDUMP"
fi

# prevent media scanning
touch "$PATH_DUMPREPORTS/.nomedia"

# take screen shot
# we run this as a bg job in case screencap is stuck
/system/bin/screencap -p $SCREENSHOT &

# run dumpstate
/system/bin/dumpstate -o $DUMPREPORT

# broadcast finished intent
if [ \( -e "$DUMPREPORT.txt" \) -a \( -e "$SCREENSHOT" \) ]; then
    echo am broadcast -a com.lge.android.quickdump.intent.QUICKDUMP_COMPLETED --es path $READ_PATH_QUICKDUMP_READ --ez fflag $FFLAG
    am broadcast -a com.lge.android.quickdump.intent.QUICKDUMP_COMPLETED --es path $READ_PATH_QUICKDUMP_READ --ez fflag $FFLAG
else
    echo am broadcast -a com.lge.android.quickdump.intent.QUICKDUMP_FAILED --ez fflag $FFLAG
    am broadcast -a com.lge.android.quickdump.intent.QUICKDUMP_FAILED --ez fflag $FFLAG
fi

