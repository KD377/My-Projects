package pl.comp.view;

import java.util.ListResourceBundle;

public class Authors extends ListResourceBundle {

    @Override
    protected Object[][] getContents() {
        return new Object[][] {
                {"-^", "Krzysztof Deka"},
                {"-&", "Jakub Olejniczak"}
        };
    }
}
