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

package org.flintparticles.threed.zones;

import nme.errors.Error;
import nme.geom.Vector3D;

/**
 * The MutiZone zone defines a zone that combines other zones into one larger zone.
 */
class MultiZone implements Zone3D 
{
	private var _zones : Array<Dynamic>;
	private var _volumes : Array<Dynamic>;
	private var _totalVolume : Float;
	
	/**
	 * The constructor defines a MultiZone zone.
	 */
	public function new()
	{
		_zones = new Array<Dynamic>();
		_volumes = new Array<Dynamic>();
		_totalVolume = 0;
	}
	
	/**
	 * The addZone method is used to add a zone into this MultiZone object.
	 * 
	 * @param zone The zone you want to add.
	 */
	public function addZone( zone:Zone3D ):Void
	{
		_zones.push( zone );
		var volume:Float = zone.getVolume();
		_volumes.push( volume );
		_totalVolume += volume;
	}
	
	/**
	 * The removeZone method is used to remove a zone from this MultiZone object.
	 * 
	 * @param zone The zone you want to remove.
	 */
	public function removeZone( zone:Zone3D ):Void
	{
		var len:Int = _zones.length;
		//for( var i:Int = 0; i < len; ++i )
		var i:Int = 0;
		while( i < len )
		{
			if( _zones[i] == zone )
			{
				_totalVolume -= _volumes[i];
				_volumes.splice( i, 1 );
				_zones.splice( i, 1 );
				return;
			}
			++i;
		}
	}

	/**
	 * The contains method determines whether a point is inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @param x The x coordinate of the location to test for.
	 * @param y The y coordinate of the location to test for.
	 * @return true if point is inside the zone, false if it is outside.
	 */
	public function contains( p:Vector3D ):Bool
	{
		var len:Int = _zones.length;
		//for( var i:Int = 0; i < len; ++i )
		var i:Int = 0;
		while( i < len )
		{
			if( cast( _zones[i], Zone3D ).contains( p ) )
			{
				return true;
			}
			++i;
		}
		return false;
	}
	
	/**
	 * The getLocation method returns a random point inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getLocation():Vector3D
	{
		var selectZone:Float = Math.random() * _totalVolume;
		var len:Int = _zones.length;
		//for( var i:Int = 0; i < len; ++i )
		var i:Int = 0;
		while( i < len )
		{
			if( ( selectZone -= _volumes[i] ) <= 0 )
			{
				return cast( _zones[i], Zone3D ).getLocation();
			}
			++i;
		}
		if( _zones.length == 0 )
		{
			throw new Error( "Attempt to use a MultiZone object that contains no Zones" );
		}
		else
		{
			return cast( _zones[0], Zone3D ).getLocation();
		}
		return null;
	}
	
	/**
	 * The getArea method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return The volume of all the zones combined.
	 */
	public function getVolume():Float
	{
		return _totalVolume;
	}
}
