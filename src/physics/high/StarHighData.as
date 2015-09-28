package physics.high {
	import nape.geom.Vec2;
	import physics.IPhysicsData;
	import nape.shape.Polygon;
	
	public class StarHighData implements IPhysicsData {
		//vars
		
		//constructor
		public function StarHighData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.get(14,32), Vec2.get(14,38), Vec2.get(21,48), Vec2.get(28,26), Vec2.get(18,29)]));
			polies.push(new Polygon([Vec2.get(42,14), Vec2.get(36,15), Vec2.get(28,26), Vec2.get(21,48), Vec2.get(37,62), Vec2.get(44,62), Vec2.get(46,19), Vec2.get(46,17)]));
			polies.push(new Polygon([Vec2.get(58,62), Vec2.get(59,57), Vec2.get(59,48), Vec2.get(52,26), Vec2.get(46,19), Vec2.get(44,62), Vec2.get(47,64), Vec2.get(54,65)]));
			polies.push(new Polygon([Vec2.get(25,65), Vec2.get(30,65), Vec2.get(37,62), Vec2.get(21,48), Vec2.get(22,62)]));
			polies.push(new Polygon([Vec2.get(66,33), Vec2.get(61,29), Vec2.get(52,26), Vec2.get(59,48), Vec2.get(66,37)]));
			
			return polies;
		}
		
		//private
		
	}
}
