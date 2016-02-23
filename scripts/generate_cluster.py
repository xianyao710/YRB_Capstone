#this script takes input file in adjcent list format and output the connected component (clusters)
#====adjcent list foramt
#A B C
#B C				represents a triangle graph structure
#C
#take input file object and return a dictionary of motif clusters

import argparse
def merge(infile):
	cluster_set= {}#the dictionary containing motif clusters
	for line in infile:
		tab = line.strip().split(' ')
		seed = tab[0]#the motif id in first column
		tab.pop(0)
		cluster_set[seed] = tab
	for key1 in cluster_set.keys():
		for key2 in cluster_set.keys():
			if key1 != key2:
				setA = set(cluster_set[key1])
				setB = set(cluster_set[key2])
				if setA&setB != []:
					if setA&setB == setA:
						cluster_set.pop(key1,cluster_set[key1])
					elif setA&setB == setB:
						cluster_set.pop(key2,cluster_set[key2])
	print(cluster_set)
	return cluster_set

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('-i','--infile',required=True)
	parser.add_argument('-o','--outfile',required=True)
	args = parser.parse_args()

	with open(args.infile,'r') as ifile:
		cluster_set = merge(ifile)
	with open(args.outfile,'w') as ofile:
		for key in cluster_set.keys():
			tmp=''
			for each in cluster_set[each]:
				tmp += each + "\t"
			ofile.write(key+"\t"+tmp+"\n")

