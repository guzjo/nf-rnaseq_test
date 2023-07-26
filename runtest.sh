nextflow run star-fc.nf \
    --fastq_dir 'fq_test/GSE220803_pe' \
    --star_index_dir '/home/epigenjg/Share/gencode_star_index_hg38' \
    --gtf_dir '/home/epigenjg/Share/gencode_refanno/hg38' \
    --output_dir 'results'
