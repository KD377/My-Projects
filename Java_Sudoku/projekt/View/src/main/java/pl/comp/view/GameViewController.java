package pl.comp.view;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Pane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import pl.comp.model.*;
import pl.comp.model.exceptions.WriteDaoException;

import java.io.File;
import java.io.IOException;
import java.nio.file.NoSuchFileException;
import java.util.Locale;
import java.util.Objects;
import java.util.ResourceBundle;

public class GameViewController {

    private DifficultyLevel level;
    private AnchorPane pane;
    private Button save;
    private Stage stage;

    @FXML
    private Label validLabel;
    private Button check;

    @FXML
    private SudokuBoard playerBoard;


    private SudokuSolver solver;

    private final ResourceBundle resourceBundle = ResourceBundle.getBundle("lang");

    private TextField [][] textFields = new TextField[9][9];
     public GameViewController (){
        level = DifficultyLevel.INTERMEDIATE;
        solver = new BacktrackingSudokuSolver();
         for (int i = 0; i < 9; i++) {
             for (int j = 0; j < 9; j++) {
                 textFields[i][j] = new TextField();
             }

         }
    }

    @FXML
    private GridPane grid;
    @FXML
    private AnchorPane root;
    @FXML
    private Button beginner;

    @FXML
    private Button intermediate;

    @FXML
    private Button pro;
    @FXML
    private Label welcomeText;

    @FXML
    private Button authors;

    @FXML
    private ComboBox<String> chooseLang;

    @FXML
    private Button confirmLang;

    @FXML
    private Button write;

    @FXML
    private Button read;



    public void switchToBeginnerSudokuView() throws IOException {
        level = DifficultyLevel.BEGINNER;
        pane = FXMLLoader.load(Objects.requireNonNull(getClass().getResource("SudokuView.fxml")));
        Scene scene = new Scene(pane,600,450);
        stage = (Stage) root.getScene().getWindow();
        stage.setScene(scene);
        stage.setTitle("SUDOKU");
        stage.show();
        getButtons(pane);
        //validLabel.setText("test");
        fillBoard((GridPane) pane.getChildren().get(0));
    }

    public void switchToIntermediateSudokuView() throws IOException {
        level = DifficultyLevel.INTERMEDIATE;
        pane = FXMLLoader.load(getClass().getResource("SudokuView.fxml"));
        Scene scene = new Scene(pane,600,450);
        stage = (Stage) root.getScene().getWindow();
        stage.setScene(scene);
        stage.setTitle("SUDOKU");
        stage.show();
        getButtons(pane);
        fillBoard((GridPane) pane.getChildren().get(0));
    }

    public void switchToProSudokuView() throws IOException {
        level = DifficultyLevel.PRO;
        pane = FXMLLoader.load(getClass().getResource("SudokuView.fxml"));
        Scene scene = new Scene(pane,600,450);
        stage = (Stage) root.getScene().getWindow();
        stage.setScene(scene);
        stage.setTitle("SUDOKU");
        stage.show();
        getButtons(pane);
        fillBoard((GridPane) pane.getChildren().get(0));
    }
    @FXML
    public void initialize(){
        if(beginner != null)
            beginner.setText(resourceBundle.getString("beginner"));
        if(intermediate != null)
            intermediate.setText(resourceBundle.getString("intermediate"));
        if(intermediate != null)
            pro.setText(resourceBundle.getString("pro"));
        if(authors != null)
            authors.setText(resourceBundle.getString("authors"));
        if(chooseLang != null) {
            chooseLang.getItems().addAll(
                    resourceBundle.getString("chooseEnglish"),
                    resourceBundle.getString("choosePolish")
            );
        }
        if(confirmLang != null)
            confirmLang.setText(resourceBundle.getString("confirmLang"));

        if(write != null)
            write.setText(resourceBundle.getString("write"));

        if(read != null)
            read.setText(resourceBundle.getString("read"));

    }

