package physics.high {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class BulletHighData implements IPhysicsData {
		//vars
		
		//constructor
		public function BulletHighData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(19,62), Vec2.weak(22,58), Vec2.weak(22,15), Vec2.weak(19,11), Vec2.weak(11,15), Vec2.weak(11,58), Vec2.weak(14,62)]));
			polies.push(new Polygon([Vec2.weak(14,11), Vec2.weak(11,15), Vec2.weak(19,11)]));
			
			return polies;
		}
		
		//private
		
	}
}