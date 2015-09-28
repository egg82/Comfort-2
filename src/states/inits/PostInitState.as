package states.inits {
	import egg82.base.BaseState;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.patterns.objectPool.DynamicObjectPool;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import enums.GameType;
	import enums.objects.StarType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import objects.base.BaseCirclePhysicsObject;
	import objects.base.BaseStarPhysicsObject;
	import objects.CorePhysicsObject;
	import objects.RemedyStar;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class PostInitState extends BaseState {
		//vars
		private var physicsEngine:IPhysicsEngine = ServiceLocator.getService("physicsEngine") as IPhysicsEngine;
		private var physicsRegistry:IRegistry = ServiceLocator.getService("physicsRegistry") as IRegistry;
		
		private var testCircle:CorePhysicsObject;
		
		private var zeroMat:Material = new Material(1, 0, 0, 1, 0);
		
		private var remedyStarPool:DynamicObjectPool = new DynamicObjectPool("remedyStar", new RemedyStar(GameType.HORDE));
		
		//constructor
		public function PostInitState() {
			
		}
		
		//public
		override public function create():void {
			super.create();
			
			trace("postInit");
			
			var border:Body = new Body(BodyType.STATIC);
			border.shapes.add(new Polygon(Polygon.rect(-40, 0, stage.stageWidth + 80, -40), zeroMat));
			border.shapes.add(new Polygon(Polygon.rect(0, 0, -40, stage.stageHeight), zeroMat));
			border.shapes.add(new Polygon(Polygon.rect(stage.stageWidth, 0, 40, stage.stageHeight), zeroMat));
			border.shapes.add(new Polygon(Polygon.rect(-40, stage.stageHeight, stage.stageWidth + 80, 40), zeroMat));
			
			var testStar:RemedyStar = remedyStarPool.getObject() as RemedyStar;
			testStar.body.position.setxy(100, 100);
			testStar.body.applyAngularImpulse(2000);
			var impulse:Vec2 = Vec2.get(stage.stageWidth - testStar.body.position.x, stage.stageHeight - testStar.body.position.y);
			impulse.length = 500;
			testStar.body.applyImpulse(impulse);
			
			testCircle = new CorePhysicsObject(GameType.HORDE);
			testCircle.body.position.setxy(stage.stageWidth / 2, stage.stageHeight / 2);
			
			physicsEngine.addBody(border);
			addChild(testStar);
			addChild(testCircle);
		}
		
		//private
		
	}
}