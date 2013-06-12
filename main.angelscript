void main()
{
	LoadScene("scenes/start.esc", "StartGame", "GameLoop");
}

uint timeElapsed = 0;
ETHEntityArray shootsArray;

void StartGame() {
  timeElapsed = 0;
}

void GameLoop() {
  timeElapsed += GetLastFrameElapsedTime();

  for(uint i = 0; i < shootsArray.size(); i++) {
    ETHEntity@ currentShoot = shootsArray[i];

    vector2 lastPosition = currentShoot.GetVector2('LastPosition');

    currentShoot.AddToPositionXY((lastPosition+(lastPosition*0.25f)));
    currentShoot.SetVector2('LastPosition', currentShoot.GetPositionXY());
  }
}

void ETHCallback_enemy(ETHEntity@ thisEntity) {
  float speed = UnitsPerSecond(20.0f);

  thisEntity.AddToPositionX(speed);
}

void ETHCallback_tower(ETHEntity@ thisEntity) {
  uint white = 0xFFFFFFFF;

  ETHEntityArray entities;

  GetEntitiesAroundEntity(thisEntity, entities);

  for(uint i = 0; i < entities.size(); i++) {
    if(entities[i].GetEntityName() == 'enemy.ent') {
      if(timeElapsed >= 200 && distance(thisEntity.GetPositionXY(), entities[i].GetPositionXY()) <= 260.0f) {
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
}