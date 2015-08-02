WordsCtrl = ($scope) ->
  $scope.word = "hello".split("")
  $scope.allLetters = "hello".split("")
  $scope.typedLetters = []

  $scope.letters = "hello".split("")

  $scope.handleLetter = (letter) ->
    possibleLetters = $scope.allLetters.slice(0)
    for chr in $scope.typedLetters
      indexOfLetter = possibleLetters.indexOf(chr)
      possibleLetters.splice(indexOfLetter, 1)
    return if letter not in possibleLetters
    indexOfLetter = possibleLetters.indexOf(letter)
    possibleLetters.splice(indexOfLetter, 1)

    $scope.typedLetters.push(letter)
    if $scope.typedLetters.length == $scope.allLetters.length
      $scope.resetGuess()
    else
      $scope.letters = $scope.typedLetters.concat(possibleLetters)

  $scope.resetGuess = ->
    $scope.typedLetters = []
    $scope.letters = $scope.allLetters.slice(0)


angular.module('app', []).controller('WordsCtrl', ['$scope', WordsCtrl])
