#!/bin/bash
cd "$(dirname "$0")"
out_dir="5obj-15iter/base-output"
pasta_python="/home/user/anaconda3/envs/pasta-ext/bin/python"
pasta_run="../pasta-extension/run_pasta.py"
python2="/usr/bin/python2"
getFpFn="PyTreePerf/getFpFn.py"
resultFile="$out_dir/treePerf.txt"
datasetList="BB11005" # BB11018 BB11033 BB11020
        #BB12001 BB12013 BB12022 BB12035 BB12044
        #BB20001 BB20010 BB20022 BB20033 BB20041
        #BB30002 BB30008 BB30015 BB30022
        #BB40001 BB40013 BB40025 BB40038 BB40048
        #BB50001 BB50005 BB50010 BB50016"
#for each data
echo "Dataset, FP, FN, RF" > $resultFile
for dataset in $datasetList
do
  score_line="$dataset,"
  #generate alignment and tree
  input_seq=$(find /home/user/MyProjects/MSA/example/bb3_release/ -name $dataset.tfa)
  $pasta_python $pasta_run -i $input_seq -d protein -o $out_dir -j $dataset --iter-limit=4
  sed -i  s/\'//g $out_dir/"$dataset".tre
  #adjust true tree
  initTrueTreeFile=`find /home/user/MyProjects/MSA/example/aligned/  -name "$dataset".msf_tfa_tt1 -type f`
  ./get_taxa.pl -i $initTrueTreeFile -o taxa	
  ./map_taxa_names_reverse.pl -i $initTrueTreeFile -m taxa -o tTree
  ./map_taxa_names_reverse.pl -i $out_dir/"$dataset".tre -m taxa -o eTree
  score_line="$score_line $($python2 $getFpFn -e eTree -t tTree)"
  echo "$score_line" >> $resultFile
  echo "$score_line"
done


# i=0
# INPUT=weights.csv
# OLDIFS=$IFS
# IFS=','
# [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
# #for each weight
# while read w1 w2 w3 w4
# do
#     echo "Running for $i-th weight: $w1, $w2, $w3, $w4"
#     msa="$dataset/msa$i"
#     msa2="$dataset-$round/msa$i"
#     ./muscle -simg $w1 -simng $w2 -osp $w3 -gap $w4 -in $msa -out $msa2 -objscore sp  -refine #-quiet
#     i=$[i+1]
#     #exit
# done < $INPUT
# IFS=$OLDIFS
