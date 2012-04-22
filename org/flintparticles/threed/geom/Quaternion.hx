/*
* FLINT PARTICLE SYSTEM
* .....................
* 
* Author: Richard Lord
* Copyright (c) Richard Lord 2008-2011
* http://flintparticles.org/
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

package org.flintparticles.threed.geom;

import nme.errors.Error;
import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import nme.Vector;

/**
 * Quaternion represents a rotational transform in three-dimensional cartesian 
 * coordinate space in quaternion form.
 */
class Quaternion 
{
	public var ZERO(ZEROGetter,null):Quaternion;
	public var magnitude(magnitudeGetter,null):Float;
	public var IDENTITY(IDENTITYGetter,null):Quaternion;
	public var magnitudeSquared(magnitudeSquaredGetter,null):Float;
	/**
	 * A zero quaternion.
	 */
	public static function _ZERO() : Quaternion
	{
		return new Quaternion( 0, 0, 0, 0 );
	}
	
	public function ZEROGetter() : Quaternion
	{
		return new Quaternion( 0, 0, 0, 0 );
	}
	
	/**
	 * An identity quaternion.
	 */
	public static inline function _IDENTITY() : Quaternion
	{
		var identity:Quaternion = new Quaternion( 1, 0, 0, 0 );
		return identity;
	}
	
	public function IDENTITYGetter() : Quaternion
	{
		return new Quaternion( 1, 0, 0, 0 );
	}
	
	/**
	 * The w coordinate of the quaternion.
	 */
	public var w:Float;

	/**
	 * The x coordinate of the quaternion.
	 */
	public var x:Float;
	
	/**
	 * The y coordinate of the quaternion.
	 */
	public var y:Float;
	
	/**
	 * The z coordinate of the quaternion.
	 */
	public var z:Float;
	
