<!-- Contains validation tests run -->
This file includes the validation simulation tests run, to be run and any bugs that occured

# Level 0 Components
- [x] DUAL_PORT_RAM
- [x] MOD_ADD
- [x] MOD_K2_ADD
- [x] MOD_SUB
- [x] MUL
- [x] MUX_2
- [x] MUX_2_RAM
- [x] MUX_3
- [x] MUX_4
- [x] REG_12

## Bug Reports
- [x] Invalid signal "X" in the register 12 module (Resolved: Multiple processes in the test bench assigning conflicting values to the data_in at the same time)
- [x] MOD_K2_RED algorithm, the implementation gives the same result when the algorithm was manually worked out. But the results does not match the expected result of the algorithm which is said to be - $k^2 \cdot C \mod q$. $2^8$ term missing in final result (Resolved: The issue was, the signed bit of the c1 attribute was not getting extended correctly to the c_h1 variable, once fixed the dropped $2^8$ term was added to the result correctly)
- [x] DUAL_PORT_RAM not using BRAM when synthesized. (Resolved: To allow Vivaldo to properly infer the use of BRAMs, the correct HDL code pattern should be followed [stated in the user guide documentation - UG901]. When followed, generated a RAM using 1 BRAM block.)


# Level 1 Components
- [x] BUFFER_4
- [] BUTTERFLY_UNIT
- [x] NTT_RAM

## Bug Reports
- [x] NTT_RAM component does not give the expected output. The data_out signal shows to be undefined. (Resolved: The name of the DUAL_PORT_RAM component was incorrectly stated as RAM)

# Level 2 Components
- [] BUTTERFLY_CORE
- [] PISO_BUFFER_UNIT

## Bug Reports
- None