package jota.utils;

import utils.ObjectHash;


/**
 * ...
 * @author john
 */

class Dictionary
{
	
	private var dictionary:Dynamic;
	private var hash:ObjectHash;

	public function new() 
	{
		dictionary = { };
		hash = new ObjectHash();
	}
	
	public function exists (key:Dynamic):Bool {
		
		if (Std.is(key, String))
		{
			return Reflect.hasField(dictionary, key);
		} else if ( Std.is(key, Int) || Std.is(key, Float) )
		{
			return Reflect.hasField(dictionary, Std.string(key));
		} else {
			return hash.exists(key);
		}
		
	}
	
	public function get (key:Dynamic):Dynamic {
		
		if (Std.is(key, String))
		{
			return Reflect.field(dictionary, key);
		} else if ( Std.is(key, Int) || Std.is(key, Float) )
		{
			return Reflect.field(dictionary, Std.string(key));
		} else {
			return hash.get(key);
		}
			
	}
	
	public inline function set (key:Dynamic, value:Dynamic):Void {
		
		if (Std.is(key, String))
		{
			Reflect.setField(dictionary, key, value);
		} else if ( Std.is(key, Int) || Std.is(key, Float) )
		{
			Reflect.setField(dictionary, Std.string(key), value);
		} else {
			hash.set(key, value);
		}
		
	}
	
	public inline function remove (key:Dynamic):Void {
		
		if (Std.is(key, String))
		{
			Reflect.deleteField(dictionary, key);
		} else if ( Std.is(key, Int) || Std.is(key, Float) )
		{
			Reflect.deleteField(dictionary, Std.string(key));
		} else {
			hash.remove(key);
		}
		
	}
	
	public inline function iterator ():Iterator<Dynamic> 
	{
		
		var values:Array<Dynamic> = new Array<Dynamic>();
		
		for (key in Reflect.fields(dictionary).iterator()) {
			
			values.push (get (key));
			
		}
		
		for (key in hash.iterator()) {
			
			values.push (key);
			
		}
		
		return values.iterator ();
		
	}
	
}