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

import java.io.Serializable;
import java.util.Arrays;
import java.util.List;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;


public class SudokuBoard implements Serializable,Cloneable {

    private List<List<SudokuField>> board;


    private transient SudokuSolver solver;


    //getter which provides access to private field
    public int getBoard(int x, int y) {

        return board.get(x).get(y).getFieldValue();
    }

    private void resetBoard() {
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                board.get(i).get(j).setFieldValue(0);
            }
        }
    }

    public SudokuBoard(SudokuSolver solver) {
        this.board = Arrays.asList(new List[9]);
        for (int i = 0; i < 9; i++) {
            board.set(i, Arrays.asList(new SudokuField[9]));
        }
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                board.get(i).set(j, new SudokuField());
            }
        }
        this.solver = solver;
    }

    public SudokuRow getRow(int row) {
        List<SudokuField> table = Arrays.asList(new SudokuField[9]);
        for (int i = 0; i < 9; i++) {
            table.set(i, new SudokuField(board.get(row).get(i).getFieldValue()));
        }
        return new SudokuRow(table);
    }

    public SudokuColumn getColumn(int column) {
        List<SudokuField> table = Arrays.asList(new SudokuField[9]);
        for (int i = 0; i < 9; i++) {
            table.set(i, new SudokuField(board.get(i).get(column).getFieldValue()));
        }
        return new SudokuColumn(table);
    }

    public SudokuBox getBox(int x, int y) {
        int cornerRow = (x / 3) * 3;
        int cornerColumn = (y / 3) * 3;
        int a = 0;
        List<SudokuField> table = Arrays.asList(new SudokuField[9]);

        for (int i = cornerRow; i < cornerRow + 3; i++) {
            for (int j = cornerColumn; j < (cornerColumn + 3); j++) {
                table.set(a,new SudokuField(board.get(i).get(j).getFieldValue()));
                a++;
            }
        }
        return new SudokuBox(table);
    }

    public void set(int x, int y, int value) {

        board.get(x).get(y).setFieldValue(value);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }

        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        SudokuBoard that = (SudokuBoard) o;

        return new EqualsBuilder().append(board, that.board).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37).append(board).toHashCode();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this)
                .append("board", board)
                .toString();
    }

    //solve the sudoku
    public void solveGame() {
        resetBoard();
        solver.solve(this);
    }

    @Override
    public SudokuBoard clone() {
        try {
            SudokuBoard clone = (SudokuBoard) super.clone();
            List<List<SudokuField>> cloneList = Arrays.asList(new List[9]);
            for (int i = 0; i < 9; i++) {
                cloneList.set(i, Arrays.asList(new SudokuField[9]));
            }
            for (int i = 0; i < 9; i++) {
                for (int j = 0; j < 9; j++) {
                    cloneList.get(i).set(j, board.get(i).get(j).clone());
                }
            }
            clone.board = cloneList;
            clone.solver = this.solver;
            return clone;
        } catch (CloneNotSupportedException e) {
            throw new AssertionError();
        }
    }
}


