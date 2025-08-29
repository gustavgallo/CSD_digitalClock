if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work debounce.sv
vlog -work work watch_interface.sv
vlog -work work clock_divisor.sv
vlog -work work dspl_drv_NexysA7.sv
vlog -work work top.sv
vlog -work work top_tb.sv


vsim -voptargs=+acc work.top_tb

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 1000ms