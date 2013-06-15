#include "Tower.angelscript"
#include "TowerShoot.angelscript"
#include "TankEnemy.angelscript"

void main()
{
  LoadScene("scenes/start.esc", "StartGame", "GameLoop");
}

Tower tower;
TowerShoot towerShoot;
TankEnemy tankEnemy;

uint GameTimeElapsed = 0;
uint enemyLastTimeAdded = 0;
uint enemyInterval = 10000;
int shootInterval = 300;

void StartGame() {
  GameTimeElapsed = 0;
  enemyLastTimeAdded = 0;

  LoadSoundEffect("soundfx/tower_shoot.mp3");
  LoadSoundEffect("soundfx/explosion.mp3");
}

void GameLoop() {
  GameTimeElapsed = GetTime();
  enemyLastTimeAdded += GetLastFrameElapsedTime();

  ETHInput@ input = GetInputHandle();

  //Using GetTouchState to hangle touchscreen too :p
  if(input.GetTouchState(0) == KS_HIT) {
    AddEntity("tower.ent", vector3(input.GetCursorPos(), 0.0f), 0.0f);
  }

  // Add new enemies after 10 seconds
  if(enemyLastTimeAdded >= enemyInterval) {
    //AddEntity("enemy.ent", vector3(-4.0f, randF(GetScreenSize().y), 0.0f));
    //AddEntity("enemy.ent", vector3(-4.0f, randF(GetScreenSize().y), 0.0f));
    enemyLastTimeAdded -= enemyInterval;
  }

  towerShoot.RefreshShootsPosition();
}

//Entities Callback

void ETHCallback_tower(ETHEntity@ thisEntity) {
  tower.StartObserver(thisEntity);
}

void ETHCallback_enemy(ETHEntity@ thisEntity) {
  tankEnemy.StartMission(thisEntity);
}