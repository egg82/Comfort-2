package util {
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class CompressionUtil {
		//vars
		private static var pngOptions:PNGEncoderOptions = new PNGEncoderOptions(false);
		private static var jpegOptions:JPEGEncoderOptions = new JPEGEncoderOptions(100);
		private static var rect:Rectangle = new Rectangle();
		
		//constructor
		public function CompressionUtil() {
			
		}
		
		//public
		public static function compressBMD(bmd:BitmapData, isPNG:Boolean):void {
			if (!bmd) {
				return;
			}
			
			rect.width = bmd.width;
			rect.height = bmd.height;
			
			bmd.encode(rect, (isPNG) ? pngOptions : jpegOptions);
		}
		public static function decompressBMD(bmd:BitmapData):void {
			if (!bmd) {
				return;
			}
			
			bmd.getPixel(0, 0);
		}
		
		//private
		
	}
}