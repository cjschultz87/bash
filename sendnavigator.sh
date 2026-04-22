read -p "target: " tango;

sierra="$(($RANDOM%256 * 256**3 + $RANDOM%256 * 256**2 + $RANDOM%256 * 256**1 + $RANDOM%256))";

sudo python3 ./python/foxcom1.1.py p 59000 80 type tcp 00000010 1024 sa $sierra 0 10.0.2.7 $tango enp0s3;

alpha=($(sudo tshark -c 1 -i enp0s3 -Y "ip.src == $tango" -T fields -e tcp.seq_raw -e tcp.ack_raw -E separator=" " 2>/dev/null));

echo ${alpha[*]};

sudo python3 ./python/foxcom1.1.py p 59000 80 type tcp 00010000 1024 sa ${alpha[1]} $((${alpha[0]} + 1)) 10.0.2.7 $tango enp0s3;

fAlpha=($(cat bytes.navigator.txt));

fL=${#fAlpha[*]};

sudo python3 ./python/foxcom1.1.py f bytes.navigator.txt p 59000 80 type tcp 00010000 64240 sa ${alpha[1]} $((${alpha[0]} + 1)) 10.0.2.7 $tango enp0s3;

alpha=($(sudo tshark -c 1 -i enp0s3 -Y "ip.src == $tango and http" -T fields -e tcp.seq_raw -e tcp.ack_raw -e tcp.len -E separator=" " 2>/dev/null));

echo ${alpha[*]};

sudo python3 ./python/foxcom1.1.py p 59000 80 type tcp 00000100 1024 sa ${alpha[1]} $((${alpha[0]} + ${alpha[2]})) 10.0.2.7 $tango enp0s3;
