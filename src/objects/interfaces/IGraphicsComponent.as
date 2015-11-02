package objects.interfaces {
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public interface IGraphicsComponent {
		//vars
		
		//constructor
		
		//public
		function create():void;
		function destroy():void;
		function update(deltaTime:Number):void;
		function draw():void;
		function get scale():Number;
		function set scale(val:Number):void;
		function get brightness():Number;
		function set brightness(val:Number):void;
		
		function get x():Number;
		function set x(val:Number):void;
		function get y():Number;
		function set y(val:Number):void;
		function get rotation():Number;
		function set rotation(val:Number):void;
		
		//private
		
	}
}