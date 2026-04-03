$HOSTNAME = ""
params.outdir = 'results'  


if (!params.profile){params.profile = ""} 
if (!params.modified_mut){params.modified_mut = ""} 
if (!params.untreated_mut){params.untreated_mut = ""} 
// Stage empty file to be used as an optional input where required
ch_empty_file_1 = file("$baseDir/.emptyfiles/NO_FILE_1", hidden:true)

if (params.profile){
   Channel.fromPath(params.profile, type: 'any').map{ file -> tuple(file.baseName, file) }.set{g_2_0_g_1}
} else {
	g_2_0_g_1 = Channel.empty()
}
g_3_1_g_1 = file(params.modified_mut, type: 'any')
g_6_2_g_1 = params.untreated_mut && file(params.untreated_mut, type: 'any').exists() ? file(params.untreated_mut, type: 'any') : ch_empty_file_1


process DanceMaPper {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}\/.*$/) "DanceMaPper_Output/$filename"}
input:
 tuple val(name), file(profile)
 path modified_mut
 path untreated_mut

output:
 tuple val(name), file("${name}/*")  ,emit:g_1_directory00_g_11 

container "quay.io/ummsbiocore/dancemapper:1.0.1"

script:

println "name"
println name
println "profile"
println profile
println "modified"
println modified_mut
println "untreated"
println untreated_mut





untreated_parsed_var = untreated_mut.toString().startsWith("NO_FILE") ? "" : "--untreated_parsed ${untreated_mut}"

min_cov_ceck = params.DanceMaPper.min_cov_ceck
min_coverage = params.DanceMaPper.min_coverage
min_cov = (min_cov_ceck == "true") ? "--mincoverage ${min_coverage}" : ""

fit_check = params.DanceMaPper.fit_check
fit = (fit_check == "true") ? "--fit" : ""
pair_check = params.DanceMaPper.pair_check
pair = (pair_check == "true") ? "--pairmap" : ""
ring_check = params.DanceMaPper.ring_check
ring = (ring_check == "true") ? "--ring" : ""

minrxbg = params.DanceMaPper.minrxbg
chisq_cut = params.DanceMaPper.chisq_cut
undersample = params.DanceMaPper.undersample

ff_check = params.DanceMaPper.ff_check
forcefitN = params.DanceMaPper.forcefitN
ff = (ff_check == "true") ? "--forcefit ${forcefitN}" : ""

maskG_check = params.DanceMaPper.maskG_check
maskG = (maskG_check == "true") ? "--maskG" : ""
maskU_check = params.DanceMaPper.maskU_check
maskU = (maskU_check == "true") ? "--maskU" : ""
maskN_check = params.DanceMaPper.maskN_check
maskN = (maskN_check == "true") ? "--maskN" : ""

other_parameters = params.DanceMaPper.other_parameters

//* @style @condition:{ff_check="true", forcefitN},{ff_check="false"},{min_cov_ceck="true", min_coverage},{min_cov_ceck="false"} @multicolumn:{min_cov_ceck, min_coverage},{fit_check, pair_check, ring_check},{maskG_check, maskU_check, maskN_check},{min_coverage, minrxbg, chisq_cut, undersample, ff_check, forcefitN}

"""
mkdir -p dancemapper_${name}_out/

DanceMapper.py \
    --modified_parsed ${modified_mut} \
    ${untreated_parsed_var} \
    --prof ${profile} \
    --out ${name} \
    ${min_cov} \
    ${fit} \
    ${pair} \
    ${ring} \
    --chisq_cut ${chisq_cut} \
    --minrxbg ${minrxbg} \
    ${maskG} \
    ${maskU} \
    ${maskN} \
    ${ff} \
    ${other_parameters}
"""

}


process Cluster_Analysis {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /.*$/) "Clusters_foldNplot_Output/$filename"}
publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}.png$/) "Cluster_Plot/$filename"}
input:
 tuple val(name), file(dancemap)

output:
 path "*"  ,emit:g_11_directory00 
 path "${name}.png" ,optional:true  ,emit:g_11_image11 

container "quay.io/ummsbiocore/dancemapper:1.0.1"

script:

plot_type = params.Cluster_Analysis.plot_type

dance_name = (name.toString().startsWith('NO_FILE')) ? "" : name
bm_react = params.Cluster_Analysis.bm_react
main_input = (bm_react == "bm") ? "--bm1 ${dance_name}.bm" : "--react1 ${dance_name}-reactivities.txt"

fold_other_params = params.Cluster_Analysis.fold_other_params
plot_other_params = params.Cluster_Analysis.plot_other_params

"""
foldClusters.py ${dance_name}-reactivities.txt ${dance_name} --bp ${dance_name} ${fold_other_params}

plotClusters.py ${main_input} --ptype ${plot_type} --out ${dance_name} ${plot_other_params}
"""


}


workflow {



DanceMaPper(g_2_0_g_1,g_3_1_g_1,g_6_2_g_1)
g_1_directory00_g_11 = DanceMaPper.out.g_1_directory00_g_11


Cluster_Analysis(g_1_directory00_g_11)
g_11_directory00 = Cluster_Analysis.out.g_11_directory00
g_11_image11 = Cluster_Analysis.out.g_11_image11


}

workflow.onComplete {
println "##Pipeline execution summary##"
println "---------------------------"
println "##Completed at: $workflow.complete"
println "##Duration: ${workflow.duration}"
println "##Success: ${workflow.success ? 'OK' : 'failed' }"
println "##Exit status: ${workflow.exitStatus}"
}
