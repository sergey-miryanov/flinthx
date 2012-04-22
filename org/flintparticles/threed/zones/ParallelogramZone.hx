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

import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import org.flintparticles.threed.geom.Matrix3DUtils;
import org.flintparticles.threed.geom.Vector3DUtils;

/**
 * The PrallelogramZone zone defines a four sided zone n which opposite sides are parallel.
 * If the two side vectors are perpendicular to each other, then the zone is rectangular.
 */
class ParallelogramZone implements Zone3D 
{
	public var side1(side1Getter,side1Setter):Vector3D;
	public var side2(side2Getter,side2Setter):Vector3D;
	public var corner(cornerGetter,cornerSetter):Vector3D;
	
	private var _corner : Vector3D;
	private var _side1 : Vector3D;
	private var _side2 : Vector3D;
	private var _normal : Vector3D;
	private var _basis : Matrix3D;
	private var _distToOrigin:Float;
	private var _dirty:Bool;
	
	/**
	 * The constructor creates a PrallelogramZone zone.
	 * 
	 * @param corner A corner of the zone.
	 * @param side1 One side of the zone from the corner. The length of the vector 
	 * indicates how long the side is.
	 * @param side2 The other side of the zone from the corner. The length of the
	 * vector indicates how long the side is.
	 */
	public function new( corner:Vector3D = null, side1:Vector3D = null, side2:Vector3D = null )
	{
		this.corner = corner != null ? corner : new Vector3D();
		this.side1 = side1 != null ? side1 : Vector3D.X_AXIS;
		this.side2 = side2 != null ? side2 : new Vector3D( 0, 1, 0 );
	}
	
	/**
	 * A corner of the zone.
	 */
	private function cornerGetter() : Vector3D
	{
		return _corner.clone();
	}
	private function cornerSetter( value : Vector3D ) : Vector3D
	{
		_corner = Vector3DUtils.clonePoint( value );
		return _corner;
	}

	/**
	 * One side of the zone from the corner. The length of the vector 
	 * indicates how long the side is.
	 */
	private function side1Getter() : Vector3D
	{
		return _side1.clone();
	}
	private function side1Setter( value : Vector3D ) : Vector3D
	{
		_side1 = Vector3DUtils.cloneVector( value );
		_dirty = true;
		return _side1;
	}

	/**
	 * The other side of the zone from the corner. The length of the
	 * vector indicates how long the side is.
	 */
	private function side2Getter() : Vector3D
	{
		return _side2.clone();
	}
	private function side2Setter( value : Vector3D ) : Vector3D
	{
		_side2 = Vector3DUtils.cloneVector( value );
		_dirty = true;
		return _side2;
	}

	private function init():Void
	{
		_normal = _side1.crossProduct( _side2 );
		_distToOrigin = _normal.dotProduct( _corner );
		var perp:Vector3D = _side1.crossProduct( _side2 );
		perp.normalize();
		_basis = Matrix3DUtils.newBasisTransform( _side1, _side2, perp );
		_basis.prependTranslation( -_corner.x, -_corner.y, -_corner.z );
		_dirty = false;
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
		if( _dirty )
		{
			init();
		}
		var dist:Float = _normal.dotProduct( p );
		if( Math.abs( dist - _distToOrigin ) > 0.1 ) // test for close, not exact
		{
			return false;
		}
		var q:Vector3D = _basis.transformVector( p );
		return q.x >= 0 && q.x <= 1 && q.y >= 0 && q.y <= 1;
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
		var d1:Vector3D = _side1.clone();
		d1.scaleBy( Math.random() );
		var d2:Vector3D = _side2.clone();
		d2.scaleBy( Math.random() );
		d1.incrementBy( d2 );
		return _corner.add( d1 );
	}
	
	/**
	 * The getVolume method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getVolume():Float
	{
		return _side1.crossProduct( _side2 ).length;
	}
}
