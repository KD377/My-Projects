from collections import deque
import time
import file_reader


def get_neighbors(state, order):
    neighbors = {}
    blank_index = state.index(0)

    for move in order:
        if move == "R" and (blank_index + 1) % 4 != 0:  # Right
            new_state = state[:]
            new_state[blank_index], new_state[blank_index + 1] = new_state[blank_index + 1], new_state[blank_index]
            neighbors['R'] = new_state
        elif move == "D" and (blank_index + 1) <= 12:  # Down
            new_state = state[:]
            new_state[blank_index], new_state[blank_index + 4] = new_state[blank_index + 4], new_state[blank_index]
            neighbors['D'] = new_state
        elif move == "L" and (blank_index + 1) % 4 != 1:  # Left
            new_state = state[:]
            new_state[blank_index], new_state[blank_index - 1] = new_state[blank_index - 1], new_state[blank_index]
            neighbors['L'] = new_state
        elif move == "U" and (blank_index + 1) > 4:  # Up
            new_state = state[:]
            new_state[blank_index], new_state[blank_index - 4] = new_state[blank_index - 4], new_state[blank_index]
            neighbors['U'] = new_state

    return neighbors


def dfs_solve_puzzle(start, order="LUDR", max_depth=20):
    goal = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
    stack = deque([(start, [], set(), 0)])
    visited_states = set()
    processed_states = 0
    max_recursion_depth = 0
    start_time = time.time()

    while stack:
        state, path, visited, depth = stack.pop()

        if state == goal:
            end_time = time.time()
            duration = round((end_time - start_time) * 1000, 3)
            return "".join(path), visited_states, processed_states, max_recursion_depth, duration

        # nawrot
        if depth >= max_depth:
            continue

        visited.add(tuple(state))
        visited_states.add(tuple(state))
        processed_states += 1
        max_recursion_depth = max(max_recursion_depth, depth)
        for move, new_state in get_neighbors(state, order).items():
            if tuple(new_state) not in visited:
                stack.append((new_state, path + [move], visited.copy(), depth + 1))

    end_time = time.time()
    duration = round((end_time - start_time) * 1000, 3)
    return None, visited_states, processed_states, max_recursion_depth, duration


def run_dfs(input, output1, output2, order):

    start_state = file_reader.read_puzzle(input)
    # Solve the puzzle
    path, visited_states, processed_states, max_recursion_depth, duration = dfs_solve_puzzle(start_state,order)

    with open(output1, 'w') as f:
        if path is None:
            f.write("-1\n")
        else:
            f.write(str(len(path)) + "\n")
            f.write("".join(path) + "\n")

    # Write the output to file
    with open(output2, 'w') as f:
        if path is None:
            f.write("-1\n")
        else:
            f.write(str(len(path)) + "\n")
            f.write(str(len(visited_states)) + "\n")
            f.write(str(processed_states) + "\n")
            f.write(str(max_recursion_depth) + "\n")
            f.write(str(duration) + "\n")

