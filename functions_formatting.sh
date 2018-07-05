sector_size=$(gdisk -l $DEV | grep -P "Logical sector size: \d+ bytes" | cut -d' ' -f4)
partnumber=1

function assert_free_space_more_than() {
    size=$1
    # get free space on device
    sectors=$(gdisk -l $DEV | grep -P "Total free space is \d+ sectors" | cut -d' ' -f5)
    free=$(bc <<< "$sector_size * $sectors / 1024^2")
    
    # check if enough free space on device
    if [[ $free -lt $size ]]; then
	echo "cannot create partition $partnumber with size $size" >&2
	echo "E: not enough space on device" >&2
	exit 4
    fi

}

function create_partition() {
    device=$1
    size=$2
    label=$3

    assert_free_space_more_than $size
    echo -e "creating partition $partnumber: \t ${SIZE}M \t for $label"
    # create new GPT and first partition
    gdisk $device > /dev/null <<EOF
n
$partnumber

+${size}M
8300

w
y
EOF
    partnumber=$(($partnumber + 1))
}

function abort() {
    echo $1 >&2
    exit $2
}
