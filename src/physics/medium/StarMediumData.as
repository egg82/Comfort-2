package physics.medium {
	import physics.IPhysicsData;
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	
	public class StarMediumData implements IPhysicsData {
		//vars
		
		//constructor
		public function StarMediumData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.get(13.5,33), Vec2.get(20.5,48), Vec2.get(38,61.5), Vec2.get(28,24.5)]));
			polies.push(new Polygon([Vec2.get(65.5,35), Vec2.get(40,13.5), Vec2.get(39,13.5), Vec2.get(58.5,49)]));
			polies.push(new Polygon([Vec2.get(26,64.5), Vec2.get(38,61.5), Vec2.get(20.5,48), Vec2.get(21.5,60)]));
			polies.push(new Polygon([Vec2.get(28,24.5), Vec2.get(38,61.5), Vec2.get(52,64.5), Vec2.get(56,62.5), Vec2.get(58.5,49), Vec2.get(39,13.5)]));
			
			return polies;
		}
		
		//private
		
	}
}
