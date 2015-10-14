package physics.medium {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class PaddleMediumData implements IPhysicsData {
		//vars
		
		//constructor
		public function PaddleMediumData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(240.5,82), Vec2.weak(248.5,69), Vec2.weak(247.5,55), Vec2.weak(168,18.5), Vec2.weak(122,15.5), Vec2.weak(121,15.5), Vec2.weak(178,63.5), Vec2.weak(228,84.5)]));
			polies.push(new Polygon([Vec2.weak(15.5,59), Vec2.weak(19.5,77), Vec2.weak(36,83.5), Vec2.weak(82,64.5), Vec2.weak(121,15.5), Vec2.weak(66,25.5), Vec2.weak(22,45.5)]));
			polies.push(new Polygon([Vec2.weak(28,83.5), Vec2.weak(36,83.5), Vec2.weak(19.5,77)]));
			polies.push(new Polygon([Vec2.weak(82,64.5), Vec2.weak(120,57.5), Vec2.weak(121,15.5)]));
			polies.push(new Polygon([Vec2.weak(120,57.5), Vec2.weak(144,57.5), Vec2.weak(121,15.5)]));
			polies.push(new Polygon([Vec2.weak(144,57.5), Vec2.weak(178,63.5), Vec2.weak(121,15.5)]));
			polies.push(new Polygon([Vec2.weak(243,47.5), Vec2.weak(220,34.5), Vec2.weak(168,18.5), Vec2.weak(247.5,55)]));
			
			return polies;
		}
		
		//private
		
	}
}
