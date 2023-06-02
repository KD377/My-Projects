var player = document.getElementById('player');
var points = 0;
var lives=3;
var shotSpeed = 1;
var currentEnemies;
var maxEnemies=6;
var countCall;
var isBegin;
var isOver = false;
var isLeft = [];
var enemies = [];
var enemyColor = ["#f54e42", "#f5e149","#49f54f","#49f5ea", "#4248f5", "#fc03ec"];
var rightInterval;
var leftInterval;
var moveInterval;
var beginInterval;
var overInterval;
var shots = document.getElementById('shots');
var info = document.getElementById('info');
var enemyShots = document.getElementById('enemyShots');
var enemiesGr = document.getElementById('enemies');
var svg = document.getElementById('svg');
var score = document.getElementById('score');
var offset=0;
var spawnOffset=0;

let shotSound= new Audio('shot.mp3');
shotSound.preload = 'auto';

let gameSound= new Audio('graTlo.mp3');
gameSound.preload = 'auto';

let pointSound= new Audio('point.mp3');
pointSound.preload = 'auto';

let deathSound= new Audio('death.mp3');
deathSound.preload = 'auto';

let menuSound= new Audio('menu.mp3');
menuSound.preload = 'auto';

function playSound(sound, volume) {
  var click = sound.cloneNode();
  click.volume = volume;
  click.play();
  return click;
}

function random (minInt, maxInt) {
  return Math.floor(Math.random() * (maxInt - minInt)) + minInt;
}

function playerShot(x) {
  var item = document.createElementNS("http://www.w3.org/2000/svg", "rect");
  item.x.baseVal.value = x + 14;
  item.y.baseVal.value = 334;
  item.width.baseVal.value = 2;
  item.height.baseVal.value = 10;
  item.style.fill = "#fc6f03";
  shots.appendChild(item);
  return item;
}

function enemyShot(enemy) {
  var item = document.createElementNS("http://www.w3.org/2000/svg", "rect");
  item.x.baseVal.value = enemy.x.baseVal.value + 19;
  item.y.baseVal.value = enemy.y.baseVal.value + 10;
  item.width.baseVal.value = 2;
  item.height.baseVal.value = 10;
  item.style.fill = enemy.style.fill;
  enemyShots.appendChild(item);
  return item;
}

function playerColision(shot) {
  var isHit = false;
    var area = (shot.x.baseVal.value >= player.x.baseVal.value) && (shot.x.baseVal.value <= player.x.baseVal.value + player.width.baseVal.value);
    if (shot.y.baseVal.value + shot.height.baseVal.value <= player.y.baseVal.value + player.height.baseVal.value &&
      (shot.y.baseVal.value >= player.y.baseVal.value) && area) {
      isHit=true
      enemyShots.removeChild(shot);
      if(lives > 0 && isBegin == false){
        lives--;
        document.getElementById('lives').textContent = lives;
      }
    }
  return isHit;
}

function enemyFire(index) {
  var thisShot = enemyShot(enemies[index]);
  var interval = setInterval(function(){
    thisShot.y.baseVal.value += shotSpeed;
    if(thisShot.y.baseVal.value == 360)
    {
      clearInterval(interval);
      enemyShots.removeChild(thisShot);
    }
    else if(playerColision(thisShot)){
      clearInterval(interval);
    }
  },5);
}

function killEnemy(index) {
  enemiesGr.removeChild(enemies[index]);
  enemies[index] = null;
  currentEnemies -=1;
}

function shotColision(shot) {
  var isHit = false;
  for(var i = maxEnemies - 1; i >= 0; i--) {
    var en = enemies[i];
    if(en == null) continue;
    var area = (shot.x.baseVal.value >= en.x.baseVal.value) && (shot.x.baseVal.value <= en.x.baseVal.value + en.width.baseVal.value);
    if (shot.y.baseVal.value <= en.y.baseVal.value + en.height.baseVal.value &&
      (shot.y.baseVal.value >= en.y.baseVal.value) && area) {
      isHit=true
      playSound(pointSound,0.6);
      points += 15;
      if(lives > 0)
        document.getElementById('score').textContent = points;
      shots.removeChild(shot);
      killEnemy(i);
      break;
    }
  }
  return isHit;
}

