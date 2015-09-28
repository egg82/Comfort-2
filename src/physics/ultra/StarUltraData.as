package physics.ultra {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;

	public class StarUltraData implements IPhysicsData {
		//vars
		
		//constructor
		public function StarUltraData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.get(57,63), Vec2.get(57,62), Vec2.get(56,63)]));
			polies.push(new Polygon([Vec2.get(24,64), Vec2.get(33,64), Vec2.get(33,63), Vec2.get(24,63)]));
			polies.push(new Polygon([Vec2.get(23,63), Vec2.get(33,63), Vec2.get(23,62)]));
			polies.push(new Polygon([Vec2.get(17,42), Vec2.get(18,42), Vec2.get(24,28), Vec2.get(17,41)]));
			polies.push(new Polygon([Vec2.get(16,41), Vec2.get(17,41), Vec2.get(24,28), Vec2.get(21,29), Vec2.get(16,40)]));
			polies.push(new Polygon([Vec2.get(15,31), Vec2.get(15,38), Vec2.get(16,31)]));
			polies.push(new Polygon([Vec2.get(28,25), Vec2.get(28,26), Vec2.get(52,26), Vec2.get(52,25)]));
			polies.push(new Polygon([Vec2.get(29,24), Vec2.get(29,25), Vec2.get(51,25), Vec2.get(51,24)]));
			polies.push(new Polygon([Vec2.get(30,23), Vec2.get(30,24), Vec2.get(50,24), Vec2.get(50,23)]));
			polies.push(new Polygon([Vec2.get(31,22), Vec2.get(31,23), Vec2.get(49,23), Vec2.get(32,22)]));
			polies.push(new Polygon([Vec2.get(33,19), Vec2.get(33,20), Vec2.get(34,19)]));
			polies.push(new Polygon([Vec2.get(34,18), Vec2.get(34,19), Vec2.get(46,19), Vec2.get(35,18)]));
			polies.push(new Polygon([Vec2.get(45,16), Vec2.get(44,16), Vec2.get(45,17)]));
			polies.push(new Polygon([Vec2.get(47,19), Vec2.get(34,19), Vec2.get(32,22), Vec2.get(47,20)]));
			polies.push(new Polygon([Vec2.get(48,20), Vec2.get(47,20), Vec2.get(48,21)]));
			polies.push(new Polygon([Vec2.get(64,31), Vec2.get(63,31), Vec2.get(64,32)]));
			polies.push(new Polygon([Vec2.get(65,32), Vec2.get(64,32), Vec2.get(64,39), Vec2.get(65,39)]));
			polies.push(new Polygon([Vec2.get(63,42), Vec2.get(63,41), Vec2.get(58,29), Vec2.get(56,28), Vec2.get(62,42)]));
			polies.push(new Polygon([Vec2.get(56,64), Vec2.get(56,63), Vec2.get(47,63), Vec2.get(47,64)]));
			polies.push(new Polygon([Vec2.get(20,48), Vec2.get(59,48), Vec2.get(60,46), Vec2.get(52,26), Vec2.get(28,26), Vec2.get(26,27), Vec2.get(20,46)]));
			polies.push(new Polygon([Vec2.get(19,46), Vec2.get(20,46), Vec2.get(26,27), Vec2.get(24,28), Vec2.get(19,44)]));
			polies.push(new Polygon([Vec2.get(18,44), Vec2.get(19,44), Vec2.get(24,28), Vec2.get(18,42)]));
			polies.push(new Polygon([Vec2.get(15,40), Vec2.get(16,40), Vec2.get(21,29), Vec2.get(18,30), Vec2.get(15,38)]));
			polies.push(new Polygon([Vec2.get(16,30), Vec2.get(16,31), Vec2.get(18,30)]));
			polies.push(new Polygon([Vec2.get(24,27), Vec2.get(24,28), Vec2.get(26,27)]));
			polies.push(new Polygon([Vec2.get(26,26), Vec2.get(26,27), Vec2.get(28,26)]));
			polies.push(new Polygon([Vec2.get(32,20), Vec2.get(32,22), Vec2.get(33,20)]));
			polies.push(new Polygon([Vec2.get(35,16), Vec2.get(35,18), Vec2.get(36,16)]));
			polies.push(new Polygon([Vec2.get(36,15), Vec2.get(36,16), Vec2.get(38,15)]));
			polies.push(new Polygon([Vec2.get(44,15), Vec2.get(42,15), Vec2.get(44,16)]));
			polies.push(new Polygon([Vec2.get(46,17), Vec2.get(45,17), Vec2.get(46,19)]));
			polies.push(new Polygon([Vec2.get(49,21), Vec2.get(48,21), Vec2.get(49,23)]));
			polies.push(new Polygon([Vec2.get(54,26), Vec2.get(52,26), Vec2.get(54,27)]));
			polies.push(new Polygon([Vec2.get(56,27), Vec2.get(54,27), Vec2.get(56,28)]));
			polies.push(new Polygon([Vec2.get(58,28), Vec2.get(56,28), Vec2.get(58,29)]));
			polies.push(new Polygon([Vec2.get(63,30), Vec2.get(61,30), Vec2.get(63,31)]));
			polies.push(new Polygon([Vec2.get(64,41), Vec2.get(64,39), Vec2.get(61,30), Vec2.get(58,29), Vec2.get(63,41)]));
			polies.push(new Polygon([Vec2.get(62,44), Vec2.get(62,42), Vec2.get(56,28), Vec2.get(54,27), Vec2.get(61,44)]));
			polies.push(new Polygon([Vec2.get(61,46), Vec2.get(61,44), Vec2.get(54,27), Vec2.get(52,26), Vec2.get(60,46)]));
			polies.push(new Polygon([Vec2.get(60,48), Vec2.get(60,46), Vec2.get(59,48)]));
			polies.push(new Polygon([Vec2.get(36,16), Vec2.get(35,18), Vec2.get(42,15), Vec2.get(42,14), Vec2.get(38,15)]));
			polies.push(new Polygon([Vec2.get(54,65), Vec2.get(54,64), Vec2.get(51,64), Vec2.get(51,65)]));
			polies.push(new Polygon([Vec2.get(44,63), Vec2.get(56,63), Vec2.get(58,57), Vec2.get(59,48), Vec2.get(44,62)]));
			polies.push(new Polygon([Vec2.get(18,29), Vec2.get(18,30), Vec2.get(21,29)]));
			polies.push(new Polygon([Vec2.get(21,28), Vec2.get(21,29), Vec2.get(24,28)]));
			polies.push(new Polygon([Vec2.get(61,29), Vec2.get(58,29), Vec2.get(61,30)]));
			polies.push(new Polygon([Vec2.get(37,63), Vec2.get(37,62), Vec2.get(22,53), Vec2.get(23,62), Vec2.get(33,63)]));
			polies.push(new Polygon([Vec2.get(38,14), Vec2.get(38,15), Vec2.get(42,14)]));
			polies.push(new Polygon([Vec2.get(66,33), Vec2.get(65,33), Vec2.get(65,37), Vec2.get(66,37)]));
			polies.push(new Polygon([Vec2.get(58,62), Vec2.get(58,57), Vec2.get(57,62)]));
			polies.push(new Polygon([Vec2.get(30,65), Vec2.get(30,64), Vec2.get(25,64), Vec2.get(25,65)]));
			polies.push(new Polygon([Vec2.get(21,53), Vec2.get(22,53), Vec2.get(59,48), Vec2.get(21,48)]));
			polies.push(new Polygon([Vec2.get(14,38), Vec2.get(15,38), Vec2.get(15,32), Vec2.get(14,32)]));
			polies.push(new Polygon([Vec2.get(16,31), Vec2.get(15,38), Vec2.get(18,30)]));
			polies.push(new Polygon([Vec2.get(57,62), Vec2.get(58,57), Vec2.get(56,63)]));
			polies.push(new Polygon([Vec2.get(33,20), Vec2.get(32,22), Vec2.get(34,19)]));
			polies.push(new Polygon([Vec2.get(44,16), Vec2.get(42,15), Vec2.get(35,18), Vec2.get(46,19), Vec2.get(45,17)]));
			polies.push(new Polygon([Vec2.get(48,21), Vec2.get(47,20), Vec2.get(32,22), Vec2.get(49,23)]));
			polies.push(new Polygon([Vec2.get(63,31), Vec2.get(61,30), Vec2.get(64,39), Vec2.get(64,32)]));
			polies.push(new Polygon([Vec2.get(59,57), Vec2.get(59,48), Vec2.get(58,57)]));
			polies.push(new Polygon([Vec2.get(44,62), Vec2.get(59,48), Vec2.get(22,53), Vec2.get(37,62)]));
			polies.push(new Polygon([Vec2.get(22, 62), Vec2.get(23, 62), Vec2.get(22, 53)]));
			
			return polies;
		}
		
		//private
		
	}
}