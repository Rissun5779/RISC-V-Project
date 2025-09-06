transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {fpu.vo}

vlog -vlog01compat -work work +incdir+/home/rissun57/Desktop/RTL/FPU_fin/project/../rtl {/home/rissun57/Desktop/RTL/FPU_fin/project/../rtl/fpu_0_tb.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  fpu_tb

add wave *
view structure
view signals
run -all
