package utils;

#if flash
import flash.utils.TypedDictionary;
#end

/**
* Example: 
var dic:ObjectHash  = new ObjectHash ();
dic.set(mc, "mc");
dic.set(pathSprite, "pathSprite");
for ( i in dic.iterator() )
{
	trace(i);
}
trace(dic.get(mc)); 
* 
*/

class ObjectHash {
	
	
	#if flash
	
	private var dictionary:TypedDictionary <Dynamic,Dynamic>;
	
	#else
	
	private var hash:IntHash <Dynamic>;
	
	#end
	
	private static var nextObjectID:Int = 0;
	
	public function new () {
		
		#if flash
		
		dictionary = new TypedDictionary <Dynamic,Dynamic> ();
		
		#else
		
		hash = new IntHash <Dynamic> ();
		
		#end
		
	}
	
	public inline function exists (key:Dynamic):Bool {
		
		#if flash
		
		return dictionary.exists (key);
		
		#else
		
		return hash.exists (getID (key));
		
		#end
		
	}
	
	public inline function get (key:Dynamic):Dynamic {
		
		#if flash
		
		return dictionary.get (key);
		
		#else
		
		return hash.get (getID (key));
		
		#end
		
	}
	
	private inline function getID (key:Dynamic):Int {

		#if cpp
		
		return untyped __global__.__hxcpp_obj_id (key);
		
		#else
		
		if (key.___id___ == null) {
			
			key.___id___ = nextObjectID ++;
			
			if (nextObjectID == 2147483647) {
				
				nextObjectID = 0;
				
			}
			
		}
		
		return key.___id___;
		
		#else
		
		return 0;
		
		#end
		
	}
	
	public inline function iterator ():Iterator <Dynamic> {
		
		#if flash
		
		var values:Array <Dynamic> = new Array <Dynamic> ();
		
		for (key in dictionary.iterator ()) {
			
			values.push (dictionary.get (key));
			
		}
		
		return values.iterator ();
		
		#else
		
		return hash.iterator ();
		
		#end
		
	}
	
	public inline function remove (key:Dynamic):Void {
		
		#if flash
		
		dictionary.delete (key);
		
		#else
		
		hash.remove (getID (key));
		
		#end
		
	}
	
	public inline function set (key:Dynamic, value:Dynamic):Void {
		
		#if flash
		
		dictionary.set (key, value);
		
		#else
		
		hash.set (getID (key), value);
		
		#end
		
	}
	
}