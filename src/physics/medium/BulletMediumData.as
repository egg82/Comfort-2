package physics.medium {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class BulletMediumData implements IPhysicsData {
		//vars
		
		//constructor
		public function BulletMediumData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(18, 61.5), Vec2.weak(21.5, 56), Vec2.weak(21.5, 16), Vec2.weak(16, 10.5), Vec2.weak(15, 10.5), Vec2.weak(10.5, 16), Vec2.weak(10.5, 56), Vec2.weak(14, 61.5)]));
			
			return polies;
		}
		
		//private
		
	}
}