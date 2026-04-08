addr=($(echo "$(sudo ip addr show enp0s3 | grep inet)"));

addr=${addr[1]};

slash="/";

slash_n=${addr%%$slash*};

mask=${addr:$((${#slash_n} + 1)):${#addr}};

addr=${addr:0:${#slash_n}};

echo "ipv4 addr = $addr";

echo "subnet mask = $mask";

addr_alpha=();

dot=".";

i_0=0;
i_1=0;

aL=${#addr};

while [ $i_0 -lt $aL ];
do
addr_prime=${addr:$i_0:$aL}; 
dot_n=${addr_prime%%$dot*};
i_1=${#dot_n};
addr_alpha+=(${addr:$i_0:$i_1});
i_0=$(($i_0 + $i_1 + 1));
done;

#echo ${addr_alpha[*]};


index=0;
mask_prime="";
while [ $index -lt 32 ];
do
if [ $index -lt $mask ];
then
mask_prime+="1";
else
mask_prime+="0";
fi
index=$(($index+1))
done;

minimums=()

index=0;

while [ $index -lt 4 ];
do
mask=${mask_prime:$((8 * $index)):8};
min=$((2#$mask));
if [ $min -lt 255 ];
then
min=$((($min + 1) % 255));
fi;
max=255;
minimums+=($min);
index=$(($index + 1));
done

indexes=(0 1 2 3);
indexes_prime=(1 2 3 4);

iL=0;

aap=();

index_prime=0;

while [ $index_prime -lt 4 ]
do

if [ ${minimums[$index_prime]} -lt $max ];
then
aap+=(${minimums[$index_prime]});
iL=$(($iL + 1));
else
aap+=(${addr_alpha[$index_prime]});
fi;

index_prime=$(($index_prime + 1));
done;

iL=${indexes_prime[$iL - 1]};

index=3;

while [ $((3 - $index)) -lt $iL ];
do

while [ ${aap[$index]} -lt $(($max - 1)) ];
do

aap[$index]=$((${aap[$index]} + 1));

if [ $index -lt 3 ];
then
index=$(($index + 1));
fi;

addr_p=$(echo "${aap[0]}.${aap[1]}.${aap[2]}.${aap[3]}");

if [ $addr != $addr_p ];
then

sudo ufw insert 1 allow out to $addr_p > /dev/null;

sudo ufw insert 1 allow in from $addr_p > /dev/null;

ping -4 -c 1 $addr_p;

index_ufw=0;

while [ $index_ufw -lt 2 ];
do

echo "y" | sudo ufw delete 1 > /dev/null;

index_ufw=$(($index_ufw + 1));

done;

fi;

done;

aap[$index]=${minimums[$index]};

index=$(($index - 1));
done;
