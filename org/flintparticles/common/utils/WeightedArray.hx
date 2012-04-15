/*
* FLINT PARTICLE SYSTEM
* .....................
* 
* Author: Richard Lord
* Copyright (c) Richard Lord 2008-2011
* http://flintparticles.org
* 
* 
* Licence Agreement
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

package org.flintparticles.common.utils;

import nme.Vector;
import org.flintparticles.common.utils.WeightedArray;

/**
 * A WeightedArray is a collection of values that are weighted. When 
 * a random value is required fromn the collection, the value returned
 * is randomly selkected based on the weightings.
 * 
 * <p>Due to the nature of a WeightedArray, there are no facilities
 * to push, unshift or splice items into the array. All items are 
 * added to the WeightedArray using the add method.</p>
 * 
 * <p>The array items can be accessed using standard Array access
 * so the items in the WeightedArray can be looped through in
 * the same manner as a standard Array.</p>
 */
class WeightedArray
{
	public var totalWeights(totalWeightsGetter,null):Float;
	public var length(lengthGetter, null):Int;
	
	private var _values:Vector<Pair>;
	private var _totalWeights:Float;
	
	/**
	 * Then constructor function is used to create a WeightedArray
	 */
	public function new()
	{
		_values = new Vector<Pair>();
		_totalWeights = 0;
	}
	
	/**
	 * Provides Array access to read values from the WeightedArray
	 */
	public function getProperty(name:Dynamic):Dynamic
	{
		var index:Int = cast( name,Int );
		if ( index == name && index < _values.length && _values[ index ] != null )
		{
			return _values[ index ].value;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * Used to set the value of an existing member of the WeightedArray.
	 * This method cannot be used to set a new member of the WeightedArray
	 * since this new member won't have a weight setting.
	 */
	public function setProperty(name:Dynamic, value:Dynamic):Void
	{
		var index:Int = cast( name,Int );
		if ( index == name && index < _values.length )
		{
			_values[index].value = value;
		}
	}

	/**
	 * Used to allow access through a for each loop.
	 */
	public function nextNameIndex( index:Int ):Int
	{
		if( index < _values.length )
		{
			return index + 1;
		}
		else
		{
			return 0;
		}
	}
	
	/**
	 * Used to allow access through a for each loop.
	 */
	public function nextName( index:Int ):String
	{
		return Std.string( index - 1 );
	}
	
	/**
	 * Used to allow access through a for each loop.
	 */
	public function nextValue( index:Int ):Dynamic
	{
		return _values[ index - 1 ].value;
	}

	/**
	 * Adds a value to the WeightedArray.
	 * 
	 * @param value the value to add
	 * @param weight the weighting to place on the item
	 * @return the length of the WeightedArray
	 */
	public function add( value:Dynamic, weight:Float ):Int
	{
		_totalWeights += weight;
		_values.push( new Pair( weight, value ) );
		return _values.length;
	}
	
	/**
	 * Removes the value from the WeightedArray
	 * @param value The item to remove from the WeightedArray
	 * @return true if the item is removed, false if it doesn't exist in the 
	 * WeightedArray
	 */
	public function remove( value:Dynamic ):Bool
	{
		//for( var i:uint = _values.length; i--; )
		var i:Int = _values.length;
		while(  i > 0  )
		{
			if( _values[i].value == value )
			{
				_totalWeights -= cast( _values[i],Pair ).weight;
				_values.splice( i, 1 );
				return true;
			}
			i--;
		}
		return false;
	}
	
	/**
	 * Indicates if the value is in the WeightedArray
	 * @param value The item to look for in the WeightedArray
	 * @return true if the item is in the WeightedArray, false if it is not.
	 */
	public function contains( value:Dynamic ):Bool
	{
		//for( var i:Int = _values.length; i--; )
		var i:Int = _values.length;
		while( i > 0 )
		{
			if( _values[i].value == value )
			{
				return true;
			}
			i--;
		}
		return false;
	}
	
	/**
	 * Removes the item at a particular index from the WeightedArray
	 * 
	 * @param index the index in the WeightedArray of the item to be removed
	 * @return the item that was removed form the WeightedArray
	 */
	public function removeAt( index:Int ):Dynamic
	{
		var temp:Dynamic = _values[index].value;
		_totalWeights -= _values[index].weight;
		_values.splice( index, 1 );
		return temp;
	}
	
	/**
	 * Empties the WeightedArray. After calling this method the WeightedArray 
	 * contains no items.
	 */
	public function clear():Void
	{
		_values.length = 0;
		_totalWeights = 0;
	}
	
	/**
	 * The number of items in the WeightedArray
	 */
	public function lengthGetter():Int
	{
		return _values.length;
	}

	/**
	 * The sum of the weights of all the values.
	 */
	public function totalWeightsGetter():Float
	{
		return _totalWeights;
	}

	/**
	 * Returns a random value from the WeightedArray. The weighting of the values is
	 * used when selcting the random value, so items with a higher weighting are
	 * more likely to be seleted.
	 * 
	 * @return A randomly selected item from the array.
	 */
	public function getRandomValue():Dynamic
	{
		var position:Float = Math.random() * _totalWeights;
		var current:Float = 0;
		var len:Int = _values.length;
		for( i in 0 ... len )
		{
			current += _values[i].weight;
			if( current >= position )
			{
				return _values[i].value;
			}
		}
		return _values[len-1].value;
	}
}

class Pair
{
	public var weight:Float;
	public var value:Dynamic;

	public function new( weight:Float, value:Dynamic )
	{
		this.weight = weight;
		this.value = value;
	}
}
