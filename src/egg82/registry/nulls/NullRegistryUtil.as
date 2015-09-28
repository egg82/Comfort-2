/**
 * Copyright (c) 2015 egg82 (Alexander Mason)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package egg82.registry.nulls {
	import egg82.registry.interfaces.IRegistryUtil;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NullRegistryUtil implements IRegistryUtil {
		//vars
		
		//constructor
		public function NullRegistryUtil() {
			
		}
		
		//public
		public function initialize():void {
			
		}
		
		public function addFile(type:String, name:String, url:String):void {
			
		}
		public function getFile(type:String, name:String):String {
			return null;
		}
		/*public function removeFile(type:String, name:String):void {
			
		}*/
		
		public function addFont(name:String, font:Class):void {
			
		}
		public function getFont(name:String):Class {
			return null;
		}
		/*public function removeFont(name:String):void {
			
		}*/
		
		public function addOption(type:String, name:String, value:*):void {
			
		}
		public function getOption(type:String, name:String):* {
			return null;
		}
		/*public function removeOption(type:String, name:String):void {
			
		}*/
		
		//private
		
	}
}