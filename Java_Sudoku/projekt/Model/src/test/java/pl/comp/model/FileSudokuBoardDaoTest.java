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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import pl.comp.model.exceptions.ReadDaoException;
import pl.comp.model.exceptions.WriteDaoException;

import static org.junit.jupiter.api.Assertions.*;

public class FileSudokuBoardDaoTest {
    SudokuBoardDaoFactory factory = new SudokuBoardDaoFactory();
    BacktrackingSudokuSolver solver = new BacktrackingSudokuSolver();
    SudokuBoard board = new SudokuBoard(solver);

    private static final Logger LOGGER = LoggerFactory.getLogger(FileSudokuBoardDao.class);

    @Test
    public void ReadEqualsWriteTest()
    {
        try(Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao("file")) {
            dao.write(board);
            SudokuBoard board1 = dao.read();
            assertEquals(board, board1);
        }
        catch(Exception exception) {
            LOGGER.info("exception");
        }

    }

    @Test
    public void IOExceptionReadTest() {
        assertThrows(ReadDaoException.class, () -> {Dao<SudokuBoard> dao = factory.getFileDao("testFileIoException");
            dao.read();});
    }


   @Test
    public void IOExceptionWriteTest() {
        assertThrows(WriteDaoException.class, () -> {Dao<SudokuBoard> dao = SudokuBoardDaoFactory.getFileDao("//?@#$%");

            dao.write(board);});
    }



}
