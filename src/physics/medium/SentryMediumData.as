package physics.medium {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class SentryMediumData implements IPhysicsData {
		//vars
		
		//constructor
		public function SentryMediumData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(114.5,58), Vec2.weak(115.5,52), Vec2.weak(109,43.5), Vec2.weak(79,31.5), Vec2.weak(71,50.5), Vec2.weak(107,61.5)]));
			polies.push(new Polygon([Vec2.weak(71,50.5), Vec2.weak(79,31.5), Vec2.weak(64,14.5), Vec2.weak(63,14.5), Vec2.weak(49,31.5), Vec2.weak(49,51.5)]));
			polies.push(new Polygon([Vec2.weak(13.5,58), Vec2.weak(21,61.5), Vec2.weak(49,51.5), Vec2.weak(49,31.5), Vec2.weak(19,43.5), Vec2.weak(12.5,52)]));
			
			return polies;
		}
		
		//private
		
	}
}
