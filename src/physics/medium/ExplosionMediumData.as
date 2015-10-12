package physics.medium {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class ExplosionMediumData implements IPhysicsData {
		//vars
		
		//constructor
		public function ExplosionMediumData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(31.5,162), Vec2.weak(70,186.5), Vec2.weak(70,137.5)]));
			polies.push(new Polygon([Vec2.weak(295.5,162), Vec2.weak(255,134.5), Vec2.weak(255.5,188)]));
			polies.push(new Polygon([Vec2.weak(257,66.5), Vec2.weak(207,77.5), Vec2.weak(247.5,114)]));
			polies.push(new Polygon([Vec2.weak(71.5,69), Vec2.weak(81.5,117), Vec2.weak(126,77.5)]));
			polies.push(new Polygon([Vec2.weak(161,293.5), Vec2.weak(195,247.5), Vec2.weak(135,253.5)]));
			polies.push(new Polygon([Vec2.weak(259,256.5), Vec2.weak(249.5,197), Vec2.weak(211,246.5)]));
			polies.push(new Polygon([Vec2.weak(70,137.5), Vec2.weak(70,186.5), Vec2.weak(79.5,198), Vec2.weak(80.5,127)]));
			polies.push(new Polygon([Vec2.weak(211,246.5), Vec2.weak(249.5,197), Vec2.weak(195,247.5)]));
			polies.push(new Polygon([Vec2.weak(195,247.5), Vec2.weak(249.5,197), Vec2.weak(255.5,188), Vec2.weak(133,72.5), Vec2.weak(126,77.5), Vec2.weak(127,246.5), Vec2.weak(135,253.5)]));
			polies.push(new Polygon([Vec2.weak(164.5,33), Vec2.weak(160,30.5), Vec2.weak(133,72.5), Vec2.weak(164.5,34)]));
			polies.push(new Polygon([Vec2.weak(247.5,114), Vec2.weak(207,77.5), Vec2.weak(194.5,76), Vec2.weak(133,72.5), Vec2.weak(248.5,126)]));
			polies.push(new Polygon([Vec2.weak(164.5,34), Vec2.weak(133,72.5), Vec2.weak(186.5,69)]));
			polies.push(new Polygon([Vec2.weak(186.5,69), Vec2.weak(133,72.5), Vec2.weak(194.5,76)]));
			polies.push(new Polygon([Vec2.weak(255,134.5), Vec2.weak(248.5,126), Vec2.weak(133,72.5), Vec2.weak(255.5,188)]));
			polies.push(new Polygon([Vec2.weak(81.5,117), Vec2.weak(80.5,127), Vec2.weak(79.5,198), Vec2.weak(115,245.5), Vec2.weak(127,246.5), Vec2.weak(126,77.5)]));
			polies.push(new Polygon([Vec2.weak(69.5,254), Vec2.weak(73,255.5), Vec2.weak(115,245.5), Vec2.weak(79.5,198)]));
			
			return polies;
		}
		
		//private
		
	}
}
