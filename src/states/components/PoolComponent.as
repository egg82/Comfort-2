package states.components {
	import egg82.patterns.interfaces.IComponent;
	import egg82.patterns.objectPool.DynamicObjectPool;
	import egg82.patterns.objectPool.ObjectPool;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import objects.BaseObject;
	import objects.Bullet;
	import objects.ClusterStressBall;
	import objects.ExplosiveStressBall;
	import objects.ReinforcementStar;
	import objects.ReliefStar;
	import objects.RemedyStar;
	import objects.ShieldedStressBall;
	import objects.StressBall;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class PoolComponent implements IComponent {
		//vars
		private var remedyStarPool:ObjectPool;
		private var reinforcementStarPool:ObjectPool;
		private var reliefStarPool:ObjectPool;
		
		private var stressBallPool:DynamicObjectPool;
		private var shieldedStressBallPool:ObjectPool;
		private var explosiveStressBallPool:ObjectPool;
		private var clusterStressBallPool:ObjectPool;
		
		private var bulletPool:ObjectPool;
		
		private var gameType:String;
		
		//constructor
		public function PoolComponent(gameType:String) {
			this.gameType = gameType;
		}
		
		//public
		public function create():void {
			remedyStarPool = new ObjectPool("remedyStar", new RemedyStar(gameType));
			remedyStarPool.initialize(3);
			reinforcementStarPool = new ObjectPool("reinforcementStar", new ReinforcementStar(gameType));
			reinforcementStarPool.initialize(3);
			reliefStarPool = new ObjectPool("reliefStar", new ReliefStar(gameType));
			reliefStarPool.initialize(3);
			
			stressBallPool = new DynamicObjectPool("stressBall", new StressBall(gameType));
			stressBallPool.initialize(3);
			shieldedStressBallPool = new ObjectPool("shieldedBall", new ShieldedStressBall(gameType));
			shieldedStressBallPool.initialize(4);
			explosiveStressBallPool = new ObjectPool("explosiveBall", new ExplosiveStressBall(gameType));
			explosiveStressBallPool.initialize(4);
			clusterStressBallPool = new ObjectPool("clusterBall", new ClusterStressBall(gameType));
			clusterStressBallPool.initialize(16);
			
			bulletPool = new ObjectPool("bullet", new Bullet(gameType));
			bulletPool.initialize(4);
		}
		public function destroy():void {
			remedyStarPool.clear();
			reinforcementStarPool.clear();
			reliefStarPool.clear();
			shieldedStressBallPool.clear();
			explosiveStressBallPool.clear();
			clusterStressBallPool.clear();
			stressBallPool.clear();
		}
		
		public function getUsedPool(type:Class):Vector.<IPrototype> {
			if (type == RemedyStar) {
				return remedyStarPool.usedPool;
			} else if (type == ReinforcementStar) {
				return reinforcementStarPool.usedPool;
			} else if (type == ReliefStar) {
				return reliefStarPool.usedPool;
			} else if (type == StressBall) {
				return stressBallPool.usedPool;
			} else if (type == ShieldedStressBall) {
				return shieldedStressBallPool.usedPool;
			} else if (type == ExplosiveStressBall) {
				return explosiveStressBallPool.usedPool;
			} else if (type == ClusterStressBall) {
				return clusterStressBallPool.usedPool;
			} else if (type == Bullet) {
				return bulletPool.usedPool;
			}
			
			return null;
		}
		public function getFreePool(type:Class):Vector.<IPrototype> {
			if (type == RemedyStar) {
				return remedyStarPool.freePool;
			} else if (type == ReinforcementStar) {
				return reinforcementStarPool.freePool;
			} else if (type == ReliefStar) {
				return reliefStarPool.freePool;
			} else if (type == StressBall) {
				return stressBallPool.freePool;
			} else if (type == ShieldedStressBall) {
				return shieldedStressBallPool.freePool;
			} else if (type == ExplosiveStressBall) {
				return explosiveStressBallPool.freePool;
			} else if (type == ClusterStressBall) {
				return clusterStressBallPool.freePool;
			} else if (type == Bullet) {
				return bulletPool.freePool;
			}
			
			return null;
		}
		
		public function getObject(type:Class):BaseObject {
			if (type == RemedyStar) {
				return remedyStarPool.getObject() as BaseObject;
			} else if (type == ReinforcementStar) {
				return reinforcementStarPool.getObject() as BaseObject;
			} else if (type == ReliefStar) {
				return reliefStarPool.getObject() as BaseObject;
			} else if (type == StressBall) {
				return stressBallPool.getObject() as BaseObject;
			} else if (type == ShieldedStressBall) {
				return shieldedStressBallPool.getObject() as BaseObject;
			} else if (type == ExplosiveStressBall) {
				return explosiveStressBallPool.getObject() as BaseObject;
			} else if (type == ClusterStressBall) {
				return clusterStressBallPool.getObject() as BaseObject;
			} else if (type == Bullet) {
				return bulletPool.getObject() as BaseObject;
			}
			
			return null;
		}
		public function returnObject(obj:BaseObject):void {
			if (obj is RemedyStar) {
				remedyStarPool.returnObject(obj as IPrototype);
			} else if (obj is ReinforcementStar) {
				reinforcementStarPool.returnObject(obj as IPrototype);
			} else if (obj is ReliefStar) {
				reliefStarPool.returnObject(obj as IPrototype);
			} else if (obj is StressBall) {
				stressBallPool.returnObject(obj as IPrototype);
			} else if (obj is ShieldedStressBall) {
				shieldedStressBallPool.returnObject(obj as IPrototype);
			} else if (obj is ExplosiveStressBall) {
				explosiveStressBallPool.returnObject(obj as IPrototype);
			} else if (obj is ClusterStressBall) {
				clusterStressBallPool.returnObject(obj as IPrototype);
			} else if (obj is Bullet) {
				bulletPool.returnObject(obj as IPrototype);
			}
		}
		
		public function draw():void {
			var i:uint;
			
			for (i = 0; i < remedyStarPool.usedPool.length; i++) {
				(remedyStarPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < reinforcementStarPool.usedPool.length; i++) {
				(reinforcementStarPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < reliefStarPool.usedPool.length; i++) {
				(reliefStarPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < stressBallPool.usedPool.length; i++) {
				(stressBallPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < shieldedStressBallPool.usedPool.length; i++) {
				(shieldedStressBallPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < explosiveStressBallPool.usedPool.length; i++) {
				(explosiveStressBallPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < clusterStressBallPool.usedPool.length; i++) {
				(clusterStressBallPool.usedPool[i]["draw"] as Function).call();
			}
			for (i = 0; i < bulletPool.usedPool.length; i++) {
				(bulletPool.usedPool[i]["draw"] as Function).call();
			}
		}
		
		//private
		
	}
}