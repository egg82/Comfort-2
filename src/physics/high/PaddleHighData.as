package physics.high {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class PaddleHighData implements IPhysicsData {
		//vars
		
		//constructor
		public function PaddleHighData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(51,78), Vec2.weak(52,76), Vec2.weak(48,78)]));
			polies.push(new Polygon([Vec2.weak(47,80), Vec2.weak(48,78), Vec2.weak(44,80)]));
			polies.push(new Polygon([Vec2.weak(237,43), Vec2.weak(232,42), Vec2.weak(185,66), Vec2.weak(191,69), Vec2.weak(195,69), Vec2.weak(239,46)]));
			polies.push(new Polygon([Vec2.weak(181,66), Vec2.weak(185,66), Vec2.weak(232,42), Vec2.weak(215,34), Vec2.weak(179,64)]));
			polies.push(new Polygon([Vec2.weak(65,72), Vec2.weak(69,69), Vec2.weak(61,72)]));
			polies.push(new Polygon([Vec2.weak(244,48), Vec2.weak(239,46), Vec2.weak(195,69), Vec2.weak(227,85), Vec2.weak(235,85), Vec2.weak(245,79), Vec2.weak(249,70), Vec2.weak(248,55)]));
			polies.push(new Polygon([Vec2.weak(38,84), Vec2.weak(44,80), Vec2.weak(25,81), Vec2.weak(28,84)]));
			polies.push(new Polygon([Vec2.weak(241,83), Vec2.weak(245,79), Vec2.weak(235,85)]));
			polies.push(new Polygon([Vec2.weak(16,58), Vec2.weak(16,69), Vec2.weak(44,80), Vec2.weak(144,16), Vec2.weak(120,16), Vec2.weak(93,19), Vec2.weak(55,30), Vec2.weak(22,46)]));
			polies.push(new Polygon([Vec2.weak(60,74), Vec2.weak(61,72), Vec2.weak(52,76)]));
			polies.push(new Polygon([Vec2.weak(23,81), Vec2.weak(25,81), Vec2.weak(44,80), Vec2.weak(16,69), Vec2.weak(18,75)]));
			polies.push(new Polygon([Vec2.weak(170,19), Vec2.weak(161,19), Vec2.weak(93,62), Vec2.weak(119,58), Vec2.weak(174,21)]));
			polies.push(new Polygon([Vec2.weak(183,22), Vec2.weak(174,21), Vec2.weak(119,58), Vec2.weak(186,24)]));
			polies.push(new Polygon([Vec2.weak(170,63), Vec2.weak(179,64), Vec2.weak(215,34), Vec2.weak(162,60)]));
			polies.push(new Polygon([Vec2.weak(152,60), Vec2.weak(162,60), Vec2.weak(215,34), Vec2.weak(145,58)]));
			polies.push(new Polygon([Vec2.weak(221,35), Vec2.weak(215,34), Vec2.weak(232,42), Vec2.weak(231,40)]));
			polies.push(new Polygon([Vec2.weak(144,16), Vec2.weak(44,80), Vec2.weak(161,19)]));
			polies.push(new Polygon([Vec2.weak(145,58), Vec2.weak(215,34), Vec2.weak(211,31), Vec2.weak(186,24), Vec2.weak(119,58)]));
			polies.push(new Polygon([Vec2.weak(191,24), Vec2.weak(186,24), Vec2.weak(211,31)]));
			polies.push(new Polygon([Vec2.weak(73,69), Vec2.weak(93,62), Vec2.weak(161,19), Vec2.weak(69,69)]));
			polies.push(new Polygon([Vec2.weak(69,69), Vec2.weak(161,19), Vec2.weak(61,72)]));
			polies.push(new Polygon([Vec2.weak(61,72), Vec2.weak(161,19), Vec2.weak(52,76)]));
			
			return polies;
		}
		
		//private
		
	}
}
