/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ejemplocup;

import java.util.HashMap;
import java.util.Iterator;

/**
 *
 * @author nsteinhilber
 */
public class TablaSimbolos {

    HashMap t;

    public TablaSimbolos() {
        t = new HashMap();
    }

    public Simbolo insertar(String nombre) {
        Simbolo s = new Simbolo(nombre);
        t.put(nombre, s);
        return s;
    }

    public Simbolo buscar(String nombre) {
        return (Simbolo) (t.get(nombre));
    }

    public void imprimir() {
        Iterator it = t.values().iterator();
        while (it.hasNext()) {
            Simbolo s = (Simbolo) it.next();
            System.out.println(s.nombre);
        }
    }
}
