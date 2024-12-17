# bit values of coefficients
bit_values = ["{:0{width}x}".format(2 * i, width=4) for i in range(128)]
print(bit_values[0:5])
bit_strs = []

for i in range(0, 32):
    bit_str = (
        bit_values[i + 96] + bit_values[i + 64] + bit_values[i + 32] + bit_values[i]
    )
    bit_strs.append(f'X"{bit_str}"')

print(len(bit_strs))

with open("ram_coeffs.txt", "w") as f:
    for i, value in enumerate(bit_strs):
        f.write(value + ",")
        if i % 4 == 3:
            f.write("\n")
