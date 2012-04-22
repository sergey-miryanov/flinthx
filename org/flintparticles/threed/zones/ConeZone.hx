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

package org.flintparticles.threeD.zones;

import nme.geom.Vector3D;
import org.flintparticles.threeD.geom.Vector3DUtils;

/**
 * The ConeZone zone defines a zone that contains all the points inside a cone.
 * The cone can be positioned anywhere in 3D space. The cone may, optionally,
 * have its top removed, leaving a truncated base as the zone.
 */

class ConeZone implements Zone3D 
{
	public var truncatedHeight(truncatedHeightGetter,truncatedHeightSetter):Float;
	public var angle(angleGetter,angleSetter):Float;
	public var apex(apexGetter,apexSetter):Vector3D;
	public var height(heightGetter,heightSetter):Float;
	public var axis(axisGetter,axisSetter):Vector3D;
	
	private var _apex:Vector3D;
	private var _axis:Vector3D;
	private var _angle:Float;
	private var _minDist:Float;
	private var _maxDist:Float;
	private var _perp1:Vector3D;
	private var _perp2:Vector3D;
	private var _dirty:Bool;
	
	/**
	 * The constructor creates a ConeZone 3D zone.
	 * 
	 * @param apex The point at the apex of the cone.
	 * @param axis A vector along the central axis of the cone from
	 * the apex and towards the base of the cone.
	 * @param angle The angle at the apex of the cone.
	 * @param height The height of the cone.
	 * @param truncatedHeight The height at which the top of the cone is removed, leaving 
	 * just the base from height to truncatedHeight. 
	 */
	public function new( apex:Vector3D = null, axis:Vector3D = null, angle:Float = 0, height:Float = 0, truncatedHeight:Float = 0 )
	{
		this.apex = apex != null ? apex : new Vector3D();
		this.axis = axis != null ? axis : Vector3D.Y_AXIS;
		this.angle = angle;
		this.truncatedHeight = truncatedHeight;
		this.height = height;
	}
	
	private function init():Void
	{
		var axes:Array<Dynamic> = Vector3DUtils.getPerpendiculars( _axis );
		_perp1 = axes[0];
		_perp2 = axes[1];
		_dirty = false;
	}

	private function radiusAtHeight( h:Float ):Float
	{
		return Math.tan( _angle / 2 ) * h;
	}

	/**
	 * The point at the apex of the cone.
	 */
	private function apexGetter() : Vector3D
	{
		return _apex.clone();
	}
	private function apexSetter( value : Vector3D ) : Vector3D
	{
		_apex = Vector3DUtils.clonePoint( value );
		return _apex;
	}

	/**
	 * The central axis of the cone, from the apex towards the base.
	 */
	private function axisGetter() : Vector3D
	{
		return _axis.clone();
	}
	private function axisSetter( value : Vector3D ) : Vector3D
	{
		_axis = Vector3DUtils.cloneVector( value );
		_dirty = true;
		return _axis;
	}
	
	/**
	 * The angle at the apex of the cone.
	 */
	private function angleGetter() : Float
	{
		return _angle;
	}
	private function angleSetter( value : Float ) : Float
	{
		_angle = value;
		return _angle;
	}
	
	/**
	 * The height of the cone.
	 */
	private function heightGetter() : Float
	{
		return _maxDist;
	}
	private function heightSetter( value : Float ) : Float
	{
		_maxDist = value;
		return _maxDist;
	}
	
	/**
	 * The height at which the top of the cone is removed, leaving 
	 * just the base from height to truncatedHeight.
	 */
	private function truncatedHeightGetter() : Float
	{
		return _minDist;
	}
	private function truncatedHeightSetter( value : Float ) : Float
	{
		_minDist = value;
		return _minDist;
	}
	
	/**
	 * The contains method determines whether a point is inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @param p The location to test.
	 * @return true if the location is inside the zone, false if it is outside.
	 */
	public function contains( p:Vector3D ):Bool
	{
		if( _dirty )
		{
			init();
		}

		var q:Vector3D = p.subtract( _apex );
		var d:Float = q.dotProduct( _axis );
		if( d < _minDist || d > _maxDist )
		{
			return false;
		}
		var dec:Vector3D = _axis.clone();
		dec.scaleBy( d );
		q.decrementBy( dec );
		var len:Float = q.lengthSquared;
		var r:Float = radiusAtHeight( d );
		return len <= r * r;
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
		if( _dirty )
		{
			init();
		}

		var h:Float = Math.random();
		h = _minDist + ( 1 - h * h ) * ( _maxDist - _minDist );
		
		var r:Float = Math.random();
		r = ( 1 - r * r ) * radiusAtHeight( h );
		
		var a:Float = Math.random() * 2 * Math.PI;
		var p1:Vector3D = _perp1.clone();
		p1.scaleBy( r * Math.cos( a ) );
		var p2:Vector3D = _perp2.clone();
		p2.scaleBy( r * Math.sin( a ) );
		var ax:Vector3D = _axis.clone();
		ax.scaleBy( h );
		p1.incrementBy( p2 );
		p1.incrementBy( ax );
		return _apex.add( p1 );
	}
	
	/**
	 * The getArea method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getVolume():Float
	{
		var r1:Float = radiusAtHeight( _minDist );
		var r2:Float = radiusAtHeight( _maxDist );
		return ( _maxDist * r2 * r2 - _minDist * r1 * r1 ) * Math.PI / 3;
	}
}