	/**
	 * Constructor
	 *
	 * @param x the x coordinate of the quaternion
	 * @param y the y coordinate of the quaternion
	 * @param z the z coordinate of the quaternion
	 * @param w the w coordinate of the quaternion
	 */
	public function new( w:Float = 1, x:Float = 0, y:Float = 0, z:Float = 0 )
	{
		this.w = w;
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	/**
	 * Assigns new coordinates to this quaternion
	 * 
	 * @param x The new x coordinate
	 * @param y The new y coordinate
	 * @param z The new z coordinate
	 * @param w The new w coordinate
	 * 
	 * @return a reference to this Quaternion object
	 */
	public function reset( w:Float = 0, x:Float = 0, y:Float = 0, z:Float = 0 ):Quaternion
	{
		this.w = w;
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}
	
	/**
	 * Copies another quaternion into this one.
	 * 
	 * @param q The quaternion to copy
	 * 
	 * @return a reference to this Quaternion object
	 */
	public function assign( q:Quaternion ):Quaternion
	{
		w = q.w;
		x = q.x;
		y = q.y;
		z = q.z;
		return this;
	}
	
	/**
	 * Makes a copy of this Quaternion object.
	 * 
	 * @return A copy of this Quaternion
	 */
	public function clone():Quaternion
	{
		return new Quaternion( w, x, y, z );
	}
	
	/**
	 * Adds another quaternion to this one, returning a new quaternion.
	 * 
	 * @param q the quaternion to add
	 * @param result The quaternion to hold the result of the addition. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return the result of the addition
	 */
	public function add( q : Quaternion, result : Quaternion = null ) : Quaternion
	{
		if ( result == null )
		{
		return new Quaternion( w + q.w, x + q.x, y + q.y, z + q.z );
	}
		result.w = w + q.w;
		result.x = x + q.x;
		result.y = y + q.y;
		result.z = z + q.z;
		return result;
	}
	
	/**
	 * Subtract another quaternion from this one, returning a new quaternion.
	 * 
	 * @param q The quaternion to subtract
	 * @param result The quaternion to hold the result of the subtraction. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The result of the subtraction
	 */		
	public function subtract( q : Quaternion, result : Quaternion = null ) : Quaternion
	{
		if ( result == null )
	{
		return new Quaternion( w - q.w, x - q.x, y - q.y, z - q.z );
	}
		result.w = w - q.w;
		result.x = x - q.x;
		result.y = y - q.y;
		result.z = z - q.z;
		return result;
	}
	
	/**
	 * Multiply this quaternion by a number.
	 * 
	 * @param s The number to multiply the quaternion by
	 * @param result The quaternion to hold the result of the multiplication. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The result of the multiplication
	 */
	public function scalarMultiply( s : Float, result : Quaternion = null ) : Quaternion
	{
		if ( result == null )
		{
			return new Quaternion( w * s, x * s, y * s, z * s );
		}
		result.w = w * s;
		result.x = x * s;
		result.y = y * s;
		result.z = z * s;
		return result;
	}

	/**
	 * Pre multiply this quaternion by another quaternion, returning a new quaternion.
	 * 
	 * @param q The quaternion to multiply by.
	 * @param result The quaternion to hold the result of the multiplication. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The result of the multiplication.
	 */
	public function preMultiply( q : Quaternion, result : Quaternion = null ) : Quaternion
	{
		if ( result == null )
		{
			return new Quaternion(
				q.w * w - q.x * x - q.y * y - q.z * z,
				q.w * x + q.x * w + q.y * z - q.z * y,
				q.w * y - q.x * z + q.y * w + q.z * x,
				q.w * z + q.x * y - q.y * x + q.z * w );
		}
		result.w = q.w * w - q.x * x - q.y * y - q.z * z;
		result.x = q.w * x + q.x * w + q.y * z - q.z * y;
		result.y = q.w * y - q.x * z + q.y * w + q.z * x;
		result.z = q.w * z + q.x * y - q.y * x + q.z * w;
		return result;
	}

	/**
	 * Post multiply this quaternion by another quaternion, returning a new quaternion.
	 * 
	 * @param q The quaternion to multiply by.
	 * @param result The quaternion to hold the result of the multiplication. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The result of the multiplication.
	 */
	public function postMultiply( q : Quaternion, result : Quaternion = null ) : Quaternion
	{
		if ( result == null )
		{
			return new Quaternion(
				w * q.w - x * q.x - y * q.y - z * q.z,
				w * q.x + x * q.w + y * q.z - z * q.y,
				w * q.y - x * q.z + y * q.w + z * q.x,
				w * q.z + x * q.y - y * q.x + z * q.w );
		}
		result.w = w * q.w - x * q.x - y * q.y - z * q.z;
		result.x = w * q.x + x * q.w + y * q.z - z * q.y;
		result.y = w * q.y - x * q.z + y * q.w + z * q.x;
		result.z = w * q.z + x * q.y - y * q.x + z * q.w;
		return result;
	}

	/**
	 * Add another quaternion to this one.
	 * 
	 * @param q The quaternion to add
	 * 
	 * @return A reference to this Quaternion object.
	 */
	public function incrementBy( q:Quaternion ):Quaternion
	{
		w += q.w;
		x += q.x;
		y += q.y;
		z += q.z;
		return this;
	}

	/**
	 * Subtract another quaternion from this one.
	 * 
	 * @param q The quaternion to subtract
	 * 
	 * @return A reference to this Quaternion object.
	 */
	public function decrementBy( q:Quaternion ):Quaternion
	{
		w -= q.w;
		x -= q.x;
		y -= q.y;
		z -= q.z;
		return this;
	}

	/**
	 * Multiply this quaternion by a number.
	 * 
	 * @param s The number to multiply by
	 * 
	 * @return A reference to this Quaternion object.
	 */
	public function scaleBy( s:Float ):Quaternion
	{
		w *= s;
		x *= s;
		y *= s;
		z *= s;
		return this;
	}

	/**
	 * Pre multiply this quaternion by another quaternion
	 * 
	 * @param q The quaternion to multiply by
	 * 
	 * @return A reference to this Quaternion object.
	 */
	public function preMultiplyBy( q:Quaternion ):Quaternion
	{
		var mw:Float = w;
		var mx:Float = x;
		var my:Float = y;
		var mz:Float = z;
		w = q.w * mw - q.x * mx - q.y * my - q.z * mz;
		x = q.w * mx + q.x * mw + q.y * mz - q.z * my;
		y = q.w * my - q.x * mz + q.y * mw + q.z * mx;
		z = q.w * mz + q.x * my - q.y * mx + q.z * mw;
		return this;
	}

	/**
	 * Post multiply this quaternion by another quaternion
	 * 
	 * @param q The quaternion to multiply by
	 * 
	 * @return A reference to this Quaternion object.
	 */
	public function postMultiplyBy( q:Quaternion ):Quaternion
	{
		var mw:Float = w;
		var mx:Float = x;
		var my:Float = y;
		var mz:Float = z;
		w = mw * q.w - mx * q.x - my * q.y - mz * q.z;
		x = mw * q.x + mx * q.w + my * q.z - mz * q.y;
		y = mw * q.y - mx * q.z + my * q.w + mz * q.x;
		z = mw * q.z + mx * q.y - my * q.x + mz * q.w;
		return this;
	}
	
	/**
	 * Compare this quaternion to another.
	 * 
	 * @param q The quaternion to compare with.
	 * 
	 * @return true if the quaternions have the same coordinates, false otherwise.
	 */
	public function equals( q:Quaternion ):Bool
	{
		return x == q.x && y == q.y && z == q.z && w == q.w;
	}

	/**
	 * Compare this quaternion to another.
	 * 
	 * @param q The quaternion to compare with.
	 * @param e The distance allowed between the coordinates of the two quaternions.
	 * 
	 * @return true if the quaternions are within 
	 * distance e of each other, false otherwise
	 */
	public function nearEquals( q:Quaternion, e:Float ):Bool
	{
		var dw : Float = w - q.w;
		var dx : Float = x - q.x;
		var dy : Float = y - q.y;
		var dz : Float = z - q.z;
		return ( dw * dw + dx * dx + dy * dy + dz * dz ) <= e * e;
	}
	
	/**
	 * The magnitude of this quaternion.
	 */
	public function magnitudeGetter():Float
	{
		return Math.sqrt( w * w + x * x + y * y + z * z );
	}
	
	/**
	 * The square of the magnitude of this quaternion.
	 */
	public function magnitudeSquaredGetter():Float
	{
		return ( w * w + x * x + y * y + z * z );
	}
	
	/**
	 * Calculate the dot product of this quaternion with another.
	 * 
	 * @param q The quaternion to calculate the dot product with
	 * 
	 * @return The dot product of the two quaternions
	 */
	public function dotProduct( q:Quaternion ):Float
	{
		return ( w * q.w + x * q.x + y * q.y + z * q.z );
	}
	
	/**
	 * The conjugate of this quaternion.
	 * 
	 * @param result The quaternion to hold the result of the conjugate. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The result of the conjugate
	 */
	public function conjugate( result : Quaternion = null ) : Quaternion
	{
		if( result == null )
		{
			return new Quaternion( w, -x, -y, -z );
		}
		result.w = w;
		result.x = -x;
		result.y = -y;
		result.z = -z;
		return result;
	}
	
	/**
	 * Set this quaternion equal to its conjugate.
	 * 
	 * @return A reference to this quaternion.
	 */
	public function selfConjugate() : Quaternion
	{
		x = -x;
		y = -y;
		z = -z;
		return this;
	}
	
	/**
	 * The inverse of this quaternion.
	 * 
	 * @param result The quaternion to hold the result of the inverse. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The result of the inverse
	 */
	public function inverse( result : Quaternion = null ) : Quaternion
	{
		var s : Float = w * w + x * x + y * y + z * z;
		if( s == 0 )
		{
			if( result != null )
			{
				result.w = result.x = result.y = result.z = Math.NaN;
			}
			return null;
		}
		s = 1 / s;
		if( result == null )
		{
			return new Quaternion( w * s, -x * s, -y * s, -z * s );
		}
		result.w = w * s;
		result.x = -x * s;
		result.y = -y * s;
		result.z = -z * s;
		return result;
	}
	
	/**
	 * Set this quaternion to its inverse.
	 * 
	 * @return A reference to this quaternion.
	 */
	public function invert():Quaternion
	{
		var s : Float = w * w + x * x + y * y + z * z;
		if( s == 0 )
		{
			w = x = y = z = Math.NaN;
			return null;
		}
		s = 1 / s;
		w *= s;
		x *= -s;
		y *= -s;
		z *= -s;
		return this;
	}
	
	/**
	 * Convert this quaternion to have magnitude 1.
	 * 
	 * @return A reference to this quaternion.
	 */
	public function normalize():Quaternion
	{
		var s : Float = ( w * w + x * x + y * y + z * z );
		if ( s == 0 )
		{
			throw new Error( "Cannot normalize the zero quaternion." );
		}
		s = 1 / Math.sqrt( s );
		w *= s;
		x *= s;
		y *= s;
		z *= s;
		return this;
	}
	
	/**
	 * Create a unit quaternion in the same direction as this one.
	 * 
	 * @param result The quaternion to hold the result. If
	 * no quaternion is passed, a new quaternion is created.
	 * 
	 * @return The unit quaternion in the same direction as this one.
	 */
	public function unit( result : Quaternion = null ) : Quaternion
	{
		var s : Float = ( w * w + x * x + y * y + z * z );
		if( s == 0 )
		{
			throw new Error( "Cannot make a unit quaternion from the zero quaternion." );
		}
		s = 1 / Math.sqrt( s );
		if( result == null )
		{
			return new Quaternion( w * s, x * s, y * s, z * s );
		}
		result.w = w * s;
		result.x = x * s;
		result.y = y * s;
		result.z = z * s;
		return result;
	}
	
	/**
	 * Create a new unit quaternion that represents a rotation about an axis in 
	 * 3D space.
	 * 
	 * @param axis The axis of the rotation.
	 * @param angle The angle, in radians, of the rotation. If no value is set, 
	 * the w coordinate of the axis Vector3D is used.
	 * 
	 * @return A Quaternion representing the rotation.
	 */
	public static function newFromAxisRotation( axis : Vector3D, angle : Float = -1 ) : Quaternion
	{
		var lenSq : Float = axis.lengthSquared;
		var unit : Bool = Math.abs( lenSq - 1 ) < 0.000001;
		var len : Float = unit ? 1 : Math.sqrt( lenSq );
		if ( angle == -1 )
		{
			angle = len * 0.5;
		}
		else
		{
			angle = angle * 0.5;
		}
		var sinOverLength : Float;
		if( unit )
		{
			sinOverLength = Math.sin( angle );
		}
		else
		{
			sinOverLength = Math.sin( angle ) / len;
		}
		return new Quaternion( Math.cos( angle ), -sinOverLength * axis.x, -sinOverLength * axis.y, -sinOverLength * axis.z );
	}
	
	/**
	 * Set this quaternion to a  unit quaternion that represents a rotation 
	 * about an axis in 3D space.
	 * 
	 * @param axis The axis of the rotation.
	 * @param angle The angle, in radians, of the rotation. If no value is set, 
	 * the w coordinate of the axis Vector3D is used.
	 * 
	 * @return A reference to this Quaternion.
	 */
	public function setFromAxisRotation( axis : Vector3D, angle : Float = -1 ) : Quaternion
	{
		var lenSq : Float = axis.lengthSquared;
		var unit : Bool = Math.abs( lenSq - 1 ) < 0.000001;
		var len : Float = unit ? 1 : Math.sqrt( lenSq );
		if( angle == -1 )
		{
			angle = len * 0.5;
		}
		else
		{
			angle = angle * 0.5;
		}
		var sinOverLength : Float;
		if( unit )
		{
			sinOverLength = Math.sin( angle );
		}
		else
		{
			sinOverLength = Math.sin( angle ) / len;
		}
		w = Math.cos( angle );
		x = -sinOverLength * axis.x;
		y = -sinOverLength * axis.y;
		z = -sinOverLength * axis.z;
		return this;
	}
	
	/**
	 * Convert this quaternion to an axis/angle rotation, returning the result in a Vector3D
	 * where x, y, z represent the axis and w represents the angle, in radians.
	 * 
	 * @return The axis/angle rotation.
	 */
	public function toAxisRotation() : Vector3D
	{
		var angle:Float = 2 * Math.acos( w );
		var axis : Vector3D = new Vector3D( x, y, z );
		axis.normalize();
		axis.scaleBy( angle );
		return axis;
	}
	
	/**
	 * Convert this quaternion to a matrix transformation.
	 * 
	 * @return The matrix transformation.
	 */
	public function toMatrixTransformation() : Matrix3D
	{
		var xx:Float = x * x;
		var yy:Float = y * y;
		var zz:Float = z * z;
		var wx:Float = w * x;
		var wy:Float = w * y;
		var wz:Float = w * z;
		var xy:Float = x * y;
		var xz:Float = x * z;
		var yz:Float = y * z;

		var mVec:Vector<Float> = new Vector<Float>();
		mVec.push(1 - 2 * ( yy + zz ));
		mVec.push(2 * ( xy + wz ));
		mVec.push(2 * ( xz - wy ));
		mVec.push(0);
		mVec.push(2 * ( xy - wz ));
		mVec.push(1 - 2 * ( xx + zz ));
		mVec.push(2 * ( yz + wx ));
		mVec.push(0);
		mVec.push(2 * ( xz + wy ));
		mVec.push(2 * ( yz - wx ));
		mVec.push(1 - 2 * ( xx + yy ));
		mVec.push(0);
		mVec.push(0);
		mVec.push(0);
		mVec.push(0);
		mVec.push(1);
		
		return new Matrix3D(mVec);
		
		//return new Matrix3D( Vector<Float>( [
			//1 - 2 * ( yy + zz ), 2 * ( xy + wz ), 2 * ( xz - wy ), 0,
			//2 * ( xy - wz ), 1 - 2 * ( xx + zz ), 2 * ( yz + wx ), 0,
			//2 * ( xz + wy ), 2 * ( yz - wx ), 1 - 2 * ( xx + yy ), 0,
			//0, 0, 0, 1
		//] ) );
	}
	
	/**
	 * Get a string representation of this quaternion
	 * 
	 * @return a string representation of this quaternion
	 */
	public function toString():String
	{
		return "(w=" + w + ", x=" + x + ", y=" + y + ", z=" + z + ")";
	}
}