function shot() {
  var thisShot = playerShot(player.x.baseVal.value);
  var interval = setInterval(function(){
    thisShot.y.baseVal.value -= shotSpeed;
    if(thisShot.y.baseVal.value == 40)
    {
      clearInterval(interval);
      shots.removeChild(thisShot);
    }
    else if (shotColision(thisShot)) {
      clearInterval(interval);
    }
  },5);
}

function movePlayerRight() {
  rightInterval = setInterval(function(){
    if (player.x.baseVal.value < 508)
      player.x.baseVal.value += 2;
    else if (player.x.baseVal.value >= 508) {
      clearInterval(rightInterval);
    }
  },5)
}

function movePlayerLeft() {
  leftInterval = setInterval(function(){
    if(player.x.baseVal.value > 60)
      player.x.baseVal.value -= 2;
    else if(player.x.baseVal.value <= 60)
    {
      clearInterval(leftInterval);
    }
  },5)
}

function spawnEnemy(index) {
  var enemy = document.createElementNS("http://www.w3.org/2000/svg", "rect");
  var randomx = random(60,441);
  var randomy = random(50,123);
  currentEnemies += 1;
  enemy.x.baseVal.value = randomx;
  enemy.y.baseVal.value = randomy;
  enemy.width.baseVal.value = 40;
  enemy.height.baseVal.value = 12;
  enemy.style.stroke = "#000000";
  enemy.style.fill = enemyColor[index];
  enemies[index]=enemy;
  enemiesGr.appendChild(enemy);
  return enemy;
}

function moveEnemy(index){
  if(enemies[index] == null)
    return;
  var en = enemies[index];
  if(isLeft[index] == false)
    en.x.baseVal.value += 1;
  else if (isLeft[index] == true) {
    en.x.baseVal.value -= 1;
  }

  if (en.x.baseVal.value >= 500)
    isLeft[index] = true;
  else if (en.x.baseVal.value <= 60) {
    isLeft[index] = false;
  }
}

function gameOver(){
  isOver = true;
  deathSound.play();
  menuSound.play();
  menuSound.volume = 0.6;
  var count = 0;
  document.getElementById('gameOver').style.fill = "#FFFFFF";
  document.getElementById('gameOver1').style.fill = "#FFFFFF";
  document.getElementById('collectedPoints').textContent = points;
  document.getElementById('collectedPoints').style.fill = "#FFFFFF";
  document.getElementById('playAgain').style.fill = "#FFFFFF";
  document.getElementById('gameBoard').style.opacity = "0.3";
  overInterval = setInterval(function(){
    rand=random(0,6);
    if(count == 2) count =0;
    count++;
    document.getElementById('title').style.fill = enemyColor[rand];
    if(count%2 == 0)
      document.getElementById('gameOver').style.fill = "#FFFFFF";
    else {
      document.getElementById('gameOver').style.fill = "#f54e42";
    }
  },500)
}

function begin() {
  isBegin=true;
  var rand;
  var m=0;
  var e;
  document.getElementById('welcome').style.fill = "#FFFFFF";
  document.getElementById('welcome1').style.fill = "#FFFFFF";
  document.getElementById('play').style.fill = "#FFFFFF";
  document.getElementById('gameBoard').style.opacity = "0.3";
  menuSound.play();
  menuSound.volume = 0.6;
  beginInterval = setInterval(function(){
    if(m == 6) {
      m=0;
    }
    if(enemies[m] != null)
      killEnemy(m);
    spawnEnemy(m);
    for(var k = 0; k < 6; k++){
      if(enemies[k] != null)
        enemyFire(k);
    }
    rand=random(0,6);
    document.getElementById('title').style.fill = enemyColor[rand];
    m++;
  },500)
}

