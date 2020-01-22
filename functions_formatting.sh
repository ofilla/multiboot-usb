sector_size="$(sgdisk -p $DEV | grep -P "Logical sector size: \d+ bytes" | cut -d' ' -f4)"
partnumber=1

function assert_free_space_more_than() {
	size="$1"
	# get free space on device
	sectors="$(sgdisk -p $DEV | grep -P "Total free space is \d+ sectors" | cut -d' ' -f5)"
	free="$(bc <<< "$sector_size * $sectors / 1024^2")"
	
	# check if enough free space on device
	if [[ $free -lt $size ]]; then
		echo "cannot create partition $partnumber with size $size" >&2
		echo "E: not enough space on device" >&2
		exit 4
	fi

}

function create_partition() {
	size=$2

	if [[ $size == "max" ]]; then
		create_last_partition $1 "$3"
	else
		create_partition_by_size $1 $2 "$3"
	fi
}

function create_last_partition() {
	device=$1
	label="$2"

	echo -e "creating partition $partnumber: \t full free space \t for $label"
	sgdisk $device -N $partnumber -c $partnumber:"$label" > /dev/null
	partnumber="$(($partnumber + 1))"
}

function create_partition_by_size() {
	device=$1
	size=$2
	label="$3"

	size=$(convert_partsize $size)
	assert_free_space_more_than $size
	echo -e "creating partition $partnumber: \t ${size}M \t for $label"

	sgdisk $device -n $partnumber::+${size}M -c $partnumber:"$label" > /dev/null
	partnumber="$(($partnumber + 1))"
}

function convert_partsize() {
	SIZE=$1
	if [[ "$SIZE" == *"G" ]]; then
		# GB
		SIZE="${SIZE/G/}"
		SIZE="$(( $SIZE * 1024 ))"
	elif [[ "$SIZE" == *"M" ]]; then
		# MB
		SIZE="${SIZE/M/}"
	elif [[ "$SIZE" != [0-9]* ]]; then
		echo "E: convert_partsize cannot understand partsize input: $SIZE" >&2
		exit 3
	fi
	echo $SIZE
}

function abort() {
	echo "$1" >&2
	exit "$2"
}
