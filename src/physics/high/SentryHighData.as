package physics.high {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class SentryHighData implements IPhysicsData {
		//vars
		
		//constructor
		public function SentryHighData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(16,61), Vec2.weak(23,62), Vec2.weak(41,54), Vec2.weak(27,40), Vec2.weak(19,44), Vec2.weak(13,51), Vec2.weak(13,56)]));
			polies.push(new Polygon([Vec2.weak(113,61), Vec2.weak(116,56), Vec2.weak(115,49), Vec2.weak(110,44), Vec2.weak(102,40), Vec2.weak(94,56), Vec2.weak(106,62)]));
			polies.push(new Polygon([Vec2.weak(94,56), Vec2.weak(102,40), Vec2.weak(96,39), Vec2.weak(33,39), Vec2.weak(27,40)]));
			polies.push(new Polygon([Vec2.weak(35,37), Vec2.weak(33,39), Vec2.weak(96,39), Vec2.weak(94,37)]));
			polies.push(new Polygon([Vec2.weak(41,54), Vec2.weak(56,51), Vec2.weak(27,40)]));
			polies.push(new Polygon([Vec2.weak(62,15), Vec2.weak(49,33), Vec2.weak(80,33), Vec2.weak(67,15)]));
			polies.push(new Polygon([Vec2.weak(56,51), Vec2.weak(73,51), Vec2.weak(27,40)]));
			polies.push(new Polygon([Vec2.weak(49,33), Vec2.weak(39,37), Vec2.weak(90,37), Vec2.weak(80,33)]));
			
			return polies;
		}
		
		//private
		
	}
}