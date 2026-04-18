echo "randomizing common ports.";

romeo=$(romeoarray 1 1023 " ");

alpha=($romeo);

aL=${#alpha[*]};

read -p "target ip: " tango;

index=0;

while [ $index -lt $aL ];
do

sudo ufw insert 1 allow out to $tango port ${alpha[$index]} &>/dev/null;

sudo ufw insert 1 allow in from $tango port ${alpha[$index]} &>/dev/null;

echo "$index/$aL: $tango port ${alpha[$index]}";

sierra="$(($RANDOM%256 * 256**3 + $RANDOM%256 * 256**2 + $RANDOM%256 * 256**1 + $RANDOM%256))";

ack="$(($RANDOM%256 * 256**3 + $RANDOM%256 * 256**2 + $RANDOM%256 * 256**1 + $RANDOM%256))";

sudo python3 ./python/foxcom1.1.py p 80 ${alpha[$index]} type tcp 00000010 172 sa $sierra $ack 10.0.2.7 10.0.2.8 enp0s3 &>/dev/null;

#sleep "$(($RANDOM % 15))s";

index_ufw=0;

while [ $index_ufw -lt 2 ];
do

echo "y" | sudo ufw delete 1 &>/dev/null;

((index_ufw++));

done;

((index++));

done;
