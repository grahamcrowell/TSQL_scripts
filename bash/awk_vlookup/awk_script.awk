# BEGIN { FS="|" } { for(i = 1; i <= NF; i++) { printf("%d  %s\n", i, $i) } }
FS="|" NR==FNR {m[$1]=$1; next} {$1=m[$1]; print}