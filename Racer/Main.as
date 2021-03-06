﻿
﻿package  Racer{
	
	import flash.display.*;
	import com.as3toolkit.ui.Keyboarder;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip{
		//Messy messy mess
		public static var instance:Main;
		
		var _background:Level;
		var _gameScreen:GameScreen;
		var _uiLayer:UILayer;
		
		public function Main() {
			instance = this;
			new Keyboarder(stage);
			stage.addEventListener(KeyboardEvent.KEY_UP, restartGameKey);
			//make game screen
			_uiLayer = new UILayer(null);
			_uiLayer.gotoAndStop("Main");
			addChildAt(_uiLayer,1);
			
			//startGame();
		}
		private function restartGameKey(e:KeyboardEvent){
			if(e.keyCode == Keyboard.R){
				trace("Restarting");
				this.win.visible = false;
				removeChild(_gameScreen);
				startGame();
			}
		}
		
		public function startGame(){
			
			win.visible = false;

			_background = new Level2();
			_gameScreen = new GameScreen(_background)
			_uiLayer._gameScreen = _gameScreen;
			//background = this.getChildByName("background_clip") as MovieClip;
			_gameScreen.Start();
			addChildAt(_gameScreen,0);
			_uiLayer.gotoAndStop("Game");

		}
		
		public function winDerp(){
			trace("derp");
			removeChild(_gameScreen);
			_gameScreen = null;
			_uiLayer.gotoAndStop("Win");
			//this.win.visible = !this.win.visible;
		}
		
		public function loseHerp(){
			trace("herp");
			removeChild(_gameScreen);
			_gameScreen = null;
			_uiLayer.gotoAndStop("Lose");
			//this.win.visible = !this.win.visible;
		}
	}
	
}
