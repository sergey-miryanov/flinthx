package jota.utils;

import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;

class ObjectUtils
{

	/**
	 * Changes an object property.
	 * @param	obj		The object to effect
	 * @param	prop	The property to change
	 * @param	value	The value for the property
	 */
	public static function changeProp ( obj : Dynamic, prop : String, value : Dynamic ) : Void
	{
		Reflect.setField(obj, prop, value);
	}

	/**
	 * find if x and y position are inside the area of an object
	 * @param	obj
	 * @param	x
	 * @param	y
	 * @return
	 */
	public static function pointInMC ( obj : Dynamic, x : Float, y : Float ) : Bool
	{
		if ( x > obj.x && x < ( obj.x + obj.width ))
		{
			if ( y > obj.y && y < ( obj.y + obj.height ))
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * Calculate the distance between two x/y coordinates
	 * @param x1
	 * @param y1
	 * @param x2
	 * @param y2
	 * @return
	 */
	public static function distance ( x1 : Float, y1 : Float, x2 : Float, y2 : Float ) : Float
	{
		var dist : Float, dx : Float, dy : Float;
		dx = x2 - x1;
		dy = y2 - y1;
		dist = Math.sqrt( dx * dx + dy * dy );
		return dist;
	}

	/**
	 * Sends a display object to the bottom of its parent display list
	 * @param obj
	 */
	public static function sendToBack ( obj : DisplayObject ) : Void
	{
		obj.parent.setChildIndex( obj, 0 );
	}

	/**
	 * Sends a display object to the top of its parent display list
	 * @param obj
	 */
	public static function bringToFront ( obj : DisplayObject ) : Void
	{
		obj.parent.setChildIndex( obj, obj.parent.numChildren - 1 );
	}

	/**
	 * Add a display object to a given depth position in the given container object
	 * @param container
	 * @param obj
	 * @param index
	 * @return
	 */
	public static function addChildAt ( container : DisplayObjectContainer, obj : DisplayObject, index : Int ) : DisplayObject
	{
		if ( container.numChildren > index )
			container.removeChildAt( index );
		return container.addChildAt( obj, index );
	}

	public static function removeChildAt ( container : DisplayObjectContainer, index : Int ) : Void
	{
		if ( container.numChildren > index )
			container.removeChildAt( index );
	}
	
	public static function removeChild ( obj : DisplayObject ) : Void
	{
		if ( obj != null )
		{
			if ( obj.parent != null )
			{
				if ( obj.parent.contains( obj ))
				{
					obj.parent.removeChild( obj );
					obj = null;
				}
			}
		}
	}

	public static function hide ( obj : DisplayObject ) : Void
	{
		obj.alpha = 0;
		obj.visible = false;
	}

	public static function resizeWidthProportional ( o : DisplayObject, w : Float, round : Bool = true ) : Void
	{
		var ratio : Float = 0;
		var newwidth : Float = w;
		var newheight : Float;
		var roundto : Bool;

		ratio = o.width / o.height;

		newheight = newwidth / ratio;

		if ( round )
		{
			newheight = Math.round(newheight);
		}

		o.width = w;
		o.height = newheight;
	}

	public static function resizeHeightProportional ( o : DisplayObject, h : Float, round : Bool = true ) : Void
	{
		var ratio : Float = 0;
		var newwidth : Float;
		var newheight : Float = h;
		var roundto : Bool;

		ratio = o.height / o.width;

		newwidth = newheight / ratio;

		if ( round )
		{
			newwidth = Math.round( newwidth );
		}

		o.width = newwidth;
		o.height = h;
	}

}

