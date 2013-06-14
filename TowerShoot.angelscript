class TowerShoot {
  private ETHEntityArray shootsArray;

  void Fire(ETHEntity@ tower, ETHEntity@ target) {
    const int shootId = AddEntity('shoot.ent', tower.GetPosition());
    ETHEntity@ shoot = SeekEntity(shootId);
    vector2 result = target.GetPositionXY() - tower.GetPositionXY();

    UpdateShootPosition(shoot, result*0.25f);
    InsertOnShootsArray(shoot);
    PlaySample('soundfx/tower_shoot.mp3');    
  }

  void UpdateShootPosition(ETHEntity@ shoot, const vector2 position) {
    shoot.AddToPositionXY(position);
    shoot.SetVector2('LastPosition', position);
  }

  void RefreshShootsPosition() {
	  for(uint i = 0; i < shootsArray.size(); i++) {
	    ETHEntity@ shoot = shootsArray[i];
	    
	    vector2 lastPosition = shoot.GetVector2('LastPosition');
			vector2 newPosition = lastPosition+(lastPosition*0.25f);

	    UpdateShootPosition(shoot, newPosition);
	  }  	
  }

  void RemoveShootFromArray(ETHEntity@ shoot) {
  	DeleteEntity(shoot);
    shootsArray.RemoveDeadEntities();
  }

  private void InsertOnShootsArray(ETHEntity@ shoot) {
    shootsArray.Insert(shoot);
  }
}