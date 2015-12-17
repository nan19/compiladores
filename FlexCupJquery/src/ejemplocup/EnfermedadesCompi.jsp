<%-- 
    Document   : Enfermedades
    Created on : 05-nov-2015, 17:11:35
    Author     : Valeria Yannina

--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Enfermedades</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://code.jquery.com/mobile/1.1.0/jquery.mobile-1.1.0.min.css" />
        <script type='text/javascript' src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
        <script type='text/javascript' src="http://code.jquery.com/mobile/1.1.0/jquery.mobile-1.1.0.min.js"></script>
        <script>
            //la direccion del servidor dada por el URI 
            var restfulWebServiceBaseUri = "http://localhost:8080/Servidor/webresources/";
            var listarEnfermedadesUri = restfulWebServiceBaseUri + "model.enfermedades";

            //TRAE LOS DATOS DE LA BD PARA LISTAR
            var mostrarLista;
            var ajaxCallFailed; //por si no logra traer los datos del servidor
            var update;
            mostrarLista = function (items) {
                var lista = "";
                $.each(items, function (index, item) {
                    //aqui se dibuja la lista dentro del listview, una especie de preparar estructura 
                    //ya que del json viene como un array, eso se debe dibujar en tags (li y a) de html, 
                    //todo eso se guarda en una variable lista y eso otra vez se pone dentro de una variable append
                    lista = lista.concat(//trae el id y el valor de la fila
                            "<li   >" + //li define las filas
                            "<a  class='update' id=" + item.idEnfermedades.toString() + " href='#new'>" +
                            //el class es para tomar el valor del id por el evento onclick de jquery,
                            //todo lo que esta dentro de la etiqueta a se considera un enlace , 
                            //en este saso se va a new llevando los datos del id y sera posible editar
                            item.clase.toString() + "</a></li>"
                            );
                });

                $('#lista').empty(); //empty es vacio, limpia toda la estructura de lista dibujada
                $('#lista').append(lista).listview("refresh", true); //append carga todo lo que se dibujó
            };
            callService = function (uri, successFunction) { //callService hace la llamada al servidor
                $.ajax({
                    url: uri,
                    type: "GET", //trae los datos de la bd para listar
                    contentType: "application/json", //con el formato de json
                    dataType: "json",
                    error: ajaxCallFailed,
                    failure: ajaxCallFailed,
                    success: successFunction
                });
            };

            //mensaje para cuando no se comunica con el webservice, es decir muestra el error de la llamada del ajax
            //ajax es la comunicacion asincrona, es cuando no se recarga la pagina, es una llamada al server en segundo plano
            //lo que aqui hace es crear registro en consola , detallando el error
            ajaxCallFailed = function (jqXHR, textStatus) { // parametros o variables que retorna la llamada ajax
                //jqXHR es el formato de la llamada y textStatus es el detalle del error
                console.log("Error: " + textStatus);
                console.log(jqXHR);
                $("form").css("visibility", "hidden");
                $("#errorMessage").empty().
                        append("Sorry, there was an error.").
                        css("color", "red");
                alert("Lamentamos que pases por esto, no existe conección con el WebServices"); //Mensaje de alerta en el navegador
            };
            $("#list").ready(function () {//lista enfermedades
                callService(listarEnfermedadesUri, mostrarLista);
            });
        </script>

    </head>
    <body>

        <!-- LISTAR id="list"-->
        <div data-role="page" >
            <div data-role="header"><!-- /header -->
                <h1>Enfermedades</h1>
            </div><!-- /header -->    
            <div data-role="content"> <!-- contenido   -->
                <form>
                    <ol data-role="listview" data-filter="true" 
                        id="lista" <!-- mostrar la lista  -->                        
                    </ol>
                </form>
            </div> <!-- /contenido   -->

            <div data-role="footer"> <!-- footer -->
                <h4>APS</h4>
            </div><!-- /footer -->
        </div>
            <!--/LISTAR-->

        <!--GUARDAR-->
        <div data-role="page" id="new"> 
            <div data-role="header"> <!-- header-->
                <h1>Enfermedades</h1>
            </div><!-- /header -->

            <!-- EDITAR y GUARDAR -->
            <div data-role="content"> <!-- contenido -->
                <form id="enfermedadesForm" method="post" action=""><!-- formulario -->
                    <label for="name">Nombre:</label>
                    <input type="hidden" name="idEnfermedades" id="idEnfermedades"> <!-- id -->
                    <!--<input type="text" name="clase" id="clase">  ingresar texto -->
                    <input type="text" data-clear-btn="true" name="clase" id="clase" value="">
                    <input type="submit" id="saveORupdate" value="Guardar"> <!-- botón guardar -->
                    <input id="deleteButton" type="button" value="Eliminar">                    
                </form>
            </div>
            <div data-role="popup" id="confirmDialog" data-dismissible="false" style="max-width:400px;">
                    <div role="main" class="ui-content">
                            <h3 class="ui-title">Estás seguro/a que deseas eliminar?</h3>
                        <p>Esta acción se podrá deshacer</p>
                            <a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back">Cancelar</a>
                            <a id="deleteConfirmButton" href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back" data-transition="flow">Eliminar</a>
                </div>
            </div>
            <div data-role="footer">
                <h4>APS</h4>
            </div><!-- /footer -->
        </div>      
