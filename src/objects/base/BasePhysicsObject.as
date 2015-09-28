package objects.base {
	import egg82.custom.CustomAtlasImage;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.patterns.ServiceLocator;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Shape;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BasePhysicsObject extends CustomAtlasImage {
		//vars
		private var _body:Body;
		private var zeroMat:Material = new Material(1, 0, 0, 1, 0);
		
		private var physicsEngine:IPhysicsEngine = ServiceLocator.getService("physicsEngine") as IPhysicsEngine;
		
		//constructor
		public function BasePhysicsObject(atlasUrl:String, atlasXMLUrl:String, body:Body) {
			super(atlasUrl, atlasXMLUrl);
			
			body.shapes.foreach(function(shape:Shape):void {
				shape.material = zeroMat;
			});
			
			var anchor:Vec2 = body.localCOM.copy(true);
			body.translateShapes(Vec2.weak(-anchor.x, -anchor.y));
			this.pivotX = anchor.x;
			this.pivotY = anchor.y;
			
			_body = body;
			physicsEngine.addBody(body);
		}
		
		//public
		public function draw():void {
			this.x = _body.position.x;
			this.y = _body.position.y;
			this.rotation = _body.rotation;
		}
		
		override public function destroy():void {
			physicsEngine.removeBody(_body);
			super.destroy();
		}
		
		public function get body():Body {
			return _body;
		}
		
		//private
		
	}
}