void main()
{
	LoadScene("scenes/start.esc", "StartGame", "GameLoop");
}

uint timeElapsed = 0;
ETHEntityArray shootsArray;

void StartGame() {
  timeElapsed = 0;

  LoadSoundEffect("soundfx/tower_shoot.mp3");
  LoadSoundEffect("soundfx/explosion.mp3");
}

void GameLoop() {
  timeElapsed += GetLastFrameElapsedTime();

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
  uint white = 0xFFFFFFFF;

  ETHEntityArray entities;

  GetEntitiesAroundEntity(thisEntity, entities);

  for(uint i = 0; i < entities.size(); i++) {
    if(entities[i].GetEntityName() == 'enemy.ent') {
      if(timeElapsed >= 500 && distance(thisEntity.GetPositionXY(), entities[i].GetPositionXY()) <= 260.0f) {
        timeElapsed = 0;
        FireFromTo(thisEntity, entities[i]);
      }
    }
  }
}

void FireFromTo(ETHEntity@ tower, ETHEntity@ enemy) {
  float speed = UnitsPerSecond(30.0f);  
  const int shootId = AddEntity('shoot.ent', vector3(tower.GetPositionXY().x, tower.GetPositionXY().y, 1.0f));
  ETHEntity@ shoot = SeekEntity(shootId);

  vector2 result = enemy.GetPositionXY() - tower.GetPositionXY();
  
  shoot.AddToPositionXY(result*0.25f);
  shoot.SetVector2('LastPosition', result*0.25f);

  shootsArray.Insert(shoot);
  PlaySample('soundfx/tower_shoot.mp3');
}