function start() {
  menuSound.pause();
  menuSound.currentTime = 0;
  for(var i = 0; i < 6; i++){
    if(enemies[i] != null)
      killEnemy(i);
  }
  var rand;
  var music;
  isBegin = false;
  isOver = false;
  points = 0;
  lives = 3;
  shotSpeed = 1;
  currentEnemies = 0;
  maxEnemies = 6;
  spawnOffset=0;
  offset=0;
  document.getElementById('welcome').style.fill = "transparent";
  document.getElementById('welcome1').style.fill = "transparent";
  document.getElementById('play').style.fill = "transparent";
  document.getElementById('gameBoard').style.opacity = "1";
  document.getElementById('gameOver').style.fill = "transparent";
  document.getElementById('gameOver1').style.fill = "transparent";
  document.getElementById('collectedPoints').style.fill = "transparent";
  document.getElementById('playAgain').style.fill = "transparent";
  document.getElementById('lives').textContent = lives;
  for(var i = 0; i < 6; i++){
    spawnEnemy(i);
    rand = random(0,6);
    if(rand%2 == 0)
      isLeft[i] = false;
    else {
      isLeft[i] = true;
    }
  }
    gameSound.play();
    gameSound.volume=0.2;
    moveInterval = setInterval(function(){
    offset++;
    spawnOffset++;
    if(lives == 0){
      clearInterval(moveInterval);
      gameSound.pause();
      gameSound.currentTime =0;
      gameOver();
    }
    if(offset ==81) offset=0;
    if(spawnOffset==200) spawnOffset=0;
    if(offset == 40 || offset == 80) {
      rand=random(0,6);
      document.getElementById('title').style.fill = enemyColor[rand];
    }
    if(enemies[0] != null){
      moveEnemy(0);
      if(offset == 1){
        enemyFire(0);
      }
    }
    else if(enemies[0] == null && spawnOffset == 100){
      spawnEnemy(0);
    }
    if(enemies[1] != null){
      moveEnemy(1);
      if(offset == 15){
        enemyFire(1);
      }
    }
    else if(enemies[1] == null && spawnOffset == 100){
      spawnEnemy(1);
    }
    if(enemies[2] != null){
      moveEnemy(2);
      if(offset == 30){
        enemyFire(2);
      }
    }
    else if(enemies[2] == null && spawnOffset == 100){
      spawnEnemy(2);
    }
    if(enemies[3] != null){
      moveEnemy(3);
      if(offset == 45){
        enemyFire(3);
      }
    }
    else if(enemies[3] == null && spawnOffset == 100){
      spawnEnemy(3);
    }
    if(enemies[4] != null){
      moveEnemy(4);
      if(offset == 60){
        enemyFire(4);
      }
    }
    else if(enemies[4] == null && spawnOffset == 100){
      spawnEnemy(4);
    }
    if(enemies[5] != null){
      moveEnemy(5);
      if(offset == 75){
        enemyFire(5);
      }
    }
    else if(enemies[5] == null && spawnOffset == 100){
      spawnEnemy(5);
    }
  },10);
}

window.addEventListener("load",begin());

window.addEventListener('keydown', (event)=>{
  switch (event.key) {
    case 'ArrowLeft':
      if(player.x.baseVal.value > 60) {
        if (countCall == 0){
          clearInterval(rightInterval);
          clearInterval(leftInterval);
          movePlayerLeft();
          countCall += 1;
        }
      } break;
    case 'ArrowRight':
      if(player.x.baseVal.value < 508){
        if (countCall == 0)
        {
          clearInterval(rightInterval);
          clearInterval(leftInterval);
          movePlayerRight();
          countCall +=1;
        }
      } break;
      case ' ':
        if(isBegin == true){
          clearInterval(beginInterval);
          setTimeout(start(),3000);
        }
        else{
          playSound(shotSound,0.1);
          shot();
          break;
        }
      case 'r':
        clearInterval(moveInterval);
        clearInterval(overInterval);
        start();
        break;
  }
})

window.addEventListener('keyup',(event)=>{
  switch(event.key){
    case 'ArrowLeft': clearInterval(leftInterval); countCall = 0; break;
    case 'ArrowRight': clearInterval(rightInterval); countCall = 0; break;
  }
})
