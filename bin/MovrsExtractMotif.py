#this script reads file containing list of motif names and print put several files each containg motifs for one group in MEME format.
#!/usr/bin/env python
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
	if E_value == 0:
		return True
	if math.log(E_value/threshold)<=0: 
		return True

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument('-i','--motif_MEME',required=True)
	parser.add_argument('-n','--motif_name')
	parser.add_argument('-t','--motif_threshold')
	parser.add_argument('-o','--out_file',required=True)
	args = parser.parse_args()

	motif_list = ParseMEME(args.motif_MEME)


	#extract motifs according to threshold
	if args.motif_threshold:
		threshold = float(args.motif_threshold)	
		for key in motif_list.keys():
			content = motif_list[key]
			if not check_threshold(content,threshold):
                                del motif_list[key]				


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
		with open(args.out_file,'w') as ofile:
			ofile.write("MEME version 4\n"+"ALPHABET= ACGT\n\n")
			for each in tab:
				content = motif_list[each]
				ofile.write(content)
	else:
		with open(args.out_file,'w') as ofile:
			ofile.write('MEME version 4\n'+"ALPHABET= ACGT\n\n")
			for each in motif_list.keys():# the motif name in each group
				content = motif_list[each]
				ofile.write(content)

			
		
	

