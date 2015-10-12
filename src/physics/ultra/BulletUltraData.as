package physics.ultra {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class BulletUltraData implements IPhysicsData {
		//vars
		
		//constructor
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(20,61), Vec2.weak(20,60), Vec2.weak(14,61)]));
			polies.push(new Polygon([Vec2.weak(13,61), Vec2.weak(14,61), Vec2.weak(20,60), Vec2.weak(21,58), Vec2.weak(13,60)]));
			polies.push(new Polygon([Vec2.weak(13,12), Vec2.weak(13,13), Vec2.weak(19,12)]));
			polies.push(new Polygon([Vec2.weak(20,12), Vec2.weak(19,12), Vec2.weak(13,13), Vec2.weak(12,15), Vec2.weak(20,13)]));
			polies.push(new Polygon([Vec2.weak(21,60), Vec2.weak(21,58), Vec2.weak(20,60)]));
			polies.push(new Polygon([Vec2.weak(12,60), Vec2.weak(13,60), Vec2.weak(21,58), Vec2.weak(22,15), Vec2.weak(12,15)]));
			polies.push(new Polygon([Vec2.weak(12,13), Vec2.weak(12,15), Vec2.weak(13,13)]));
			polies.push(new Polygon([Vec2.weak(21,13), Vec2.weak(20,13), Vec2.weak(12,15), Vec2.weak(21,15)]));
			polies.push(new Polygon([Vec2.weak(19,62), Vec2.weak(19,61), Vec2.weak(14,61), Vec2.weak(14,62)]));
			polies.push(new Polygon([Vec2.weak(14,11), Vec2.weak(14,12), Vec2.weak(19,12), Vec2.weak(19,11)]));
			polies.push(new Polygon([Vec2.weak(22,58), Vec2.weak(22,15), Vec2.weak(21,58)]));
			polies.push(new Polygon([Vec2.weak(11,58), Vec2.weak(12,58), Vec2.weak(12,15), Vec2.weak(11,15)]));
			
			return polies;
		}
		
		//private
		
	}
}