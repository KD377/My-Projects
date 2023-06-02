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


import static org.junit.jupiter.api.Assertions.*;

public class SudokuFieldTest {

    public SudokuFieldTest() {

    }

    @Test
    public void SudokuFieldParameterConstructorTest() {
        SudokuField field = new SudokuField(9);
        assertEquals(9,field.getFieldValue());

    }

    @Test
    public void getFieldValueTest() {
        SudokuField field = new SudokuField(9);
        assertEquals(9,field.getFieldValue());
    }

    @Test
    public void setFieldValuePositiveTest() {
        SudokuField field = new SudokuField(9);
        boolean flag1 = field.setFieldValue(5);
        boolean flag2 = field.getFieldValue() == 5;
        assertTrue(flag1 && flag2);
    }

    @Test
    public void setFieldValueNegativeFirstCaseTest() {
        SudokuField field = new SudokuField(9);
        boolean flag1 = field.setFieldValue(20);
        boolean flag2 = field.getFieldValue() != 9;
        assertFalse(flag1 || flag2);
    }

    @Test
    public void setFieldValueNegativeSecondCaseTest() {
        SudokuField field = new SudokuField(9);
        boolean flag1 = field.setFieldValue(-1);
        boolean flag2 = field.getFieldValue() != 9;
        assertFalse(flag1 || flag2);
    }

    @Test
    public void EqualsTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        assertTrue(field.equals(field2) && field.equals(field));
    }

    @Test
    public void NegativeEqualsTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        SudokuSolver solver = new BacktrackingSudokuSolver();
        assertFalse(field.equals(null) || field2.equals(solver) );
    }

    @Test
    public void HashCodeTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        assertEquals(field.hashCode(), field2.hashCode());
    }

    @Test
    public void ToStringTest() {
        SudokuField field = new SudokuField();
        assertNotNull(field.toString());
    }

    @Test
    public void hashCodeAndEqualsIntegrityTest() {
        SudokuField field = new SudokuField();
        SudokuField field2 = new SudokuField();
        boolean flag = field.equals(field2);
        boolean flag1 = field.hashCode() == field2.hashCode();
        assertTrue(flag && flag1);
    }

    @Test
    public void compareToPositiveTest(){
        SudokuField field = new SudokuField(9);
        SudokuField field2 = new SudokuField(8);
        assertEquals(1,field.compareTo(field2));
        assertEquals(-1,field2.compareTo(field));
        field2.setFieldValue(9);
        assertEquals(0,field.compareTo(field2));
    }

    @Test
    public void compareToExceptionTest(){
        SudokuField field = new SudokuField(9);
        assertThrows(NullPointerException.class,() -> {field.compareTo(null);});
    }

    @Test
    public void cloneTest(){
        SudokuField field = new SudokuField(9);
        SudokuField cloned = field.clone();
        assertEquals(field,cloned);
        assertNotSame(field,cloned);
        field.setFieldValue(8);
        assertNotEquals(field.getFieldValue(),cloned.getFieldValue());
    }

}
