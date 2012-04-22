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
 * The SphereZone zone defines a zone that contains all the points in a sphere.
 * The sphere can be positioned anywhere in 3D space and may, optionally,
 * be hollow in the middle.
 */

class SphereZone implements Zone3D 
{
	public var outerRadius(outerRadiusGetter,outerRadiusSetter):Float;
	public var innerRadius(innerRadiusGetter,innerRadiusSetter):Float;
	public var center(centerGetter,centerSetter):Vector3D;
	
	private var _center:Vector3D;
	private var _innerRadius:Float;
	private var _innerRadiusSq:Float;
	private var _outerRadius:Float;
	private var _outerRadiusSq:Float;
	
	/**
	 * The constructor creates a SphereZone 3D zone.
	 * 
	 * @param center The point at the center of the sphere.
	 * @param outerRadius The outer radius of the sphere.
	 * @param innerRadius The inner radius of the sphere. This defines the hollow 
	 * center of the sphere. If set to zero, the sphere is solid throughout. 
	 */
	public function new( center:Vector3D = null, outerRadius:Float = 0, innerRadius:Float = 0 )
	{
		this.center = center != null ? center : new Vector3D();
		this.innerRadius = innerRadius;
		this.outerRadius = outerRadius;
	}
	
	/**
	 * The point at the center of the sphere.
	 */
	public function centerGetter() : Vector3D
	{
		return _center.clone();
	}
	public function centerSetter( value : Vector3D ) : Vector3D
	{
		_center = Vector3DUtils.clonePoint( value );
		return _center;
	}

	/**
	 * The radius of the hollow center of the sphere.
	 */
	public function innerRadiusGetter() : Float
	{
		return _innerRadius;
	}
	public function innerRadiusSetter( value : Float ) : Float
	{
		_innerRadius = value;
		_innerRadiusSq = _innerRadius * _innerRadius;
		return _innerRadius;
	}

	/**
	 * The outer radius of the sphere.
	 */
	public function outerRadiusGetter() : Float
	{
		return _outerRadius;
	}
	public function outerRadiusSetter( value : Float ) : Float
	{
		_outerRadius = value;
		_outerRadiusSq = _outerRadius * _outerRadius;
		return _outerRadius;
	}

	/**
	 * The contains method determines whether a point is inside the sphere.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @param p The location to test.
	 * @return true if the location is inside the zone, false if it is outside.
	 */
	public function contains( p:Vector3D ):Bool
	{
		var distSq:Float = Vector3DUtils.distanceSquared( p, _center );
		return distSq <= _outerRadiusSq && distSq >= _innerRadiusSq;
	}
	
	/**
	 * The getLocation method returns a random point inside the sphere.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @return A random point inside the zone.
	 */
	public function getLocation():Vector3D
	{
		var rand:Vector3D;
		do
		{
			rand = new Vector3D( Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5 );
		}
		while ( rand.x == 0 && rand.y == 0 && rand.z == 0 );
		rand.normalize();
		var d:Float = Math.random();
		d = _innerRadius + ( 1 - d * d ) * ( _outerRadius - _innerRadius );
		rand.scaleBy( d / rand.length );
		return _center.add( rand );
	}
	
	/**
	 * The getVolume method returns the volume of the sphere.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return the volume of the sphere.
	 */
	public function getVolume():Float
	{
		return ( _outerRadiusSq * _outerRadius - _innerRadiusSq * _innerRadius ) * Math.PI * 4 / 3;
	}
}
