package jota.utils;

	import jota.utils.MathUtils;
	
	class MathUtils
	{

		/**
		* Return a random number between two given numbers
		* @param  low  lowest number possible
		* @param  high  highest number possible
		* @return    a random number
		*/
		public static function randomNumBetween (low:Float,high:Float) : Float
		{
			var this_number:Float = high - low;
			var ran_unrounded:Float = Math.random() * this_number;
			var ran_number:Float = Math.round(ran_unrounded); 
			ran_number += low;
			return ran_number;
		}
		
		public static function intToBool ( num:Int ) : Bool
		{
			return num == 0 || Math.isNaN(num) ? false : true;
		}
		
		public static function floatToBool ( num:Float ) : Bool
		{
			return cast(num,Int) == 0 || Math.isNaN(num) ? false : true;
		}
		
	}

