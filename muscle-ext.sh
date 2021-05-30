#!/bin/bash
cd "$(dirname "$0")"
source path-config.sh

out_dir="output/muscle-ext-output"
#muscle="/Users/ali_nayeem/NetBeansProjects/muscle_extesion/muscle"
#fasttree="/Users/ali_nayeem/NetBeansProjects/FastTree-old/FastTreeMP"
#python2="/Users/ali_nayeem/PycharmProjects/sate-extension/venv/bin/python"
#getFpFn="/Users/ali_nayeem/Projects/PyTreePerf/getFpFn.py"

INPUT=weights4D.csv
export OMP_NUM_THREADS=4
# $fasttree -help
# exit
datasetList=$*
# "BB11005 BB11018 BB11033 BB11020
#         BB12001 BB12013 BB12022 BB12035 BB12044
#         BB20001 BB20010 BB20022 BB20033 BB20041
#         BB30002 BB30008 BB30015 BB30022
#         BB40001 BB40013 BB40025 BB40038 BB40048
#         BB50001 BB50005 BB50010 BB50016"
#for each data
mkdir -pv $out_dir
for dataset in $datasetList
do
  mkdir -pv $out_dir/$dataset
  resultFile="$out_dir/$dataset-treePerf.txt"
  echo "Weight, FP, FN, RF" > $resultFile
  #adjust true tree
  initTrueTreeFile=`find "$bb_path"/aligned/  -name "$dataset".msf_tfa_tt1 -type f`
  ./get_taxa.pl -i $initTrueTreeFile -o taxa-$dataset
  ./map_taxa_names_reverse.pl -i $initTrueTreeFile -m taxa-$dataset -o tTree-$dataset
  i=0
  OLDIFS=$IFS
  IFS=','
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  #for each weight
  while read w1 w2 w3 w4
  do
      score_line=$(printf "%.2f|%.2f|%.2f|%.2f," $w1 $w2 $w3 $w4)
      #score_line="$w1:$w2:$w3:$w4:$w5,"
      echo "$dataset: Running for $i-th weight=$score_line"
      #generate alignment and tree
      input_seq=$(find "$bb_path"/bb3_release/ -name $dataset.tfa)
      $muscle_ext -simg $w1 -simng $w2 -osp $w3 -gap $w4 -objscore sp -in $input_seq -out  "$out_dir/$dataset/$i".aln
      $fasttree -wag -gamma -fastest -quiet "$out_dir/$dataset/$i".aln > "$out_dir/$dataset/$i".tre
      ./map_taxa_names_reverse.pl -i "$out_dir/$dataset/$i".tre -m taxa-$dataset -o eTree-$dataset
      score_line="$score_line $($python2 $getFpFn -e eTree-$dataset -t tTree-$dataset)"
      echo "$score_line" >> $resultFile
      echo "$score_line"
      i=$[i+1]
      #exit
  done < $INPUT
  IFS=$OLDIFS
done
