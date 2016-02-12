package states.components {
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.enums.ServiceType;
	import egg82.patterns.interfaces.IComponent;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.MathUtil;
	import enums.GameType;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import nape.geom.Geom;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import objects.BaseObject;
	import objects.Border;
	import objects.Bullet;
	import objects.ExplosiveStressBall;
	import objects.ReinforcementStar;
	import objects.ReliefStar;
	import objects.RemedyStar;
	import objects.ShieldedStressBall;
	import objects.StressBall;
	import starling.display.Stage;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class TimerComponent implements IComponent {
		//vars
		public var canFire:Boolean = false;
		
		private var physicsEngine:IPhysicsEngine = ServiceLocator.getService(ServiceType.PHYSICS_ENGINE) as IPhysicsEngine;
		
		private var poolComponent:PoolComponent;
		private var registryComponent:RegistryComponent;
		private var spawnCallback:Function = null;
		private var stage:Stage;
		
		private var _fireRateMultiplier:Number = 1;
		
		private var impulseTimer:Timer = new Timer(50);
		private var unstuckTimer:Timer = new Timer(1000);
		private var speedTimer:Timer = new Timer(250);
		
		private var fireTimer:Timer;
		private var remedyTimer:Timer;
		private var reinforceTimer:Timer;
		private var reliefTimer:Timer;
		private var stressTimer:Timer;
		private var shieldedStressTimer:Timer;
		private var explosiveStressTimer:Timer;
		
		private var nemesisImpulseTimer:Timer;
		
		//constructor
		public function TimerComponent(spawnCallback:Function, poolComponent:PoolComponent, registryComponent:RegistryComponent, stage:Stage) {
			this.poolComponent = poolComponent;
			this.registryComponent = registryComponent;
			this.spawnCallback = spawnCallback;
			this.stage = stage;
		}
		
		//public
		public function create():void {
			impulseTimer.addEventListener(TimerEvent.TIMER, onImpulseTimer);
			impulseTimer.start();
			unstuckTimer.addEventListener(TimerEvent.TIMER, onUnstuckTimer);
			unstuckTimer.start();
			speedTimer.addEventListener(TimerEvent.TIMER, onSpeedTimer);
			speedTimer.start();
			
			remedyTimer = new Timer(registryComponent.remedySpawnRate);
			remedyTimer.addEventListener(TimerEvent.TIMER, onRemedyTimer);
			remedyTimer.start();
			reinforceTimer = new Timer(registryComponent.reinforceSpawnRate);
			reinforceTimer.addEventListener(TimerEvent.TIMER, onReinforceTimer);
			reinforceTimer.start();
			stressTimer = new Timer(registryComponent.stressSpawnRate);
			stressTimer.addEventListener(TimerEvent.TIMER, onStressTimer);
			stressTimer.start();
			
			if (registryComponent.gameType != GameType.NEMESIS) {
				reliefTimer = new Timer(registryComponent.reliefSpawnRate);
				reliefTimer.addEventListener(TimerEvent.TIMER, onReliefTimer);
				reliefTimer.start();
				shieldedStressTimer = new Timer(registryComponent.shieldedStressSpawnRate);
				shieldedStressTimer.addEventListener(TimerEvent.TIMER, onShieldedStressTimer);
				shieldedStressTimer.start();
				explosiveStressTimer = new Timer(registryComponent.explosiveStressSpawnRate);
				explosiveStressTimer.addEventListener(TimerEvent.TIMER, onExplosiveStressTimer);
				explosiveStressTimer.start();
			}
			
			if (registryComponent.gameType == GameType.HORDE) {
				fireTimer = new Timer(registryComponent.fireRate * _fireRateMultiplier, 1);
				fireTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFireTimer);
				fireTimer.start();
			} else if (registryComponent.gameType == GameType.NEMESIS) {
				nemesisImpulseTimer = new Timer(registryComponent.nemesisImpulseRate, 1);
				nemesisImpulseTimer.addEventListener(TimerEvent.TIMER, onNemesisImpulseTimer);
				nemesisImpulseTimer.start();
			}
		}
		public function destroy():void {
			impulseTimer.stop();
			impulseTimer.removeEventListener(TimerEvent.TIMER, onImpulseTimer);
			unstuckTimer.stop();
			unstuckTimer.removeEventListener(TimerEvent.TIMER, onUnstuckTimer);
			speedTimer.stop();
			speedTimer.removeEventListener(TimerEvent.TIMER, onSpeedTimer);
			
			remedyTimer.stop();
			remedyTimer.removeEventListener(TimerEvent.TIMER, onRemedyTimer);
			reinforceTimer.stop();
			reinforceTimer.removeEventListener(TimerEvent.TIMER, onReinforceTimer);
			stressTimer.stop();
			stressTimer.removeEventListener(TimerEvent.TIMER, onStressTimer);
			
			if (registryComponent.gameType != GameType.NEMESIS) {
				reliefTimer.stop();
				reliefTimer.removeEventListener(TimerEvent.TIMER, onReliefTimer);
				shieldedStressTimer.stop();
				shieldedStressTimer.removeEventListener(TimerEvent.TIMER, onShieldedStressTimer);
				explosiveStressTimer.stop();
				explosiveStressTimer.removeEventListener(TimerEvent.TIMER, onExplosiveStressTimer);
			}
			
			if (registryComponent.gameType == GameType.HORDE) {
				fireTimer.stop();
				fireTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFireTimer);
			} else if (registryComponent.gameType == GameType.NEMESIS) {
				nemesisImpulseTimer.stop();
				nemesisImpulseTimer.removeEventListener(TimerEvent.TIMER, onNemesisImpulseTimer);
			}
		}
		
		public function get fireRateMultiplier():Number {
			return _fireRateMultiplier;
		}
		public function set fireRateMultiplier(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_fireRateMultiplier = val;
		}
		
		public function startFireTimer():void {
			if (fireTimer) {
				fireTimer.start();
			}
		}
		
		public function spawnObjects(num:uint):void {
			var check:uint = 0;
			
			while (num > 0) {
				if (check == 0 && registryComponent.remedySpawnChance && Math.random() <= registryComponent.remedySpawnChance) {
					spawnCallback.apply(null, [RemedyStar]);
					num--;
				} else if (check == 1 && registryComponent.reinforceSpawnChance && Math.random() <= registryComponent.reinforceSpawnChance) {
					spawnCallback.apply(null, [ReinforcementStar]);
					num--;
				} else if (check == 2 && registryComponent.gameType != GameType.NEMESIS && registryComponent.reliefSpawnChance && Math.random() <= registryComponent.reliefSpawnChance) {
					spawnCallback.apply(null, [ReliefStar]);
					num--;
				} else if (check == 3 && registryComponent.stressSpawnChance && Math.random() <= registryComponent.stressSpawnChance) {
					spawnCallback.apply(null, [StressBall]);
					num--;
				} else if (check == 4 && registryComponent.gameType != GameType.NEMESIS && registryComponent.shieldedStressSpawnChance && Math.random() <= registryComponent.shieldedStressSpawnChance) {
					spawnCallback.apply(null, [ShieldedStressBall]);
					num--;
				} else if (check == 5 && registryComponent.gameType != GameType.NEMESIS && registryComponent.explosiveStressSpawnChance && Math.random() <= registryComponent.explosiveStressSpawnChance) {
					spawnCallback.apply(null, [ExplosiveStressBall]);
					num--;
				}
				
				if (check == 5) {
					check = 0;
				} else {
					check++;
				}
			}
		}
		
		//private
		private function onImpulseTimer(e:TimerEvent):void {
			for (var i:uint = 0; i < poolComponent.getUsedPool(ShieldedStressBall).length; i++) {
				for (var j:uint = 0; j < physicsEngine.numBodies; j++) {
					var body1:Body = (poolComponent.getUsedPool(ShieldedStressBall)[i] as BaseObject).body;
					var body2:Body = physicsEngine.getBody(j);
					
					if (body1 === body2) {
						continue;
					}
					if (body2 is Border) {
						continue;
					}
					
					try {
						var distance:Number = Geom.distanceBody(body1, body2, Vec2.weak(), Vec2.weak());
					} catch (ex:Error) {
						continue;
					}
					
					if (distance <= 70) {
						var impulse1:Vec2 = Vec2.get(body1.worldCOM.x - body2.worldCOM.x, body1.worldCOM.y - body2.worldCOM.y);
						impulse1.length = 40 - distance;
						body1.applyImpulse(impulse1);
						
						var impulse2:Vec2 = Vec2.get(body2.worldCOM.x - body1.worldCOM.x, body2.worldCOM.y - body1.worldCOM.y);
						impulse2.length = 80 - distance;
						body2.applyImpulse(impulse2);
					}
				}
			}
		}
		private function onNemesisImpulseTimer(e:TimerEvent):void {
			if (!registryComponent.nemesisImpulseChance || Math.random() > registryComponent.nemesisImpulseChance) {
				return;
			}
			
			for (var i:uint = 0; i < physicsEngine.numBodies; i++) {
				var body:Body = physicsEngine.getBody(i);
				if (body.type == BodyType.DYNAMIC) {
					var impulse:Vec2 = Vec2.get(stage.stageWidth / 2 - body.worldCOM.x, stage.stageHeight / 2 - body.worldCOM.y);
					impulse.length = MathUtil.random(10, 20);
					body.applyImpulse(impulse);
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
						var impulse1:Vec2 = Vec2.get(body1.worldCOM.x - body2.worldCOM.x, body1.worldCOM.y - body2.worldCOM.y);
						impulse1.length = 25;
						body1.applyImpulse(impulse1);
						
						var impulse2:Vec2 = Vec2.get(body2.worldCOM.x - body1.worldCOM.x, body2.worldCOM.y - body1.worldCOM.y);
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
			canFire = true;
			fireTimer.delay = registryComponent.fireRate * _fireRateMultiplier;
		}
		
		private function onRemedyTimer(e:TimerEvent):void {
			if (registryComponent.remedySpawnChance && Math.random() <= registryComponent.remedySpawnChance) {
				spawnCallback.apply(null, [RemedyStar]);
			}
			remedyTimer.delay = registryComponent.remedySpawnRate;
		}
		private function onReinforceTimer(e:TimerEvent):void {
			if (registryComponent.reinforceSpawnChance && Math.random() <= registryComponent.reinforceSpawnChance) {
				spawnCallback.apply(null, [ReinforcementStar]);
			}
			reinforceTimer.delay = registryComponent.reinforceSpawnRate;
		}
		private function onReliefTimer(e:TimerEvent):void {
			if (registryComponent.reliefSpawnChance && Math.random() <= registryComponent.reliefSpawnChance) {
				spawnCallback.apply(null, [ReliefStar]);
			}
			reliefTimer.delay = registryComponent.reliefSpawnRate;
		}
		private function onStressTimer(e:TimerEvent):void {
			if (registryComponent.stressSpawnChance && Math.random() <= registryComponent.stressSpawnChance) {
				spawnCallback.apply(null, [StressBall]);
			}
			stressTimer.delay = registryComponent.stressSpawnRate;
		}
		private function onShieldedStressTimer(e:TimerEvent):void {
			if (registryComponent.shieldedStressSpawnChance && Math.random() <= registryComponent.shieldedStressSpawnChance) {
				spawnCallback.apply(null, [ShieldedStressBall]);
			}
			shieldedStressTimer.delay = registryComponent.shieldedStressSpawnRate;
		}
		private function onExplosiveStressTimer(e:TimerEvent):void {
			if (registryComponent.explosiveStressSpawnChance && Math.random() <= registryComponent.explosiveStressSpawnChance) {
				spawnCallback.apply(null, [ExplosiveStressBall]);
			}
			explosiveStressTimer.delay = registryComponent.explosiveStressSpawnRate;
		}
	}
}