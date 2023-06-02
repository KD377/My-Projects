/**
 * MIT License
 * Copyright (c) 2022 Krzysztof Deka & Jakub Olejniczak
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package pl.comp.model;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;




public class BacktrackingSudokuSolver implements SudokuSolver {

    private List randomNumbers() {
        List<Integer> numbers = Arrays.asList(new Integer[9]);
        for (int i = 0; i < 9; i++) {
            numbers.set(i, i + 1);
        }
        Collections.shuffle(numbers);
        return numbers;
    }

    //Function that validates if the number is unique in row column and subsquare 3x3
    public boolean isPossible(int row, int column, int number,final SudokuBoard board) {
        //row check
        for (int i = 0; i < 9; i++) {
            if (board.getBoard(row, i) == number && i != column) {
                return false;
            }
        }
        //column check
        for (int x = 0; x < 9; x++) {
            if (board.getBoard(x, column) == number && x != row) {
                return false;
            }
        }
        //3x3 square check
        int cornerRow = (row / 3) * 3; //get the index of the first field in the subsquare
        int cornerColumn = (column / 3) * 3; //get the index of the first field in the subsquare
        for (int row2 = cornerRow; row2 <= cornerRow + 2; row2++) {
            for (int column2 = cornerColumn; column2 <= cornerColumn + 2; column2++) {
                if ((column != column2 || row != row2) && board.getBoard(row2,
                        column2) == number) {
                    return false;
                }
            }
        }
        return true;
    }

    private boolean backtracking(int row, int column, List<Integer> list, final SudokuBoard board) {
        list = randomNumbers();

        if (row * column == 72) {
            return true;
        }
        if (column == 9) {
            row++;
            column = 0;
        }
        for (int x = 0; x < 9; x++) {
            if (isPossible(row, column,list.get(x),board)) {
                board.set(row, column, list.get(x));
                if (backtracking(row, column + 1, list, board)) {
                    return true;
                }
                board.set(row, column, 0);
            }
        }
        return false;
    }

    @Override
    public void solve(final SudokuBoard board) {
        List<Integer> list = Arrays.asList(new Integer[9]);
        backtracking(0, 0, list, board);
    }
}
