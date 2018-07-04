sector_size=$(gdisk -l $DEV | grep -P "Logical sector size: \d+ bytes" | cut -d' ' -f4)
free_sectors=$(gdisk -l $DEV | grep -P "Total free space is \d+ sectors" | cut -d' ' -f5)
free_mb=$(bc <<< "$sector_size * $free_sectors / 1024^2")

function create_partition() {
    device=$1
    free=$2
    size=$3
    partnum=$4
    label=$5

    # check if enough free space on device
    if [[ $free -lt $size ]]; then
	echo "cannot create partition $partnum with size $size" >&2
	echo "E: not enough space on device" >&2
	exit 4
    fi

    echo -e "creating partition $partnumber: \t ${SIZE}M \t for $label"
    # create new GPT and first partition
    gdisk $device > /dev/null <<EOF
n
$partnum

+${size}M
8300

w
y
EOF
}
