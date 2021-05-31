import numpy as np
from util.read_aln import ReadSeqs, ReadSeqs2, Die
import pickle
import glob
import sys

input_aln_path = '/Users/ali_nayeem/Projects/MSA/example/bb3_release'
output_aln_path = '../../output/5obj-3iter'
export_file_dir = '../out'
data_list = ['BB11005'] #, 'BB11018', 'BB11033', 'BB11020',
        # 'BB12001', 'BB12013', 'BB12022', 'BB12035', 'BB12044',
        # 'BB20001', 'BB20010', 'BB20022', 'BB20033', 'BB20041',
        # 'BB30002', 'BB30008', 'BB30015', 'BB30022',
        # 'BB40001', 'BB40013', 'BB40025', 'BB40038', 'BB40048',
        # 'BB50001', 'BB50005', 'BB50010', 'BB50016']

method_list = ['muscle-ext-output'] #, 'decom-muscle-ext-output', 'decom-muscle-output', 'decom-output']
no_of_aln = {'muscle-ext-output': 50, 'decom-muscle-ext-output':100, 'decom-muscle-output':100, 'decom-output':100}



aln_count = 0
for method in method_list:
    aln_count += no_of_aln[method]

for data in data_list:
    outfile = open(export_file_dir + '/' + data + '.pickle', 'wb')
    pickle.dump(aln_count, outfile)
    input_path = input_aln_path + '/RV' + data[2:4] + '/' + data + '.tfa'
    labels, seqs = ReadSeqs2(input_path)
    for method in method_list:
        for aln_i in range(no_of_aln[method]):
            path_pattern = output_aln_path + '/' + method + '/' + data + '/' + str(aln_i) + '*.aln'
            aln_path = glob.glob(path_pattern)[0]
            aln = ReadSeqs(aln_path)
            feature = []
            for Label in labels:
                if Label not in aln.keys():
                    Die("Not found in alignment: " + Label)
                #print(AlnSeqs[Label])
                #feature.extend([ord(c) for c in aln[Label]])
                feature.extend(list(bytes(aln[Label], 'ascii')))
            #print(feature[0:30])
            print(str(aln_i) + ': ' + str(len(feature)))
            pickle.dump(np.array(feature), outfile)
            #sys.exit(1)
    outfile.close()
