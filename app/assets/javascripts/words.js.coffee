WordsCtrl = ($scope, $http, $timeout, $modal) ->
  $scope.word = []
  $scope.allLetters = []
  $scope.typedLetters = []
  $scope.gameState = "new"
  $scope.score = 0
  $scope.time = 60

  $scope.letters = []

  $scope.handleLetter = (letter) ->
    return if $scope.time == 0
    if letter == 'backspace'
      $scope.typedLetters.pop()
      return
    possibleLetters = $scope.allLetters.slice(0)
    for chr in $scope.typedLetters
      indexOfLetter = possibleLetters.indexOf(chr)
      possibleLetters.splice(indexOfLetter, 1)
    return if letter not in possibleLetters
    indexOfLetter = possibleLetters.indexOf(letter)
    possibleLetters.splice(indexOfLetter, 1)

    $scope.typedLetters.push(letter)
    if $scope.typedLetters.length == $scope.allLetters.length
      if $scope.typedLetters.join('') == $scope.word.join('')
        $scope.gameState = "won"
      else
        $scope.gameState = "lost"
      $timeout($scope.resetGuess, 500)
    else
      $scope.letters = $scope.typedLetters.concat(possibleLetters)

  $scope.resetGuess = ->
    if $scope.gameState == "lost"
      $scope.resetWord()
    else if $scope.gameState == "won"
      $scope.score += 5
      $scope.newWord()
    $scope.gameState = "new"

  $scope.resetWord = ->
    $scope.typedLetters = []
    $scope.letters = $scope.allLetters.slice(0)

  $scope.newWord = ->
    req = {
      method: 'GET'
      url: 'https://wordsapiv1.p.mashape.com/words/?frequencymin=2.5&letterpattern=%5E%5Ba-z%5D*%24&lettersMax=6&lettersmin=4&random=true'
      headers: {"X-Mashape-Key": "CZGUyo80scmsh2I2TyVX5aGINQCXp16IMwNjsnHuTuyEJYOrIc", "Accept": "application/json"}
    }
    $http(req).success((data) -> $scope.setWord(data.word))

  $scope.setWord = (word) ->
      $scope.word = word.toLowerCase().split("")
      $scope.allLetters = $scope.shuffle($scope.word.slice(0))
      $scope.typedLetters = []
      $scope.letters = $scope.allLetters.slice(0)
      $scope.gameState = "new"

  $scope.timer = ->
    if $scope.time == 0
      $scope.openModal()
      return
    $scope.time -= 1
    $timeout($scope.timer, 1000)

  $scope.shuffle = (array) ->
    i = array.length
    while --i > 0
        j = ~~(Math.random() * (i + 1))
        t = array[j]
        array[j] = array[i]
        array[i] = t
    array

  $scope.newGame = ->
    $scope.time = 60
    $scope.score = 0
    $scope.newWord()
    $timeout($scope.timer, 1000)

  $scope.openModal = () ->
    modalInstance = $modal.open(
      animation: true
      controller: 'ModalCtrl'
      template: "<div class=\"modal-header\">
            <h3 class=\"modal-title\">You scored {{score}} points!</h3>
        </div>
        <div class=\"modal-footer\">
            <button class=\"btn btn-primary\" ng-click=\"ok()\">Play again!</button>
        </div>"
      resolve: {score: -> $scope.score}
    )

    modalInstance.result.then(-> $scope.newGame())

  $scope.newGame()

ModalCtrl = ($scope, $modalInstance, score) ->
  $scope.score = score
  $scope.ok = ->
    $modalInstance.close()
    return


angular.module('app', ['ui.bootstrap']).controller('WordsCtrl', ['$scope', '$http', '$timeout', '$modal', WordsCtrl])
angular.module('ui.bootstrap').controller('ModalCtrl', ['$scope', '$modalInstance', 'score', ModalCtrl])
