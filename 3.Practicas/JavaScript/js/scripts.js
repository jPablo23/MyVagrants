//console.log(document.getElementById('titulo'));
const title = document.getElementById('titulo'); //Buena Practica
const title2 = document.querySelector('#titulo'); //Solo usar en una emergencia
const listItems = document.querySelectorAll('ul li');//Devuelve una lista
const listItems2 = document.querySelector('ul li:nth-child(2)');//Devuelve el objeto
const       list = document.getElementById('list1');

title.style.background = 'yellow';

console.log(title);
console.log(title2);
console.log(listItems[0]);
console.log(listItems2);
console.log(list.querySelector('li:last-child'));
console.log('=======>*********<==========');

const nodelist = document.querySelectorAll('li'),//Nunca te devuelve un array
        nodelistArray = Array.from(document.querySelectorAll('li')),//Convierte en un array
    elementHTML = document.getElementsByTagName('li');

    nodelistArray.map( el => el.style.background = 'green');
    nodelistArray.map( el => {
        if(el.textContent.trim().toUpperCase() === 'OBJECT'){
            el.remove()
        }
    });



console.log(nodelist);
console.log(elementHTML);

console.log('=======>Con For<==========');
for (let el of nodelistArray) {
    if(el.textContent.trim().toUpperCase() === 'MODEL'){
        el.remove()
    }
    
}