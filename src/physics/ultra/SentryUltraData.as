package physics.ultra {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class SentryUltraData implements IPhysicsData {
		//vars
		
		//constructor
		public function SentryUltraData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(15,60), Vec2.weak(26,60), Vec2.weak(30,58), Vec2.weak(15,49)]));
			polies.push(new Polygon([Vec2.weak(15,48), Vec2.weak(15,49), Vec2.weak(16,48)]));
			polies.push(new Polygon([Vec2.weak(16,47), Vec2.weak(16,48), Vec2.weak(17,47)]));
			polies.push(new Polygon([Vec2.weak(17,46), Vec2.weak(17,47), Vec2.weak(18,46)]));
			polies.push(new Polygon([Vec2.weak(18,45), Vec2.weak(18,46), Vec2.weak(19,45)]));
			polies.push(new Polygon([Vec2.weak(49,32), Vec2.weak(49,33), Vec2.weak(80,33), Vec2.weak(80,32)]));
			polies.push(new Polygon([Vec2.weak(50,31), Vec2.weak(50,32), Vec2.weak(79,32), Vec2.weak(79,31)]));
			polies.push(new Polygon([Vec2.weak(51,30), Vec2.weak(51,31), Vec2.weak(78,31), Vec2.weak(78,30)]));
			polies.push(new Polygon([Vec2.weak(53,27), Vec2.weak(53,28), Vec2.weak(54,27)]));
			polies.push(new Polygon([Vec2.weak(54,26), Vec2.weak(54,27), Vec2.weak(55,26)]));
			polies.push(new Polygon([Vec2.weak(56,23), Vec2.weak(56,24), Vec2.weak(57,23)]));
			polies.push(new Polygon([Vec2.weak(58,20), Vec2.weak(58,21), Vec2.weak(59,20)]));
			polies.push(new Polygon([Vec2.weak(60,17), Vec2.weak(60,18), Vec2.weak(61,17)]));
			polies.push(new Polygon([Vec2.weak(61,16), Vec2.weak(61,17), Vec2.weak(68,17), Vec2.weak(68,16)]));
			polies.push(new Polygon([Vec2.weak(69,17), Vec2.weak(68,17), Vec2.weak(69,18)]));
			polies.push(new Polygon([Vec2.weak(71,20), Vec2.weak(70,20), Vec2.weak(71,21)]));
			polies.push(new Polygon([Vec2.weak(73,23), Vec2.weak(72,23), Vec2.weak(73,24)]));
			polies.push(new Polygon([Vec2.weak(75,26), Vec2.weak(74,26), Vec2.weak(75,27)]));
			polies.push(new Polygon([Vec2.weak(76,27), Vec2.weak(75,27), Vec2.weak(76,28)]));
			polies.push(new Polygon([Vec2.weak(111,45), Vec2.weak(110,45), Vec2.weak(111,46)]));
			polies.push(new Polygon([Vec2.weak(112,46), Vec2.weak(111,46), Vec2.weak(112,47)]));
			polies.push(new Polygon([Vec2.weak(113,47), Vec2.weak(112,47), Vec2.weak(113,48)]));
			polies.push(new Polygon([Vec2.weak(114,48), Vec2.weak(113,48), Vec2.weak(99,58), Vec2.weak(103,60), Vec2.weak(113,60), Vec2.weak(114,59)]));
			polies.push(new Polygon([Vec2.weak(114,60), Vec2.weak(114,59), Vec2.weak(113,60)]));
			polies.push(new Polygon([Vec2.weak(35,57), Vec2.weak(35,56), Vec2.weak(15,49), Vec2.weak(33,57)]));
			polies.push(new Polygon([Vec2.weak(30,59), Vec2.weak(30,58), Vec2.weak(28,59)]));
			polies.push(new Polygon([Vec2.weak(28,60), Vec2.weak(28,59), Vec2.weak(26,60)]));
			polies.push(new Polygon([Vec2.weak(16,61), Vec2.weak(26,61), Vec2.weak(26,60), Vec2.weak(16,60)]));
			polies.push(new Polygon([Vec2.weak(14,49), Vec2.weak(14,59), Vec2.weak(15,59), Vec2.weak(15,49)]));
			polies.push(new Polygon([Vec2.weak(19,44), Vec2.weak(19,45), Vec2.weak(21,44)]));
			polies.push(new Polygon([Vec2.weak(21,43), Vec2.weak(21,44), Vec2.weak(23,43)]));
			polies.push(new Polygon([Vec2.weak(23,42), Vec2.weak(23,43), Vec2.weak(25,42)]));
			polies.push(new Polygon([Vec2.weak(25,41), Vec2.weak(25,42), Vec2.weak(27,41)]));
			polies.push(new Polygon([Vec2.weak(33,38), Vec2.weak(33,39), Vec2.weak(35,38)]));
			polies.push(new Polygon([Vec2.weak(45,34), Vec2.weak(45,35), Vec2.weak(84,35), Vec2.weak(84,34)]));
			polies.push(new Polygon([Vec2.weak(47,33), Vec2.weak(47,34), Vec2.weak(82,34), Vec2.weak(82,33)]));
			polies.push(new Polygon([Vec2.weak(52,28), Vec2.weak(52,30), Vec2.weak(53,28)]));
			polies.push(new Polygon([Vec2.weak(55,24), Vec2.weak(55,26), Vec2.weak(56,24)]));
			polies.push(new Polygon([Vec2.weak(57,21), Vec2.weak(57,23), Vec2.weak(58,21)]));
			polies.push(new Polygon([Vec2.weak(59,18), Vec2.weak(59,20), Vec2.weak(60,18)]));
			polies.push(new Polygon([Vec2.weak(70,18), Vec2.weak(69,18), Vec2.weak(70,20)]));
			polies.push(new Polygon([Vec2.weak(72,21), Vec2.weak(71,21), Vec2.weak(72,23)]));
			polies.push(new Polygon([Vec2.weak(74,24), Vec2.weak(73,24), Vec2.weak(74,26)]));
			polies.push(new Polygon([Vec2.weak(77,28), Vec2.weak(76,28), Vec2.weak(77,30)]));
			polies.push(new Polygon([Vec2.weak(96,38), Vec2.weak(94,38), Vec2.weak(96,39)]));
			polies.push(new Polygon([Vec2.weak(104,41), Vec2.weak(102,41), Vec2.weak(104,42)]));
			polies.push(new Polygon([Vec2.weak(106,42), Vec2.weak(104,42), Vec2.weak(106,43)]));
			polies.push(new Polygon([Vec2.weak(108,43), Vec2.weak(106,43), Vec2.weak(108,44)]));
			polies.push(new Polygon([Vec2.weak(110,44), Vec2.weak(108,44), Vec2.weak(110,45)]));
			polies.push(new Polygon([Vec2.weak(115,49), Vec2.weak(114,49), Vec2.weak(114,59), Vec2.weak(115,59)]));
			polies.push(new Polygon([Vec2.weak(113,61), Vec2.weak(113,60), Vec2.weak(103,60), Vec2.weak(103,61)]));
			polies.push(new Polygon([Vec2.weak(101,60), Vec2.weak(103,60), Vec2.weak(101,59)]));
			polies.push(new Polygon([Vec2.weak(99,59), Vec2.weak(101,59), Vec2.weak(99,58)]));
			polies.push(new Polygon([Vec2.weak(94,57), Vec2.weak(96,57), Vec2.weak(113,48), Vec2.weak(94,56)]));
			polies.push(new Polygon([Vec2.weak(41,55), Vec2.weak(41,54), Vec2.weak(15,49), Vec2.weak(38,55)]));
			polies.push(new Polygon([Vec2.weak(38,56), Vec2.weak(38,55), Vec2.weak(15,49), Vec2.weak(35,56)]));
			polies.push(new Polygon([Vec2.weak(33,58), Vec2.weak(33,57), Vec2.weak(15,49), Vec2.weak(30,58)]));
			polies.push(new Polygon([Vec2.weak(27,40), Vec2.weak(27,41), Vec2.weak(30,40)]));
			polies.push(new Polygon([Vec2.weak(30,39), Vec2.weak(30,40), Vec2.weak(33,39)]));
			polies.push(new Polygon([Vec2.weak(39,36), Vec2.weak(39,37), Vec2.weak(87,36)]));
			polies.push(new Polygon([Vec2.weak(42,35), Vec2.weak(42,36), Vec2.weak(87,36), Vec2.weak(87,35)]));
			polies.push(new Polygon([Vec2.weak(90,36), Vec2.weak(39,37), Vec2.weak(16,48), Vec2.weak(90,37)]));
			polies.push(new Polygon([Vec2.weak(99,39), Vec2.weak(96,39), Vec2.weak(16,48), Vec2.weak(15,49), Vec2.weak(99,40)]));
			polies.push(new Polygon([Vec2.weak(102,40), Vec2.weak(99,40), Vec2.weak(102,41)]));
			polies.push(new Polygon([Vec2.weak(96,58), Vec2.weak(99,58), Vec2.weak(113,48), Vec2.weak(96,57)]));
			polies.push(new Polygon([Vec2.weak(91,56), Vec2.weak(94,56), Vec2.weak(113,48), Vec2.weak(91,55)]));
			polies.push(new Polygon([Vec2.weak(88,55), Vec2.weak(91,55), Vec2.weak(113,48), Vec2.weak(88,54)]));
			polies.push(new Polygon([Vec2.weak(49,53), Vec2.weak(49,52), Vec2.weak(15,49), Vec2.weak(45,53)]));
			polies.push(new Polygon([Vec2.weak(45,54), Vec2.weak(45,53), Vec2.weak(15,49), Vec2.weak(41,54)]));
			polies.push(new Polygon([Vec2.weak(35,37), Vec2.weak(35,38), Vec2.weak(39,37)]));
			polies.push(new Polygon([Vec2.weak(94,37), Vec2.weak(90,37), Vec2.weak(94,38)]));
			polies.push(new Polygon([Vec2.weak(84,54), Vec2.weak(88,54), Vec2.weak(113,48), Vec2.weak(84,53)]));
			polies.push(new Polygon([Vec2.weak(80,53), Vec2.weak(84,53), Vec2.weak(113,48), Vec2.weak(80,52)]));
			polies.push(new Polygon([Vec2.weak(23,62), Vec2.weak(23,61), Vec2.weak(18,61), Vec2.weak(18,62)]));
			polies.push(new Polygon([Vec2.weak(13,56), Vec2.weak(14,56), Vec2.weak(14,51), Vec2.weak(13,51)]));
			polies.push(new Polygon([Vec2.weak(62,15), Vec2.weak(62,16), Vec2.weak(67,16), Vec2.weak(67,15)]));
			polies.push(new Polygon([Vec2.weak(116,51), Vec2.weak(115,51), Vec2.weak(115,56), Vec2.weak(116,56)]));
			polies.push(new Polygon([Vec2.weak(111,62), Vec2.weak(111,61), Vec2.weak(106,61), Vec2.weak(106,62)]));
			polies.push(new Polygon([Vec2.weak(56,52), Vec2.weak(56,51), Vec2.weak(15,49), Vec2.weak(49,52)]));
			polies.push(new Polygon([Vec2.weak(73,52), Vec2.weak(80,52), Vec2.weak(113,48), Vec2.weak(112,47), Vec2.weak(106,43), Vec2.weak(73,51)]));
			polies.push(new Polygon([Vec2.weak(19,45), Vec2.weak(16,48), Vec2.weak(30,40), Vec2.weak(25,42)]));
			polies.push(new Polygon([Vec2.weak(53,28), Vec2.weak(52,30), Vec2.weak(77,30), Vec2.weak(75,27), Vec2.weak(74,26), Vec2.weak(55,26)]));
			polies.push(new Polygon([Vec2.weak(56,24), Vec2.weak(55,26), Vec2.weak(74,26), Vec2.weak(68,17), Vec2.weak(57,23)]));
			polies.push(new Polygon([Vec2.weak(58,21), Vec2.weak(57,23), Vec2.weak(68,17), Vec2.weak(59,20)]));
			polies.push(new Polygon([Vec2.weak(60,18), Vec2.weak(59,20), Vec2.weak(68,17), Vec2.weak(61,17)]));
			polies.push(new Polygon([Vec2.weak(69,18), Vec2.weak(68,17), Vec2.weak(70,20)]));
			polies.push(new Polygon([Vec2.weak(71,21), Vec2.weak(70,20), Vec2.weak(72,23)]));
			polies.push(new Polygon([Vec2.weak(73,24), Vec2.weak(72,23), Vec2.weak(74,26)]));
			polies.push(new Polygon([Vec2.weak(76,28), Vec2.weak(75,27), Vec2.weak(77,30)]));
			polies.push(new Polygon([Vec2.weak(110,45), Vec2.weak(106,43), Vec2.weak(112,47)]));
			polies.push(new Polygon([Vec2.weak(35,38), Vec2.weak(16,48), Vec2.weak(39,37)]));
			polies.push(new Polygon([Vec2.weak(94,38), Vec2.weak(90,37), Vec2.weak(16,48), Vec2.weak(96,39)]));
			polies.push(new Polygon([Vec2.weak(27,41), Vec2.weak(25,42), Vec2.weak(30,40)]));
			polies.push(new Polygon([Vec2.weak(102,41), Vec2.weak(99,40), Vec2.weak(15,49), Vec2.weak(56,51), Vec2.weak(106,43)]));
			polies.push(new Polygon([Vec2.weak(73,51), Vec2.weak(106,43), Vec2.weak(56,51)]));
			polies.push(new Polygon([Vec2.weak(30,40), Vec2.weak(16,48), Vec2.weak(33,39)]));
			
			return polies;
		}
		
		//private
		
	}
}
