#!/bin/bash
cd "$(dirname "$0")"
out_dir="5obj-15iter/decom-muscle-output"
pasta_python="../venv/bin/python"
pasta_run="/Users/ali_nayeem/PycharmProjects/pasta-extension/pasta/run_pasta.py"
python2="/Users/ali_nayeem/PycharmProjects/sate-extension/venv/bin/python"
getFpFn="/Users/ali_nayeem/Projects/PyTreePerf/getFpFn.py"
INPUT=weights5D.csv

datasetList=$*
# "BB11005 BB11018 BB11033 BB11020
#         BB12001 BB12013 BB12022 BB12035 BB12044
#         BB20001 BB20010 BB20022 BB20033 BB20041
#         BB30002 BB30008 BB30015 BB30022
#         BB40001 BB40013 BB40025 BB40038 BB40048
#         BB50001 BB50005 BB50010 BB50016"
#for each data

for dataset in $datasetList
do
  #mkdir $dataset
  resultFile="$out_dir/$dataset-treePerf.txt"
  echo "Weight, FP, FN, RF" > $resultFile
  #adjust true tree
  initTrueTreeFile=`find /Users/ali_nayeem/Projects/MSA/example/aligned/  -name "$dataset".msf_tfa_tt1 -type f`
  ./get_taxa.pl -i $initTrueTreeFile -o taxa-$dataset
  ./map_taxa_names_reverse.pl -i $initTrueTreeFile -m taxa-$dataset -o tTree-$dataset
  i=0
  OLDIFS=$IFS
  IFS=','
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  #for each weight
  while read w1 w2 w3 w4 w5
  do
      score_line=$(printf "%.2f|%.2f|%.2f|%.2f|%.2f," $w1 $w2 $w3 $w4 $w5)
      #score_line="$w1:$w2:$w3:$w4:$w5,"
      echo "$dataset: Running for $i-th weight=$score_line"
      #generate alignment and tree
      input_seq=$(find /Users/ali_nayeem/Projects/MSA/example/bb3_release/ -name $dataset.tfa)
      $pasta_python $pasta_run -i $input_seq -d protein -o $out_dir/$dataset -j $i --aligner=muscle --simg=$w1 --simng=$w2 --osp=$w3 --gap=$w4 --ml=$w5 --iter-limit=15
      sed -i ''  s/\'//g "$out_dir/$dataset/$i".tre
      ./map_taxa_names_reverse.pl -i "$out_dir/$dataset/$i".tre -m taxa-$dataset -o eTree-$dataset
      score_line="$score_line $($python2 $getFpFn -e eTree-$dataset -t tTree-$dataset)"
      echo "$score_line" >> $resultFile
      echo "$score_line"
      i=$[i+1]
      #exit
  done < $INPUT
  IFS=$OLDIFS
done
