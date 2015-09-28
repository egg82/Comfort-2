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

package egg82.patterns.objectPool {
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.patterns.prototype.interfaces.IPrototypeFactory;
	import egg82.patterns.ServiceLocator;
	import flash.system.System;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class DynamicObjectPool {
		//vars
		private var prototypeFactory:IPrototypeFactory = ServiceLocator.getService("prototypeFactory") as IPrototypeFactory;
		private var prototypeName:String = null;
		
		private var usedPool:Vector.<IPrototype> = new Vector.<IPrototype>();
		private var freePool:Vector.<IPrototype> = new Vector.<IPrototype>();
		
		//constructor
		public function DynamicObjectPool(prototypeName:String, prototype:IPrototype) {
			if (!prototypeName || prototypeName == "") {
				throw new Error("prototypeName cannot be null");
			}
			if (!prototype) {
				throw new Error("prototype cannot be null");
			}
			
			this.prototypeName = prototypeName;
			prototypeFactory.addPrototype(prototypeName, prototype);
		}
		
		//public
		public function initialize(numObjects:uint = 1):void {
			for (var i:uint = 0; i < numObjects; i++) {
				freePool.push(prototypeFactory.createInstance(prototypeName));
			}
		}
		
		public function getObject():IPrototype {
			usedPool.push((freePool.length == 0) ? prototypeFactory.createInstance(prototypeName) : freePool.splice(0, 1)[0]);
			return usedPool[usedPool.length - 1];
		}
		public function returnObject(obj:IPrototype):void {
			for (var i:uint = 0; i < usedPool.length; i++) {
				if (obj === usedPool[i]) {
					freePool.push(usedPool.splice(i, 1)[0]);
					return;
				}
			}
		}
		
		public function get size():uint {
			return usedPool.length + freePool.length;
		}
		
		public function gc():void {
			freePool = new Vector.<IPrototype>();
			System.pauseForGCIfCollectionImminent();
		}
		public function resize(to:uint, hard:Boolean = false):void {
			var i:int;
			
			if (to == usedPool.length + freePool.length) {
				return;
			} else if (to > usedPool.length + freePool.length) {
				for (i = usedPool.length + freePool.length; i < to; i++) {
					freePool.push(prototypeFactory.createInstance(prototypeName));
				}
				
				return;
			} else if (to == 0 && hard) {
				freePool = new Vector.<IPrototype>();
				usedPool = new Vector.<IPrototype>();
			}
			
			for (i = freePool.length - 1; i >= 0; i--) {
				freePool.splice(i, 1);
				
				if (usedPool.length + freePool.length == to) {
					return;
				}
			}
			
			if (!hard) {
				return;
			}
			
			for (i = usedPool.length - 1; i >= 0; i--) {
				usedPool.splice(i, 1);
				
				if (usedPool.length == to) {
					return;
				}
			}
		}
		
		//private
		
	}
}