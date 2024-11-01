from math import ceil

omega_values = []
q = 3329
k = 13

# modular inverse of k^2 mod q is 2285
K2_INV = 2285

# skip the first 2 lines and last line
with open("omega_values.txt", "r") as file:
    for i, line in enumerate(file):
        if i % 2 == 0:
            continue
        value = int(line.strip()[:-1], 16)
        omega_values.append(value)


values = []
for value in omega_values:
    v = ceil(value * K2_INV) % q
    print(v, value)
    values.append(hex(v)[2:])


# write to output file
with open("k2_omega_values.txt", "w") as file:
    file.write("memory_initialization_radix=16;" + "\n")
    file.write("memory_initialization_vector=" + "\n")

    for i, value in enumerate(values):
        file.write('X"' + value.zfill(3) + '", ')
        if i % 8 == 7:
            file.write("\n")
        else:
            i += 1
    file.write(";")
