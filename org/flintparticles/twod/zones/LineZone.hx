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

import nme.geom.Point;
import org.flintparticles.twod.particles.Particle2D;


/**
 * The LineZone zone defines a zone that contains all the points on a line.
 */

class LineZone implements Zone2D
{
	public var end(endGetter,endSetter):Point;
	public var endY(endYGetter,endYSetter):Float;
	public var start(startGetter,startSetter):Point;
	public var endX(endXGetter,endXSetter):Float;
	public var startY(startYGetter,startYSetter):Float;
	public var startX(startXGetter, startXSetter):Float;
	
	private var _start:Point;
	private var _end:Point;
	private var _length:Point;
	private var _normal:Point;
	private var _parallel:Point;
	
	/**
	 * The constructor creates a LineZone zone.
	 * 
	 * @param start The point at one end of the line.
	 * @param end The point at the other end of the line.
	 */
	public function new( start:Point = null, end:Point = null )
	{
		if( start == null )
		{
			_start = new Point( 0, 0 );
		}
		else
		{
			_start = start;
		}
		if( end == null )
		{
			_end = new Point( 0, 0 );
		}
		else
		{
			_end = end;
		}
		setLengthAndNormal();
	}
	
	private function setLengthAndNormal():Void
	{
		_length = _end.subtract( _start );
		_parallel = _length.clone();
		_parallel.normalize( 1 );
		_normal = new Point( _parallel.y, - _parallel.x );
	}
	
	/**
	 * The point at one end of the line.
	 */
	private function startGetter() : Point
	{
		return _start;
	}
	private function startSetter( value : Point ) : Point
	{
		_start = value;
		setLengthAndNormal();
		return _start;
	}

	/**
	 * The point at the other end of the line.
	 */
	private function endGetter() : Point
	{
		return _end;
	}
	private function endSetter( value : Point ) : Point
	{
		_end = value;
		setLengthAndNormal();
		return _end;
	}

	/**
	 * The x coordinate of the point at the start of the line.
	 */
	private function startXGetter() : Float
	{
		return _start.x;
	}
	private function startXSetter( value : Float ) : Float
	{
		_start.x = value;
		_length = _end.subtract( _start );
		return _start.x;
	}

	/**
	 * The y coordinate of the point at the start of the line.
	 */
	private function startYGetter() : Float
	{
		return _start.y;
	}
	private function startYSetter( value : Float ) : Float
	{
		_start.y = value;
		_length = _end.subtract( _start );
		return _start.y;
	}

	/**
	 * The x coordinate of the point at the end of the line.
	 */
	private function endXGetter() : Float
	{
		return _end.x;
	}
	private function endXSetter( value : Float ) : Float
	{
		_end.x = value;
		_length = _end.subtract( _start );
		return value;
	}

	/**
	 * The y coordinate of the point at the end of the line.
	 */
	private function endYGetter() : Float
	{
		return _end.y;
	}
	private function endYSetter( value : Float ) : Float
	{
		_end.y = value;
		_length = _end.subtract( _start );
		return value;
	}

	/**
	 * @inheritDoc
	 */
	public function contains( x:Float, y:Float ):Bool
	{
		// not on line if dot product with perpendicular is not zero
		if ( ( x - _start.x ) * _length.y - ( y - _start.y ) * _length.x != 0 )
		{
			return false;
		}
		// is it between the points, dot product of the vectors towards each point is negative
		return ( x - _start.x ) * ( x - _end.x ) + ( y - _start.y ) * ( y - _end.y ) <= 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getLocation():Point
	{
		var ret:Point = _start.clone();
		var scale:Float = Math.random();
		ret.x += _length.x * scale;
		ret.y += _length.y * scale;
		return ret;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getArea():Float
	{
		// treat as one pixel tall rectangle
		return _length.length;
	}

	/**
	 * Manages collisions between a particle and the zone. The particle will collide with the line defined
	 * for this zone. In the interests of speed, the collisions are not exactly accurate at the ends of the
	 * line, but are accurate enough to ensure the particle doesn't pass through the line and to look
	 * realistic in most circumstances. The collisionRadius of the particle is used when calculating the collision.
	 * 
	 * @param particle The particle to be tested for collision with the zone.
	 * @param bounce The coefficient of restitution for the collision.
	 * 
	 * @return Whether a collision occured.
	 */
	public function collideParticle( particle:Particle2D, bounce:Float = 1 ):Bool
	{
		// if it was moving away from the line, return false
		var previousDistance:Float = ( particle.previousX - _start.x ) * _normal.x + ( particle.previousY - _start.y ) * _normal.y;
		var velDistance:Float = particle.velX * _normal.x + particle.velY * _normal.y;
		if( previousDistance * velDistance >= 0 )
		{
			return false;
		}
		
		// if it is further away than the collision radius and the same side as previously, return false
		var distance:Float = ( particle.x - _start.x ) * _normal.x + ( particle.y - _start.y ) * _normal.y;
		if( distance * previousDistance > 0 && ( distance > particle.collisionRadius || distance < -particle.collisionRadius ) )
		{
			return false;
		}
		
		// move line collisionradius distance in direction particle was, extend it by collision radius
		var offsetX:Float;
		var offsetY:Float;
		if( previousDistance < 0 )
		{
			offsetX = _normal.x * particle.collisionRadius;
			offsetY = _normal.y * particle.collisionRadius;
		}
		else
		{
			offsetX = - _normal.x * particle.collisionRadius;
			offsetY = - _normal.y * particle.collisionRadius;
		}
		var thenX:Float = particle.previousX + offsetX;
		var thenY:Float = particle.previousY + offsetY;
		var nowX:Float = particle.x + offsetX;
		var nowY:Float = particle.y + offsetY;
		var startX:Float = _start.x - _parallel.x * particle.collisionRadius;
		var startY:Float = _start.y - _parallel.y * particle.collisionRadius;
		var endX:Float = _end.x + _parallel.x * particle.collisionRadius;
		var endY:Float = _end.y + _parallel.y * particle.collisionRadius;
		
		var den:Float = 1 / ( ( nowY - thenY ) * ( endX - startX ) - ( nowX - thenX ) * ( endY - startY ) );
		
		var u : Float = den * ( ( nowX - thenX ) * ( startY - thenY ) - ( nowY - thenY ) * ( startX - thenX ) );
		if( u < 0 || u > 1 )
		{
			return false;
		}
		
		var v : Float = - den * ( ( endX - startX ) * ( thenY - startY ) - ( endY - startY ) * ( thenX - startX ) );
		if( v < 0 || v > 1 )
		{
			return false;
		}
		
		particle.x = particle.previousX + v * ( particle.x - particle.previousX );
		particle.y = particle.previousY + v * ( particle.y - particle.previousY );
		
		var normalSpeed:Float = _normal.x * particle.velX + _normal.y * particle.velY;
		var factor:Float = ( 1 + bounce ) * normalSpeed;
		particle.velX -= factor * _normal.x;
		particle.velY -= factor * _normal.y;
		return true;
	}
}
