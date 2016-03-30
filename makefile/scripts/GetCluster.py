#this is a python script to extract motif clusters 

import networkx as nx
import matplotlib.pyplot as plt
import argparse

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('-i','--edgelist',required=True)
	parser.add_argument('-e','--cluster_set',required=True)
	parser.add_argument('-t','--threshold',default= 9)
	args = parser.parse_args()

	G=nx.read_edglist(args.edgelist,nodetype=str)
	for node in G.nodes():
		if (node,node) in G.edges():
			G.remove_edge(node,node)
	
	graphs = list(nx.connected_component_subgraphs(G))
	cluster = []
	for each in graphs:
		if len(each)>= args.threshold:
			cluster.append(each)
	
	output = nx.Graph()
	for each in cluster:
		output = nx.union(output,each)
	nx.draw(output)
	plt.savefig('../results/output.png')
	with open(args.cluster_set,'w') as fout:
		for each in cluster:
			fout.write(each)
	
