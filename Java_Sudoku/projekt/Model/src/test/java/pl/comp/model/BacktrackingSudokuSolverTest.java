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


import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

public class BacktrackingSudokuSolverTest {
    private SudokuBoard sudoku;
    private SudokuBoard sudoku2;

    private BacktrackingSudokuSolver solver;


    public BacktrackingSudokuSolverTest() {

    }

    @Test
    public void solveTest(){
        solver = new BacktrackingSudokuSolver();
        sudoku = new SudokuBoard(solver);
        sudoku.solveGame();
        int[][] board1 = new int[9][9];
        int[][] board2 = new int[9][9];
        for (int i = 0;i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                board1[i][j]= sudoku.getBoard(i,j);
            }
        }
        sudoku.solveGame();
        for (int i = 0;i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                board2[i][j]= sudoku.getBoard(i,j);
            }
        }
        assertFalse(Arrays.deepEquals(board1,board2));
    }

    @Test
    public void isPossibleNegativeRowTest() {
        solver = new BacktrackingSudokuSolver();
        sudoku = new SudokuBoard(solver);
        sudoku.solveGame();
        sudoku.set(0,2,5);
        boolean flag = solver.isPossible(0,1,5,sudoku);
        solver.isPossible(0,2,5,sudoku);
        boolean flag1 = true;
        for (int i = 0; i < 9; i++) {
            if ((sudoku.getBoard(0, i) == 5) && (i != 1)) {
                flag1 = false;
            }
        }
        assertEquals(flag, flag1);
    }

    @Test
    public void isPossibleNegativeColumnTest() {
        solver = new BacktrackingSudokuSolver();
        sudoku = new SudokuBoard(solver);
        sudoku.solveGame();
        int y = sudoku.getBoard(0,5);
        sudoku.set(0,5,sudoku.getBoard(0,0));
        sudoku.set(0,0,y);
        boolean flag = solver.isPossible(0,0,y,sudoku);
        solver.isPossible(3,0,sudoku.getBoard(3,0),sudoku);
        boolean flag1 = true;
        for (int x = 0; x < 9; x++) {
            if ((sudoku.getBoard(x, 0) == y) && (x != 0)) {
                flag1 = false;
            }
        }
        assertEquals(flag, flag1);
    }
}

