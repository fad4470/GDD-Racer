﻿package  Racer{
	
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import com.as3toolkit.ui.Keyboarder;
	import flash.geom.Point;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2Math;
	import flash.utils.Dictionary;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2DebugDraw;
	import flash.display.Sprite;
	import Box2D.Dynamics.Joints.b2Joint;
	
	public class Player extends PhysicalClip {
		
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		private var _rot:Number = 0;	
		
		private var _wheels:Dictionary;
		private var _flJoint:b2RevoluteJoint;
		private var _frJoint:b2RevoluteJoint;
		
		public function Player() {
		}
		
		protected override function setupPhys() {
			_bodyDef = new b2BodyDef();
			_bodyDef.type = b2Body.b2_dynamicBody;
			
			_fixtureDef = new b2FixtureDef();
			
			_body = _world.CreateBody(_bodyDef);			
			
			_shape = new b2PolygonShape();
			(_shape as b2PolygonShape).SetAsBox(this.width / 2 / GameScreen.SCALE, this.height / 2 / GameScreen.SCALE);
			_fixtureDef.shape = _shape;
			_fixtureDef.density = 0.3;
			_fixture = _body.CreateFixture(_fixtureDef);
			

			var maxForwardSpeed:Number = 150;
			var maxBackwardSpeed:Number = -40;
			var frontTireMaxDrive:Number = 40;
			var backTireMaxDrive:Number = 10;
			var frontLateral:Number = 8.5;
			var backLateral:Number = 7.5;
			
			_wheels = new Dictionary();
			var flWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			flWheel.setCharacteristics(maxForwardSpeed, maxBackwardSpeed, frontTireMaxDrive, frontLateral);
			var frWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			frWheel.setCharacteristics(maxForwardSpeed, maxBackwardSpeed, frontTireMaxDrive, frontLateral);
			var blWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			blWheel.setCharacteristics(maxForwardSpeed, maxBackwardSpeed, backTireMaxDrive, backLateral);
			var brWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			brWheel.setCharacteristics(maxForwardSpeed, maxBackwardSpeed, backTireMaxDrive, backLateral);
			
			_wheels[0] = flWheel;
			_wheels[1] = frWheel;
			_wheels[2] = blWheel;
			_wheels[3] = brWheel;
			
			flWheel.setPosition(this.x+this.width/2, this.y-this.height/2);
			frWheel.setPosition(this.x+this.width/2, this.y+this.height/2);
			blWheel.setPosition(this.x-this.width/2, this.y-this.height/2);
			brWheel.setPosition(this.x-this.width/2, this.y+this.height/2);
			
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.bodyA = _body;
			jointDef.enableLimit = true;
			jointDef.lowerAngle = 0;//with both these at zero...
			jointDef.upperAngle = 0;//...the joint will not move
			jointDef.localAnchorB.SetZero();//joint anchor in tire is always center
			
			jointDef.localAnchorA.Set(this.width/2/GameScreen.SCALE, -this.height/2/GameScreen.SCALE); //Front left
			jointDef.bodyB = _wheels[0].body;
			_flJoint = _world.CreateJoint(jointDef) as b2RevoluteJoint;
			
			jointDef.localAnchorA.Set(this.width/2/GameScreen.SCALE, this.height/2/GameScreen.SCALE); //Front right
			jointDef.bodyB = _wheels[1].body;
			_frJoint = _world.CreateJoint(jointDef) as b2RevoluteJoint;
			
			jointDef.localAnchorA.Set(-this.width/2/GameScreen.SCALE, -this.height/2/GameScreen.SCALE); //Back left
			jointDef.bodyB = _wheels[2].body;
			_world.CreateJoint(jointDef);
			jointDef.localAnchorA.Set(-this.width/2/GameScreen.SCALE, this.height/2/GameScreen.SCALE); //Back right
			jointDef.bodyB = _wheels[3].body;
			_world.CreateJoint(jointDef);
			
			/*var fWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			var bWheel:Wheel = new Wheel(_world,this.width/6, this.height/6);
			
			fWheel.setPosition(this.x+this.width/2, this.y);
			bWheel.setPosition(this.x-this.width/2, this.y);
			
			_wheels[0] = fWheel;
			_wheels[1] = bWheel;
			
			//Joints
			var frontJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			frontJointDef.Initialize(_body,fWheel.body, fWheel.body.GetWorldCenter());
			frontJointDef.enableMotor = true;
			frontJointDef.maxMotorTorque = 100;
			
			var backJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			backJointDef.Initialize(_body,bWheel.body, bWheel.body.GetWorldCenter());
			backJointDef.enableMotor = true;
			backJointDef.maxMotorTorque = 100;
			
			var fJoint:b2RevoluteJoint = _world.CreateJoint(frontJointDef) as b2RevoluteJoint;
			var bJoint:b2RevoluteJoint = _world.CreateJoint(frontJointDef) as b2RevoluteJoint;
			
			_joints[0] = fJoint;
			_joints[1] = bJoint;*/
		}
		
		public function update():void {
			
			this._posX = _body.GetPosition().x * GameScreen.SCALE;
			this._posY = _body.GetPosition().y * GameScreen.SCALE;
			this._rot  = _body.GetAngle()*(180/Math.PI);
			
			for(var i:int = 0; i < 4; i++){
				(_wheels[i] as Wheel).applyFriction();
				if(i < 2){
					(_wheels[i] as Wheel).frontDrive();
					//(_wheels[i] as Wheel).turnDrive();
				}
			}
			turnDrive();
			
			//applyFriction();
			//turnDrive();
			//frontDrive();
			//trace(this);
		}
		
		private function turnDrive(){
			var left:Boolean = Keyboarder.keyIsDown(Keyboard.A);
			var right:Boolean = Keyboarder.keyIsDown(Keyboard.D);
			
			var lockAngle = 23 * MathHelper.DEGTORAD;
			var turnSpeedPerSec:Number = 90 * MathHelper.DEGTORAD;
			var turnPerTimeStep:Number = turnSpeedPerSec / 24; //Framerate
			var desiredAngle:Number = 0;
			
			if(left) desiredAngle = -lockAngle;
			if(right) desiredAngle = lockAngle;
			
			var angleNow:Number = this._flJoint.GetJointAngle();
			var angleToTurn:Number = desiredAngle - angleNow;
			angleToTurn = MathHelper.clamp(angleToTurn,-turnPerTimeStep, turnPerTimeStep);
			var newAngle = angleNow + angleToTurn;
			_flJoint.SetLimits(newAngle,newAngle);
			_frJoint.SetLimits(newAngle,newAngle);
			
			//cheatAlign();
		}
		
		private function cheatAlign(){
			var tol:Number = 10;
			var rot = _body.GetAngle()*MathHelper.RADTODEG;
			trace("RAWR " + Math.abs(rot%90));
			if(Math.abs(rot%90) > tol && Math.abs(rot%90) < 90-tol){
				var dir:Number = 1;
				if(this.rotation%90 < tol) dir = -1;
				_body.SetAngle(_body.GetAngle() + dir*2*MathHelper.DEGTORAD*(this.getForwardVelocity().Length()/10));
			}
		}
		
		public function getLateralVelocity():b2Vec2 {
			var currentRightNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(0,1));
			currentRightNormal.Multiply(b2Math.Dot(currentRightNormal,_body.GetLinearVelocity()))
			return currentRightNormal;
		}
		
		public function getForwardVelocity():b2Vec2 {
			var currentFrontNormal:b2Vec2 = _body.GetWorldVector(new b2Vec2(1,0));
			currentFrontNormal.Multiply(b2Math.Dot(currentFrontNormal,_body.GetLinearVelocity()))
			return currentFrontNormal;
		}
		
		private function applyFriction():void {
			var impulse:b2Vec2 = getLateralVelocity().GetNegative();
			impulse.Multiply(_body.GetMass());
			_body.ApplyImpulse(impulse, _body.GetWorldCenter());
			_body.ApplyAngularImpulse(0.1 * _body.GetInertia() * - _body.GetAngularVelocity());
			
			//Forward drag
			var currentForwardNormal:b2Vec2 = getForwardVelocity();
			var currentForwardSpeed:Number = currentForwardNormal.Normalize();
			var dragForceMagnitude = -1 * currentForwardSpeed;
			currentForwardNormal.Multiply(dragForceMagnitude);
			_body.ApplyForce(currentForwardNormal, _body.GetWorldCenter());
		}
	
		public function get velocity():Point { return new Point(_body.GetLinearVelocity().x, _body.GetLinearVelocity().y); }
		public function set velocity(val:Point):void { _body.SetLinearVelocity(new b2Vec2(val.x,val.y)); }
		
		public function get position():Point { return new Point(_posX,_posY); }		
		public function set position(val:Point):void { this._posX = val.x; this._posY = val.y; }
		public function get rot():Number { return _rot; }
		
		public override function toString():String 
		{
			return "[Player]: \nphyspos=[" + _body.GetPosition().x +", " + _body.GetPosition().y + "] \nderp=[" + position.x + ", " + position.y + "] \nphysvel=[" + _body.GetLinearVelocity().x + ", " + _body.GetLinearVelocity().y + "] \nphysrot=" + _body.GetAngle() + ", " + _body.GetAngularVelocity();
		}
	}
	
	
}
