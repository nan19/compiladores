/* seccion de imports*/
package ejemplocup;
import java_cup.runtime.*;
import java.io.Reader;




%% /*seccion de declaraciones*/
%class AnalizadorLexico
%line
%column
%cup  /*compatibilidad con CUP*/
%{  

private TablaSimbolos tabla;
public AnalizadorLexico(Reader in, TablaSimbolos t){
    this(in);
    this.tabla = t;
    }

          private Symbol symbol(int type) {
               return new Symbol(type, yyline, yycolumn);
             }
           private Symbol symbol(int type, Object value) {
                return new Symbol(type, yyline, yycolumn, value);
           }
%}
Salto = \r|\n|\r\n 
Espacio = {Salto} | [ \t\f]
Entero = 0 | [1-9][0-9]*

%% /*Secciones de reglas*/
<YYINITIAL> {

"FORM"
{ return new Symbol(sym.FORM); }

"LIST"
{ return new Symbol(sym.LIST); }

"COMBO"
{ return new Symbol(sym.COMBO); }

"TEXTFIELD"
{ return new Symbol(sym.TEXTFIELD); }

"("
{ return new Symbol(sym.LA); }

")"
{ return new Symbol(sym.LC); }

":"
{ return new Symbol(sym.DOSPUNTOS); }

"\,"
{ return new Symbol(sym.COMA); }


[:jletter:][:jletterdigit:]* {
                            Simbolo s;
                            if ((s = tabla.buscar(yytext())) == null)
                            s = tabla.insertar(yytext());
                            return new Symbol(sym.ID, s);
                            }
  
    {Espacio}       { /* ignora el espacio */ } 
}
[^] { throw new Error("Caracter ilegal '"+yytext()+ "' en linea "+ yyline+ " columna "+yycolumn);  }
