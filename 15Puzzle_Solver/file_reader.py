def read_puzzle(filename):
    with open(filename, 'r') as f:
        rows, cols = map(int, f.readline().split())
        puzzle = []
        for i in range(rows):
            row = list(map(int, f.readline().split()))
            puzzle.extend(row)
    return puzzle


def write_solution(puzzle,output):
    if puzzle[0] == -1:
        with open(output, "w") as file:
            file.write("-1")
    else:
        text = ''.join(puzzle[0])
        with open(output, "w") as file:
            file.write(str(len(puzzle[0])) + '\n')
            file.write(text)
        file.close()


def write_additional_info(puzzle,output):
    with open(output,"w") as file:
        file.write(str(len(puzzle[0])) + "\n")
        file.write(str(puzzle[1]) + "\n")
        file.write(str(puzzle[2]) + "\n")
        file.write(str(puzzle[3]) + "\n")
        file.write(str(puzzle[4]))
        file.close()
