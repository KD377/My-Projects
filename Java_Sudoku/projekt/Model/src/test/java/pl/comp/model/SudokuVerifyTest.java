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
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Arrays;
import java.util.List;

public class SudokuVerifyTest {
    private List<SudokuField> table1;
    private List<SudokuField> table2;


    private SudokuVerify row;
    private SudokuVerify row2;

    private SudokuVerify row3;

    public SudokuVerifyTest() {
    }

    @BeforeEach
    public void setUp() {
        table1 = Arrays.asList(new SudokuField[9]);
        for(int i = 0; i < 9; i++){
            table1.set(i, new SudokuField(i+1));
        }
        row = new SudokuRow(table1);

        table2 = Arrays.asList(new SudokuField[9]);
        for(int i = 0; i < 9; i++){
            table2.set(i,new SudokuField(i+1));
        }
        table2.get(0).setFieldValue(5);
        row2 = new SudokuRow(table2);

        row3 = new SudokuRow(table1);
        }


    @Test
    public void positiveVerifyTest() {
        boolean x = true;
        boolean y = row.verify();
        for (int i = 0; i < 9; i++) {
            for (int j = i + 1; j < 9; j++) {
                if (table1.get(i).getFieldValue() == table1.get(j).getFieldValue()) {
                    x = false;
                    break;
                }
            }
        }
        assertTrue(x == y);
    }

    @Test
    public void negativeVerifyTest() {
        boolean x = true;
        boolean y = row2.verify();
        for (int i = 0; i < 9; i++) {
            for (int j = i + 1; j < 9; j++) {
                if (table2.get(i).getFieldValue() == table2.get(j).getFieldValue()) {
                    x = false;
                    break;
                }
            }
        }
        assertTrue( x == y);
    }

    @Test
    public void getterVerifyTest() {
        assertEquals(5,row2.getTableValue(0));
    }

    @Test
    public void EqualsTest() {
        assertTrue(row.equals(row) && row.equals(row3));
    }
    @Test
    public void NegativeEqualsTest() {
        SudokuVerify test = new SudokuBox(table1);
        assertFalse(row.equals(null) || row.equals(test));
    }

    @Test
    public void HashCodeTest() {

        assertTrue(row.hashCode() == row3.hashCode());
    }

    @Test
    public void ToStringTest() {
        assertNotNull(row.toString());
    }

    @Test
    public void hashCodeAndEqualsIntegrityTest() {
        boolean flag = row.equals(row3);
        boolean flag1 = row.hashCode() == row3.hashCode();
        assertTrue(flag && flag1);
    }

    @Test
    public void cloneTest(){
        SudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard board = new SudokuBoard(solver);
        board.solveGame();
        SudokuVerify column = board.getColumn(2);
        SudokuVerify cloned =column.clone();
        assertEquals(column,cloned);
        assertNotSame(column,cloned);
        if(board.getBoard(0,2) == 5) {
            board.set(0, 2, 4);
        }
        else{
            board.set(0, 2, 5);

        }
        assertNotEquals(board.getBoard(0,2),cloned.getTableValue(0));

    }

}



