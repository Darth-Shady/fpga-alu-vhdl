onerror {quit -f}
vlib work
vlog -work work StorageUnit.vo
vlog -work work StorageUnit.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.StorageUnit_vlg_vec_tst
vcd file -direction StorageUnit.msim.vcd
vcd add -internal StorageUnit_vlg_vec_tst/*
vcd add -internal StorageUnit_vlg_vec_tst/i1/*
add wave /*
run -all
