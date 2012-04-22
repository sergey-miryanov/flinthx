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
 * The BoxZone zone defines a cuboid or box shaped zone.
 */

class BoxZone implements Zone3D 
{
	public var depth(depthGetter,depthSetter):Float;
	public var width(widthGetter,widthSetter):Float;
	public var upAxis(upAxisGetter,upAxisSetter):Vector3D;
	public var depthAxis(depthAxisGetter,depthAxisSetter):Vector3D;
	public var height(heightGetter,heightSetter):Float;
	public var center(centerGetter,centerSetter):Vector3D;
	
	private var _width:Float;
	private var _height:Float;
	private var _depth:Float;
	private var _center:Vector3D;
	private var _upAxis:Vector3D;
	private var _depthAxis:Vector3D;
	private var _transformTo:Matrix3D;
	private var _transformFrom:Matrix3D;
	private var _dirty:Bool;
	
	/**
	 * The constructor creates a BoxZone 3D zone.
	 * 
	 * @param width The width of the box.
	 * @param height The height of the box.
	 * @param depth The depth of the box.
	 * @param center The point at the center of the box.
	 * @param upAxis The axis along which the height is measured. The box is rotated
	 * so that the height is in this direction.
	 * @param depthAxis The axis along which the depth is measured. The box is rotated
	 * so that the depth is in this direction.
	 */
	public function new( width:Float = 0, height:Float = 0, depth:Float = 0, center:Vector3D = null, upAxis:Vector3D = null, depthAxis:Vector3D = null )
	{
		this.width = width;
		this.height = height;
		this.depth = depth;
		this.center = center != null ? center : new Vector3D();
		this.upAxis = upAxis != null ? upAxis : Vector3D.Y_AXIS;
		this.depthAxis = depthAxis != null ? depthAxis : Vector3D.Z_AXIS;
	}
	
	private function init():Void
	{
		_transformFrom = Matrix3DUtils.newBasisTransform( _upAxis.crossProduct( _depthAxis ), _upAxis, _depthAxis );
		_transformFrom.appendTranslation( _center.x, _center.y, _center.z );
		_transformFrom.prependTranslation( -_width/2, -_height/2, -_depth/2 );
		_transformTo = _transformFrom.clone();
		_transformTo.invert();
		_dirty = false;
	}
	
	/**
	 * The width of the box.
	 */
	private function widthGetter() : Float
	{
		return _width;
	}
	private function widthSetter( value : Float ) : Float
	{
		_width = value;
		_dirty = true;
		return _width;
	}
	
	/**
	 * The height of the box.
	 */
	private function heightGetter() : Float
	{
		return _height;
	}
	private function heightSetter( value : Float ) : Float
	{
		_height = value;
		_dirty = true;
		return _height;
	}
	
	/**
	 * The depth of the box.
	 */
	private function depthGetter() : Float
	{
		return _depth;
	}
	private function depthSetter( value : Float ) : Float
	{
		_depth = value;
		_dirty = true;
		return _depth;
	}

	/**
	 * The point at the center of the box.
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
	 * The axis along which the height is measured. The box is rotated
	 * so that the height is in this direction.
	 */
	private function upAxisGetter() : Vector3D
	{
		return _upAxis.clone();
	}
	private function upAxisSetter( value : Vector3D ) : Vector3D
	{
		_upAxis = Vector3DUtils.cloneUnit( value );
		_dirty = true;
		return _upAxis;
	}

	/**
	 * The axis along which the depth is measured. The box is rotated
	 * so that the depth is in this direction.
	 */
	private function depthAxisGetter() : Vector3D
	{
		return _depthAxis.clone();
	}
	private function depthAxisSetter( value : Vector3D ) : Vector3D
	{
		_depthAxis = Vector3DUtils.cloneUnit( value );
		_dirty = true;
		return _depthAxis;
	}

	/**
	 * The contains method determines whether a point is inside the box.
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
		var q:Vector3D = _transformTo.transformVector( p );
		return q.x >= 0 && q.x <= _width && q.y >= 0 && q.y <= _height && q.z >= 0 && q.z <= _depth;
	}
	
	/**
	 * The getLocation method returns a random point inside the box.
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
		var p:Vector3D = new Vector3D( Math.random() * _width, Math.random() * _height, Math.random() * _depth, 1 );
		p = _transformFrom.transformVector( p );
		return p;
	}
	
	/**
	 * The getArea method returns the volume of the box.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return the volume of the box.
	 */
	public function getVolume():Float
	{
		return _width * _height * _depth;
	}
}
