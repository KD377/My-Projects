import argparse
import time
from queue import Queue

import file_reader


def create_moves(state):
    moves = []
    zero_index = state.index(0)

    if (zero_index + 1) % 4 != 0:
        moves.append("R")
    if (zero_index + 1) % 4 != 1:
        moves.append("L")
    if (zero_index + 1) > 4:
        moves.append("U")
    if (zero_index + 1) <= 12:
        moves.append("D")
    return moves


def make_move(state,move):
    new_puzzle = state[:]
    zero_index = new_puzzle.index(0)

    if move == 'U':
        new_puzzle[zero_index], new_puzzle[zero_index - 4] = new_puzzle[zero_index - 4], new_puzzle[zero_index]
    elif move == 'D':
        new_puzzle[zero_index], new_puzzle[zero_index + 4] = new_puzzle[zero_index + 4], new_puzzle[zero_index]
    elif move == 'L':
        new_puzzle[zero_index], new_puzzle[zero_index - 1] = new_puzzle[zero_index - 1], new_puzzle[zero_index]
    elif move == 'R':
        new_puzzle[zero_index], new_puzzle[zero_index + 1] = new_puzzle[zero_index + 1], new_puzzle[zero_index]
    return new_puzzle


def bfs_solver(start_state, order='UDLR'):
    goal_state = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
    queue = Queue()
    queue.put((start_state, []))
    visited = set()
    visited.add(tuple(start_state))

    processed_states = 0
    max_recursion_depth = 0
    start_time = time.time()

    while not queue.empty():
        state, path = queue.get()

        if state == goal_state:
            end_time = time.time()
            duration = end_time - start_time
            return path, visited, processed_states, max_recursion_depth, duration

        for move in order:
            if move not in create_moves(state):
                continue

            new_state = make_move(state, move)

            if tuple(new_state) not in visited:
                visited.add(tuple(new_state))
                new_path = path + [move]
                queue.put((new_state, new_path))
                processed_states += 1
                max_recursion_depth = max(max_recursion_depth, len(new_path))

    end_time = time.time()
    duration = end_time - start_time
    return None, visited, processed_states, max_recursion_depth, duration


def run_bfs(in1, out1, out2, order):
    # Wczytywanie planszy startowej z pliku
    start_state = file_reader.read_puzzle(in1)

        # Rozwiązanie zagadki za pomocą algorytmu BFS
    path, visited, processed_states, max_recursion_depth, duration = bfs_solver(start_state,order)

        # Zapisywanie wyniku do plików
    with open(out1, 'w') as f:
        if path is None:
            f.write("-1\n")
        else:
            f.write(str(len(path)) + "\n")
            f.write("".join(path) + "\n")

    with open(out2, 'w') as f:
        if path is None:
            f.write("-1\n")
        else:
            f.write(str(len(path)) + "\n")
            f.write(str(len(visited)) + "\n")
            f.write(str(processed_states) + "\n")
            f.write(str(max_recursion_depth) + "\n")
            f.write(str(duration) + "\n")

