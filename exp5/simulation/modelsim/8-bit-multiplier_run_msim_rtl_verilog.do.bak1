transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/8-bit-multiplier.sv}
vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/control.sv}
vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/D_flipflop.sv}
vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/reg_8.sv}
vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/hexdriver.sv}
vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/lab5_multiplier_toplevel.sv}

vlog -sv -work work +incdir+D:/mine/UIUC/ECE385/Git/exp5 {D:/mine/UIUC/ECE385/Git/exp5/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
