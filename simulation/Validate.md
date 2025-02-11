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
- [x] Twiddle_ROM

## Bug Reports
- [x] Invalid signal "X" in the register 12 module (Resolved: Multiple processes in the test bench assigning conflicting values to the data_in at the same time)
- [x] MOD_K2_RED algorithm, the implementation gives the same result when the algorithm was manually worked out. But the results does not match the expected result of the algorithm which is said to be - $k^2 \cdot C \mod q$. $2^8$ term missing in final result (Resolved: The issue was, the signed bit of the c1 attribute was not getting extended correctly to the c_h1 variable, once fixed the dropped $2^8$ term was added to the result correctly)
- [x] DUAL_PORT_RAM not using BRAM when synthesized. (Resolved: To allow Vivaldo to properly infer the use of BRAMs, the correct HDL code pattern should be followed [stated in the user guide documentation - UG901]. When followed, generated a RAM using 1 BRAM block.)
- [x] The inverse of the twiddle factors divided by $k^2$, is not the actual division but the modular inverse of those numbers. Hence, they are not small numbers rather numbers within the same range of the original twiddle factors. Also Twiddle ROM need to take as input 3 addresses of twiddle factors and return 3 twiddle factors $\omega_{00},\quad \omega_{10}, \quad \omega_{11}$
- [x] Although the 256-th root of unity is used, by properties of periodicity and symmetry we only need to compute the first 128 terms of $ \omega^n $ to perform NTT calculations.


# Level 1 Components
- [x] BUFFER_4
- [x] BUTTERFLY_UNIT
- [x] NTT_RAM

## Bug Reports
- [x] NTT_RAM component does not give the expected output. The data_out signal shows to be undefined. (Resolved: The name of the DUAL_PORT_RAM component was incorrectly stated as RAM)

## Note
- [x] The NTT ROM stores $k^{-2} * \omega$ values to compensate for the $k^2$ multiplication in the modular reduction algorithm. Note here, the value $k^{-2}$ means the modular inverse of $k^2$ which is of the for, $ x = 3329*n + 2285 $. As $a*b*c \mod q = a*b \mod q * c \mod q$, the value stored in the ROM is $k^{-2} * \omega  \mod q $ which is the twiddle factor multiplied by $ 2285 $.
- [x] We need seperate mode signals for each of the butterfly cores as in some stages we need different modes for different butterfly unit. To accomplish this, we will create a 8 bit bus (2 bits * 4) with 2 bits addressing each butterfly unit.
- [x] Butterfly unit - Remember to have the twiddle factors multiplied by the modular of $ k^2 $ when being applied in testcases. Given these conditions, the tests give the correct results.
- [x] The given architecture for the butterfly has an issue as in mode=0, the v line and u line takes different times to reach the end mux, making it impossible to pipeline the results. Hence the in put to the mux_2_vsub multiplexor is taken as the output of reg3. Also, in the given architecture, we cannot perform both $u - v*\omega$ and $(v-u)*\omega$ by doing the subtraction operation in a single order. Hence, in this implementation, priority is given to $u - v*\omega$ 

# Level 2 Components
- [x] BUTTERFLY_CORE
- [x] SIPO_BUFFER_UNIT

## Note
- [x] THe SIPO Buffer, for 4 register buffer, the data out signal should be read when the 4th register is filled, and for a 5 register buffer when the 5th register is filled and so on.

## Bug Reports
- None

# Level 3 Components
- [x] NTT_CORE

## Bug Reports
- None