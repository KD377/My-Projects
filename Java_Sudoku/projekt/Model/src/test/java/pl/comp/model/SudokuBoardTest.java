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


import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

public class SudokuBoardTest {

    private SudokuBoard sudoku;


    public SudokuBoardTest() {

    }

    @BeforeEach
    public void setUp() {
        BacktrackingSudokuSolver solver = new BacktrackingSudokuSolver();
        sudoku = new SudokuBoard(solver);
    }

    @Test
    public void solveGameTest() {
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
                board2[i][j] = sudoku.getBoard(i,j);
            }
        }
        assertFalse(Arrays.deepEquals(board1,board2));
    }

    @Test
    public void GetterTest() {
        int x;
        sudoku.set(0,0,1);
        x = sudoku.getBoard(0,0);
        assertEquals(x,1);


    }

    @Test
    public void SetterTest() {
        int x, y;
        sudoku.set(0,0,1);
        x = sudoku.getBoard(0,0);
        sudoku.set(0,0,2);
        y = sudoku.getBoard(0,0);
        assertNotEquals(x,y);
    }

    @Test
    public void getRowTest(){
        SudokuRow row;
        sudoku.solveGame();
        row = sudoku.getRow(0);
        int[] tab = new int[9];
        int[] tab2 = new int[9];
        for (int i = 0; i < 9; i++) {
            tab[i] = sudoku.getBoard(0, i);
            tab2[i] = row.getTableValue(i);
        }
        assertArrayEquals(tab, tab2);
    }

    @Test
    public void getColumnTest(){
        SudokuColumn column;
        sudoku.solveGame();
        column = sudoku.getColumn(0);
        int[] tab = new int[9];
        int[] tab2 = new int[9];
        for (int i = 0; i < 9; i++) {
            tab[i] = sudoku.getBoard(i, 0);
            tab2[i] = column.getTableValue(i);
        }
        assertArrayEquals(tab, tab2);
    }

    @Test
    public void getBoxTest(){
        SudokuBox box;
        sudoku.solveGame();
        box = sudoku.getBox(0,0);
        int[] tab = new int[9];
        int[] tab2 = new int[9];
        int k = 0;
        for (int x = 0; x < 3; x++) {
            for (int y = 0; y < 3; y++) {
                tab[k] = sudoku.getBoard(x,y);
                k++;
            }
        }
        for (int i = 0; i < 9; i++) {
            tab2[i] = box.getTableValue(i);
        }
        assertArrayEquals(tab, tab2);
    }

    @Test
    public void sudokuPositiveCheckTest() {
        sudoku.solveGame();
        boolean flag = true;
        for (int row = 0; row < 9; row++) {
            //row check
            for (int i = 0; i < 9; i++) {
                for (int i2 = 0; i2 < 9; i2++) {
                    if ((sudoku.getBoard(row,i) == sudoku.getBoard(row, i2))
                            && (i != i2)) {
                        flag = false;
                    }
                }
            }
        }
        //column check
        for (int column = 0; column < 9; column++) {
            for (int x = 0; x < 9; x++) {
                for (int x2 = 0; x2 < 9; x2++) {
                    if ((sudoku.getBoard(x,column) == sudoku.getBoard(x2,column))
                            && (x != x2)) {
                        flag = false;
                    }
                }
            }
        }
        for (int row = 0; row < 9; row++) {
            for (int column = 0; column < 9; column++) {
                //3x3 square check
                //get the index of the first field in the subsquare
                int cornerRow = (row / 3) * 3;
                int cornerColumn = (column / 3) * 3;
                for (int row2 = cornerRow; row2 <= cornerRow + 2; row2++) {
                    for (int column2 = cornerColumn; column2 <= cornerColumn + 2; column2++) {
                        if (((column != column2) || (row != row2))
                                && sudoku.getBoard(row2,column2)
                                == sudoku.getBoard(row,column)) {
                            flag = false;
                        }
                    }
                }
            }
        }
        assertTrue(flag);
    }

    @Test
    public void toStringTest() {
        assertNotNull(sudoku.toString());
    }
    @Test
    public void equalsTest() {
        SudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard board1 = new SudokuBoard(solver);
        SudokuBoard board2 = new SudokuBoard(solver);
        assertTrue(board1.equals(board2) && board2.equals(board1) && board2.equals(board2));
    }

    @Test
    public void equalsNegativeTest() {
        SudokuSolver solver = new BacktrackingSudokuSolver();
        assertFalse(sudoku.equals(null) || sudoku.equals(solver));
    }

    @Test
    public void hashCodeTest() {
        SudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard board1 = new SudokuBoard(solver);
        SudokuBoard board2 = new SudokuBoard(solver);
        assertEquals(board1.hashCode(),board2.hashCode());
    }

    @Test
    public void hashCodeAndEqualsIntegrityTest() {
        SudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard board = new SudokuBoard(solver);
        SudokuBoard board1 = new SudokuBoard(solver);
        boolean flag = board.equals(board1);
        boolean flag1 = board.hashCode() == board1.hashCode();
        assertTrue(flag && flag1);
    }

    @Test
    public void cloneTest(){
        SudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard board = new SudokuBoard(solver);
        board.solveGame();
        SudokuBoard cloned = board.clone();
        assertEquals(board,cloned);
        assertNotSame(board,cloned);
        if(board.getBoard(0,0) != 5){
            board.set(0,0,5);
        }
        else {
            board.set(0,0,4);
        }
        assertNotEquals(board.getBoard(0,0),cloned.getBoard(0,0));


    }

}
