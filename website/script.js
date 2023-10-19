function opadajacaSzczeke() {
    var h1 = document.querySelector('h1');
    h1.style.animation = 'jawDrop 1s linear 1';
}

// Wywołanie funkcji po załadowaniu strony
window.onload = function() {
    opadajacaSzczeke();
}
