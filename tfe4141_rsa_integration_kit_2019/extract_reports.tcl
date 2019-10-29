
source -notrace [file normalize "$origin_dir/procedures.tcl"]

if {[current_project -quiet] != "RSA_soc"} {
	error [format_box auto [list\
		"Please open RSA_soc"\
		"cannot extract bitfiles and report without an open project"\
	]]
}

if {[current_design] != ""} {close_design}

open_bd_design [list [file normalize "${origin_dir}/RSA_soc/boards/rsa_soc.bd"]]
write_bd_tcl -force [file normalize "${origin_dir}/Bitfiles/rsa_soc.tcl"]
close_bd_design [get_bd_designs rsa_soc]

if {![file exists [file normalize "$origin_dir/Bitfiles"]]} {
	file mkdir [file normalize "$origin_dir/Bitfiles"]
}
if {![file exists [file normalize "$origin_dir/Reports"]]} {
	file mkdir [file normalize "$origin_dir/Reports"]
}
#copy out bitfile
if [file exists [file normalize "${origin_dir}/RSA_soc/rsa_soc/rsa_soc.runs/impl_1/rsa_soc_wrapper.bit"]] {
	file copy -force \
		[file normalize "${origin_dir}/RSA_soc/rsa_soc/rsa_soc.runs/impl_1/rsa_soc_wrapper.bit"]\
		[file normalize "${origin_dir}/Bitfiles/rsa_soc.bit"]
}

#copying/generating reports
#RSA accelerator utilization
set file [file normalize "${origin_dir}/RSA_soc/rsa_soc/rsa_soc.runs/rsa_soc_rsa_acc_0_synth_1/rsa_soc_rsa_acc_0_utilization_synth.rpt"]
if [file exists $file] {
	file copy -force $file [file normalize "${origin_dir}/Reports/rsa_accelerator_utilization.txt"]
}
#full design utilization
set file [file normalize "${origin_dir}/RSA_soc/rsa_soc/rsa_soc.runs/impl_1/rsa_soc_wrapper_utilization_placed.rpt"]
if [file exists $file] {
	file copy -force $file [file normalize "${origin_dir}/Reports/placed_design_utilization.txt"]
}
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1
#full design timing summary
set file [file normalize "${origin_dir}/RSA_soc/rsa_soc/rsa_soc.runs/impl_1/rsa_soc_wrapper_timing_summary_routed.rpt"]
if [file exists $file] {
	file copy -force $file [file normalize "${origin_dir}/Reports/placed_design_timing_summary.txt"]
}

close_design