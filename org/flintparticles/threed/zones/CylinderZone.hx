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
 * The CylinderZone zone defines a zone that contains all the points in a 
 * cylinder. The cylinder can be positioned anywhere in 3D space and may,
 * optionally, have a hole running down the centre of it.
 */
class CylinderZone implements Zone3D 
{
	public var length(lengthGetter,lengthSetter):Float;
	public var outerRadius(outerRadiusGetter,outerRadiusSetter):Float;
	public var innerRadius(innerRadiusGetter,innerRadiusSetter):Float;
	public var center(centerGetter,centerSetter):Vector3D;
	public var axis(axisGetter,axisSetter):Vector3D;
	
	private var _center:Vector3D;
	private var _axis:Vector3D;
	private var _innerRadius:Float;
	private var _innerRadiusSq:Float;
	private var _outerRadius:Float;
	private var _outerRadiusSq:Float;
	private var _length:Float;
	private var _perp1:Vector3D;
	private var _perp2:Vector3D;
	private var _dirty:Bool;
	
	/**
	 * The constructor creates a CylinderZone 3D zone.
	 * 
	 * @param center The point at the center of one end of the cylinder.
	 * @param axis A vector along the central axis of the cylinder from
	 * the center and towards the other end of the cylinder.
	 * @param length The length of the cylinder.
	 * @param outerRadius The outer radius of the cylinder.
	 * @param innerRadius The inner radius of the cylinder. This defines the 
	 * hole in the center of the cylinder that runs the length of the cylinder.
	 * If this is set to zero, there is no hole. 
	 */
	public function new( center:Vector3D = null, axis:Vector3D = null, length:Float = 0, outerRadius:Float = 0, innerRadius:Float = 0 )
	{
		this.center = center != null ? center : new Vector3D();
		this.axis = axis != null ? center : Vector3D.Y_AXIS;
		this.innerRadius = innerRadius;
		this.outerRadius = outerRadius;
		this.length = length;
	}
	
	private function init():Void
	{
		var axes:Array<Dynamic> = Vector3DUtils.getPerpendiculars( _axis );
		_perp1 = axes[0];
		_perp2 = axes[1];
		_dirty = false;
	}
	
	/**
	 * The point at the center of one end of the cylinder.
	 */
	private function centerGetter() : Vector3D
	{
		return _center.clone();
	}
	private function centerSetter( value : Vector3D ) : Vector3D
	{
		_center = Vector3DUtils.clonePoint( value );
		return _center;
	}
	
	/**
	 * The central axis of the cylinder, from the center point towards the other end.
	 */
	private function axisGetter() : Vector3D
	{
		return _axis.clone();
	}
	private function axisSetter( value : Vector3D ) : Vector3D
	{
		_axis = Vector3DUtils.cloneUnit( value );
		_dirty = true;
		return _axis;
	}
	
	/**
	 * The length of the cylinder.
	 */
	private function lengthGetter() : Float
	{
		return _length;
	}
	private function lengthSetter( value : Float ) : Float
	{
		_length = value;
		return _length;
	}
	
	/**
	 * The outer radius of the cylinder.
	 */
	private function outerRadiusGetter() : Float
	{
		return _outerRadius;
	}
	private function outerRadiusSetter( value : Float ) : Float
	{
		_outerRadius = value;
		_outerRadiusSq = value * value;
		return _outerRadius;
	}
	
	/**
	 * The inner radius of the cylinder. This defines the 
	 * hole in the center of the cylinder that runs the length of the cylinder.
	 * If this is set to zero, there is no hole.
	 */
	private function innerRadiusGetter() : Float
	{
		return _innerRadius;
	}
	private function innerRadiusSetter( value : Float ) : Float
	{
		_innerRadius = value;
		_innerRadiusSq = value * value;
		return _innerRadius;
	}
	
	/**
	 * The contains method determines whether a point is inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @param p The location to test.
	 * @return true if the location is inside the cylinder, false if it is outside.
	 */
	public function contains( p:Vector3D ):Bool
	{
		if( _dirty )
		{
			init();
		}

		var q:Vector3D = p.subtract( _center );
		var d:Float = q.dotProduct( _axis );
		if( d < 0 || d > _length )
		{
			return false;
		}
		var ax:Vector3D = _axis.clone();
		ax.scaleBy( d );
		q.decrementBy( ax );
		var len:Float = q.lengthSquared;
		return len >= _innerRadiusSq && len <= _outerRadiusSq;
	}
	
	/**
	 * The getLocation method returns a random point inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @return a random point inside the cylinder.
	 */
	public function getLocation():Vector3D
	{
		if( _dirty )
		{
			init();
		}

		var l:Float = Math.random() * _length;
		
		var r:Float = Math.random();
		r = _innerRadius + ( 1 - r * r ) * ( _outerRadius - _innerRadius );
		
		var a:Float = Math.random() * 2 * Math.PI;
		var p:Vector3D = _perp1.clone();
		p.scaleBy( r * Math.cos( a ) );
		var p2:Vector3D = _perp2.clone();
		p2.scaleBy( r * Math.sin( a ) );
		p.incrementBy( p2 );
		var ax:Vector3D = _axis.clone();
		ax.scaleBy( l );
		p.incrementBy( ax );
		return _center.add( p );
	}
	
	/**
	 * The getArea method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return The volume of the cylinder
	 */
	public function getVolume():Float
	{
		return ( _outerRadiusSq - _innerRadiusSq ) * _length * Math.PI;
	}
}
