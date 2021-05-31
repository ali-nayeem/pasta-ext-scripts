import sys

InputFileName = "/Users/ali_nayeem/Projects/MSA/example/bb3_release/RV11/BB11005.tfa"#sys.argv[1]
AlnFileName = "/Users/ali_nayeem/PycharmProjects/pasta-extension/scripts/output/5obj-3iter/base-output/BB11005.marker001.BB11005.tfa.aln"#sys.argv[2]

def Die(s):
    print >> sys.stderr
    print >> sys.stderr, sys.argv
    print >> sys.stderr, "**ERROR**", s
    sys.exit(1)

def ReadSeqs(FileName):
    Seqs = {}
    Id = ""
    File = open(FileName)
    while 1:
        Line = File.readline()
        if len(Line) == 0:
            return Seqs
        if len(Line) == 0:
            continue
        if Line[0] == ">":
            Id = Line[1:][:-1]
            Seqs[Id] = ""
        else:
            if Id == "":
                Die("FASTA file '%s' does not start with '>'" % FileName)
            Seqs[Id] = Seqs[Id] + Line[:-1]

def ReadSeqs2(FileName):
    Seqs = []
    Labels = []
    File = open(FileName)
    while 1:
        Line = File.readline()
        if len(Line) == 0:
            return Labels, Seqs
        Line = Line.strip()
        if len(Line) == 0:
            continue
        if Line[0] == ">":
            Id = Line[1:]
            Labels.append(Id)
            Seqs.append("")
        else:
            i = len(Seqs)-1
            Seqs[i] = Seqs[i] + Line

# InLabels, InSeqs = ReadSeqs2(InputFileName)
# AlnSeqs = ReadSeqs(AlnFileName)
#
# for Label in InLabels:
#     if Label not in AlnSeqs.keys():
#         Die("Not found in alignment: " + Label)
#     print(">" + Label)
#     print(AlnSeqs[Label])
