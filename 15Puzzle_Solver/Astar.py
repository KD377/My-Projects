import file_reader
import time

def manhattan_distance(list1, list2):
    def get_2d_list(state):
        return [state[i:i+4] for i in range(0, len(state), 4)]

    def get_pos(item, state):
        row = next((i for i, x in enumerate(state) if item in x), None)
        col = state[row].index(item)
        return row, col

    state1 = get_2d_list(list1)
    state2 = get_2d_list(list2)

    distance = 0
    for i in range(4):
        for j in range(4):
            if state1[i][j] != 0:
                row2, col2 = get_pos(state1[i][j], state2)
                distance += abs(row2 - i) + abs(col2 - j)

    return distance


def hamming_distance(state1, state2):
    distance = 0
    for i in range(len(state1)):
        if state1[i] != state2[i]:
            distance += 1
    return distance


def a_star(puzzle, metrics):
    start_time = time.time()
    start = puzzle[:]
    goal_state = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]

    closed_set = set()
    moves = []
    solution = []
    move_dict = {}
    parent = {tuple(start): None}

    processed_states = 0

    cost = {tuple(start): 0} #g score
    open_set = {tuple(start): (metrics(start, goal_state) + cost[tuple(start)])}
    while open_set:
        current = list(min(open_set, key=lambda x: open_set[x]))
        if current == goal_state:
            path = []
            while current is not None:
                path.append(current)
                current = parent[tuple(current)]
            visited_states = len(closed_set)
            path = path[::-1]
            for sublist in path:
                key = tuple(sublist)
                if key in move_dict:
                    moves.append(move_dict[key])

            solution.append(moves)
            solution.append(visited_states)
            solution.append(processed_states)
            solution.append(max(cost.values()))
            end_time = time.time()
            solution.append(round((end_time - start_time) * 1000, 3))
            return solution

        zero_index = current.index(0)
        if (zero_index + 1) % 4 != 0:
            new_puzzle = current[:]
            new_puzzle[zero_index], new_puzzle[zero_index + 1] = new_puzzle[zero_index + 1], new_puzzle[zero_index]
            if tuple(new_puzzle) not in closed_set:
                move_dict[tuple(new_puzzle)] = "R"
                new_g_score = cost[tuple(current)] + 1
                new_h_score = metrics(new_puzzle, goal_state)
                new_f_score = new_g_score + new_h_score

                open_set[tuple(new_puzzle)] = new_f_score
                processed_states += 1
                parent[tuple(new_puzzle)] = current
                cost[tuple(new_puzzle)] = new_g_score
        if (zero_index + 1) % 4 != 1:
            new_puzzle = current[:]
            new_puzzle[zero_index], new_puzzle[zero_index - 1] = new_puzzle[zero_index - 1], new_puzzle[zero_index]
            if tuple(new_puzzle) not in closed_set:
                move_dict[tuple(new_puzzle)] = "L"
                new_g_score = cost[tuple(current)] + 1
                new_h_score = metrics(new_puzzle, goal_state)
                new_f_score = new_g_score + new_h_score

                open_set[tuple(new_puzzle)] = new_f_score
                processed_states += 1
                parent[tuple(new_puzzle)] = current
                cost[tuple(new_puzzle)] = new_g_score

        if (zero_index + 1) > 4:
            new_puzzle = current[:]
            new_puzzle[zero_index], new_puzzle[zero_index - 4] = new_puzzle[zero_index - 4], new_puzzle[zero_index]
            if tuple(new_puzzle) not in closed_set:
                move_dict[tuple(new_puzzle)] = "U"
                new_g_score = cost[tuple(current)] + 1
                new_h_score = metrics(new_puzzle, goal_state)
                new_f_score = new_g_score + new_h_score

                open_set[tuple(new_puzzle)] = new_f_score
                processed_states += 1
                parent[tuple(new_puzzle)] = current
                cost[tuple(new_puzzle)] = new_g_score

        if(zero_index + 1) <= 12:
            new_puzzle = current[:]
            new_puzzle[zero_index], new_puzzle[zero_index + 4] = new_puzzle[zero_index + 4], new_puzzle[zero_index]
            if tuple(new_puzzle) not in closed_set:
                move_dict[tuple(new_puzzle)] = "D"
                new_g_score = cost[tuple(current)] + 1
                new_h_score = metrics(new_puzzle, goal_state)
                new_f_score = new_g_score + new_h_score

                open_set[tuple(new_puzzle)] = new_f_score
                processed_states += 1
                parent[tuple(new_puzzle)] = current
                cost[tuple(new_puzzle)] = new_g_score

        closed_set.add(tuple(current))
        del open_set[tuple(current)]
    solution.append(-1)
    solution.append(len(closed_set))
    solution.append(processed_states)
    solution.append(max(cost.values()))
    end_time = time.time()
    solution.append(round((end_time - start_time) * 1000, 3))
    return solution

def run_astar(input,output1,output2,option):
    start_state=file_reader.read_puzzle(input)
    if option == 'manh':
        solution = a_star(start_state,manhattan_distance)
    elif option == 'hamm':
        solution = a_star(start_state,hamming_distance)
    file_reader.write_solution(solution,output1)
    file_reader.write_additional_info(solution,output2)