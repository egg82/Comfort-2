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
			shieldedStressBallPool = new ObjectPool("shieldedBall", new ShieldedStressBall(gmeType));
			shieldedStressBallPool.initialize(4);
			explosiveStressBallPool = new ObjectPool("explosiveBall", new ExplosiveStressBall(gameType));
			explosiveStressBallPool.initialize(4);
			clusterStressBallPool = new ObjectPool("clusterBall", new ClusterStressBall(gameType));
			clusterStressBallPool.initialize(16);
			
			bulletPool = new ObjectPool("bullet", new Bullet(gameType));
			bulletPool.initialize(6);
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
		
		public function getObject(type:Class):BaseObject {
			if (type is RemedyStar) {
				return remedyStarPool.getObject() as BaseObject;
			} else if (type is ReinforcementStar) {
				return reinforcementStarPool.getObject() as BaseObject;
			} else if (type is ReliefStar) {
				return reliefStarPool.getObject() as BaseObject;
			} else if (type is StressBall) {
				return stressBallPool.getObject() as BaseObject;
			} else if (type is ShieldedStressBall) {
				return shieldedStressBallPool.getObject() as BaseObject;
			} else if (type is ExplosiveStressBall) {
				return explosiveStressBallPool.getObject() as BaseObject;
			} else if (type is ClusterStressBall) {
				return clusterStressBallPool.getObject() as BaseObject;
			} else if (type is Bullet) {
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
		
		//private
		
	}
}