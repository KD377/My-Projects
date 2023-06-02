package pl.comp.view;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;
import java.util.ResourceBundle;

public class GameView extends Application {
    private final ResourceBundle resourceBundle = ResourceBundle.getBundle("lang");
    @Override
    public void start(Stage stage) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(GameView.class.getResource("GameView.fxml"));
        fxmlLoader.setResources(resourceBundle);
        Scene scene = new Scene(fxmlLoader.load(),600,400);
        stage.setTitle(resourceBundle.getString("Title"));
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}