/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ejemplocup;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FlexCupJquery {

    public static void main(String[] args) {
        String al = "lexico.jflex";
        //String al = "D:\\proyectoCompi\\FlexCupJquery\\src\\ejemplocup\\lexico.jflex";
        //String as = "D:\\proyectoCompi\\FlexCupJquery\\src\\ejemplocup\\sintactico.cup";
        String as = "sintactico.cup";

        String[] alexico = {al};
        String[] asintactico = {"-parser", "AnalizadorSintactico", as};
        jflex.Main.main(alexico);
        try {
            java_cup.Main.main(asintactico);
        } catch (Exception ex) {
            Logger.getLogger(FlexCupJquery.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("Habemus Compiler!!");
    }

}
