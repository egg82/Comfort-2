package physics.high {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class ExplosionHighData implements IPhysicsData {
		//vars
		
		//constructor
		public function ExplosionHighData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(72,69), Vec2.weak(73,80), Vec2.weak(82,116), Vec2.weak(113,78), Vec2.weak(83,70)]));
			polies.push(new Polygon([Vec2.weak(70,256), Vec2.weak(98,251), Vec2.weak(114,246), Vec2.weak(80,210), Vec2.weak(73,233)]));
			polies.push(new Polygon([Vec2.weak(161,30), Vec2.weak(153,44), Vec2.weak(169,42), Vec2.weak(167,36)]));
			polies.push(new Polygon([Vec2.weak(48,174), Vec2.weak(50,174), Vec2.weak(67,139), Vec2.weak(58,146), Vec2.weak(47,172)]));
			polies.push(new Polygon([Vec2.weak(45,172), Vec2.weak(47,172), Vec2.weak(58,146), Vec2.weak(44,170)]));
			polies.push(new Polygon([Vec2.weak(42,170), Vec2.weak(44,170), Vec2.weak(58,146), Vec2.weak(52,148), Vec2.weak(41,168)]));
			polies.push(new Polygon([Vec2.weak(32,163), Vec2.weak(37,167), Vec2.weak(41,168), Vec2.weak(36,160), Vec2.weak(34,160)]));
			polies.push(new Polygon([Vec2.weak(261,256), Vec2.weak(259,252), Vec2.weak(253,256), Vec2.weak(256,258), Vec2.weak(259,258)]));
			polies.push(new Polygon([Vec2.weak(259,252), Vec2.weak(258,242), Vec2.weak(254,229), Vec2.weak(213,247), Vec2.weak(221,250), Vec2.weak(253,256)]));
			polies.push(new Polygon([Vec2.weak(258,67), Vec2.weak(239,70), Vec2.weak(255,81), Vec2.weak(258,75)]));
			polies.push(new Polygon([Vec2.weak(161,294), Vec2.weak(164,294), Vec2.weak(168,286), Vec2.weak(159,290), Vec2.weak(159,292)]));
			polies.push(new Polygon([Vec2.weak(169,42), Vec2.weak(153,44), Vec2.weak(151,45), Vec2.weak(150,49), Vec2.weak(176,50)]));
			polies.push(new Polygon([Vec2.weak(255,81), Vec2.weak(239,70), Vec2.weak(236,72), Vec2.weak(251,97), Vec2.weak(254,91)]));
			polies.push(new Polygon([Vec2.weak(170,285), Vec2.weak(171,281), Vec2.weak(153,281), Vec2.weak(159,290), Vec2.weak(168,286)]));
			polies.push(new Polygon([Vec2.weak(143,267), Vec2.weak(145,268), Vec2.weak(178,270), Vec2.weak(186,257), Vec2.weak(142,263)]));
			polies.push(new Polygon([Vec2.weak(282,151), Vec2.weak(278,150), Vec2.weak(278,176), Vec2.weak(286,169), Vec2.weak(283,153)]));
			polies.push(new Polygon([Vec2.weak(77,194), Vec2.weak(80,197), Vec2.weak(198,247), Vec2.weak(132,75), Vec2.weak(130,75), Vec2.weak(127,78), Vec2.weak(81,128), Vec2.weak(77,192)]));
			polies.push(new Polygon([Vec2.weak(73,190), Vec2.weak(77,192), Vec2.weak(71,138), Vec2.weak(67,139), Vec2.weak(71,187)]));
			polies.push(new Polygon([Vec2.weak(134,71), Vec2.weak(132,75), Vec2.weak(198,247), Vec2.weak(251,194), Vec2.weak(256,188), Vec2.weak(137,69)]));
			polies.push(new Polygon([Vec2.weak(263,139), Vec2.weak(259,138), Vec2.weak(274,177), Vec2.weak(267,143)]));
			polies.push(new Polygon([Vec2.weak(150,49), Vec2.weak(142,59), Vec2.weak(177,54), Vec2.weak(176,50)]));
			polies.push(new Polygon([Vec2.weak(154,285), Vec2.weak(159,290), Vec2.weak(153,281)]));
			polies.push(new Polygon([Vec2.weak(137,67), Vec2.weak(137,69), Vec2.weak(256,188), Vec2.weak(274,177), Vec2.weak(249,128), Vec2.weak(195,77), Vec2.weak(187,70), Vec2.weak(141,63)]));
			polies.push(new Polygon([Vec2.weak(113,78), Vec2.weak(82,116), Vec2.weak(81,128), Vec2.weak(127,78)]));
			polies.push(new Polygon([Vec2.weak(297,161), Vec2.weak(283,153), Vec2.weak(286,169), Vec2.weak(296,164)]));
			polies.push(new Polygon([Vec2.weak(278,150), Vec2.weak(271,144), Vec2.weak(267,143), Vec2.weak(274,177), Vec2.weak(278,176)]));
			polies.push(new Polygon([Vec2.weak(171,281), Vec2.weak(177,274), Vec2.weak(178,270), Vec2.weak(145,268), Vec2.weak(147,274), Vec2.weak(153,281)]));
			polies.push(new Polygon([Vec2.weak(64,184), Vec2.weak(71,187), Vec2.weak(67,139), Vec2.weak(60,180)]));
			polies.push(new Polygon([Vec2.weak(36,160), Vec2.weak(41,168), Vec2.weak(52,148)]));
			polies.push(new Polygon([Vec2.weak(114,246), Vec2.weak(192,250), Vec2.weak(198,247), Vec2.weak(80,197), Vec2.weak(80,210)]));
			polies.push(new Polygon([Vec2.weak(184,263), Vec2.weak(186,257), Vec2.weak(178,270)]));
			polies.push(new Polygon([Vec2.weak(140,262), Vec2.weak(142,263), Vec2.weak(186,257), Vec2.weak(192,250), Vec2.weak(136,254)]));
			polies.push(new Polygon([Vec2.weak(51,176), Vec2.weak(60,180), Vec2.weak(67,139), Vec2.weak(50,174)]));
			polies.push(new Polygon([Vec2.weak(236,72), Vec2.weak(208,78), Vec2.weak(248,114), Vec2.weak(251,103), Vec2.weak(251,97)]));
			polies.push(new Polygon([Vec2.weak(136,254), Vec2.weak(192,250), Vec2.weak(128,247)]));
			polies.push(new Polygon([Vec2.weak(177,54), Vec2.weak(142,59), Vec2.weak(141,63), Vec2.weak(187,70), Vec2.weak(181,58)]));
			polies.push(new Polygon([Vec2.weak(254,229), Vec2.weak(254,223), Vec2.weak(250,210), Vec2.weak(198,247), Vec2.weak(213,247)]));
			polies.push(new Polygon([Vec2.weak(250,210), Vec2.weak(251,194), Vec2.weak(198,247)]));
			polies.push(new Polygon([Vec2.weak(248,114), Vec2.weak(208,78), Vec2.weak(195,77), Vec2.weak(249,128)]));
			polies.push(new Polygon([Vec2.weak(259,138), Vec2.weak(249,128), Vec2.weak(274,177)]));
			polies.push(new Polygon([Vec2.weak(71,138), Vec2.weak(77,192), Vec2.weak(81,128)]));
			polies.push(new Polygon([Vec2.weak(273,179), Vec2.weak(274,177), Vec2.weak(256,188)]));
			
			return polies;
		}
		
		//private
		
	}
}