#this is a python script to extract motif clusters 
#!/usr/bin/env python
import networkx as nx
import argparse

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('-i','--edgelist',required=True)
	parser.add_argument('-t','--threshold',default= 9)
	args = parser.parse_args()

	G=nx.read_edgelist(args.edgelist,nodetype=str)
	#remove the edge like (A,A),(B,B)
	for node in G.nodes():
		if (node,node) in G.edges():
			G.remove_edge(node,node)
	
	graphs = list(nx.connected_component_subgraphs(G))
	cluster = []
	for each in graphs:
		#exclude the possibility that a cluster only contains motifs in a single training set
		node_list=each.nodes()
		train_set=[]
		for tmp in node_list:
			group_number=tmp.split("_")[1]#e.g. motif_01_05 is the 5th motif in training set 1, so group_number should be "01"
			if group_number not in train_set:
				train_set.append(group_number)

		#extract connected components which contain at least 9 nodes from different training sets
		if len(train_set)>= int(args.threshold):
			cluster.append(each)
	print("There are %d clusters identified\n" %(len(cluster)))	
	output = nx.Graph()
	for each in cluster:
		output = nx.union(output,each)
	
	#output the files which contain nodes id in each extracted cluster
	nodes=[]
	for each in cluster:
		nodes.append(each.nodes())
	for i in range(len(nodes)):
		tmp="cluster"+str(i+1)+".txt"		#tmp is the cluster id
		with open(tmp,"w") as fp:
			fp.write(str(nodes[i]))
		fp.close()

		
