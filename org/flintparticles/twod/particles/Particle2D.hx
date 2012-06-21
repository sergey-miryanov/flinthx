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

package org.flintparticles.twod.particles;

import nme.geom.Matrix;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.particles.ParticleFactory;

/**
 * The Particle class is a set of public properties shared by all particles.
 * It is deliberately lightweight, with only one method. The Initializers
 * and Actions modify these properties directly. This means that the same
 * particles can be used in many different emitters, allowing Particle 
 * objects to be reused.
 * 
 * Particles are usually created by the ParticleCreator class. This class
 * just simplifies the reuse of Particle objects which speeds up the
 * application. 
 */
class Particle2D extends Particle
{
	public var matrixTransform(matrixTransformGetter,null):Matrix;
	public var inertia(inertiaGetter, null):Float;
	
	/**
	 * The x coordinate of the particle in pixels.
	 */
	public var x:Float;
	/**
	 * The y coordinate of the particle in pixels.
	 */
	public var y:Float;
	/**
	 * The x coordinate of the particle prior to the latest update.
	 */
	public var previousX:Float;
	/**
	 * The y coordinate of the particle prior to the latest update.
	 */
	public var previousY:Float;
	/**
	 * The x coordinate of the velocity of the particle in pixels per second.
	 */
	public var velX:Float;
	/**
	 * The y coordinate of the velocity of the particle in pixels per second.
	 */
	public var velY:Float;
	
	/**
	 * The rotation of the particle in radians.
	 */
	public var rotation:Float;
	/**
	 * The angular velocity of the particle in radians per second.
	 */
	public var angVelocity:Float;

	private var _previousMass:Float;
	private var _previousRadius:Float;
	private var _inertia:Float;
	
	/**
	 * The moment of inertia of the particle about its center point
	 */
	private function inertiaGetter():Float
	{
		if( mass != _previousMass || collisionRadius != _previousRadius )
		{
			_inertia = mass * collisionRadius * collisionRadius * 0.5;
			_previousMass = mass;
			_previousRadius = collisionRadius;
		}
		return _inertia;
	}

	/**
	 * The position in the emitter's horizontal spacial sorted array
	 */
	public var sortID:Int;
	
	/**
	 * Creates a particle. Alternatively particles can be reused by using the ParticleCreator to create
	 * and manage them. Usually the emitter will create the particles and the user doesn't need
	 * to create them.
	 */
	public function new()
	{
		super();
		sortID = -1;
		x = 0;
		y = 0;
		previousX = 0;
		previousY = 0;
		velX = 0;
		velY = 0;
		rotation = 0;
		angVelocity = 0;
	}
	
	/**
	 * Sets the particles properties to their default values.
	 */
	override public function initialize():Void
	{
		super.initialize();
		x = 0;
		y = 0;
		previousX = 0;
		previousY = 0;
		velX = 0;
		velY = 0;
		rotation = 0;
		angVelocity = 0;
		sortID = -1;
	}
	
	/**
	 * A transformation matrix for the position, scale and rotation of the particle.
	 */
	private function matrixTransformGetter():Matrix
	{
		var cos:Float = scale * Math.cos( rotation );
		var sin:Float = scale * Math.sin( rotation );
		return new Matrix( cos, sin, -sin, cos, x, y );
	}
	
	/**
	 * @inheritDoc
	 */
	override public function clone( factory:ParticleFactory = null ):Particle
	{
		var p:Particle2D;
		if( factory != null )
		{
			p = cast( factory.createParticle(), Particle2D );
		}
		else
		{
			p = new Particle2D();
		}
		cloneInto( p );
		p.x = x;
		p.y = y;
		p.velX = velX;
		p.velY = velY;
		p.rotation = rotation;
		p.angVelocity = angVelocity;
		return p;
	}
}
