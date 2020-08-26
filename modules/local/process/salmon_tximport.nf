// Import generic module functions
include { saveFiles; getSoftwareName } from './functions'

process SALMON_TXIMPORT {
    tag "$meta.id"
    label "process_medium"
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:options, publish_dir:getSoftwareName(task.process), publish_id:meta.id) }

    conda (params.conda ? "${baseDir}/environment.yml" : null)

    input:
    tuple val(meta), path("salmon/*")
    path tx2gene
    val options

    output:
    tuple val(meta), path("*gene_tpm.csv"), emit: gene_tpm
    tuple val(meta), path("*gene_counts.csv"), emit: gene_counts
    tuple val(meta), path("*transcript_tpm.csv"), emit: transcript_tpm
    tuple val(meta), path("*transcript_counts.csv"), emit: transcript_counts

    script:
    """
    tximport.r NULL salmon $meta.id
    """
}
