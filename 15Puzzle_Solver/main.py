import argparse
import Astar
import BFS
import DFS

if __name__ == '__main__':
    # Creating the command line argument parser
    parser = argparse.ArgumentParser(description='Solve 15 puzzle.')
    parser.add_argument('alg', type=str, help='Type of algorythm: bfs/dfs/astr.')
    parser.add_argument('order', type=str, default='UDLR', help='Order of moves: UDLR (default) or DLRU.')
    parser.add_argument('input_file', type=str, help='Path to input file.')
    parser.add_argument('output_file1', type=str, help='Path to output file 1.')
    parser.add_argument('output_file2', type=str, help='Path to output file 2.')

    args = parser.parse_args()

    if args.alg == 'bfs':
        BFS.run_bfs(args.input_file, args.output_file1, args.output_file2, args.order)
    elif args.alg == 'dfs':
        DFS.run_dfs(args.input_file, args.output_file1, args.output_file2, args.order)
    elif args.alg == 'astr':
        Astar.run_astar(args.input_file, args.output_file1, args.output_file2, args.order)

