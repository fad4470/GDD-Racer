﻿package  Racer{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class GameScreen extends Sprite{

		var carLayer:CarLayer;
		var _buildingLayer:BuildingLayer;
		var _player:Player;
		var _backgroundClip:MovieClip;
		var uiLayer:UILayer;
		var _translationContainer:MovieClip;
		var _rotationContainer:MovieClip;

		public function GameScreen(/*backgroundClip:MovieClip*/) {
			//trace("BACKGROUND : " + backgroundClip);
			//this._backgroundClip = backgroundClip;

		public function GameScreen(backgroundClip:MovieClip) {
			this._backgroundClip = backgroundClip;
			_translationContainer = new MovieClip();
			_rotationContainer = new MovieClip();
			_rotationContainer.addChild(_translationContainer);
			super.addChild(_rotationContainer);

		}
		
		public function init(){
			_buildingLayer = new BuildingLayer(this);
			addChild(_buildingLayer);
			
			carLayer = new CarLayer(this);
			addChild(carLayer);

			_player = new Player();
			super.addChild(_player);
			

			
			//uiLayer = new UILayer(this);

			
			//buildingLayer.init();

			carLayer.init();
			//_buildingLayer.init();

			//uiLayer.init();
			//addChild(BuildingLayer);
			//addChild(uiLayer);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event){
			player.update();
			carLayer.update();
			moveCamera();
		}
		
		private function moveCamera(){

			var camPos:Point = new Point(-_player.position.x + stage.stageWidth/2, -_player.position.y + stage.stageHeight/2);
			_buildingLayer.x = carLayer.x = /*_backgroundClip.x = */camPos.x;
			_buildingLayer.y = carLayer.y = /*_backgroundClip.y = */camPos.y;

			/*var camPos:Point = new Point(-_player.position.x + stage.stageWidth/2, -_player.position.y + stage.stageHeight/2);
			_buildingLayer.x = carLayer.x = _backgroundClip.x = camPos.x;
			_buildingLayer.y = carLayer.y = _backgroundClip.y = camPos.y;

			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_player.rotation = _player.rot;
			this.rotation = -_player.rot-90;*/
			
			_translationContainer.x = -_player.position.x;
			_translationContainer.y = -_player.position.y;
			this.x = stage.stageWidth/2;
			this.y = stage.stageHeight/2;
			_rotationContainer.rotation = -_player.rot - 90;
			_player.rotation = -90;
			//_player.x = _player.position.x;
			//_player.y = _player.position.y;
			//_player.rotation = _player.rot;
		}
		
		
		public function get player():Player { return _player; }
	
		public override function addChild(child:DisplayObject):DisplayObject{
			return this._translationContainer.addChild(child);
		}

	}
	
}
