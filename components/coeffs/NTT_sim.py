instrs = [
    (0, 1, 0, 0, 1, 2, 3, 0, 0),
    (0, 1, 0, 0, 1, 2, 3, 0, 8),
    (0, 1, 0, 0, 1, 2, 3, 0, 16),
    (0, 1, 0, 0, 1, 2, 3, 0, 24),
    (0, 1, 0, 0, 1, 2, 3, 0, 1),
    (0, 1, 0, 0, 1, 2, 3, 0, 9),
    (0, 1, 0, 0, 1, 2, 3, 0, 17),
    (0, 1, 0, 0, 1, 2, 3, 0, 25),
    (0, 1, 0, 0, 1, 2, 3, 0, 2),
    (0, 1, 0, 0, 1, 2, 3, 0, 10),
    (0, 1, 0, 0, 1, 2, 3, 0, 18),
    (0, 1, 0, 0, 1, 2, 3, 0, 26),
    (0, 1, 0, 0, 1, 2, 3, 0, 3),
    (0, 1, 0, 0, 1, 2, 3, 0, 11),
    (0, 1, 0, 0, 1, 2, 3, 0, 19),
    (0, 1, 0, 0, 1, 2, 3, 0, 27),
    (0, 0, 0, 0, 0, 0, 0, 0, 0),  # nop
]
instr_strs = []

for instr in instrs:
    instr_strs.append(
        "{:0{width}b}".format(instr[0], width=1)
        + "{:0{width}b}".format(instr[1], width=1)
        + "{:0{width}b}".format(instr[2], width=2)
        + "{:0{width}b}".format(instr[3], width=8)
        + "{:0{width}b}".format(instr[4], width=7)
        + "{:0{width}b}".format(instr[5], width=7)
        + "{:0{width}b}".format(instr[6], width=7)
        + "{:0{width}b}".format(instr[7], width=6)
        + "{:0{width}b}".format(instr[8], width=6)
    )

print(len(instr_strs[0]))


with open("instructions.txt", "w") as f:
    for i, value in enumerate(instr_strs):
        f.write(f'"{value}",')
        if i % 2 == 1:
            f.write("\n")
