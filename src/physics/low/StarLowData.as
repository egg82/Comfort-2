package physics.low {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class StarLowData implements IPhysicsData {
		//vars
		
		//constructor
		public function StarLowData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.get(13.5,35), Vec2.get(27,64.5), Vec2.get(55.5,63), Vec2.get(65.5,35), Vec2.get(40,13.5), Vec2.get(39,13.5)]));
			
			return polies;
		}
		
		//private
		
	}
}