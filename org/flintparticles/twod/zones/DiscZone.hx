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

package org.flintparticles.twoD.zones;

import nme.errors.Error;
import nme.geom.Point;
import org.flintparticles.twoD.particles.Particle2D;

/**
 * The DiscZone zone defines a circular zone. The zone may
 * have a hole in the middle, like a doughnut.
 */

class DiscZone implements Zone2D
{
	public var outerRadius(outerRadiusGetter,outerRadiusSetter):Float;
	public var centerX(centerXGetter,centerXSetter):Float;
	public var centerY(centerYGetter,centerYSetter):Float;
	public var innerRadius(innerRadiusGetter,innerRadiusSetter):Float;
	public var center(centerGetter, centerSetter):Point;
	
	private var _center:Point;
	private var _innerRadius:Float;
	private var _outerRadius:Float;
	private var _innerSq:Float;
	private var _outerSq:Float;
	
	public static inline var TWOPI:Float = Math.PI * 2;
	
	/**
	 * The constructor defines a DiscZone zone.
	 * 
	 * @param center The centre of the disc.
	 * @param outerRadius The radius of the outer edge of the disc.
	 * @param innerRadius If set, this defines the radius of the inner
	 * edge of the disc. Points closer to the center than this inner radius
	 * are excluded from the zone. If this parameter is not set then all 
	 * points inside the outer radius are included in the zone.
	 */
	public function new( center:Point = null, outerRadius:Float = 0, innerRadius:Float = 0 )
	{
		if( outerRadius < innerRadius )
		{
			throw new Error( "The outerRadius (" + outerRadius + ") can't be smaller than the innerRadius (" + innerRadius + ") in your DiscZone. N.B. the outerRadius is the second argument in the constructor and the innerRadius is the third argument." );
		}
		if( center == null )
		{
			_center = new Point( 0, 0 );
		}
		else
		{
			_center = center;
		}
		_innerRadius = innerRadius;
		_outerRadius = outerRadius;
		_innerSq = _innerRadius * _innerRadius;
		_outerSq = _outerRadius * _outerRadius;
	}
	
	/**
	 * The centre of the disc.
	 */
	private function centerGetter() : Point
	{
		return _center;
	}
	private function centerSetter( value : Point ) : Point
	{
		_center = value;
		return _center;
	}

	/**
	 * The x coordinate of the point that is the center of the disc.
	 */
	private function centerXGetter() : Float
	{
		return _center.x;
	}
	private function centerXSetter( value : Float ) : Float
	{
		_center.x = value;
		return value;
	}

	/**
	 * The y coordinate of the point that is the center of the disc.
	 */
	private function centerYGetter() : Float
	{
		return _center.y;
	}
	private function centerYSetter( value : Float ) : Float
	{
		_center.y = value;
		return value;
	}

	/**
	 * The radius of the inner edge of the disc.
	 */
	private function innerRadiusGetter() : Float
	{
		return _innerRadius;
	}
	private function innerRadiusSetter( value : Float ) : Float
	{
		_innerRadius = value;
		_innerSq = _innerRadius * _innerRadius;
		return _innerRadius;
	}

