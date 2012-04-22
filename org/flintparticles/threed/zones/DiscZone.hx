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
 * The DiscZone zone defines a zone that contains all the points on a disc.
 * The disc can be positioned anywhere in 3D space. The disc may, optionally,
 * have a hole in the middle.
 */
class DiscZone implements Zone3D 
{
	public var outerRadius(outerRadiusGetter,outerRadiusSetter):Float;
	public var normal(normalGetter,normalSetter):Vector3D;
	public var innerRadius(innerRadiusGetter,innerRadiusSetter):Float;
	public var center(centerGetter,centerSetter):Vector3D;
	
	private var _center:Vector3D;
	private var _normal:Vector3D;
	private var _innerRadius:Float;
	private var _innerRadiusSq:Float;
	private var _outerRadius:Float;
	private var _outerRadiusSq:Float;
	private var _distToOrigin:Float;
	private var _planeAxis1:Vector3D;
	private var _planeAxis2:Vector3D;
	private var _dirty:Bool;

	public static inline var TWOPI:Float = Math.PI * 2;
	
	/**
	 * The constructor creates a DiscZone 3D zone.
	 * 
	 * @param centre The point at the center of the disc.
	 * @param normal A vector normal to the disc.
	 * @param outerRadius The outer radius of the disc.
	 * @param innerRadius The inner radius of the disc. This defines the hole 
	 * in the center of the disc. If set to zero, there is no hole. 
	 */
	public function new( center:Vector3D = null, normal:Vector3D = null, outerRadius:Float = 0, innerRadius:Float = 0 )
	{
		this.center = center != null ? center : new Vector3D();
		this.normal = normal != null ? normal : Vector3D.Z_AXIS;
		this.innerRadius = innerRadius;
		this.outerRadius = outerRadius;
	}
	
	private function init():Void
	{
		_distToOrigin = _normal.dotProduct( center );
		var axes:Array<Dynamic> = Vector3DUtils.getPerpendiculars( normal );
		_planeAxis1 = axes[0];
		_planeAxis2 = axes[1];
		_dirty = false;
	}
	
	/**
	 * The point at the center of the disc.
	 */
	private function centerGetter() : Vector3D
	{
		return _center.clone();
	}
	private function centerSetter( value : Vector3D ) : Vector3D
	{
		_center = Vector3DUtils.clonePoint( value );
		_dirty = true;
		return _center;
	}

	/**
	 * The vector normal to the disc. When setting the vector, the vector is
	 * normalized. So, when reading the vector this will be a normalized version
	 * of the vector that is set.
	 */
	private function normalGetter() : Vector3D
	{
		return _normal.clone();
	}
	private function normalSetter( value : Vector3D ) : Vector3D
	{
		_normal = Vector3DUtils.cloneUnit( value );
		_dirty = true;
		return _normal;
	}

	/**
	 * The inner radius of the disc.
	 */
	private function innerRadiusGetter() : Float
	{
		return _innerRadius;
	}
	private function innerRadiusSetter( value : Float ) : Float
	{
		_innerRadius = value;
		_innerRadiusSq = _innerRadius * _innerRadius;
		return _innerRadius;
	}

	/**
	 * The outer radius of the disc.
	 */
	private function outerRadiusGetter() : Float
	{
		return _outerRadius;
	}
	private function outerRadiusSetter( value : Float ) : Float
	{
		_outerRadius = value;
		_outerRadiusSq = _outerRadius * _outerRadius;
		return _outerRadius;
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
		// is not in plane if dist to origin along normal is different
		var dist:Float = _normal.dotProduct( p );
		if( Math.abs( dist - _distToOrigin ) > 0.1 ) // test for close, not exact
		{
			return false;
		}
		// test distance to center
		var distToCenter:Float = Vector3D.distance( center, p );
		if( distToCenter <= _outerRadiusSq && distToCenter >= _innerRadiusSq )
		{
			return true;
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
		if( _dirty )
		{
			init();
		}
		var rand:Float = Math.random();
		var radius:Float = _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius );
		var angle:Float = Math.random() * TWOPI;
		var p:Vector3D = _planeAxis1.clone();
		p.scaleBy( radius * Math.cos( angle ) );
		var p2:Vector3D = _planeAxis2.clone();
		p2.scaleBy( radius * Math.sin( angle ) );
		p.incrementBy( p2 );
		return _center.add( p );
	}
	
	/**
	 * The getArea method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return The surface area of the disc.
	 */
	public function getVolume():Float
	{
		// treat as one pixel tall disc
		return ( _outerRadius * _outerRadius - _innerRadius * _innerRadius ) * Math.PI;
	}
}
