window.onload = function () {
  var alphabet = "abcdefghijklmnopqrstuvwxyz".split("");
  var scope = angular.element(document.getElementById('wordScrambler')).scope()
  alphabet.forEach(function(letter) {
    key(letter, function(){
      scope.$apply(function() {
        scope.handleLetter(letter);
      });
    })
  })
}
