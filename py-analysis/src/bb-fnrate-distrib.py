import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import seaborn as sns

input_dir = '/Users/ali_nayeem/PycharmProjects/pasta-extension/scripts/output/4obj-3iter'
tool_dir = '/Users/ali_nayeem/PycharmProjects/pasta-extension/scripts/output/5obj-3iter'
out_dir = '/Users/ali_nayeem/PycharmProjects/pasta-extension/latex/figure/4-obj'
Data = ['BB11005', 'BB11018', 'BB11033', 'BB11020',
        'BB12001', 'BB12013', 'BB12022', 'BB12035', 'BB12044',
        'BB20001', 'BB20010', 'BB20022', 'BB20033', 'BB20041',
        'BB30002', 'BB30008', 'BB30015', 'BB30022',
        'BB40001', 'BB40013', 'BB40025', 'BB40038', 'BB40048',
        'BB50001', 'BB50005', 'BB50010', 'BB50016']
ext_list = ['EP', 'EP-M', 'EP-EM', 'EM']
ext_dir_dic = {'EP': 'decom-output', 'EP-M': 'decom-muscle-output', 'EP-EM': 'decom-muscle-ext-output', 'EM': 'muscle-ext-output'}
marker_dic = {'EP': 's', 'EP-M': 'o', 'EP-EM': '^', 'EM': '*'}
colors = ['b', 'g', 'k', 'olive', 'k', 'm', 'pink', 'violet', 'grey', 'gold', 'green', 'red', 'cyan', 'blue']
sns.set(style="whitegrid")
sns.set_context("talk")

# Global data for PASTA
df_base = pd.read_csv(tool_dir + '/' + 'base-output' + '/' + 'treePerf.txt', sep=', ', index_col='Dataset')
df_base_muscle = pd.read_csv(tool_dir + '/' + 'base-muscle-output' + '/' + 'treePerf.txt', sep=', ',
                             index_col='Dataset')
df_muscle = pd.read_csv(tool_dir + '/' + 'muscle-output' + '/' + 'treePerf.txt', sep=', ',
                             index_col='Dataset')

for data in Data:
    # print(df_base.loc[data, 'FN'])

    for ext_i in range(len(ext_list)):
        df = pd.read_csv(input_dir + '/' + ext_dir_dic[ext_list[ext_i]] + '/' + data + '-treePerf.txt', sep=', ',
                         index_col=False, usecols=['FN'])
        df = df.sort_values(by='FN')
        df = df.reset_index(drop=True)
        plt.scatter(df.index, df['FN'], label=ext_list[ext_i], alpha=0.8, facecolors='none', edgecolors=colors[ext_i],
                    marker=marker_dic[ext_list[ext_i]], linewidth=1)

    plt.axhline(y=df_base.loc[data, 'FN'], label='PASTA', linestyle='-.', linewidth=2, color='red')  # alpha=0.5
    plt.axhline(y=df_base_muscle.loc[data, 'FN'], label='PASTA-M', linestyle='-.', linewidth=2,
                color='pink')  # ,  alpha=0.5
    plt.axhline(y=df_muscle.loc[data, 'FN'], label='MUSCLE', linestyle='-.', linewidth=2,
                color='violet')  # ,  alpha=0.5

    plt.xlabel('100 solutions (sorted w.r.t. FN Rate)')
    plt.ylabel('FN Rate')
    plt.suptitle(data)
    # leg = plt.legend(loc=3, bbox_to_anchor=(-0.22, 1.02, 1.24, .402),ncol=4, mode="expand", prop={'size': 13}, title="Legend", fancybox=True)
    # plt.legend(loc='best', ncol=2) #fontsize=12
    plt.legend(loc='upper center', bbox_to_anchor=(0.40, 1.08),
               ncol=7, fancybox=True, prop={'size': 8})
    # plt.show()
    # break
    plt.savefig( out_dir + '/' + data+'_fnrate_density.pdf', format='pdf', bbox_inches='tight')
    plt.clf()
