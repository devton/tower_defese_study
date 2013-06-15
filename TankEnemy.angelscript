class TankEnemy {
  private float enemyRadius = 10.0f;
  private float shootRadius = 2.0f;

  void StartMission(ETHEntity@ tank) {
    MoveToX(tank);
    FireZone(tank); 
  }

  void MoveToX(ETHEntity@ tank) {
    float speed = UnitsPerSecond(20.0f);
    tank.AddToPositionX(speed);
  }

  void FireZone(ETHEntity@ tank) {
    ETHEntityArray entities;
    GetEntitiesAroundEntity(tank, entities);

    for(uint i = 0; i < entities.size(); i++) {
      ETHEntity@ shoot = entities[i];

      if(IsShoot(entities[i])) {        
        if(ShootHit(tank, entities[i])) {
          TankReached(tank, entities[i]);
        }
      }
    }   
  }

  bool IsShoot(ETHEntity@ entity) {
    return entity.GetEntityName() == 'shoot.ent';
  }

  bool ShootHit(ETHEntity@ tank, ETHEntity@ shoot) {
    float dist = distance(tank.GetPositionXY(), shoot.GetPositionXY());
    return dist < enemyRadius + shootRadius;
  }

  void TankReached(ETHEntity@ tank, ETHEntity@ shoot) {
    tank.AddToInt('resistence', -1);

    if(tank.GetInt('resistence') <= 0)
      TankDown(tank);

    towerShoot.RemoveShootFromArray(shoot);    
  }

  void TankDown(ETHEntity@ tank) {
    PlaySample('soundfx/explosion.mp3');
    DeleteEntity(tank);
  }
}
