package jota.utils;

	import jota.utils.ArrayUtils;
	import jota.utils.StringUtils;

	class StringUtils
	{

		/* STRING FUNCTIONS **************************************************/

		public static function getAbsoluteUrl ( urlInput : String ) : String
		{
			var strResult : String = "";
			if ( urlInput.indexOf( ".swf" ) > -1 ) // only convert when an actual .swf file is used
			{
				strResult = urlInput.substr( 0, urlInput.lastIndexOf( "/" ) + 1 ); // find absolut path minus filename of .swf
			}
			return strResult;
		}

		/**
		 * Replaces all occurencies of the passed-in string {@code what} with the passed-in
		 * string {@code to} in the passed-in string {@code string}.
		 *
		 * @param string the string to replace the content of
		 * @param what the string to search and replace in the passed-in {@code string}
		 * @param to the string to insert instead of the passed-in string {@code what}
		 * @return the result in which all occurences of the {@code what} string are replaced
		 * by the {@code to} string
		 */
		public static function replace ( string : String, what : String, to : String ) : String
		{
			return string.split( what ).join( to );
		}

		/**
		 * replace given text in given string with given text
		 * @param	search the text to replace
		 * @param	replace	the string to replace with
		 * @param	string	the source string
		 * @return string with replaced text
		 */
		public static function str_replace ( search : String, replace : String, string : String ) : String
		{
			while ( string.indexOf( search ) != -1 ) {
				var array : Array<Dynamic> = string.split( search );
				string = array.join( replace );
			}
			return string;
		}

		/**
		 * Generates an unix timestamp, in the format YYYYMMDDHHMMSS
		 * @return    a string
		 */
		public static function getTimeStamp () : String
		{
			var now : Date = Date.now();
			var date_str : String = ( now.getFullYear() + "" + ( now.getDate() + 1 ) + "" + now.getHours() + "" + now.getMinutes() + "" + now.getSeconds());
			return date_str;
		}

		/**
		 * Checks if all characters in string are numbers.
		 * @param  s  a string
		 * @return    true or false
		 */
		public static function isInteger ( s : String ) : Bool
		{
			var i : Float;
			if ( s.length > 0 ) {
				//for ( i = 0; i < s.length; i++ ) {
				for ( i in 0 ... s.length ) {
					var c : String = s.charAt( i );
					if ( !isDigit( c ))
						return false;
				}
				return true;
			}
			return false;
		}

		/**
		 * Check whether character c is a digit
		 * @param  s  a string
		 * @return    true or false
		 */
		public static function isDigit ( s : String ) : Bool
		{
			return (( s >= "0" ) && ( s <= "9" ));
		}

		/**
		 * Check is phone number (PT) is valid 
		 * @param	s
		 * @return	true or false
		 */
		public static function isPhoneNumber ( s : String ) : Bool
		{
			if ( s.length == 9 ) {
				if ( ArrayUtils.inArray([ "91", "92", "93", "96" ], s.substr( 0, 2 ))) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Convert string to boolean
		 * @param	s
		 * @return	true or false
		 */
		public static function strToBool ( s:String ) : Bool
		{
			s = s.toLowerCase();
			if (s == "false" || s == "0" || s == "null" || s == "") 
				return false 
			else 
				return true;
		}

	}

