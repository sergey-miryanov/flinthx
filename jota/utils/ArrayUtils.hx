package jota.utils;

	import jota.utils.MathUtils;
	import jota.utils.ArrayUtils;
	import nme.Vector;

	class ArrayUtils
	{
		/**
		 * cleans values in array
		 * @param	arr
		 */
		public static function clear(arr:Array<Dynamic>):Void
		{
			#if (cpp||php)
			   arr.splice(0,arr.length);          
			#else
			   untyped arr.length = 0;
			#end
		}
		
		/**
		 * Simulates a Dictionary
		 * usage: create a Hash and assign its value type eg: 
			var hash:Hash<Point> = HashTool.hashify([
			   {key: o,   val: p}
			]);
		 * get values by using: hash.get(o);
		 */
		public static function hashify<T>(values:Array<{key:Dynamic, val:T}>):Hash<T>
		{
		   var h:Hash<T> = new Hash();
		   var pair:{key:Dynamic, val:T};
		   for (pair in values) {
			  h.set(pair.key, pair.val);
		   }
		   return h;
		}
		
		/**
		 * Searches given array for given object, return true if found, false otherwise
		 * @param  array  an array
		 * @param  value  an object
		 * @return    a boolean
		 */
		public static function inArray ( array : Array<Dynamic>, value : Dynamic ) : Bool
		{
			var len : Int = array.length;
			for ( i in 0 ... len ) {
				if ( array[ i ] == value ) {
					return true;
				}
			}
			return false;
		}

		/**
		 * Insert value into array at given index
		 * @param	index
		 * @param	value
		 * @param	array
		 */
		public static function insertIntoArray ( index : Int, value : Dynamic, arr:Array<Dynamic> ) : Dynamic
		{
			var arr1:Array<Dynamic> = arr.splice(0, index);
			arr1.push(3);
			arr = arr1.concat(arr);
			return arr;
		}
		//public static function insertIntoArray ( index : Int, value : Dynamic, arr:Array<Dynamic> ) : Dynamic
		//{
			//var tempArr:Array<Dynamic> = new Array<Dynamic>();
			//tempArr = arr.splice(index, 1);
			//arr.push(value);
			//arr = arr.concat(tempArr);
			//return arr;
		//}
		
		/**
		 * Insert value into vector at given index
		 * @param	args	[index : Int, value : Dynamic, vec:Vector]
		 * @return
		 */
		public static function insertIntoVector( args : Array<Dynamic> ) : Dynamic
		{
			var vec1 = args[2].splice(0, args[0]);
			vec1.push(args[1]);
			return vec1.concat(args[2]);
		}

		/**
		 * Searches given array for given object, return array without the object if found
		 * @param	array
		 * @param	value
		 * @return	an array
		 */
		public static function removeFromArray ( array : Array<Dynamic>, value : Dynamic, multi : Bool = false ) : Array<Dynamic>
		{
			var len : Int = array.length;
			for ( i in 0 ... len ) {
				if ( array[ i ] == value ) {
					array.splice( i, 1 );
					if ( !multi )
						break;
				}
			}
			return array;
		}

		/**
		 * Shuffles array's contents into a random order and returns a new array
		 * @param  theArray  an array
		 * @return    an array
		 */
		public static function shuffle ( theArray : Array<Dynamic> ) : Array<Dynamic>
		{
			var o : Array<Dynamic> = theArray.slice(0,theArray.length);
			var l : Int = o.length;
			var n : Array<Dynamic> = new Array<Dynamic>();
			var i : Int;
			for (i in 0...l)  {
				var r : Int = Math.round( Math.random() * o.length );
				n[ n.length ] = o[ r ];
				o[ r ] = o[ o.length - 1 ];
				o.pop();
			}
			return n;
		}

		/**
		 * Gets a random index from an array
		 * @param  theArray  an array
		 * @return    an object
		 */
		public static function getRandomIndex ( theArray : Array<Dynamic> ) : Dynamic
		{
			var rnd : Int = cast(MathUtils.randomNumBetween( 0, theArray.length - 1 ),Int);
			if ( rnd > 0 )
				return theArray[ rnd ];
			else
				return theArray[ 0 ];
		}

		/**
		 * Implodes an array into a string
		 * @param	delimiter
		 * @return	String
		 */
		public static function implode ( theArray : Array<Dynamic>, delimiter : String ) : String
		{
			var str : String = '';
			var len : Int = theArray.length;
			var i : Int;
			for (i in 0...len)  {
				str += theArray[ i ] + delimiter;
			}
			return str.substr( 0, str.length - 1 );
		}

		public static function removeIndex ( array : Array<Dynamic>, index : Int ) : Array<Dynamic>
		{
			array.splice( index, 1 );
			return array;
		}

		/**
		 * Returns a new array object
		 * @param	array
		 * @return	array
		 */
		public static function cloneArray ( array : Array<Dynamic> ) : Array<Dynamic>
		{
			var newarray = new Array();
			return newarray.concat(array);
		}

	}

