<!-- Contains validation tests run -->
This file includes the validation simulation tests run, to be run and any bugs that occured

# Level 0 Components
- [x] DUAL_PORT_RAM
- [x] MOD_ADD
- [x] MOD_K2_ADD
- [x] MOD_SUB
- [x] MUL
- [x] MUX_2
- [x] MUX_3
- [x] MUX_4
- [x] REG_12

## Bug Reports
- [x] Invalid signal "X" in the register 12 module (Resolved: Multiple processes in the test bench assigning conflicting values to the data_in at the same time)
- [] MOD_K2_RED algorithm, the implementation gives the same result when the algorithm was manually worked out. But the results does not match the expected result of the algorithm which is said to be - $k^2 \cdot C \mod q$


# Level 1 Components
- [] BUFFER_4
- [] BUTTERFLY_UNIT

## Bug Reports
- None

# Level 2 Components
- [] BUTTERFLY_CORE
- [] PISO_BUFFER_UNIT

## Bug Reports
- None