	/**
	 * The radius of the outer edge of the disc.
	 */
	private function outerRadiusGetter() : Float
	{
		return _outerRadius;
	}
	private function outerRadiusSetter( value : Float ) : Float
	{
		_outerRadius = value;
		_outerSq = _outerRadius * _outerRadius;
		return _outerRadius;
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
	public function contains( x:Float, y:Float ):Bool
	{
		x -= _center.x;
		y -= _center.y;
		var distSq:Float = x * x + y * y;
		return distSq <= _outerSq && distSq >= _innerSq;
	}
	
	/**
	 * The getLocation method returns a random point inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getLocation():Point
	{
		var rand:Float = Math.random();
		var point:Point =  Point.polar( _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius ), Math.random() * TWOPI );
		point.x += _center.x;
		point.y += _center.y;
		return point;
	}
	
	/**
	 * The getArea method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getArea():Float
	{
		return Math.PI * ( _outerSq - _innerSq );
	}
	
	/**
	 * Manages collisions between a particle and the zone. The particle will collide with the edges of
	 * the disc defined for this zone, from inside or outside the disc.  The collisionRadius of the 
	 * particle is used when calculating the collision.
	 * 
	 * @param particle The particle to be tested for collision with the zone.
	 * @param bounce The coefficient of restitution for the collision.
	 * 
	 * @return Whether a collision occured.
	 */
	public function collideParticle(particle:Particle2D, bounce:Float = 1):Bool
	{
		var outerLimit:Float;
		var innerLimit:Float;
		var outerLimitSq:Float;
		var innerLimitSq:Float;
		var distanceSq:Float;
		var distance:Float;
		var pdx:Float;
		var pdy:Float;
		var pDistanceSq:Float;
		var adjustSpeed:Float;
		var positionRatio:Float;
		var epsilon:Float = 0.001;
		var dx:Float = particle.x - _center.x;
		var dy:Float = particle.y - _center.y;
		var dotProduct:Float = particle.velX * dx + particle.velY * dy;
		if( dotProduct < 0 ) // moving towards center
		{
			outerLimit = _outerRadius + particle.collisionRadius;
			if( Math.abs( dx ) > outerLimit ) return false;
			if( Math.abs( dy ) > outerLimit ) return false;
			distanceSq = dx * dx + dy * dy;
			outerLimitSq =  outerLimit * outerLimit;
			if( distanceSq > outerLimitSq ) return false;
			// Particle is inside outer circle
			
			pdx = particle.previousX - _center.x;
			pdy = particle.previousY - _center.y;
			pDistanceSq = pdx * pdx + pdy * pdy;
			if( pDistanceSq > outerLimitSq )
			{
				// particle was outside outer circle
				adjustSpeed = ( 1 + bounce ) * dotProduct / distanceSq;
				particle.velX -= adjustSpeed * dx;
				particle.velY -= adjustSpeed * dy;
				distance = Math.sqrt( distanceSq );
				positionRatio = ( 2 * outerLimit - distance ) / distance + epsilon;
				particle.x = _center.x + dx * positionRatio;
				particle.y = _center.y + dy * positionRatio;
				return true;
			}
			
			if( _innerRadius != 0 && innerRadius != _outerRadius )
			{
				innerLimit = _innerRadius + particle.collisionRadius;
				if( Math.abs( dx ) > innerLimit ) return false;
				if( Math.abs( dy ) > innerLimit ) return false;
				innerLimitSq = innerLimit * innerLimit;
				if( distanceSq > innerLimitSq ) return false;
				// Particle is inside inner circle

				if( pDistanceSq > innerLimitSq )
				{
					// particle was outside inner circle
					adjustSpeed = ( 1 + bounce ) * dotProduct / distanceSq;
					particle.velX -= adjustSpeed * dx;
					particle.velY -= adjustSpeed * dy;
					distance = Math.sqrt( distanceSq );
					positionRatio = ( 2 * innerLimit - distance ) / distance + epsilon;
					particle.x = _center.x + dx * positionRatio;
					particle.y = _center.y + dy * positionRatio;
					return true;
				}
			}
			return false;
		}
		else // moving away from center
		{
			outerLimit = _outerRadius - particle.collisionRadius;
			pdx = particle.previousX - _center.x;
			pdy = particle.previousY - _center.y;
			if( Math.abs( pdx ) > outerLimit ) return false;
			if( Math.abs( pdy ) > outerLimit ) return false;
			pDistanceSq = pdx * pdx + pdy * pdy;
			outerLimitSq = outerLimit * outerLimit;
			if( pDistanceSq > outerLimitSq ) return false;
			// particle was inside outer circle
			
			distanceSq = dx * dx + dy * dy;

			if( _innerRadius != 0 && innerRadius != _outerRadius )
			{
				innerLimit = _innerRadius - particle.collisionRadius;
				innerLimitSq = innerLimit * innerLimit;
				if( pDistanceSq < innerLimitSq && distanceSq >= innerLimitSq )
				{
					// particle was inside inner circle and is outside it
					adjustSpeed = ( 1 + bounce ) * dotProduct / distanceSq;
					particle.velX -= adjustSpeed * dx;
					particle.velY -= adjustSpeed * dy;
					distance = Math.sqrt( distanceSq );
					positionRatio = ( 2 * innerLimit - distance ) / distance - epsilon;
					particle.x = _center.x + dx * positionRatio;
					particle.y = _center.y + dy * positionRatio;
					return true;
				}
			}

			if( distanceSq >= outerLimitSq )
			{
				// Particle is inside outer circle
				adjustSpeed = ( 1 + bounce ) * dotProduct / distanceSq;
				particle.velX -= adjustSpeed * dx;
				particle.velY -= adjustSpeed * dy;
				distance = Math.sqrt( distanceSq );
				positionRatio = ( 2 * outerLimit - distance ) / distance - epsilon;
				particle.x = _center.x + dx * positionRatio;
				particle.y = _center.y + dy * positionRatio;
				return true;
			}
			return false;
		}
	}
}
