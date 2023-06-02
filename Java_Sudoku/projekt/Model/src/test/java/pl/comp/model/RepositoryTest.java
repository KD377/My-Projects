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

import static org.junit.jupiter.api.Assertions.assertEquals;

public class RepositoryTest {
    @Test
    public void test(){
        int removeB = 0;
        int removeI = 0;
        int removeP = 0;
        SudokuBoard sudokuboardB = Repository.createInstance(DifficultyLevel.BEGINNER);
        SudokuBoard sudokuboardI = Repository.createInstance(DifficultyLevel.INTERMEDIATE);
        SudokuBoard sudokuboardP = Repository.createInstance(DifficultyLevel.PRO);
        for(int row = 0; row < 9; row++) {
            for(int column = 0; column < 9; column++) {
                if(sudokuboardP.getBoard(row, column) == 0) {
                    removeP++;
                }
                if(sudokuboardI.getBoard(row, column) == 0) {
                    removeI++;
                }
                if(sudokuboardB.getBoard(row, column) == 0) {
                    removeB++;
                }
            }
        }

        assertEquals(removeB, 10);
        assertEquals(removeI, 40);
        assertEquals(removeP, 70);

    }

}
