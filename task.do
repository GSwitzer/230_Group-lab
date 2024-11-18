vsim SimpleComputer

# display hexadecimal values
radix -hexadecimal

view wave

add wave clock

add wave debug_PC
add wave P/reset
add wave debug_IR
add wave debug_state
add wave debug_r1
add wave debug_r2
add wave debug_r3
add wave debug_r4
add wave debug_r5
add wave debug_r6
add wave debug_r7
add wave debug_RA
add wave debug_RB
add wave debug_Extension
add wave debug_RZ
add wave debug_RY
# add other signals
add wave SW
add wave KEY
add wave HEX_DP
add wave LEDR
# add signals inside simpleProcessor
add wave P/MEM_read
add wave P/MEM_write
add wave P/MEM_address
add wave P/Data_to_Mem

force clock 1 0, 0 1000 -repeat 2000
# push KEY0 between 0 and 100 to reset the computer
force KEY(1) 1 0, 1 50000
force KEY(0) 0 0, 1 100
#clear all switches at time 0 and set every other switch after 100000
force SW 0000000000 0
force SW(8) 0 0, 1 100000
force SW(6) 0 0, 1 100000
force SW(4) 0 0, 1 100000
force SW(2) 0 0, 1 100000
force SW(0) 0 0, 1 100000

run 250000


