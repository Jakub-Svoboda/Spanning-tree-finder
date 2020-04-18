RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

make 

for entry in tests/in/*
do
    #inp=`cat $entry`
    #echo ./dka-2-mka.exe -t $entry
    out=`./flp20-log < $entry`
    f=$(basename $entry)
    correct=`echo tests/out/$f`
    correctOut=`cat $correct`
    dif=`diff <(echo "$out") <(echo "$correctOut")`
    #dif=`diff <(sort < echo $out)) <(sort < echo $correctOut))`
    #sort | echo $out
    printf "Testing %s: " $entry 
    if [ "$dif" == "" ]; then
        printf  "${GREEN}""PASS""${NOCOLOR}"
    else
        echo -e "${RED}""FAIL""${NOCOLOR}"
    fi
    printf "%s\n" $dif
done