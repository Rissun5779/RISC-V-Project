transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/rissun57/Desktop/RTL/FPU/rtl {/home/rissun57/Desktop/RTL/FPU/rtl/fpu_0.v}
vlog -vlog01compat -work work +incdir+/home/rissun57/Desktop/RTL/FPU/rtl {/home/rissun57/Desktop/RTL/FPU/rtl/fadd_s.v}

vlog -vlog01compat -work work +incdir+/home/rissun57/Desktop/RTL/FPU/project/../rtl {/home/rissun57/Desktop/RTL/FPU/project/../rtl/fpu_0_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  fpu_tb

add wave *
view structure
view signals
run -all
