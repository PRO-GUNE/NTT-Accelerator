# Create the twiddle factors in bit reversed order

q = 3329
phi_q = 17

phis = []
for i in range(256):
    b = "{:0{width}b}".format(i, width=7)
    # value of phi in hex
    phis.append(format(phi_q ** int(b[::-1], 2) % q, "03X"))

# write to phi_values file
with open("phi_values.txt", "w") as f:
    f.writelines(",\n".join(phis))
