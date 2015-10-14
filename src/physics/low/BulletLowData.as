package physics.low {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class BulletLowData implements IPhysicsData {
		//vars
		
		//constructor
		public function BulletLowData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(15, 61.5), Vec2.weak(21.5, 57), Vec2.weak(21.5, 17), Vec2.weak(16, 10.5), Vec2.weak(15, 10.5), Vec2.weak(10.5, 15), Vec2.weak(10.5, 55)]));
			
			return polies;
		}
		
		//private
		
	}
}