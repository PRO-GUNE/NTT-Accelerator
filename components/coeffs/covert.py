from math import floor

omega_values = []
q = 3329
k = 13


# skip the first 2 lines and last line
with open("omega_values.txt", "r") as file:
    for line in file:
        value = int(line.strip()[:-1], 16)
        omega_values.append(floor(value * k ** (-2)))

values = [hex(value)[2:] for value in omega_values]

print(values)

# write to output file
with open("k2_omega_values.coe", "w") as file:
    file.write("memory_initialization_radix=16;" + "\n")
    file.write("memory_initialization_vector=")

    for value in values:
        file.write(value.zfill(3) + "," + "\n")
    file.write(";")
