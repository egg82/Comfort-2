package objects.components {
	import objects.interfaces.IGraphicsComponent;
	import starling.display.DisplayObjectContainer;
	import starling.display.Graphics;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class BlankGraphicsComponent extends Sprite implements IGraphicsComponent {
		//vars
		private const _GRAPHICS:Graphics = new Graphics(this as DisplayObjectContainer);
		
		//constructor
		public function BlankGraphicsComponent() {
			
		}
		
		//public
		public function create():void {
			
		}
		public function destroy():void {
			
		}
		
		public function update(deltaTime:Number):void {
			
		}
		public function draw():void {
			
		}
		
		public function get graphics():Graphics {
			return _GRAPHICS;
		}
		
		public function get scale():Number {
			return 1;
		}
		public function set scale(val:Number):void {
			
		}
		
		public function get brightness():Number {
			return 0;
		}
		public function set brightness(val:Number):void {
			
		}
		
		//private
		
	}
}