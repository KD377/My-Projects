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

public class Repository {
    public static SudokuBoard createInstance(DifficultyLevel l) {
        BacktrackingSudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard sudokuboard = new SudokuBoard(solver);
        sudokuboard.solveGame();
        int remove = 0;
        if (l.equals(DifficultyLevel.BEGINNER)) {
            remove = 10;
        } else if (l.equals(DifficultyLevel.INTERMEDIATE)) {
            remove = 40;
        } else if (l.equals(DifficultyLevel.PRO)) {
            remove = 70;
        }
        for (int i = 0; i < remove; i++) {
            int row = (int) (Math.random() * 9);
            int column = (int) (Math.random() * 9);
            if (sudokuboard.getBoard(row, column) != 0) {
                sudokuboard.set(row, column, 0);
            } else {
                i--;
            }

        }

        return sudokuboard.clone();
    }
}
