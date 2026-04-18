echo "randomizing common ports.";

romeo=$(./romeoarray 1 1023 " ");

alpha=($romeo);

aL=${#alpha[*]};

read -p "target ip: " tango;

index=0;

while [ $index -lt $aL ];
do

sudo ufw insert 1 allow out to $tango port ${alpha[$index]} &>/dev/null;

sudo ufw insert 1 allow in from $tango port ${alpha[$index]} &>/dev/null;

echo "$index/$aL: $tango port ${alpha[$index]}";

sudo nmap -sS -Pn -p ${alpha[$index]} --mtu 504 -e enp0s3 -g 80 --reason --open --disable-arp-ping -v $tango | grep open >> novemberscan.txt;

tail -n 1 novemberscan.txt;

sleep "$(($RANDOM % 15))s";

index_ufw=0;

while [ $index_ufw -lt 2 ];
do

echo "y" | sudo ufw delete 1 &>/dev/null;

((index_ufw++));

done;

((index++));

done;
