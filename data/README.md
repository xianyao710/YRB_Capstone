`Train_motifs_all.txt` is the raw Homer output for our 10 training groups
`Train_motifs_combined.meme` is the MEME format of raw Homer output done by Taylor's R script
`Train_motifs_comined.mem.threshold` is the file extracting motifs with E-value less or equal than 1e-30 from `Train_motifs_combined.meme` using xianyao's `extract_motif.py` script
`tomtom.txt` is the tomtom result by comparing `Train_motifs_combined.meme` against itself done by Taylor, xianyao doesn't know what parameter Taylor used for this output.
`tomtom_Evalue_30` is the folder xianyao created that contains tomtom result of comparing `Train_motifs_combined.meme.threshold` against itself without parameter in tomtom.
`tomtom_no_Evalue` is the folder xianyao created that contains tomtom result of comparing `Train_motifs_combined.meme` against itself without parameter in tomtom
