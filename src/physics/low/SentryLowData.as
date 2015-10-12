package physics.low {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class SentryLowData implements IPhysicsData {
		//vars
		
		//constructor
		public function SentryLowData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(113.5,59), Vec2.weak(110,44.5), Vec2.weak(81.5,33), Vec2.weak(70,50.5)]));
			polies.push(new Polygon([Vec2.weak(81.5,33), Vec2.weak(64,14.5), Vec2.weak(63,14.5), Vec2.weak(46,33.5), Vec2.weak(70,50.5)]));
			polies.push(new Polygon([Vec2.weak(18,44.5), Vec2.weak(14.5,59), Vec2.weak(70,50.5), Vec2.weak(46,33.5)]));
			
			return polies;
		}
		
		//private
		
	}
}