function holaMundo() {
    alert('Ya no se usa')
}//Obsoleto, Solo se usa en emergencias y no se usa en CallBack

const tituloXD = document.getElementById('tituloXD');

//tituloXD.addEventListener('eventName', eventHandler)//Nombre del evento, CallBack
tituloXD.addEventListener('click', () => {
    alert('Nueva Forma');
})//Funciones con parametro

const tituloXD2 = document.getElementById('tituloXD2'),
    HolaXD2 = text => alert(text);
HolaXDSinParametro = () => alert('Sin Parametro');

/*    document.querySelector('button').addEventListener('click', () => {
        HolaXD2('Con Parametro');
 /*   })//Funciones con parametro*/

document.querySelector('button').addEventListener('click', HolaXDSinParametro);

//Origen del DOM
const tituloXD3 = document.getElementById('tituloXD3');
tituloXD3.addEventListener('click', e => {
    //console.log(e.target);//html
    console.log(e.target.textContent);//Mas especifico
})//Funciones con parametro

//Eventos del Raton
const tituloXD4 = document.getElementById('tituloXD4'),
    Holanda = e => console.log(e.target.textContent),
    saliXD = () => console.log('SaliXD'),
    EntreXD = () => console.log('EntreXD');

const createMenu = e => {
    const menu = document.createElement('div')
    const prevMenu = document.getElementById('divMenuContex')
    menu.id = 'divMenuContex'
    menu.textContent = 'soy el menu'

    if (prevMenu) {
        document.body.removeChild(prevMenu)
    }

    document.body.appendChild(menu)

    menu.style.padding = '1em'
    menu.style.background = '#eee'
    menu.style.position = 'fixed'
    menu.style.top = `${e.pageY}px`
    menu.style.left = `${e.pageX}px`
}

tituloXD4.addEventListener('dblclick', e => Holanda(e));
tituloXD4.addEventListener('mouseenter', EntreXD);
tituloXD4.addEventListener('mouseleave', saliXD);
//Prevenir un evento
//tituloXD4.addEventListener('contextmenu', e => {
document.addEventListener('contextmenu', e => {
    createMenu(e)
    e.preventDefault();//Previene el evento
});

//Eventos del teclado
const txtKeyDown = document.getElementById('txtKeyDown')

//txtKeyDown.addEventListener('keydown', e => {
txtKeyDown.addEventListener('keyup', e => {
    console.log(e)
    if (e.key === 'a' && e.ctrlKey === true) {
        e.preventDefault();
        alert('Control + a')
    }
});

let x = 0, y = 0;
addEventListener('keyup', e => {
    const ball = document.getElementById('ball');

    const move = direction => {
        switch (direction) {
            case 'up':
                y--
                break;
            case 'down':
                y++
                break;
            case 'right':
                x++
                break;
            case 'left':
                x--
                break;
            default:
                break;
        }
        ball.style.transform = `translate(${x*10}px,${y*10}px)`
    }

    switch (e.key) {
        case 'ArrowUp':
            move('up')
            break;
        case 'ArrowDown':
            move('down')
            break;
        case 'ArrowRight':
            move('right')
            break;
        case 'ArrowLeft':
            move('left')
            break;

        default:
            break;
    }
})