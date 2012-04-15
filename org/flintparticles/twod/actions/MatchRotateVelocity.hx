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

package org.flintparticles.twoD.actions;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twoD.emitters.Emitter2D;
import org.flintparticles.twoD.particles.Particle2D;

/**
 * The MatchRotateVelocity action applies an angular acceleration to each 
 * particle to match its angular velocity to that of its nearest neighbours.
 * 
 * <p>This action has a priority of 10, so that it executes 
 * before other actions.</p>
 */

class MatchRotateVelocity extends ActionBase
{
	public var acceleration(accelerationGetter,accelerationSetter):Float;
	public var maxDistance(maxDistanceGetter, maxDistanceSetter):Float;
	
	private var _max:Float;
	private var _maxSq:Float;
	private var _acc:Float;
	
	/**
	 * The constructor creates a MatchRotateVelocity action for use by an 
	 * emitter. To add a MatchRotateVelocity to all particles created by an 
	 * emitter, use the emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param maxDistance The maximum distance, in pixels, over which this 
	 * action operates. The particle will match its angular velocity to other 
	 * particles that are at most this close to it.
	 * @param acceleration The angular acceleration applied to adjust the
	 * angular velocity to match that of the other particles.
	 */
	public function new( maxDistance:Float = 0, acceleration:Float = 0 )
	{
		super();
		priority = 10;
		this.maxDistance = maxDistance;
		this.acceleration = acceleration;
	}
	
	/**
	 * The maximum distance, in pixels, over which this action operates.
	 * The particle will match its angular velocity other particles that are 
	 * at most this close to it.
	 */
	public function maxDistanceGetter():Float
	{
		return _max;
	}
	public function maxDistanceSetter( value:Float ):Float
	{
		_max = value;
		_maxSq = value * value;
		return _max;
	}
	
	/**
	 * The angular acceleration applied to adjust the angular velocity to 
	 * match that of the other particles.
	 */
	public function accelerationGetter():Float
	{
		return _acc;
	}
	public function accelerationSetter( value:Float ):Float
	{
		_acc = value;
		return _acc;
	}

	/**
	 * Instructs the emitter to produce a sorted particle array for optimizing
	 * the calculations in the update method of this action.
	 * 
	 * @param emitter The emitter this action has been added to.
	 * 
	 * @see org.flintparticles.common.actions.Action#addedToEmitter()
	 */
	override public function addedToEmitter( emitter:Emitter ) : Void
	{
		cast( emitter,Emitter2D ).spaceSort = true;
	}
	
	/**
	 * Checks all particles near the current particle and applies the 
	 * angular acceleration to alter the particle's angular velocity
	 * towards their average angular velocity.
	 * 
	 * <p>This method is called by the emitter and need not be called by the 
	 * user.</p>
	 * 
	 * @param emitter The Emitter that created the particle.
	 * @param particle The particle to be updated.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Action#update()
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle2D = cast( particle,Particle2D );
		var e:Emitter2D = cast( emitter,Emitter2D );
		var particles:Array<Dynamic> = e.particlesArray;
		var other:Particle2D;
		var i:Int;
		var len:Int = particles.length;
		var distanceSq:Float;
		var dx:Float;
		var dy:Float;
		var vel:Float = 0;
		var count:Int = 0;
		var factor:Float;
		//for( i = p.sortID - 1; i >= 0; --i )
		i = p.sortID - 1;
		while( i >= 0 )
		{
			other = particles[i];
			if( ( dx = p.x - other.x ) > _max ) break;
			dy = other.y - p.y;
			if( dy > _max || dy < -_max ) continue;
			distanceSq = dy * dy + dx * dx;
			if( distanceSq <= _maxSq )
			{
				vel += other.angVelocity;
				++count;
			}
			--i;
		}
		//for( i = p.sortID + 1; i < len; ++i )
		i = p.sortID + 1;
		while( i < len )
		{
			other = particles[i];
			if( ( dx = other.x - p.x ) > _max ) break;
			dy = other.y - p.y;
			if( dy > _max || dy < -_max ) continue;
			distanceSq = dy * dy + dx * dx;
			if( distanceSq <= _maxSq )
			{
				vel += other.angVelocity;
				++count;
			}
			++i;
		}
		if( count != 0 )
		{
			vel = vel / count - p.angVelocity;
			if( vel != 0 )
			{
				var velSign:Float = 1;
				if( vel < 0 )
				{
					velSign = -1;
					vel = -vel;
				}
				factor = time * _acc;
				if( factor > vel ) factor = vel;
				p.angVelocity += factor * velSign;
			}
		}
	}
}
