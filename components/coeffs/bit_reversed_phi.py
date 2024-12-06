# Create the twiddle factors in bit reversed order

q = 3329
phi_q = 17

phis = []
for i in range(128):
    b = "{:0{width}b}".format(i, width=7)
    # value of phi in hex
    phi = phi_q ** int(b[::-1], 2) % q
    print(f"{i} : {phi}")
    phis.append(format(phi, "03X"))

# write to phi_values file
with open("phi_values.txt", "w") as f:
    f.writelines(",\n".join(phis))
