window.onload = function () {
  var alphabet = "abcdefghijklmnopqrstuvwxyz".split("");
  var scope = angular.element(document.getElementById('wordScrambler')).scope()
  document.addEventListener("keydown", keyDown, false);
  document.addEventListener("keyup", keyUp, false);

  function keyDown(event) {
    if (event.keyCode === 8) {
      event.preventDefault();
    }
  }
  function keyUp(event) {
    var char = String.fromCharCode(event.keyCode).toLowerCase()
    if (event.keyCode === 8 || alphabet.indexOf(char) > -1) {
      if (event.keyCode === 8) {
        event.preventDefault();
        char = 'backspace'
      }
      scope.$apply(function() {
        scope.handleLetter(char);
      });
    }
  }
}
