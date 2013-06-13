void main()
{
	LoadScene("scenes/start.esc", "StartGame", "GameLoop");
}

uint timeElapsed = 0;
uint enemyLastTimeAdded = 0;
uint enemyInterval = 10000;
ETHEntityArray shootsArray;

void StartGame() {
  timeElapsed = 0;
  enemyLastTimeAdded = 0;

  LoadSoundEffect("soundfx/tower_shoot.mp3");
  LoadSoundEffect("soundfx/explosion.mp3");
}

void GameLoop() {
  timeElapsed = GetTime();
  enemyLastTimeAdded += GetLastFrameElapsedTime();

  ETHInput@ input = GetInputHandle();

  //Using GetTouchState to hangle touchscreen too :p
  if(input.GetTouchState(0) == KS_HIT) {
    AddEntity("tower.ent", vector3(input.GetCursorPos(), 0.0f), 0.0f);
  }

  // Add new enemies after 10 seconds
  if(enemyLastTimeAdded >= enemyInterval) {
    AddEntity("enemy.ent", vector3(-4.0f, randF(GetScreenSize().y), 0.0f));
    AddEntity("enemy.ent", vector3(-4.0f, randF(GetScreenSize().y), 0.0f));
    enemyLastTimeAdded -= enemyInterval;
  }

  // Update shoot entity position
  for(uint i = 0; i < shootsArray.size(); i++) {
    ETHEntity@ currentShoot = shootsArray[i];

    vector2 lastPosition = currentShoot.GetVector2('LastPosition');

    vector2 newPosition = lastPosition+(lastPosition*0.25f);
    
    currentShoot.AddToPositionXY(newPosition);
    currentShoot.SetVector2('LastPosition', newPosition);
  }
}

void ETHCallback_enemy(ETHEntity@ thisEntity) {
  float speed = UnitsPerSecond(20.0f);
  float enemyRadius = 10.0f;
  float shootRadius = 2.0f;

  ETHEntityArray entities;

  thisEntity.AddToPositionX(speed);

  GetEntitiesAroundEntity(thisEntity, entities);

  for(uint i = 0; i < entities.size(); i++) {
    ETHEntity@ shoot = entities[i];

    if(shoot.GetEntityName() == 'shoot.ent') {
      float dist = distance(thisEntity.GetPositionXY(), shoot.GetPositionXY());

      //Shoot on target
      if(dist < enemyRadius + shootRadius) {
        //Decrease target resistence
        thisEntity.AddToInt('resistence', -1);

        //When target resistence is less or equal 0
        if(thisEntity.GetInt('resistence') <= 0) {
          //Target destroyed ;)
          PlaySample('soundfx/explosion.mp3');
          DeleteEntity(thisEntity);
        }

        //Remove shoot entity
        DeleteEntity(shoot);
        shootsArray.RemoveDeadEntities();
      }
    }
  }
}

void ETHCallback_tower(ETHEntity@ thisEntity) {
  ETHEntityArray entities;

  GetEntitiesAroundEntity(thisEntity, entities);

  for(uint i = 0; i < entities.size(); i++) {
    if(entities[i].GetEntityName() == 'enemy.ent') {
      
      uint lastShootTime = thisEntity.GetUInt('LastShootTime');
      
      if(distance(thisEntity.GetPositionXY(), entities[i].GetPositionXY()) <= 260.0f) {
        if(lastShootTime <= 0 || ((timeElapsed - lastShootTime) >= 500)) {
          thisEntity.SetUInt('LastShootTime', timeElapsed);
          FireFromTo(thisEntity, entities[i]);
        }
      }
    }
  }
}

void FireFromTo(ETHEntity@ tower, ETHEntity@ enemy) {
  const int shootId = AddEntity('shoot.ent', vector3(tower.GetPositionXY().x, tower.GetPositionXY().y, 1.0f));
  ETHEntity@ shoot = SeekEntity(shootId);

  vector2 result = enemy.GetPositionXY() - tower.GetPositionXY();
  
  shoot.AddToPositionXY(result*0.25f);
  shoot.SetVector2('LastPosition', result*0.25f);

  shootsArray.Insert(shoot);
  PlaySample('soundfx/tower_shoot.mp3');
}