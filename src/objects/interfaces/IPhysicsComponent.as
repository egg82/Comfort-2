package objects.interfaces {
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public interface IPhysicsComponent {
		//vars
		
		//constructor
		
		//public
		function create():void;
		function destroy():void;
		function update(deltaTime:Number):void;
		function draw():void;
		function get body():Body;
		function get scale():Number;
		function set scale(val:Number):void;
		function setShapes(shapes:Array):void;
		
		//private
		
	}
}