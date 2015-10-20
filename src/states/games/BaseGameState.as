package states.games {
	import com.greensock.TweenMax;
	import egg82.base.BaseState;
	import egg82.custom.CustomImage;
	import egg82.engines.interfaces.IInputEngine;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.engines.interfaces.IAudioEngine;
	import egg82.engines.PhysicsEngine;
	import egg82.enums.AudioRegistryType;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.enums.XboxButtonCodes;
	import egg82.events.engines.PhysicsEngineEvent;
	import egg82.math.FastMath;
	import egg82.patterns.objectPool.DynamicObjectPool;
	import egg82.patterns.objectPool.ObjectPool;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.RegistryUtil;
	import enums.CustomOptionsRegistryType;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import nape.geom.Geom;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import objects.base.BasePhysicsObject;
	import objects.Border;
	import objects.Bullet;
	import objects.ClusterStressBall;
	import objects.Core;
	import objects.ExplosiveStressBall;
	import objects.interfaces.ITriggerable;
	import objects.Paddle;
	import objects.ReinforcementStar;
	import objects.ReliefStar;
	import objects.RemedyStar;
	import objects.Sentry;
	import objects.ShieldedStressBall;
	import objects.StressBall;
	import states.LoseState;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BaseGameState extends BaseState {
		//vars
		protected var gameType:String;
		private var background:CustomImage;
		
		private var border:Border;
		private var core:Core;
		
		private var remedyStarPool:ObjectPool;
		private var reinforcementStarPool:ObjectPool;
		private var reliefStarPool:ObjectPool;
		
		private var stressBallPool:DynamicObjectPool;
		private var shieldedStressBallPool:ObjectPool;
		private var explosiveStressBallPool:ObjectPool;
		private var clusterStressBallPool:ObjectPool;
		
		private var bulletPool:ObjectPool;
		
		protected var paddle1:Paddle;
		protected var paddle2:Paddle;
		protected var sentry:Sentry;
		
		protected var physicsEngine:IPhysicsEngine = ServiceLocator.getService(ServiceType.PHYSICS_ENGINE) as IPhysicsEngine;
		private var inputEngine:IInputEngine = ServiceLocator.getService(ServiceType.INPUT_ENGINE) as IInputEngine;
		private var audioEngine:IAudioEngine = ServiceLocator.getService(ServiceType.AUDIO_ENGINE) as IAudioEngine;
		
		private var physicsEngineObserver:Observer = new Observer();
		private var registryUtilObserver:Observer = new Observer();
		
		private var impulseTimer:Timer = new Timer(100);
		private var unstuckTimer:Timer = new Timer(1000);
		private var speedTimer:Timer = new Timer(250);
		
		private var fireKeys:Array;
		private var fireButtons:Array;
		private var autoFire:Boolean;
		private var controllerDeadZone:Number;
		
		protected var fireTimer:Timer = new Timer(750, 1);
		private var _canFire:Boolean = false;
		
		protected var health:Number = 4;
		
		//constructor
		public function BaseGameState() {
			
		}
		
		//public
		override public function create(...args):void {
			_nextState = LoseState;
			
			super.create();
			
			throwErrorOnArgsNull(args);
			gameType = getArg(args, "gameType");
			if (!gameType || gameType == "") {
				throw new Error("gameType cannot be null.");
			}
			
			physicsEngine.resize();
			
			background = new CustomImage(REGISTRY_UTIL.getFile(FileRegistryType.TEXTURE, gameType + "_background"));
			background.create();
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			addChild(background);
			
			border = new Border(stage.stageWidth, stage.stageHeight);
			border.create();
			border.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			physicsEngine.addBody(border.body);
			
			core = new Core(gameType, health);
			core.create();
			core.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			physicsEngine.addBody(core.body);
			addChild(core);
			
			remedyStarPool = new ObjectPool("remedyStar", new RemedyStar(gameType, checkHit));
			remedyStarPool.initialize(3);
			reinforcementStarPool = new ObjectPool("reinforcementStar", new ReinforcementStar(gameType, checkHit));
			reinforcementStarPool.initialize(3);
			reliefStarPool = new ObjectPool("reliefStar", new ReliefStar(gameType, checkHit));
			reliefStarPool.initialize(3);
			
			stressBallPool = new DynamicObjectPool("stressBall", new StressBall(gameType, checkHit));
			stressBallPool.initialize(3);
			shieldedStressBallPool = new ObjectPool("shieldedStressBall", new ShieldedStressBall(gameType, checkHit));
			shieldedStressBallPool.initialize(4);
			explosiveStressBallPool = new ObjectPool("explosiveStressBall", new ExplosiveStressBall(gameType, checkHit));
			explosiveStressBallPool.initialize(4);
			clusterStressBallPool = new ObjectPool("clusterStressBall", new ClusterStressBall(gameType, checkHit));
			clusterStressBallPool.initialize(16);
			
			bulletPool = new ObjectPool("bullet", new Bullet(gameType, checkHit));
			bulletPool.initialize(6);
			
			var i:uint;
			/*for (i = 1; i <= 1; i++) {
				var testStar:RemedyStar = remedyStarPool.getObject() as RemedyStar;
				testStar.body.position.setxy(20 * i, 20);
				var impulse10:Vec2 = Vec2.get(stage.stageWidth - testStar.body.position.x, stage.stageHeight - testStar.body.position.y);
				impulse10.length = 100;
				testStar.body.applyImpulse(impulse10);
				
				physicsEngine.addBody(testStar.body);
				addChild(testStar);
			}
			for (i = 1; i <= 1; i++) {
				var testStar2:ReinforcementStar = reinforcementStarPool.getObject() as ReinforcementStar;
				testStar2.body.position.setxy(20 * i, 40);
				var impulse11:Vec2 = Vec2.get(stage.stageWidth - testStar2.body.position.x, stage.stageHeight - testStar2.body.position.y);
				impulse11.length = 100;
				testStar2.body.applyImpulse(impulse11);
				
				physicsEngine.addBody(testStar2.body);
				addChild(testStar2);
			}
			for (i = 1; i <= 3; i++) {
				var testStar3:ReliefStar = reliefStarPool.getObject() as ReliefStar;
				testStar3.body.position.setxy(20 * i, 60);
				var impulse12:Vec2 = Vec2.get(stage.stageWidth - testStar3.body.position.x, stage.stageHeight - testStar3.body.position.y);
				impulse12.length = 100;
				testStar3.body.applyImpulse(impulse12);
				
				physicsEngine.addBody(testStar3.body);
				addChild(testStar3);
			}
			
			for (i = 1; i <= 1; i++) {
				var testBall:ShieldedStressBall = shieldedStressBallPool.getObject() as ShieldedStressBall;
				testBall.body.position.setxy(20 * i, 80);
				var impulse:Vec2 = Vec2.get(stage.stageWidth - testBall.body.position.x, stage.stageHeight - testBall.body.position.y);
				impulse.length = 100;
				testBall.body.applyImpulse(impulse);
				
				physicsEngine.addBody(testBall.body);
				addChild(testBall);
			}
			for (i = 1; i <= 3; i++) {
				var testBall2:StressBall = stressBallPool.getObject() as StressBall;
				testBall2.body.position.setxy(20 * i, 100);
				var impulse2:Vec2 = Vec2.get(stage.stageWidth - testBall2.body.position.x, stage.stageHeight - testBall2.body.position.y);
				impulse2.length = 100;
				testBall2.body.applyImpulse(impulse2);
				
				physicsEngine.addBody(testBall2.body);
				addChild(testBall2);
			}
			for (i = 1; i <= 1; i++) {
				var testBall3:ExplosiveStressBall = explosiveStressBallPool.getObject() as ExplosiveStressBall;
				testBall3.body.position.setxy(20 * i, 120);
				var impulse3:Vec2 = Vec2.get(stage.stageWidth - testBall3.body.position.x, stage.stageHeight - testBall3.body.position.y);
				impulse3.length = 100;
				testBall3.body.applyImpulse(impulse3);
				
				physicsEngine.addBody(testBall3.body);
				addChild(testBall3);
			}
			for (i = 1; i <= 2; i++) {
				var testBall4:ClusterStressBall = clusterStressBallPool.getObject() as ClusterStressBall;
				testBall4.body.position.setxy(10 * i, 130);
				var impulse4:Vec2 = Vec2.get(stage.stageWidth - testBall4.body.position.x, stage.stageHeight - testBall4.body.position.y);
				impulse4.length = 100;
				testBall4.body.applyImpulse(impulse4);
				
				physicsEngine.addBody(testBall4.body);
				addChild(testBall4);
			}*/
			
			paddle1 = new Paddle(gameType, false);
			paddle1.create();
			paddle1.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			paddle2 = new Paddle(gameType, true);
			paddle2.create();
			paddle2.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			sentry = new Sentry(gameType);
			sentry.create();
			sentry.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			
			physicsEngineObserver.add(onPhysicsEngineObserverNotify);
			Observer.add(PhysicsEngine.OBSERVERS, physicsEngineObserver);
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			fireKeys = REGISTRY_UTIL.getOption(OptionsRegistryType.KEYS, "fire") as Array;
			fireButtons = REGISTRY_UTIL.getOption(OptionsRegistryType.CONTROLLER, "fire") as Array;
			autoFire = REGISTRY_UTIL.getOption(CustomOptionsRegistryType.GAMEPLAY, "autoFire") as Boolean;
			controllerDeadZone = REGISTRY_UTIL.getOption(OptionsRegistryType.CONTROLLER, "deadZone") as Number;
			
			audioEngine.playAudio("music_" + gameType);
			
			impulseTimer.addEventListener(TimerEvent.TIMER, onImpulseTimer);
			impulseTimer.start();
			
			unstuckTimer.addEventListener(TimerEvent.TIMER, onUnstuckTimer);
			unstuckTimer.start();
			
			speedTimer.addEventListener(TimerEvent.TIMER, onSpeedTimer);
			speedTimer.start();
			
			fireTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFireTimer);
		}
		
		override public function update(deltaTime:Number):void {
			if (!inputEngine.isUsingController()) {
				sentry.body.rotation = FastMath.atan2(inputEngine.mousePosition.y - sentry.body.position.y, inputEngine.mousePosition.x - sentry.body.position.x) + 1.5708;
				paddle1.body.rotation = FastMath.atan2(inputEngine.mousePosition.y - sentry.body.position.y, inputEngine.mousePosition.x - sentry.body.position.x) + 1.5708;
				paddle2.body.rotation = FastMath.atan2(inputEngine.mousePosition.y - sentry.body.position.y, inputEngine.mousePosition.x - sentry.body.position.x) + Math.PI + 1.5708;
			} else {
				if (inputEngine.getStickProperties(0, 0).y > controllerDeadZone) {
					sentry.body.rotation = inputEngine.getStickProperties(0, 0).x + 1.5708;
					paddle1.body.rotation = inputEngine.getStickProperties(0, 0).x + 1.5708;
					paddle2.body.rotation = inputEngine.getStickProperties(0, 0).x + Math.PI + 1.5708;
				} else if (inputEngine.getStickProperties(0, 1).y > controllerDeadZone) {
					sentry.body.rotation = inputEngine.getStickProperties(0, 1).x + 1.5708;
					paddle1.body.rotation = inputEngine.getStickProperties(0, 1).x + 1.5708;
					paddle2.body.rotation = inputEngine.getStickProperties(0, 1).x + Math.PI + 1.5708;
				}
			}
			
			if (_canFire && (inputEngine.isMouseDown(fireKeys) || inputEngine.isKeysDown(fireKeys) || inputEngine.isButtonsDown(0, fireButtons) || autoFire)) {
				spawnBullet();
			}
		}
		
		override public function destroy():void {
			Observer.remove(PhysicsEngine.OBSERVERS, physicsEngineObserver);
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			speedTimer.stop();
			unstuckTimer.stop();
			impulseTimer.stop();
			
			physicsEngine.removeAllBodies();
			
			remedyStarPool.clear();
			reinforcementStarPool.clear();
			reliefStarPool.clear();
			shieldedStressBallPool.clear();
			explosiveStressBallPool.clear();
			clusterStressBallPool.clear();
			stressBallPool.clear();
			
			super.destroy();
		}
		
		//private
		private function spawnBullet():void {
			var bullet:Bullet = bulletPool.getObject() as Bullet;
			if (bullet) {
				_canFire = false;
				fireTimer.start();
				
				bullet.body.position.setxy(sentry.body.position.x, sentry.body.position.y);
				bullet.body.rotation = sentry.body.rotation;
				
				var impulse:Vec2 = Vec2.get(bullet.body.worldCOM.x - stage.stageWidth / 2, bullet.body.worldCOM.y - stage.stageHeight / 2);
				impulse.length = 200;
				bullet.body.applyImpulse(impulse);
				
				physicsEngine.addBody(bullet.body);
				addChild(bullet);
			}
		}
		private function spawnClusterBall(x:Number, y:Number, centerX:Number, centerY:Number):void {
			var ball:ClusterStressBall = clusterStressBallPool.getObject() as ClusterStressBall;
			if (ball) {
				ball.body.position.setxy(x, y);
				
				var impulse:Vec2 = Vec2.get(x - centerX, y - centerY);
				impulse.length = 10;
				ball.body.applyImpulse(impulse);
				
				physicsEngine.addBody(ball.body);
				addChild(ball);
			}
		}
		
		private function onImpulseTimer(e:TimerEvent):void {
			for (var i:uint = 0; i < shieldedStressBallPool.usedPool.length; i++) {
				for (var j:uint = 0; j < physicsEngine.numBodies; j++) {
					var body1:Body = (shieldedStressBallPool.usedPool[i] as BasePhysicsObject).body;
					var body2:Body = physicsEngine.getBody(j);
					
					if (body1 === body2) {
						continue;
					}
					
					try {
						var distance:Number = Geom.distanceBody(body1, body2, Vec2.weak(), Vec2.weak());
					} catch (ex:Error) {
						continue;
					}
					
					if (distance <= 70) {
						var impulse1:Vec2 = Vec2.get(body1.position.x - body2.position.x, body1.position.y - body2.position.y);
						impulse1.length = 40 - distance;
						body1.applyImpulse(impulse1);
						
						var impulse2:Vec2 = Vec2.get(body2.position.x - body1.position.x, body2.position.y - body1.position.y);
						impulse2.length = 80 - distance;
						body2.applyImpulse(impulse2);
					}
				}
			}
		}
		private function onUnstuckTimer(e:TimerEvent):void {
			for (var i:uint = 0; i < physicsEngine.numBodies; i++) {
				for (var j:uint = 0; j < physicsEngine.numBodies; j++) {
					if (i == j) {
						continue;
					}
					
					var body1:Body = physicsEngine.getBody(i);
					var body2:Body = physicsEngine.getBody(j);
					
					if (Geom.intersectsBody(body1, body2)) {
						var impulse1:Vec2 = Vec2.get(body1.position.x - body2.position.x, body1.position.y - body2.position.y);
						impulse1.length = 25;
						body1.applyImpulse(impulse1);
						
						var impulse2:Vec2 = Vec2.get(body2.position.x - body1.position.x, body2.position.y - body1.position.y);
						impulse2.length = 25;
						body2.applyImpulse(impulse2);
					}
				}
			}
		}
		private function onSpeedTimer(e:TimerEvent):void {
			for (var i:uint = 0; i < physicsEngine.numBodies; i++) {
				var body:Body = physicsEngine.getBody(i);
				
				if (body.type != BodyType.DYNAMIC) {
					continue;
				}
				
				if (body.userData.parent is Bullet) {
					continue;
				}
				
				if (body.velocity.length > 300) {
					body.velocity.length = 300;
				} else if (body.velocity.length < 200) {
					body.velocity.length = 200;
				}
				
				if (body.angularVel > 250) {
					body.angularVel = 250;
				}
			}
		}
		
		private function onFireTimer(e:TimerEvent):void {
			_canFire = true;
		}
		
		private function onPhysicsEngineObserverNotify(sender:Object, event:String, data:Object):void {
			if (event == PhysicsEngineEvent.COLLIDE) {
				onCollide(data.body1 as Body, data.body2 as Body);
			}
		}
		private function onCollide(body1:Body, body2:Body):void {
			if (body1.userData.parent is ITriggerable) {
				(body1.userData.parent as ITriggerable).trigger(body2.userData.parent as BasePhysicsObject);
			}
			if (body2.userData.parent is ITriggerable) {
				(body2.userData.parent as ITriggerable).trigger(body1.userData.parent as BasePhysicsObject);
			}
		}
		
		private function checkHit(body1:BasePhysicsObject, body2:BasePhysicsObject):void {
			if (body2 is Core) {
				core.health -= body1.damage;
				checkLose();
			}
			
			if (body1 is Bullet) {
				var destroyBullet:Boolean = true;
				
				if (body2 is ClusterStressBall) {
					destroyBullet = false;
				}
				
				if (destroyBullet) {
					body1.destroy();
					bulletPool.returnObject(body1 as Bullet);
				}
			} else if (body1 is RemedyStar) {
				if (body2 is Core || body2 is Bullet) {
					body1.tweenRemove(remedyStarPool.returnObject, [body1]);
					if (body2 is Core) {
						TweenMax.to(physicsEngine, 2, {
							"speed": 0.25
						});
						TweenMax.to(physicsEngine, 2, {
							"speed": 1,
							"delay": 8
						});
					}
				}
			} else if (body1 is ReinforcementStar) {
				if (body2 is Core || body2 is Bullet) {
					body1.tweenRemove(reinforcementStarPool.returnObject, [body1]);
				}
			} else if (body1 is ReliefStar) {
				if (body2 is Core || body2 is Bullet) {
					body1.tweenRemove(reliefStarPool.returnObject, [body1]);
					if (body2 is Core) {
						setFireTimerDelay(250);
						TweenMax.delayedCall(6, setFireTimerDelay, [750]);
						
						paddle1.tweenResize(4);
						TweenMax.delayedCall(6, paddle1.tweenResize, [0.25]);
						paddle2.tweenResize(4);
						TweenMax.delayedCall(6, paddle2.tweenResize, [0.25]);
					}
				}
				
			} else if (body1 is StressBall) {
				if (body2 is Core || body2 is Bullet) {
					body1.tweenRemove(stressBallPool.returnObject, [body1]);
				}
			} else if (body1 is ShieldedStressBall) {
				if (body2 is Core) {
					body1.tweenRemove(shieldedStressBallPool.returnObject, [body1]);
				}
			} else if (body1 is ExplosiveStressBall) {
				body1.tweenRemove(explosiveStressBallPool.returnObject, [body1]);
				if (!(body2 is Core)) {
					for (var i:uint = 0; i < 8; i++) {
						spawnClusterBall(body1.body.position.x + FastMath.sin(FastMath.toRadians((i / 8) * 360), true) * 15, body1.body.position.y + FastMath.cos(FastMath.toRadians((i / 8) * 360), true) * 15, body1.body.position.x, body1.body.position.y);
					}
				}
			} else if (body1 is ClusterStressBall) {
				body1.tweenRemove(clusterStressBallPool.returnObject, [body1]);
			}
		}
		
		private function setFireTimerDelay(delay:Number):void {
			fireTimer.delay = delay;
		}
		
		private function checkLose():void {
			if (core.health <= 0) {
				//nextState();
			}
		}
		
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == CustomOptionsRegistryType.GAMEPLAY && name == "autoFire") {
				autoFire = value as String;
			} else if (type == OptionsRegistryType.KEYS && name == "fire") {
				fireKeys = value as Array;
			} else if (type == OptionsRegistryType.CONTROLLER) {
				if (name == "fire") {
					fireButtons = value as Array;
				} else if (name == "deadZone") {
					controllerDeadZone = value as Number;
				}
			}
		}
	}
}