package objects {
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import objects.physics.PhysicsComponent;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Border extends BaseObject {
		//vars
		
		//constructor
		public function Border(width:uint, height:uint) {
			physicsComponent = new PhysicsComponent(BodyType.STATIC);
			
			physicsComponent.setShapes([
				new Polygon(Polygon.rect(-40, 0, width + 80, -40)),
				new Polygon(Polygon.rect(0, 0, -40, height)),
				new Polygon(Polygon.rect(width, 0, 40, height)),
				new Polygon(Polygon.rect(-40, height, width + 80, 40))
			]);
			
			physicsComponent.body.allowRotation = false;
			physicsComponent.body.allowMovement = false;
			physicsComponent.body.isBullet = false;
		}
		
		//public
		
		//private
		
	}
}