package states.games {
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import egg82.base.BaseState;
	import egg82.custom.CustomImage;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.engines.interfaces.IInputEngine;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.enums.FileRegistryType;
	import egg82.enums.ServiceType;
	import egg82.math.FastMath;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.MathUtil;
	import nape.geom.Vec2;
	import objects.BaseObject;
	import objects.Border;
	import objects.Bullet;
	import objects.ClusterStressBall;
	import objects.components.AnimatedGraphicsComponent;
	import objects.Core;
	import objects.ExplosiveStressBall;
	import objects.Paddle;
	import objects.ReinforcementStar;
	import objects.ReliefStar;
	import objects.RemedyStar;
	import objects.Sentry;
	import objects.ShieldedStressBall;
	import objects.StressBall;
	import starling.display.DisplayObject;
	import states.components.CollisionComponent;
	import states.components.PoolComponent;
	import states.components.RegistryComponent;
	import states.components.TimerComponent;
	import states.LoseState;
	import states.UnloadingState;
	import util.Shake;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseGameState extends BaseState {
		//vars
		protected var physicsEngine:IPhysicsEngine = ServiceLocator.getService(ServiceType.PHYSICS_ENGINE) as IPhysicsEngine;
		private var inputEngine:IInputEngine = ServiceLocator.getService(ServiceType.INPUT_ENGINE) as IInputEngine;
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var registryComponent:RegistryComponent;
		private var poolComponent:PoolComponent;
		private var timerComponent:TimerComponent;
		private var collisionComponent:CollisionComponent;
		
		private var gameType:String;
		
		private var background:CustomImage;
		private var border:Border;
		private var core:Core;
		protected var paddle1:Paddle;
		protected var paddle2:Paddle;
		protected var sentry:Sentry;
		
		private var _screenAnimating:Boolean = false;
		private var smallShake:Shake = new Shake(0.5, 15, 2);
		private var mediumShake:Shake = new Shake(0.75, 30, 4);
		private var largeShake:Shake = new Shake(1.5, 60, 16);
		private var deathShake:Shake = new Shake(4.0, 120, 64);
		
		//constructor
		public function BaseGameState() {
			
		}
		
		//public
		override public function create(...args):void {
			_nextState = UnloadingState;
			_nextStateParams = [{
				"nextState": LoseState
			}];
			
			super.create();
			
			throwErrorOnArgsNull(args);
			gameType = getArg(args, "gameType");
			if (!gameType || gameType == "") {
				throw new Error("gameType cannot be null.");
			}
			
			registryComponent = new RegistryComponent(gameType);
			registryComponent.create();
			poolComponent = new PoolComponent(gameType);
			poolComponent.create();
			timerComponent = new TimerComponent(spawn, poolComponent, registryComponent, stage);
			timerComponent.create();
			collisionComponent = new CollisionComponent(onCollide);
			collisionComponent.create();
			
			physicsEngine.resize();
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, registryComponent.textureQuality + "_" + gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			border = new Border(stage.stageWidth, stage.stageHeight);
			border.create();
			border.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			physicsEngine.addBody(border.body);
			
			core = new Core(gameType, registryComponent.health);
			core.create();
			core.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			physicsEngine.addBody(core.body);
			addChild(core.graphics);
			
			paddle1 = new Paddle(gameType, false);
			paddle1.create();
			paddle1.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			paddle2 = new Paddle(gameType, true);
			paddle2.create();
			paddle2.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			sentry = new Sentry(gameType);
			sentry.create();
			sentry.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			
			audioEngine.playAudio(registryComponent.musicQuality + "_music_" + gameType);
			
			alignPivot();
			x = (stage.stageWidth / 2) - 89;
			y = (stage.stageHeight / 2) - 79;
			rotation = 0;
		}
		
		override public function update(deltaTime:Number):void {
			if (deathShake.shaking) {
				deathShake.update();
			} else if (largeShake.shaking) {
				largeShake.update();
			} else if (mediumShake.shaking) {
				mediumShake.update();
			} else if (smallShake.shaking) {
				smallShake.update();
			}
			
			if (poolComponent.getNumUsedObjects() < registryComponent.minObjects) {
				timerComponent.spawnObjects(registryComponent.minObjects - poolComponent.getNumUsedObjects());
			}
			
			if (!inputEngine.isUsingController()) {
				sentry.body.rotation = FastMath.atan2(inputEngine.mousePosition.y - sentry.body.position.y, inputEngine.mousePosition.x - sentry.body.position.x) + 1.5708;
				paddle1.body.rotation = FastMath.atan2(inputEngine.mousePosition.y - sentry.body.position.y, inputEngine.mousePosition.x - sentry.body.position.x) + 1.5708;
				paddle2.body.rotation = FastMath.atan2(inputEngine.mousePosition.y - sentry.body.position.y, inputEngine.mousePosition.x - sentry.body.position.x) + Math.PI + 1.5708;
			} else {
				if (inputEngine.getStickProperties(0, 0).y > registryComponent.controllerDeadZone) {
					sentry.body.rotation = inputEngine.getStickProperties(0, 0).x + 1.5708;
					paddle1.body.rotation = inputEngine.getStickProperties(0, 0).x + 1.5708;
					paddle2.body.rotation = inputEngine.getStickProperties(0, 0).x + Math.PI + 1.5708;
				} else if (inputEngine.getStickProperties(0, 1).y > registryComponent.controllerDeadZone) {
					sentry.body.rotation = inputEngine.getStickProperties(0, 1).x + 1.5708;
					paddle1.body.rotation = inputEngine.getStickProperties(0, 1).x + 1.5708;
					paddle2.body.rotation = inputEngine.getStickProperties(0, 1).x + Math.PI + 1.5708;
				}
			}
			
			if (timerComponent.canFire && (inputEngine.isMouseDown(registryComponent.fireKeys) || inputEngine.isKeysDown(registryComponent.fireKeys) || inputEngine.isButtonsDown(0, registryComponent.fireButtons) || inputEngine.isSticksPressed(0, registryComponent.fireButtons) || registryComponent.autoFire)) {
				spawnBullet();
				timerComponent.startFireTimer();
			}
			
			super.update(deltaTime);
		}
		override public function draw():void {
			core.draw();
			paddle1.draw();
			paddle2.draw();
			sentry.draw();
			
			poolComponent.draw();
			
			super.draw();
		}
		
		override public function destroy():void {
			registryComponent.destroy();
			poolComponent.destroy();
			timerComponent.destroy();
			collisionComponent.destroy();
			
			physicsEngine.removeAllBodies();
			
			audioEngine.stopAudio(registryComponent.musicQuality + "_music_" + gameType);
			
			super.destroy();
		}
		
		//private
		private function onCollide(obj1:BaseObject, obj2:BaseObject):void {
			if (obj2 is Core) {
				obj2.tweenBrightness(0.6);
				TweenMax.delayedCall(0.2, obj2.tweenBrightness, [0]);
				if (obj1 is StressBall) {
					mediumShake.start(this);
					core.health -= registryComponent.stressPower;
				} else if (obj1 is ShieldedStressBall) {
					mediumShake.start(this);
					core.health -= registryComponent.shieldedStressPower;
				} else if (obj1 is ExplosiveStressBall) {
					mediumShake.start(this);
					core.health -= registryComponent.explosiveStressPower;
				} else if (obj1 is ClusterStressBall) {
					smallShake.start(this);
					core.health -= registryComponent.clusterStressPower;
				} else if (obj1 is ReliefStar) {
					core.health += registryComponent.reliefPower;
				}
				checkLose();
			} else if (obj2 is Sentry) {
				obj2.tweenBrightness(0.8);
				TweenMax.delayedCall(0.2, obj2.tweenBrightness, [0]);
			} else if (obj2 is Paddle) {
				obj2.tweenBrightness(0.8);
				TweenMax.delayedCall(0.2, obj2.tweenBrightness, [0]);
			}
			
			if (obj1 is Bullet) {
				var destroyBullet:Boolean = true;
				
				if (obj2 is ClusterStressBall) {
					destroyBullet = false;
				}
				
				if (destroyBullet) {
					tweenDestroy(obj1);
				}
			} else if (obj1 is RemedyStar) {
				if (obj2 is Core || obj2 is Bullet) {
					tweenDestroy(obj1);
					if (obj2 is Core) {
						TweenMax.to(physicsEngine, 2, {
							"speed": physicsEngine.speed / registryComponent.remedyPower,
							"ease": Expo.easeOut
						});
						TweenMax.to(physicsEngine, 2, {
							"speed": 1,
							"delay": (registryComponent.remedyTime / 1000) + 2,
							"ease": Expo.easeIn
						});
					}
				}
			} else if (obj1 is ReinforcementStar) {
				if (obj2 is Core || obj2 is Bullet) {
					tweenDestroy(obj1);
					if (obj2 is Core) {
						setFireRateMultiplier(timerComponent.fireRateMultiplier / registryComponent.reinforcePower);
						TweenMax.delayedCall(registryComponent.reinforceTime / 1000, setFireRateMultiplier, [1]);
						
						paddle1.tweenScale(registryComponent.reinforcePower);
						TweenMax.delayedCall(registryComponent.reinforceTime / 1000, paddle1.tweenScale, [1]);
						paddle2.tweenScale(registryComponent.reinforcePower);
						TweenMax.delayedCall(registryComponent.reinforceTime / 1000, paddle2.tweenScale, [1]);
					}
				}
			} else if (obj1 is ReliefStar) {
				if (obj2 is Core || obj2 is Bullet) {
					tweenDestroy(obj1);
				}
			} else if (obj1 is StressBall) {
				if (obj2 is Core || obj2 is Bullet) {
					tweenDestroy(obj1);
				}
			} else if (obj1 is ShieldedStressBall) {
				if (obj2 is Core) {
					tweenDestroy(obj1);
				}
			} else if (obj1 is ExplosiveStressBall) {
				if (!(obj2 is Border)) {
					tweenDestroy(obj1);
					if (!(obj2 is Core)) {
						largeShake.start(this);
						for (var i:uint = 0; i < registryComponent.clusterStressNumber; i++) {
							spawnClusterBall(obj1.body.position.x + FastMath.sin(FastMath.toRadians((i / registryComponent.clusterStressNumber) * 360), true) * 15, obj1.body.position.y + FastMath.cos(FastMath.toRadians((i / registryComponent.clusterStressNumber) * 360), true) * 15, obj1.body.position.x, obj1.body.position.y);
						}
					}
				}
			} else if (obj1 is ClusterStressBall) {
				tweenDestroy(obj1);
			}
		}
		
		private function spawn(type:Class):void {
			var obj:BaseObject = poolComponent.getObject(type);
			
			if (!obj) {
				return;
			}
			
			var x:Number;
			var y:Number;
			
			do {
				var good:Boolean = true;
				
				x = MathUtil.betterRoundedRandom(20, stage.stageWidth - 20);
				y = MathUtil.betterRoundedRandom(20, stage.stageHeight - 20);
				
				if ((x >= stage.stageWidth / 2 - 70 && x <= stage.stageWidth / 2 + 70) && (y >= stage.stageHeight / 2 - 70 && y <= stage.stageHeight / 2 + 70)) {
					good = false;
				}
			} while (!good);
			
			obj.body.position.setxy(x, y);
			
			tweenCreate(obj);
			
			var impulse:Vec2 = Vec2.get((stage.stageWidth / 2 - obj.body.worldCOM.x) * -1, (stage.stageHeight / 2 - obj.body.worldCOM.y) * -1);
			impulse.length = MathUtil.random(10, 20);
			obj.body.applyImpulse(impulse);
			if (obj.body.allowRotation) {
				obj.body.applyAngularImpulse(MathUtil.random(100, 200));
			}
		}
		
		private function spawnBullet():void {
			var bullet:Bullet = poolComponent.getObject(Bullet) as Bullet;
			if (bullet) {
				timerComponent.canFire = false;
				
				bullet.body.position.setxy(sentry.body.position.x, sentry.body.position.y);
				bullet.body.rotation = sentry.body.rotation;
				
				var impulse:Vec2 = Vec2.get(bullet.body.worldCOM.x - stage.stageWidth / 2, bullet.body.worldCOM.y - stage.stageHeight / 2);
				impulse.length = 200;
				bullet.body.applyImpulse(impulse);
				
				physicsEngine.addBody(bullet.body);
				bullet.resetPosition();
				addChild(bullet.graphics);
			}
		}
		private function spawnClusterBall(x:Number, y:Number, centerX:Number, centerY:Number):void {
			var ball:ClusterStressBall = poolComponent.getObject(ClusterStressBall) as ClusterStressBall;
			if (ball) {
				ball.body.position.setxy(x, y);
				
				var impulse:Vec2 = Vec2.get(x - centerX, y - centerY);
				impulse.length = 10;
				ball.body.applyImpulse(impulse);
				
				physicsEngine.addBody(ball.body);
				addChild(ball.graphics);
			}
		}
		
		private function setFireRateMultiplier(multiplier:Number):void {
			timerComponent.fireRateMultiplier = multiplier;
		}
		
		private function checkLose():void {
			if (core.health <= 0) {
				timerComponent.destroy();
				tweenDestroyAll();
				deathShake.start(this);
				TweenMax.delayedCall(3, TweenMax.to, [
					this,
					1,
					{
						"alpha": 0,
						"ease": Circ.easeOut,
						"onComplete": nextState
					}
				]);
				
				var origSpeed:Number = physicsEngine.speed;
				TweenMax.to(physicsEngine, 2, {
					"speed": 0.25,
					"ease": Expo.easeOut
				});
				TweenMax.delayedCall(2, TweenMax.to, [
					physicsEngine,
					2,
					{
						"speed": origSpeed,
						"ease": Expo.easeIn
					}
				]);
			}
		}
		
		private function tweenCreate(obj:BaseObject):void {
			physicsEngine.addBody(obj.body);
			addChild(obj.graphics);
			
			TweenMax.from(obj, 0.75, {
				"scale": 0,
				"ease": Elastic.easeOut
			});
		}
		private function tweenDestroy(obj:BaseObject, duration:Number = 0.75):void {
			physicsEngine.removeBody(obj.body);
			
			TweenMax.to(obj, duration, {
				"scale": 0,
				"ease": Expo.easeOut,
				"onComplete": tweenDestroyInternal,
				"onCompleteParams": [obj]
			});
		}
		private function tweenDestroyInternal(obj:BaseObject):void {
			removeChild(obj.graphics);
			obj.destroy();
			poolComponent.returnObject(obj);
		}
		
		private function tweenDestroyAll():void {
			destroyPool(poolComponent.getUsedPool(RemedyStar));
			destroyPool(poolComponent.getUsedPool(ReinforcementStar));
			destroyPool(poolComponent.getUsedPool(ReliefStar));
			destroyPool(poolComponent.getUsedPool(StressBall));
			destroyPool(poolComponent.getUsedPool(ShieldedStressBall));
			destroyPool(poolComponent.getUsedPool(ExplosiveStressBall));
			destroyPool(poolComponent.getUsedPool(ClusterStressBall));
			destroyPool(poolComponent.getUsedPool(Bullet));
			
			TweenMax.delayedCall(2, tweenDestroy, [paddle1, 2]);
			TweenMax.delayedCall(2, tweenDestroy, [paddle2, 2]);
			TweenMax.delayedCall(2, tweenDestroy, [sentry, 2]);
			TweenMax.delayedCall(2, tweenDestroy, [core, 2]);
		}
		private function destroyPool(objs:Vector.<IPrototype>):void {
			for (var i:uint = 0; i < objs.length; i++) {
				tweenDestroy(objs[i] as BaseObject, 2);
			}
		}
	}
}