<!--/GUARDAR-->


    </body>

    <script>
        $(document).ready(function () {
            $('#enfermedadesForm').on('submit', function (e) { //submit es enviar datos
                e.preventDefault();
                $.ajax({
                    type: "POST", //para guardar
                    url: restfulWebServiceBaseUri + "model.enfermedades", //se comunica con el servidor para datos actualizados
                    contentType: "application/json", //con el formato de json
                    dataType: "json",
                    //data, toma del formulario los campos y los convierte en un json para enviar al server
                    data: JSON.stringify({clase: $("#clase").val(), idEnfermedades: $("#idEnfermedades").val()}),
                    success: successSave,
                    dataType: "application/json"
                });

            });

            //una vez bien guardados los campos vacia el formulario
            successSave = function () {
                //todos los campos de la tabla 
                $("#idEnfermedades").val("");
                $("#clase").val("");

                //actualiza la lista, llama de vuelta a listar lo que trae la URL del servidor
                callService(listarEnfermedadesUri, mostrarLista);
                window.location.replace("#list")
            };
            successDelete = function () {
                $("#idEnfermedades").val("");
                $("#clase").val("");
                callService(listarEnfermedadesUri, mostrarLista);
                window.location.replace("#list")
            };

            //con clic sobre uno de los registros toma el id y lleva los datos al formulario del New, 
            //esto sucede cuando estamos en la pestaña de lista
            $("#lista").on("click", "li > a.update", function () {//para el caso de EDITAR, pasa al formulario con los datos completos
                //todos los campos de la tabla 
                $("#idEnfermedades").val($(this).attr("id"));//toma el id de la bd correspondiente a la fila en la que se hizo click y lo lleva al formulario editar
                $("#clase").val($(this).text()); //Le carga los datos correspondientes al id
            });
            $("#new").on('click', function () { // limpia los datos del formulario, para que no traiga datos antiguos
                //todos los campos de la tabla 
                $("#idEnfermedades").val("");
                $("#clase").val("");
            });
            $("#deleteButton").on('click', function () {
                $('#confirmDialog').popup('open');
            });
            $("#deleteConfirmButton").on('click', function () {
                $.ajax({
                    type: "DELETE",
                    url: restfulWebServiceBaseUri + "model.enfermedades" + "/" + $("#idEnfermedades").val(), //se comunica con el servidor para datos actualizados
                    success: successDelete//successSave,
                });
            });
        });
    </script>
</html>

