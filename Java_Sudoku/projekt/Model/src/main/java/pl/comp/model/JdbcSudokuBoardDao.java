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

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JdbcSudokuBoardDao implements Dao<SudokuBoard> {
    private static Connection connection;
    private static final Logger LOGGER = LoggerFactory.getLogger(JdbcSudokuBoardDao.class);
    private static final String DB_URL = "jdbc:sqlite:"
            + System.getProperty("user.home") + "/Desktop/";
    private static final String CREATE_SUDOKU_INDEX_TABLE_SQL = "CREATE TABLE IF NOT EXISTS"
            + " sudokuIndex (\n"
            + "\tid INTEGER NOT NULL\n"
            + ");";
    private static final String CREATE_SUDOKU_CONTENT_TABLE_SQL =
            "CREATE TABLE IF NOT EXISTS"
            + " sudokuContent (\n"
            + "\tboardId INTEGER NOT NULL,\n"
            + "\tx INTEGER NOT NULL,\n"
            + "\ty INTEGER NOT NULL,\n"
            + "\tcontent INTEGER NOT NULL,\n"
            + "    FOREIGN KEY (boardId)\n"
            + "       REFERENCES sudokuIndex (id)\n"
            + ");";
    private static final String INSERT_INTO_SUDOKU_INDEX_SQL = "INSERT OR REPLACE"
            + " INTO sudokuIndex VALUES(1)";
    private static final String INSERT_INTO_SUDOKU_CONTENT_SQL = "INSERT OR REPLACE INTO "
            + "sudokuContent(boardId, x, y, content) VALUES(?,?,?,?)";
    private static final String SELECT_SUDOKU_CONTENT_SQL = "SELECT x, y, content FROM sudokuContent";
    private static final String TRUNCATE_SUDOKU_INDEX_SQL = "DELETE FROM sudokuIndex";
    private static final String TRUNCATE_SUDOKU_CONTENT_SQL = "DELETE FROM sudokuContent";
    private final String file;

    public JdbcSudokuBoardDao(String file) {
        this.file = file;
    }

    private Connection connect() {
        try {
            String url = DB_URL + file;
            connection = DriverManager.getConnection(url);
            connection.setAutoCommit(false);
            return connection;
        } catch (SQLException e) {
            LOGGER.error("Connection error", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public SudokuBoard read() {
        SudokuSolver solver = new BacktrackingSudokuSolver();
        SudokuBoard sudokuBoard = new SudokuBoard(solver);
        try (Connection con = connect();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_SUDOKU_CONTENT_SQL)) {
            while (rs.next()) {
                int x = rs.getInt("x");
                int y = rs.getInt("y");
                int content = rs.getInt("content");
                sudokuBoard.set(x, y, content);
            }
        } catch (SQLException e) {
            LOGGER.error("Read error", e);
            throw new RuntimeException(e);
        }
        return sudokuBoard;
    }

    @Override
    public void write(SudokuBoard obj) {
        try (Connection con = connect();
             Statement stmt = con.createStatement()) {
            stmt.execute(TRUNCATE_SUDOKU_INDEX_SQL);
            stmt.execute(TRUNCATE_SUDOKU_CONTENT_SQL);
            stmt.execute(CREATE_SUDOKU_INDEX_TABLE_SQL);
            stmt.execute(CREATE_SUDOKU_CONTENT_TABLE_SQL);
            stmt.execute(INSERT_INTO_SUDOKU_INDEX_SQL);
            try (PreparedStatement pstmt = con.prepareStatement(INSERT_INTO_SUDOKU_CONTENT_SQL)) {
                for (int i = 0; i < 9; i++) {
                    for (int j = 0; j < 9; j++) {
                        pstmt.setInt(1, 1);
                        pstmt.setInt(2, i);
                        pstmt.setInt(3, j);
                        pstmt.setInt(4, obj.getBoard(i, j));
                        pstmt.executeUpdate();
                    }
                }
            }
            con.commit();
        } catch (SQLException e) {
            LOGGER.error("Write error", e);
            throw new RuntimeException(e);
        }
    }

    public void close() {
        try {
            connection.close();
        } catch (SQLException e) {
            LOGGER.error("Error closing connection", e);
            throw new RuntimeException(e);
        }
    }
}