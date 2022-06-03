const title3 = document.getElementById('titulo2'),
        tituloH2 = document.querySelector('h2'),
        parrafoH2 = document.querySelector('p'),
     title4 = document.getElementById('titulo2');
console.log(title3.getAttribute('class'));
if (title3) {
    title3.style.background = 'gainsboro';
}
console.log('Cuidado con los Nulls');

title4.setAttribute('id', 'SobreEscribe?')//Lo asigna y lo sobreescribe

// No se cual es y lo mando llamar por elemento
tituloH2.id = 'th2';
// Muestro en Consola
console.log('=====>>>*******<<<<<<========');
console.log(tituloH2.classList);
console.log(parrafoH2.classList);
parrafoH2.classList.add('Class-1','Class-3'); //Ojo Se lo pone al primer p
console.log('=====>>>****Contenido***<<<<<<========');
console.log(tituloH2.textContent);//Devuelve solo texto Recomendado
console.log(tituloH2.innerHTML);//El texto en html, invento de IE
console.log(tituloH2.outerHTML);//Devuelve etiqueta con contenido
tituloH2.textContent = 'Hola XD'; //Sobre escribe con texto
tituloH2.innerHTML = `Hola <em>XDDD</em>`; //Inyecta con html
console.log('=====>>>****Crear Elementos***<<<<<<========');

const profe = document.createElement('h3');

profe.textContent = 'Voy a modificar el DOM';
profe.classList.add('profe');
profe.id = 'teacher';

document.body.appendChild(profe);//Loo crea hasta el final de la hoja

/////// Jugando con el DOM

const tituloLista = document.getElementById('Agregando'),
    divListaToda = document.getElementById('divListaToda'),
    listV34 = document.getElementById('listV34'),
    nameLista = document.createElement('p'),
    listaCompleta = document.createElement('ul'),
    listaElemto = document.createElement('li');
    ;

    nameLista.textContent = 'Lista de X';
    nameLista.classList.add('cLista');
    listaCompleta.innerHTML = `<li>XD</li>
                                <li>SD</li>
                                <li>AM</li>`;
    listaElemto.textContent = 'Ultimo YEA';                          


    if (tituloLista && tituloLista.querySelector('span')) {
        tituloLista.querySelector('span').appendChild(nameLista);
    }

    if (divListaToda) {
        divListaToda.appendChild(listaCompleta);
    }

    if (listV34) {
        listV34.appendChild(listaElemto);
    }