#this script reads file containing list of motif names and print put several files each containg motifs for one group in MEME format.

import argparse,math
#ParseMEME parse the combined motif file into a dictionary, key is the name of motif, and value is a string containg all the content for this motif.
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
#check_threshold return true when E-value is less than threshold
def check_threshold(motif,threshold):
	lines = motif.split('\n')
	second = lines[1].strip()
	E_value = second.split('E=')[1].strip()
	E_value = float(E_value)
	if math.log(E_value/threshold) <=0:
		return True

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('-i','--motif_MEME',required=True)
	parser.add_argument('-e','--motif_name')
	parser.add_argument('-t','--motif_threshold')
	args = parser.parse_args()

	motif_list = ParseMEME(args.motif_MEME)
	if args.motif_name:#extract motifs according to motif names in motif_name file
		with open(args.motif_name,'r') as fileName:
			i = 0
			for line in fileName:
				line="".join(line.split())
				line = line.replace("'","")
				i += 1
				output = 'Group'+str(i)
				tmp = line.strip()
				tab = tmp[1:-1].split(',')#the list of motif names for each group
				with open(output,'w') as ofile:
					ofile.write('MEME version 4\n'+"ALPHABET= ACGT\n\n")
					for each in tab:# the motif name in each group
						content = motif_list[each]
						ofile.write(content)
	else:#extract motifs according to threshold
		if args.motif_threshold:
			threshold = float(args.motif_threshold)
			out = args.motif_MEME+'.threshold'
			with open(out,'w') as ofile:
				ofile.write('MEME version 4\n'+'ALPHABET= ACGT\n\n')
				for each in motif_list.keys():
					content = motif_list[each]
					if check_threshold(content,threshold):
						ofile.write(content)


			
		
	

