package physics.low {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class ExplosionLowData implements IPhysicsData {
		//vars
		
		//constructor
		public function ExplosionLowData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(71.5,71), Vec2.weak(80.5,127), Vec2.weak(127,76.5)]));
			polies.push(new Polygon([Vec2.weak(32.5,163), Vec2.weak(78.5,195), Vec2.weak(251,193.5), Vec2.weak(194.5,76), Vec2.weak(80.5,127)]));
			polies.push(new Polygon([Vec2.weak(296.5,161), Vec2.weak(248.5,125), Vec2.weak(251,193.5)]));
			polies.push(new Polygon([Vec2.weak(159.5,292), Vec2.weak(197,247.5), Vec2.weak(127,246.5)]));
			polies.push(new Polygon([Vec2.weak(257,257.5), Vec2.weak(251,193.5), Vec2.weak(78.5,195), Vec2.weak(197,247.5)]));
			polies.push(new Polygon([Vec2.weak(71,255.5), Vec2.weak(127,246.5), Vec2.weak(78.5,195)]));
			polies.push(new Polygon([Vec2.weak(258.5,69), Vec2.weak(194.5,76), Vec2.weak(248.5,125)]));
			polies.push(new Polygon([Vec2.weak(127,246.5), Vec2.weak(197,247.5), Vec2.weak(78.5,195)]));
			polies.push(new Polygon([Vec2.weak(248.5,125), Vec2.weak(194.5,76), Vec2.weak(251,193.5)]));
			polies.push(new Polygon([Vec2.weak(80.5,127), Vec2.weak(194.5,76), Vec2.weak(127,76.5)]));
			polies.push(new Polygon([Vec2.weak(127,76.5), Vec2.weak(194.5,76), Vec2.weak(164.5,34), Vec2.weak(159.5,31)]));
			polies.push(new Polygon([Vec2.weak(164.5,33), Vec2.weak(159.5,31), Vec2.weak(164.5,34)]));
			
			return polies;
		}
		
		//private
		
	}
}
