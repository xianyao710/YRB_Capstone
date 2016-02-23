#read the raw_adjlist file to convert to standard adjcent list format

with open("../results/raw_adjlist","r") as ifile:
	adj_set ={}
	for line in ifile:
		if line[0] != '#':
			tab = line.strip().split('\t')
			if tab[0] not in adj_set.keys():
				adj_set[tab[0]] = [tab[1]]
			else:
				adj_set[tab[0]].append(tab[1])

with open("../results/standard_adjlist","w") as ofile:
	for key in adj_set.keys():
		tmp = ''
		for each in adj_set[key]:
			tmp += each + "\t"
		ofile.write(key+"\t"+tmp+"\n")
