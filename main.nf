process SAMTOOLS_TOBAM {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/bwbioinfo/samtools:latest'

    tag "$meta"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    publishDir "output", mode: 'copy'

    input:
    tuple val(meta), path(in_sam)

    output:
    tuple val(meta), path("*.bam"), emit: bamfile
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '-b'
    def prefix = task.ext.prefix ?: "${meta}"
    def threads = task.cpus
    """
    samtools \\
        view \\
        -@ ${threads} \\
        ${args} \\
        ${in_sam} > ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_SORT {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/bwbioinfo/samtools:latest'

    tag "$meta"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    publishDir "output", mode: 'copy'

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path("*.sorted.bam"), emit: sortedbam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    def threads = task.cpus
    """
    samtools \\
        sort \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam} \\
        -o ${prefix}.sorted.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}


process SAMTOOLS_INDEX {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/bwbioinfo/samtools:latest'

    tag "$meta"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    publishDir "output", mode: 'copy'

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path(in_bam),path("*.bai"), emit: bamfile_index
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    def threads = task.cpus
    """
    samtools \\
        index \\
        -@ ${threads} \\
        ${args} \\
        ${in_bam} 

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}

process SAMTOOLS_MERGE {
    // TODO : SET FIXED VERSION WHEN PIPELINE IS STABLE
    container 'ghcr.io/bwbioinfo/samtools:latest'

    tag "$meta"
    label 'process_cpu_med'
    label 'process_memory_med'
    label 'process_time_med'
    errorStrategy { task.attempt <= 3 ? 'retry' : 'terminate' }

    publishDir "output", mode: 'copy'

    input:
    tuple val(meta), path(in_bam)

    output:
    tuple val(meta), path("*.bam"), emit: mergedBam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // def prefix = task.ext.prefix ?: "${meta}"
    def threads = task.cpus
    """
    samtools \\
        merge \\
        -@ ${threads} \\
        ${args} \\
        ${meta}_merged.bam \\
        $in_bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')    END_VERSIONS
    """
}