    @FXML
    private void confirmLanguage() throws IOException{
        if (!chooseLang.getSelectionModel().isEmpty()) {
            String language = chooseLang.getSelectionModel().getSelectedItem();

            if (language.equals(resourceBundle.getString("choosePolish"))) {
                Locale.setDefault(new Locale("pl"));
            } else if (language.equals(resourceBundle.getString("chooseEnglish"))) {
                Locale.setDefault(new Locale("en"));
            }

            try {
                AnchorPane pane = FXMLLoader.load(Objects.requireNonNull(getClass().getResource("GameView.fxml")),resourceBundle);
                Scene scene = new Scene(pane,600,400);
                Stage stage = (Stage) root.getScene().getWindow();
                stage.setScene(scene);
                stage.setTitle("SUDOKU");
                stage.show();
            } catch (IOException e) {
                throw new NoSuchFileException("No such file");
            }

        }
    }



    @FXML
    private void getAuthor() {
        ResourceBundle authors = ResourceBundle.getBundle("pl.comp.view.Authors");
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Authors");
        alert.setContentText(authors.getObject("-^") + "\n" + authors.getObject("-&") + "\n" );
        alert.showAndWait();
    }

    public void setLevel(DifficultyLevel level) {
        this.level = level;
    }

    public SudokuBoard fillBoard(GridPane grid){
        playerBoard = Repository.createInstance(level);
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                textFields[i][j].setText(String.valueOf(playerBoard.getBoard(i,j)));
                if (playerBoard.getBoard(i,j) != 0) {
                    textFields[i][j].setDisable(true);
                    textFields[i][j].setMinSize(30,30);
                }
                grid.add(textFields[i][j],i,j);
            }

        }
        return playerBoard;
    }
    public void save() throws WriteDaoException {
        SudokuSolver solver1 = new BacktrackingSudokuSolver();
        SudokuBoard board = new SudokuBoard(solver1);
        board.solveGame();
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if(textFields[i][j].getText() == "")
                {
                    board.set(i,j,0);
                }else {
                    board.set(i,j,Integer.parseInt(textFields[i][j].getText()));
                }

            }
        }
        FileChooser fileChooser = new FileChooser();
        FileChooser.ExtensionFilter extFilter =
                new FileChooser.ExtensionFilter("Sudoku board files (*.sudoku)", "*.sudoku");
        fileChooser.getExtensionFilters().add(extFilter);
        boolean success = true;
        try {
            File file = fileChooser.showSaveDialog(stage);
            FileSudokuBoardDao fileSudokuBoardDao = new FileSudokuBoardDao(file.getName());
            fileSudokuBoardDao.write(board);
        } catch (NullPointerException | WriteDaoException e) {
            throw new NullPointerException();
        }
    }
    private boolean isPossible(int row, int column, int number,final SudokuBoard board) {
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
    @FXML
    private void check(){
        SudokuBoard board = new SudokuBoard(solver);
        boolean isValid =true;
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if(textFields[i][j].getText() == "")
                {
                    board.set(i,j,0);
                }else {
                    board.set(i,j,Integer.parseInt(textFields[i][j].getText()));
                }

            }
        }
        for (int i = 0; i < 9; i++) {
            for (int j = 0; j < 9; j++) {
                if(!isPossible(i,j, board.getBoard(i,j),board)){
                    isValid = false;
                }
            }
        }
        if(isValid){
            validLabel.setText("ok");
        }
        else {
            validLabel.setText("nieok");
        }
    }



    private void getButtons(AnchorPane pane){
        save = (Button) pane.getChildren().get(1);
        check = (Button) pane.getChildren().get(2);
        validLabel = (Label) pane.getChildren().get(3);
        if(save != null)
            save.setText(resourceBundle.getString("write"));
        if(check != null)
            check.setText(resourceBundle.getString("check"));

    }
}