package objects.base {
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BasePolyPhysicsObject extends BasePhysicsObject {
		//vars
		
		//constructor
		public function BasePolyPhysicsObject(atlasUrl:String, atlasXMLUrl:String, physicsData:IPhysicsData, damage:Number, bodyType:BodyType = null) {
			var body:Body = new Body((bodyType) ? bodyType : BodyType.DYNAMIC);
			
			var polygons:Vector.<Polygon> = physicsData.getPolygons();
			for (var i:uint = 0; i < polygons.length; i++) {
				body.shapes.add(polygons[i]);
			}
			
			super(atlasUrl, atlasXMLUrl, body, damage);
		}
		
		//public
		
		//private
		protected function updateBody(physicsData:IPhysicsData):void {
			body.shapes.clear();
			
			var polygons:Vector.<Polygon> = physicsData.getPolygons();
			for (var i:uint = 0; i < polygons.length; i++) {
				body.shapes.add(polygons[i]);
			}
		}
	}
}