class Tower {

  void StartObserver(ETHEntity@ thisEntity) {
    ETHEntityArray entities;
    GetEntitiesAroundEntity(thisEntity, entities);

    for(uint i = 0; i < entities.size(); i++) {
      if(IsEnemy(entities[i]) && EnemySpoted(thisEntity, entities[i]) && CanFire(thisEntity)) {
        Fire(thisEntity, entities[i]);
      }
    }
  }

  void Fire(ETHEntity@ tower, ETHEntity@ target) {
    tower.SetUInt('LastShootTime', GameTimeElapsed);
    towerShoot.Fire(tower, target);
  }

  bool EnemySpoted(ETHEntity@ tower, ETHEntity@ target) {
    return (distance(tower.GetPositionXY(), target.GetPositionXY()) <= 260.0f);
  }

  bool CanFire(ETHEntity@ tower) {
    uint lastShootTime = tower.GetUInt('LastShootTime');    
    return (lastShootTime <= 0 || ((GameTimeElapsed - lastShootTime) >= shootInterval));
  }

  bool IsEnemy(ETHEntity@ target) {
    return target.GetEntityName() == 'enemy.ent';
  }
}