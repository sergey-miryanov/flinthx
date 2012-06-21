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

package org.flintparticles.twod.zones;

import nme.errors.Error;
import nme.geom.Point;
import org.flintparticles.twod.particles.Particle2D;


/**
 * The MutiZone zone defines a zone that combines other zones into one larger zone.
 */

class MultiZone implements Zone2D 
{
	private var _zones : Array<Dynamic>;
	private var _areas : Array<Dynamic>;
	private var _totalArea : Float;
	
	/**
	 * The constructor defines a MultiZone zone.
	 */
	public function new()
	{
		_zones = new Array<Dynamic>();
		_areas = new Array<Dynamic>();
		_totalArea = 0;
	}
	
	/**
	 * The addZone method is used to add a zone into this MultiZone object.
	 * 
	 * @param zone The zone you want to add.
	 */
	public function addZone( zone:Zone2D ):Void
	{
		_zones.push( zone );
		var area:Float = zone.getArea();
		_areas.push( area );
		_totalArea += area;
	}
	
	/**
	 * The removeZone method is used to remove a zone from this MultiZone object.
	 * 
	 * @param zone The zone you want to add.
	 */
	public function removeZone( zone:Zone2D ):Void
	{
		var len:Int = _zones.length;
		//for( var i:Int = 0; i < len; ++i )
		for( i in 0 ... len )
		{
			if( _zones[i] == zone )
			{
				_totalArea -= _areas[i];
				_areas.splice( i, 1 );
				_zones.splice( i, 1 );
				return;
			}
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function contains( x:Float, y:Float ):Bool
	{
		var len:Int = _zones.length;
		//for( var i:Int = 0; i < len; ++i )
		for( i in 0 ... len )
		{
			if( cast( _zones[i],Zone2D ).contains( x, y ) )
			{
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLocation():Point
	{
		var selectZone:Float = Math.random() * _totalArea;
		var len:Int = _zones.length;
		//for( var i:Int = 0; i < len; ++i )
		for( i in 0 ... len )
		{
			if( ( selectZone -= _areas[i] ) <= 0 )
			{
				return cast( _zones[i],Zone2D ).getLocation();
			}
		}
		if( _zones.length == 0 )
		{
			throw new Error( "Attempt to use a MultiZone object that contains no Zones" );
		}
		else
		{
			return cast( _zones[0],Zone2D ).getLocation();
		}
		return null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getArea():Float
	{
		return _totalArea;
	}
	
	/**
	 * @inheritDoc
	 */
	public function collideParticle( particle:Particle2D, bounce:Float = 1 ):Bool
	{
		var collide:Bool = false;
		for( zone in _zones.iterator() )
		{
			collide = zone.collideParticle( particle, bounce ) || collide;
		}
		return collide;
	}
}
