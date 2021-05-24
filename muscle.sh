#!/bin/bash
cd "$(dirname "$0")"
out_dir="output/muscle-sp-output"
muscle="/Users/ali_nayeem/PycharmProjects/pasta-extension/pasta/bin/muscle"
fasttree="/Users/ali_nayeem/NetBeansProjects/FastTree-old/FastTreeMP"
python2="/Users/ali_nayeem/PycharmProjects/sate-extension/venv/bin/python"
getFpFn="/Users/ali_nayeem/Projects/PyTreePerf/getFpFn.py"
resultFile="$out_dir/treePerf.txt"
datasetList="BB11005 BB11018 BB11033 BB11020
        BB12001 BB12013 BB12022 BB12035 BB12044
        BB20001 BB20010 BB20022 BB20033 BB20041
        BB30002 BB30008 BB30015 BB30022
        BB40001 BB40013 BB40025 BB40038 BB40048
        BB50001 BB50005 BB50010 BB50016"
#for each data
echo "Dataset, FP, FN, RF" > $resultFile
for dataset in $datasetList
do
  echo "Running MUSCLE for $dataset"
  score_line="$dataset,"
  #generate alignment and tree
  input_seq=$(find /Users/ali_nayeem/Projects/MSA/example/bb3_release/ -name $dataset.tfa)
  $muscle -objscore sp -in $input_seq -out  "$out_dir/$dataset".aln
  $fasttree -wag -gamma -fastest -quiet "$out_dir/$dataset".aln > "$out_dir/$dataset".tre
  #adjust true tree
  initTrueTreeFile=`find /Users/ali_nayeem/Projects/MSA/example/aligned/  -name "$dataset".msf_tfa_tt1 -type f`
	./get_taxa.pl -i $initTrueTreeFile -o taxa-muscle
	./map_taxa_names_reverse.pl -i $initTrueTreeFile -m taxa-muscle -o tTree-muscle
  ./map_taxa_names_reverse.pl -i $out_dir/"$dataset".tre -m taxa-muscle -o eTree-muscle
  score_line="$score_line $($python2 $getFpFn -e eTree-muscle -t tTree-muscle)"
  echo "$score_line" >> $resultFile
  echo "$score_line"
  #exit
done
