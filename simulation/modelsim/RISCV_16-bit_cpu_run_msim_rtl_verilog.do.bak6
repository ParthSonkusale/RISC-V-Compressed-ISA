transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/SETU_ZOHO/code {C:/SETU_ZOHO/code/RVC_CPU.v}
vlog -vlog01compat -work work +incdir+C:/SETU_ZOHO/code {C:/SETU_ZOHO/code/Reg_file.v}
vlog -vlog01compat -work work +incdir+C:/SETU_ZOHO/code {C:/SETU_ZOHO/code/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/SETU_ZOHO/code {C:/SETU_ZOHO/code/Datapath.v}
vlog -vlog01compat -work work +incdir+C:/SETU_ZOHO/code {C:/SETU_ZOHO/code/ALU.v}

vlog -vlog01compat -work work +incdir+C:/SETU_ZOHO/.tb {C:/SETU_ZOHO/.tb/RVC_CPU_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  RVC_CPU_tb

add wave *
view structure
view signals
run -all
