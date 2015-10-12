package objects {
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import objects.base.BasePhysicsObject;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class Border extends BasePhysicsObject {
		//vars
		
		//constructor
		public function Border(width:uint, height:uint) {
			var body:Body = new Body(BodyType.STATIC);
			body.shapes.add(new Polygon(Polygon.rect(-40, 0, width + 80, -40)));
			body.shapes.add(new Polygon(Polygon.rect(0, 0, -40, height)));
			body.shapes.add(new Polygon(Polygon.rect(width, 0, 40, height)));
			body.shapes.add(new Polygon(Polygon.rect(-40, height, width + 80, 40)));
			
			super("null", null, body, 0);
		}
		
		//public
		
		//private
		
	}
}