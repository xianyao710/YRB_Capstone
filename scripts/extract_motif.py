#this script reads file containing list of motif names and print put several files each containg motifs for one group in MEME format.

import argparse

def ParseMEME(filePath):
	'''Get the motif file in MEME formatted'''
	with open(filePath,'r') as fileMEME:
		content = fileMEME.read()
	motif_list = {}
	tabs = content.split('MOTIF')
	for i in range(1,len(tabs)):
		current = tabs[i]
		title = 'MOTIF'+ current.split('\n')[0]
		name = title.split(' ')[1]
		tmp = current.split('\n')[0]+'\n'
		motif = current.replace(tmp,'')
		motif_list[name] = title + '\n' + motif
	return motif_list

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('-i','--motif_MEME',required=True)
	parser.add_argument('-n','--motif_name',required=True)
	args = parser.parse_args()

	motif_list = ParseMEME(args.motif_MEME)

	with open(args.motif_name,'r') as fileName:
		i = 0
		for line in fileName:
			line="".join(line.split())
			line = line.replace("'","")
			i += 1
			output = 'Group'+str(i)
			tmp = line.strip()
			tab = tmp[1:-1].split(',')
			with open(output,'w') as ofile:
				ofile.write('MEME version4\n'+"ALPHABET= ACGT\n\n")
				for each in tab:
					ofile.write(motif_list[each])



