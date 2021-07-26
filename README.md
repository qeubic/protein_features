# protein_features_datasets
The code automates the construction of visualization-ready datasets from the features report of the NCBI Web Batch Conserved Domain Search [CD-Search] (https://www.ncbi.nlm.nih.gov/Structure/bwrpsb/bwrpsb.cgi?).

The focus of the code is on the construction of datasets for visual analytics of the protein features fields in the output file from the CD-Search for a collection of fasta formatted protein sequence obtained from the Integrated Microbial Genomes & Microbiomes (IMG/M https://img.jgi.doe.gov/cgi-bin/mer/main.cgi).

The input file can be obtained from the IMG/M including (1) searching for protein sequences with specific annotations (e.g. Pfam and COG functions); and (2) protein sequences predicted from the protein-coding. 


An example of line in the output file of the CD-Search tool is provided below. 

Query	Type	Title	coordinates	complete size	mapped size	source domain
Q#1 - >2503788320 DND132_3470 thyX thymidylate synthase (FAD) [Desulfovibrio desulfuricans ND132 (Final JGI assembly) : Ddes_Contig54]	specific	FAD binding site	S65,E68,R89,H90,R91,S96,Q97,S99,N174,R176,H180,L184,R185,R189	14	14	412038
