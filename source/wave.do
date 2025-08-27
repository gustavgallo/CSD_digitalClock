onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clock
add wave -noupdate /top_tb/reset
add wave -noupdate /top_tb/mode_buttonBTNC
add wave -noupdate /top_tb/add_buttonBTNR
add wave -noupdate /top_tb/sub_buttonBTNL
add wave -noupdate /top_tb/AN
add wave -noupdate /top_tb/DIGIT
add wave -noupdate /top_tb/uut/display/ck_1KHz
add wave -noupdate /top_tb/uut/display/dig_selection
add wave -noupdate /top_tb/uut/display/selected_dig
add wave -noupdate /top_tb/uut/display/an
add wave -noupdate /top_tb/uut/display/reset
add wave -noupdate /top_tb/uut/display/clock
add wave -noupdate /top_tb/uut/main/d1
add wave -noupdate /top_tb/uut/main/d2
add wave -noupdate /top_tb/uut/main/d3
add wave -noupdate /top_tb/uut/main/d4
add wave -noupdate /top_tb/uut/main/d5
add wave -noupdate /top_tb/uut/main/d6
add wave -noupdate /top_tb/uut/main/d7
add wave -noupdate /top_tb/uut/main/d8
add wave -noupdate /top_tb/uut/main/EA
add wave -noupdate /top_tb/uut/main/pulse_1hz
add wave -noupdate /top_tb/uut/main/pulse_500ms
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {5429215616 ps}
