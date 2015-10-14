package physics.ultra {
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import physics.IPhysicsData;
	
	public class PaddleUltraData implements IPhysicsData {
		//vars
		
		//constructor
		public function PaddleUltraData() {
			
		}
		
		//public
		public function getPolygons():Vector.<Polygon> {
			var polies:Vector.<Polygon> = new Vector.<Polygon>();
			
			polies.push(new Polygon([Vec2.weak(61,73), Vec2.weak(61,72), Vec2.weak(60,73)]));
			polies.push(new Polygon([Vec2.weak(52,77), Vec2.weak(52,76), Vec2.weak(51,77)]));
			polies.push(new Polygon([Vec2.weak(48,79), Vec2.weak(48,78), Vec2.weak(47,79)]));
			polies.push(new Polygon([Vec2.weak(25,82), Vec2.weak(26,82), Vec2.weak(25,81)]));
			polies.push(new Polygon([Vec2.weak(22,80), Vec2.weak(23,80), Vec2.weak(22,79)]));
			polies.push(new Polygon([Vec2.weak(21,79), Vec2.weak(22,79), Vec2.weak(21,78)]));
			polies.push(new Polygon([Vec2.weak(19,76), Vec2.weak(20,76), Vec2.weak(19,75)]));
			polies.push(new Polygon([Vec2.weak(19,51), Vec2.weak(19,52), Vec2.weak(20,51)]));
			polies.push(new Polygon([Vec2.weak(21,48), Vec2.weak(21,49), Vec2.weak(22,48)]));
			polies.push(new Polygon([Vec2.weak(22,46), Vec2.weak(22,48), Vec2.weak(24,46)]));
			polies.push(new Polygon([Vec2.weak(24,45), Vec2.weak(24,46), Vec2.weak(25,45)]));
			polies.push(new Polygon([Vec2.weak(232,41), Vec2.weak(231,41), Vec2.weak(232,42)]));
			polies.push(new Polygon([Vec2.weak(238,44), Vec2.weak(237,44), Vec2.weak(238,45)]));
			polies.push(new Polygon([Vec2.weak(239,45), Vec2.weak(238,45), Vec2.weak(239,46)]));
			polies.push(new Polygon([Vec2.weak(242,47), Vec2.weak(241,47), Vec2.weak(242,48)]));
			polies.push(new Polygon([Vec2.weak(244,48), Vec2.weak(242,48), Vec2.weak(244,50)]));
			polies.push(new Polygon([Vec2.weak(245,50), Vec2.weak(244,50), Vec2.weak(245,51)]));
			polies.push(new Polygon([Vec2.weak(244,80), Vec2.weak(244,79), Vec2.weak(243,80)]));
			polies.push(new Polygon([Vec2.weak(243,81), Vec2.weak(243,80), Vec2.weak(242,81)]));
			polies.push(new Polygon([Vec2.weak(242,82), Vec2.weak(242,81), Vec2.weak(241,82)]));
			polies.push(new Polygon([Vec2.weak(221,82), Vec2.weak(222,82), Vec2.weak(221,81)]));
			polies.push(new Polygon([Vec2.weak(69,70), Vec2.weak(69,69), Vec2.weak(16,58), Vec2.weak(67,70)]));
			polies.push(new Polygon([Vec2.weak(67,71), Vec2.weak(67,70), Vec2.weak(65,71)]));
			polies.push(new Polygon([Vec2.weak(57,75), Vec2.weak(57,74), Vec2.weak(55,75)]));
			polies.push(new Polygon([Vec2.weak(44,81), Vec2.weak(44,80), Vec2.weak(16,58), Vec2.weak(42,81)]));
			polies.push(new Polygon([Vec2.weak(42,82), Vec2.weak(42,81), Vec2.weak(16,58), Vec2.weak(40,82)]));
			polies.push(new Polygon([Vec2.weak(40,83), Vec2.weak(40,82), Vec2.weak(16,58), Vec2.weak(17,69), Vec2.weak(38,83)]));
			polies.push(new Polygon([Vec2.weak(26,83), Vec2.weak(28,83), Vec2.weak(26,82)]));
			polies.push(new Polygon([Vec2.weak(23,81), Vec2.weak(25,81), Vec2.weak(23,80)]));
			polies.push(new Polygon([Vec2.weak(20,78), Vec2.weak(21,78), Vec2.weak(20,76)]));
			polies.push(new Polygon([Vec2.weak(18,75), Vec2.weak(19,75), Vec2.weak(18,73)]));
			polies.push(new Polygon([Vec2.weak(20,49), Vec2.weak(20,51), Vec2.weak(21,49)]));
			polies.push(new Polygon([Vec2.weak(25,44), Vec2.weak(25,45), Vec2.weak(27,44)]));
			polies.push(new Polygon([Vec2.weak(27,43), Vec2.weak(27,44), Vec2.weak(29,43)]));
			polies.push(new Polygon([Vec2.weak(29,42), Vec2.weak(29,43), Vec2.weak(31,42)]));
			polies.push(new Polygon([Vec2.weak(31,41), Vec2.weak(31,42), Vec2.weak(33,41)]));
			polies.push(new Polygon([Vec2.weak(33,40), Vec2.weak(33,41), Vec2.weak(35,40)]));
			polies.push(new Polygon([Vec2.weak(35,39), Vec2.weak(35,40), Vec2.weak(37,39)]));
			polies.push(new Polygon([Vec2.weak(37,38), Vec2.weak(37,39), Vec2.weak(39,38)]));
			polies.push(new Polygon([Vec2.weak(39,37), Vec2.weak(39,38), Vec2.weak(41,37)]));
			polies.push(new Polygon([Vec2.weak(41,36), Vec2.weak(41,37), Vec2.weak(43,36)]));
			polies.push(new Polygon([Vec2.weak(46,34), Vec2.weak(46,35), Vec2.weak(48,34)]));
			polies.push(new Polygon([Vec2.weak(51,32), Vec2.weak(51,33), Vec2.weak(53,32)]));
			polies.push(new Polygon([Vec2.weak(53,31), Vec2.weak(53,32), Vec2.weak(55,31)]));
			polies.push(new Polygon([Vec2.weak(61,28), Vec2.weak(61,29), Vec2.weak(63,28)]));
			polies.push(new Polygon([Vec2.weak(208,30), Vec2.weak(206,30), Vec2.weak(208,31)]));
			polies.push(new Polygon([Vec2.weak(213,32), Vec2.weak(211,32), Vec2.weak(213,33)]));
			polies.push(new Polygon([Vec2.weak(215,33), Vec2.weak(213,33), Vec2.weak(197,70), Vec2.weak(202,72), Vec2.weak(215,34)]));
			polies.push(new Polygon([Vec2.weak(223,36), Vec2.weak(221,36), Vec2.weak(223,37)]));
			polies.push(new Polygon([Vec2.weak(225,37), Vec2.weak(223,37), Vec2.weak(204,73), Vec2.weak(225,38)]));
			polies.push(new Polygon([Vec2.weak(227,38), Vec2.weak(225,38), Vec2.weak(204,73), Vec2.weak(209,75), Vec2.weak(227,39)]));
			polies.push(new Polygon([Vec2.weak(229,39), Vec2.weak(227,39), Vec2.weak(209,75), Vec2.weak(209,76), Vec2.weak(211,76), Vec2.weak(229,40)]));
			polies.push(new Polygon([Vec2.weak(231,40), Vec2.weak(229,40), Vec2.weak(231,41)]));
			polies.push(new Polygon([Vec2.weak(237,43), Vec2.weak(235,43), Vec2.weak(237,44)]));
			polies.push(new Polygon([Vec2.weak(241,46), Vec2.weak(239,46), Vec2.weak(241,47)]));
			polies.push(new Polygon([Vec2.weak(246,51), Vec2.weak(245,51), Vec2.weak(246,53)]));
			polies.push(new Polygon([Vec2.weak(247,53), Vec2.weak(246,53), Vec2.weak(247,55)]));
			polies.push(new Polygon([Vec2.weak(247,75), Vec2.weak(247,73), Vec2.weak(246,75)]));
			polies.push(new Polygon([Vec2.weak(246,77), Vec2.weak(246,75), Vec2.weak(245,77)]));
			polies.push(new Polygon([Vec2.weak(245,79), Vec2.weak(245,77), Vec2.weak(244,79)]));
			polies.push(new Polygon([Vec2.weak(225,84), Vec2.weak(235,84), Vec2.weak(225,83)]));
			polies.push(new Polygon([Vec2.weak(219,81), Vec2.weak(221,81), Vec2.weak(232,42), Vec2.weak(229,40), Vec2.weak(219,80)]));
			polies.push(new Polygon([Vec2.weak(217,80), Vec2.weak(219,80), Vec2.weak(229,40), Vec2.weak(217,79)]));
			polies.push(new Polygon([Vec2.weak(215,79), Vec2.weak(217,79), Vec2.weak(229,40), Vec2.weak(215,78)]));
			polies.push(new Polygon([Vec2.weak(213,78), Vec2.weak(215,78), Vec2.weak(229,40), Vec2.weak(213,77)]));
			polies.push(new Polygon([Vec2.weak(211,77), Vec2.weak(213,77), Vec2.weak(229,40), Vec2.weak(211,76)]));
			polies.push(new Polygon([Vec2.weak(204,74), Vec2.weak(206,74), Vec2.weak(204,73)]));
			polies.push(new Polygon([Vec2.weak(202,73), Vec2.weak(204,73), Vec2.weak(218,35), Vec2.weak(215,34), Vec2.weak(202,72)]));
			polies.push(new Polygon([Vec2.weak(197,71), Vec2.weak(199,71), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(195,70), Vec2.weak(197,70), Vec2.weak(195,69)]));
			polies.push(new Polygon([Vec2.weak(179,65), Vec2.weak(181,65), Vec2.weak(179,64)]));
			polies.push(new Polygon([Vec2.weak(85,65), Vec2.weak(85,64), Vec2.weak(16,58), Vec2.weak(82,65)]));
			polies.push(new Polygon([Vec2.weak(82,66), Vec2.weak(82,65), Vec2.weak(16,58), Vec2.weak(79,66)]));
			polies.push(new Polygon([Vec2.weak(79,67), Vec2.weak(79,66), Vec2.weak(16,58), Vec2.weak(76,67)]));
			polies.push(new Polygon([Vec2.weak(76,68), Vec2.weak(76,67), Vec2.weak(73,68)]));
			polies.push(new Polygon([Vec2.weak(60,74), Vec2.weak(60,73), Vec2.weak(57,74)]));
			polies.push(new Polygon([Vec2.weak(55,76), Vec2.weak(55,75), Vec2.weak(52,76)]));
			polies.push(new Polygon([Vec2.weak(51,78), Vec2.weak(51,77), Vec2.weak(48,78)]));
			polies.push(new Polygon([Vec2.weak(47,80), Vec2.weak(47,79), Vec2.weak(44,80)]));
			polies.push(new Polygon([Vec2.weak(17,55), Vec2.weak(17,58), Vec2.weak(18,55)]));
			polies.push(new Polygon([Vec2.weak(18,52), Vec2.weak(18,55), Vec2.weak(19,52)]));
			polies.push(new Polygon([Vec2.weak(43,35), Vec2.weak(43,36), Vec2.weak(46,35)]));
			polies.push(new Polygon([Vec2.weak(48,33), Vec2.weak(48,34), Vec2.weak(51,33)]));
			polies.push(new Polygon([Vec2.weak(55,30), Vec2.weak(55,31), Vec2.weak(58,30)]));
			polies.push(new Polygon([Vec2.weak(58,29), Vec2.weak(58,30), Vec2.weak(61,29)]));
			polies.push(new Polygon([Vec2.weak(63,27), Vec2.weak(63,28), Vec2.weak(66,27)]));
			polies.push(new Polygon([Vec2.weak(66,26), Vec2.weak(66,27), Vec2.weak(69,26)]));
			polies.push(new Polygon([Vec2.weak(73,24), Vec2.weak(73,25), Vec2.weak(76,24)]));
			polies.push(new Polygon([Vec2.weak(186,23), Vec2.weak(183,23), Vec2.weak(186,24)]));
			polies.push(new Polygon([Vec2.weak(194,25), Vec2.weak(191,25), Vec2.weak(194,26)]));
			polies.push(new Polygon([Vec2.weak(197,26), Vec2.weak(194,26), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(200,27), Vec2.weak(197,27), Vec2.weak(197,70), Vec2.weak(200,28)]));
			polies.push(new Polygon([Vec2.weak(203,28), Vec2.weak(200,28), Vec2.weak(197,70), Vec2.weak(203,29)]));
			polies.push(new Polygon([Vec2.weak(206,29), Vec2.weak(203,29), Vec2.weak(206,30)]));
			polies.push(new Polygon([Vec2.weak(211,31), Vec2.weak(208,31), Vec2.weak(211,32)]));
			polies.push(new Polygon([Vec2.weak(218,34), Vec2.weak(215,34), Vec2.weak(218,35)]));
			polies.push(new Polygon([Vec2.weak(221,35), Vec2.weak(218,35), Vec2.weak(221,36)]));
			polies.push(new Polygon([Vec2.weak(235,42), Vec2.weak(232,42), Vec2.weak(235,43)]));
			polies.push(new Polygon([Vec2.weak(248,55), Vec2.weak(247,55), Vec2.weak(247,73), Vec2.weak(248,73)]));
			polies.push(new Polygon([Vec2.weak(241,83), Vec2.weak(241,82), Vec2.weak(238,83)]));
			polies.push(new Polygon([Vec2.weak(238,84), Vec2.weak(238,83), Vec2.weak(221,81), Vec2.weak(225,83), Vec2.weak(235,84)]));
			polies.push(new Polygon([Vec2.weak(222,83), Vec2.weak(225,83), Vec2.weak(222,82)]));
			polies.push(new Polygon([Vec2.weak(206,75), Vec2.weak(209,75), Vec2.weak(206,74)]));
			polies.push(new Polygon([Vec2.weak(199,72), Vec2.weak(202,72), Vec2.weak(199,71)]));
			polies.push(new Polygon([Vec2.weak(188,68), Vec2.weak(191,68), Vec2.weak(188,67)]));
			polies.push(new Polygon([Vec2.weak(185,67), Vec2.weak(188,67), Vec2.weak(185,66)]));
			polies.push(new Polygon([Vec2.weak(93,63), Vec2.weak(93,62), Vec2.weak(16,58), Vec2.weak(89,63)]));
			polies.push(new Polygon([Vec2.weak(89,64), Vec2.weak(89,63), Vec2.weak(16,58), Vec2.weak(85,64)]));
			polies.push(new Polygon([Vec2.weak(73,69), Vec2.weak(73,68), Vec2.weak(69,69)]));
			polies.push(new Polygon([Vec2.weak(65,72), Vec2.weak(65,71), Vec2.weak(61,72)]));
			polies.push(new Polygon([Vec2.weak(17,73), Vec2.weak(18,73), Vec2.weak(17,69)]));
			polies.push(new Polygon([Vec2.weak(69,25), Vec2.weak(69,26), Vec2.weak(73,25)]));
			polies.push(new Polygon([Vec2.weak(76,23), Vec2.weak(76,24), Vec2.weak(80,23)]));
			polies.push(new Polygon([Vec2.weak(80,22), Vec2.weak(80,23), Vec2.weak(84,22)]));
			polies.push(new Polygon([Vec2.weak(89,20), Vec2.weak(89,21), Vec2.weak(93,20)]));
			polies.push(new Polygon([Vec2.weak(174,20), Vec2.weak(170,20), Vec2.weak(174,21)]));
			polies.push(new Polygon([Vec2.weak(183,22), Vec2.weak(179,22), Vec2.weak(183,23)]));
			polies.push(new Polygon([Vec2.weak(191,69), Vec2.weak(195,69), Vec2.weak(191,68)]));
			polies.push(new Polygon([Vec2.weak(181,66), Vec2.weak(185,66), Vec2.weak(181,65)]));
			polies.push(new Polygon([Vec2.weak(175,64), Vec2.weak(179,64), Vec2.weak(175,63)]));
			polies.push(new Polygon([Vec2.weak(166,62), Vec2.weak(170,62), Vec2.weak(166,61)]));
			polies.push(new Polygon([Vec2.weak(162,61), Vec2.weak(166,61), Vec2.weak(162,60)]));
			polies.push(new Polygon([Vec2.weak(103,61), Vec2.weak(103,60), Vec2.weak(16,58), Vec2.weak(98,61)]));
			polies.push(new Polygon([Vec2.weak(98,62), Vec2.weak(98,61), Vec2.weak(16,58), Vec2.weak(93,62)]));
			polies.push(new Polygon([Vec2.weak(84,21), Vec2.weak(84,22), Vec2.weak(89,21)]));
			polies.push(new Polygon([Vec2.weak(179,21), Vec2.weak(174,21), Vec2.weak(179,22)]));
			polies.push(new Polygon([Vec2.weak(191,24), Vec2.weak(186,24), Vec2.weak(191,25)]));
			polies.push(new Polygon([Vec2.weak(170,63), Vec2.weak(175,63), Vec2.weak(170,62)]));
			polies.push(new Polygon([Vec2.weak(161,18), Vec2.weak(154,18), Vec2.weak(161,19)]));
			polies.push(new Polygon([Vec2.weak(145,59), Vec2.weak(152,59), Vec2.weak(145,58)]));
			polies.push(new Polygon([Vec2.weak(60,73), Vec2.weak(61,72), Vec2.weak(16,58), Vec2.weak(57,74)]));
			polies.push(new Polygon([Vec2.weak(51,77), Vec2.weak(52,76), Vec2.weak(16,58), Vec2.weak(48,78)]));
			polies.push(new Polygon([Vec2.weak(47,79), Vec2.weak(48,78), Vec2.weak(16,58), Vec2.weak(44,80)]));
			polies.push(new Polygon([Vec2.weak(19,52), Vec2.weak(17,58), Vec2.weak(33,41), Vec2.weak(27,44)]));
			polies.push(new Polygon([Vec2.weak(241,82), Vec2.weak(242,81), Vec2.weak(245,77), Vec2.weak(247,73), Vec2.weak(232,42), Vec2.weak(221,81), Vec2.weak(238,83)]));
			polies.push(new Polygon([Vec2.weak(222,82), Vec2.weak(225,83), Vec2.weak(221,81)]));
			polies.push(new Polygon([Vec2.weak(119,59), Vec2.weak(119,58), Vec2.weak(16,58)]));
			polies.push(new Polygon([Vec2.weak(111,60), Vec2.weak(111,59), Vec2.weak(16,58)]));
			polies.push(new Polygon([Vec2.weak(26,82), Vec2.weak(28,83), Vec2.weak(38,83), Vec2.weak(17,69), Vec2.weak(20,76)]));
			polies.push(new Polygon([Vec2.weak(23,80), Vec2.weak(25,81), Vec2.weak(20,76), Vec2.weak(21,78)]));
			polies.push(new Polygon([Vec2.weak(19,75), Vec2.weak(20,76), Vec2.weak(17,69), Vec2.weak(18,73)]));
			polies.push(new Polygon([Vec2.weak(21,49), Vec2.weak(20,51), Vec2.weak(27,44), Vec2.weak(25,45)]));
			polies.push(new Polygon([Vec2.weak(93,19), Vec2.weak(93,20), Vec2.weak(101,19)]));
			polies.push(new Polygon([Vec2.weak(101,18), Vec2.weak(101,19), Vec2.weak(197,70), Vec2.weak(109,18)]));
			polies.push(new Polygon([Vec2.weak(231,41), Vec2.weak(229,40), Vec2.weak(232,42)]));
			polies.push(new Polygon([Vec2.weak(237,44), Vec2.weak(235,43), Vec2.weak(232,42), Vec2.weak(247,73), Vec2.weak(247,55), Vec2.weak(239,46)]));
			polies.push(new Polygon([Vec2.weak(241,47), Vec2.weak(239,46), Vec2.weak(247,55), Vec2.weak(245,51)]));
			polies.push(new Polygon([Vec2.weak(244,79), Vec2.weak(245,77), Vec2.weak(242,81)]));
			polies.push(new Polygon([Vec2.weak(235,85), Vec2.weak(235,84), Vec2.weak(227,84), Vec2.weak(227,85)]));
			polies.push(new Polygon([Vec2.weak(170,19), Vec2.weak(161,19), Vec2.weak(170,20)]));
			polies.push(new Polygon([Vec2.weak(38,84), Vec2.weak(38,83), Vec2.weak(28,83), Vec2.weak(28,84)]));
			polies.push(new Polygon([Vec2.weak(154,17), Vec2.weak(144,17), Vec2.weak(154,18)]));
			polies.push(new Polygon([Vec2.weak(152,60), Vec2.weak(162,60), Vec2.weak(152,59)]));
			polies.push(new Polygon([Vec2.weak(16,69), Vec2.weak(17,69), Vec2.weak(16,58)]));
			polies.push(new Polygon([Vec2.weak(109,17), Vec2.weak(109,18), Vec2.weak(197,70), Vec2.weak(144,17)]));
			polies.push(new Polygon([Vec2.weak(249,58), Vec2.weak(248,58), Vec2.weak(248,70), Vec2.weak(249,70)]));
			polies.push(new Polygon([Vec2.weak(65,71), Vec2.weak(67,70), Vec2.weak(16,58), Vec2.weak(61,72)]));
			polies.push(new Polygon([Vec2.weak(181,65), Vec2.weak(185,66), Vec2.weak(179,64)]));
			polies.push(new Polygon([Vec2.weak(55,75), Vec2.weak(57,74), Vec2.weak(16,58), Vec2.weak(52,76)]));
			polies.push(new Polygon([Vec2.weak(43,36), Vec2.weak(37,39), Vec2.weak(17,58), Vec2.weak(46,35)]));
			polies.push(new Polygon([Vec2.weak(48,34), Vec2.weak(46,35), Vec2.weak(17,58), Vec2.weak(51,33)]));
			polies.push(new Polygon([Vec2.weak(55,31), Vec2.weak(51,33), Vec2.weak(17,58), Vec2.weak(80,23), Vec2.weak(73,25)]));
			polies.push(new Polygon([Vec2.weak(63,28), Vec2.weak(61,29), Vec2.weak(73,25), Vec2.weak(69,26)]));
			polies.push(new Polygon([Vec2.weak(206,30), Vec2.weak(203,29), Vec2.weak(197,70), Vec2.weak(208,31)]));
			polies.push(new Polygon([Vec2.weak(211,32), Vec2.weak(208,31), Vec2.weak(197,70), Vec2.weak(213,33)]));
			polies.push(new Polygon([Vec2.weak(221,36), Vec2.weak(218,35), Vec2.weak(204,73), Vec2.weak(223,37)]));
			polies.push(new Polygon([Vec2.weak(206,74), Vec2.weak(209,75), Vec2.weak(204,73)]));
			polies.push(new Polygon([Vec2.weak(199,71), Vec2.weak(202,72), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(194,26), Vec2.weak(191,25), Vec2.weak(186,24), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(186,24), Vec2.weak(183,23), Vec2.weak(179,22), Vec2.weak(174,21), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(174,21), Vec2.weak(170,20), Vec2.weak(161,19), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(161,19), Vec2.weak(154,18), Vec2.weak(144,17), Vec2.weak(197,70)]));
			polies.push(new Polygon([Vec2.weak(120,16), Vec2.weak(120,17), Vec2.weak(144,17), Vec2.weak(144,16)]));
			polies.push(new Polygon([Vec2.weak(93,20), Vec2.weak(89,21), Vec2.weak(17,58), Vec2.weak(145,58), Vec2.weak(101,19)]));
			polies.push(new Polygon([Vec2.weak(73,68), Vec2.weak(76,67), Vec2.weak(16,58), Vec2.weak(69,69)]));
			polies.push(new Polygon([Vec2.weak(76,24), Vec2.weak(73,25), Vec2.weak(80,23)]));
			polies.push(new Polygon([Vec2.weak(191,68), Vec2.weak(195,69), Vec2.weak(101,19), Vec2.weak(179,64)]));
			polies.push(new Polygon([Vec2.weak(33,41), Vec2.weak(17,58), Vec2.weak(37,39)]));
			polies.push(new Polygon([Vec2.weak(84,22), Vec2.weak(80,23), Vec2.weak(17,58), Vec2.weak(89,21)]));
			polies.push(new Polygon([Vec2.weak(170,62), Vec2.weak(175,63), Vec2.weak(101,19), Vec2.weak(162,60)]));
			polies.push(new Polygon([Vec2.weak(152,59), Vec2.weak(162,60), Vec2.weak(101,19), Vec2.weak(145,58)]));
			polies.push(new Polygon([Vec2.weak(179,64), Vec2.weak(101,19), Vec2.weak(175,63)]));
			
			return polies;
		}
		
		//private
		
	}
}
