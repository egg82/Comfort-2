package physics.low {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class PaddleLowData implements IPhysicsData {
		//vars
		
		//constructor
		public function PaddleLowData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(19.5,77), Vec2.weak(34,83.5), Vec2.weak(82,64.5), Vec2.weak(122,15.5), Vec2.weak(121,15.5), Vec2.weak(66,25.5), Vec2.weak(22,45.5), Vec2.weak(15.5,61)]));
			polies.push(new Polygon([Vec2.weak(242,80.5), Vec2.weak(248.5,69), Vec2.weak(244,49.5), Vec2.weak(222,35.5), Vec2.weak(178,20.5), Vec2.weak(178,63.5), Vec2.weak(230,84.5)]));
			polies.push(new Polygon([Vec2.weak(178,63.5), Vec2.weak(178,20.5), Vec2.weak(122,15.5), Vec2.weak(122,57.5)]));
			polies.push(new Polygon([Vec2.weak(122,57.5), Vec2.weak(122,15.5), Vec2.weak(82,64.5)]));
			
			return polies;
		}
		
		//private
		
	}
}