#this script aims to change motif name and correct motif length

import sys

#extract set name from input file name
fname = sys.argv[1]
tmp = fname.split('.')
tag = tmp[0]

#parse input meme file and correct title

'''Get the motif file in MEME formatted'''
with open(fname,'r') as fileMEME:
    content = fileMEME.read()
    motif_list = {}
    tabs = content.split('MOTIF')
    index = 1
    for i in range(1,len(tabs)):
        name = ''
        current = tabs[i]
        name += "motif_"+tag+"_"+str(index) 
        title = 'MOTIF'+ current.split('\n')[0]
        #name = title.split(' ')[1]
        motif_string = title.split('-')[1].rstrip()
        motif_width = len(motif_string)
        tab = title.split(' ')
        title = tab[0]+' '+name+' '+str(motif_width)+'-'+motif_string
        tmp = current.split('\n')[0]+'\n'
        motif = current.replace(tmp,'')
        motif_list[name] = title + '\n' + motif
        index += 1						
	
with open(sys.argv[2],'w') as fileOut:
    for key in sorted(motif_list.keys()):
        fileOut.write(motif_list[key])
    
