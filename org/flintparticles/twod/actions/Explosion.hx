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
import org.flintparticles.common.activities.FrameUpdatable;
import org.flintparticles.common.activities.UpdateOnFrame;
import org.flintparticles.common.behaviours.Resetable;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twoD.particles.Particle2D;

/**
 * The Explosion action applies a force on the particles to push them away 
 * from a single point - the center of the explosion. The force occurs 
 * instantaneously at the central point of the explosion and then ripples 
 * out in a shock wave.
 */

class Explosion extends ActionBase, implements Resetable, implements FrameUpdatable
{
	public var x(xGetter,xSetter):Float;
	public var depth(depthGetter,depthSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var power(powerGetter,powerSetter):Float;
	public var epsilon(epsilonGetter,epsilonSetter):Float;
	public var expansionRate(expansionRateGetter, expansionRateSetter):Float;
	
	private static inline var POWER_FACTOR:Float = 100000;
	
	private var _updateActivity:UpdateOnFrame;
	private var _x:Float;
	private var _y:Float;
	private var _power:Float;
	private var _depth:Float;
	private var _invDepth:Float;
	private var _epsilonSq:Float;
	private var _oldRadius:Float;
	private var _radius:Float;
	private var _radiusChange:Float;
	private var _expansionRate:Float;
	
	/**
	 * The constructor creates an Explosion action for use by an emitter. 
	 * To add an Explosion to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param power The strength of the explosion - larger numbers produce a 
	 * stronger force. (The scale of value has been altered from previous versions
	 * so small numbers now produce a visible effect.)
	 * @param x The x coordinate of the center of the explosion.
	 * @param y The y coordinate of the center of the explosion.
	 * @param expansionRate The rate at which the shockwave moves out from the 
	 * explosion, in pixels per second.
	 * @param depth The depth (front-edge to back-edge) of the shock wave.
	 * @param epsilon The minimum distance for which the explosion force is 
	 * calculated. Particles closer than this distance experience the explosion
	 * as if they were this distance away. This stops the explosion effect 
	 * blowing up as distances get small.
	 */
	public function new( power:Float = 0, x:Float = 0, y:Float = 0, expansionRate:Float = 300, depth:Float = 10, epsilon:Float = 1 )
	{
		super();
		_oldRadius = 0;
		_radius = 0;
		_radiusChange = 0;
		_expansionRate = 500;
		this.power = power;
		this.x = x;
		this.y = y;
		this.expansionRate = expansionRate;
		this.depth = depth;
		this.epsilon = epsilon;
	}
	
	/**
	 * The strength of the explosion - larger numbers produce a stronger force.
	 */
	public function powerGetter():Float
	{
		return _power / POWER_FACTOR;
	}
	public function powerSetter( value:Float ):Float
	{
		_power = value * POWER_FACTOR;
		return _power;
	}
	
	/**
	 * The rate at which the shockwave moves out from the 
	 * explosion, in pixels per second.
	 */
	public function expansionRateGetter():Float
	{
		return _expansionRate;
	}
	public function expansionRateSetter( value:Float ):Float
	{
		_expansionRate = value;
		return _expansionRate;
	}
	
	/**
	 * The depth (front-edge to back-edge) of the shock wave.
	 */
	public function depthGetter():Float
	{
		return _depth * 2;
	}
	public function depthSetter( value:Float ):Float
	{
		_depth = value * 0.5;
		_invDepth = 1 / _depth;
		return _depth;
	}
	
	/**
	 * The x coordinate of the center of the explosion.
	 */
	public function xGetter():Float
	{
		return _x;
	}
	public function xSetter( value:Float ):Float
	{
		_x = value;
		return _x;
	}
	
	/**
	 * The y coordinate of the center of the explosion.
	 */
	public function yGetter():Float
	{
		return _y;
	}
	public function ySetter( value:Float ):Float
	{
		_y = value;
		return _y;
	}
	
	/**
	 * The minimum distance for which the explosion force is calculated. 
	 * Particles closer than this distance to the center of the explosion
	 * experience the explosion as it they were this distance away. This 
	 * stops the explosion effect blowing up as distances get small.
	 */
	public function epsilonGetter():Float
	{
		return Math.sqrt( _epsilonSq );
	}
	public function epsilonSetter( value:Float ):Float
	{
		_epsilonSq = value * value;
		return _epsilonSq;
	}
	
	/**
	 * Adds an UpdateOnFrame activity to the emitter to call this objects
	 * frameUpdate method once per frame.
	 * 
	 * @param emitter The emitter this action has been added to.
	 * 
	 * @see frameUpdate()
	 * @see org.flintparticles.common.activities.UpdateOnFrame
	 * @see org.flintparticles.common.actions.Action#addedToEmitter()
	 */
	override public function addedToEmitter( emitter:Emitter ):Void
	{
		_updateActivity = new UpdateOnFrame( this );
		emitter.addActivity( _updateActivity );
	}
	
	/**
	 * Removes the UpdateOnFrame activity that was added to the emitter in the
	 * addedToEmitter method.
	 * 
	 * @param emitter The emitter this action has been added to.
	 * 
	 * @see addedToEmitter()
	 * @see org.flintparticles.common.activities.UpdateOnFrame
	 * @see org.flintparticles.common.actions.Action#removedFromEmitter()
	 */
	override public function removedFromEmitter( emitter:Emitter ):Void
	{
		if( _updateActivity != null )
		{
			emitter.removeActivity( _updateActivity );
		}
	}
	
	/**
	 * Resets the explosion to its initial state, so it can start again.
	 */
	public function reset():Void
	{
		_radius = 0;
		_oldRadius = 0;
		_radiusChange = 0;
	}
	
	/**
	 * Called every frame before the particles are updated, this method
	 * calculates the current position of the blast shockwave.
	 * 
	 * <p>This method is called using an UpdateOnFrame activity that is
	 * created in the addedToEmitter method.</p>
	 * 
	 * @param emitter The emitter that is using this action.
	 * @param time The duration of the current animation frame.
	 * 
	 * @see org.flintparticles.common.activities.UpdateOnFrame
	 */
	public function frameUpdate( emitter:Emitter, time:Float ):Void
	{
		_oldRadius = _radius;
		_radiusChange = _expansionRate * time;
		_radius += _radiusChange;
	}
	
	/**
	 * Calculates the effect of the blast and shockwave on the particle at this
	 * time.
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
		var x:Float = p.x - _x;
		var y:Float = p.y - _y;
		var dSq:Float = x * x + y * y;
		if( dSq == 0 )
		{
			dSq = 0.02;
			x = 0.1;
			y = 0.1;
//				return;
		}
		var d:Float = Math.sqrt( dSq );
		
		if( d < _oldRadius - _depth )
		{
			return;
		}
		if( d > _radius + _depth )
		{
			return;
		}
		
		var offset:Float = d < _radius ? _depth - _radius + d : _depth - d + _radius;
		var oldOffset:Float = d < _oldRadius ? _depth - _oldRadius + d : _depth - d + _oldRadius;
		offset *= _invDepth;
		oldOffset *= _invDepth;
		if( offset < 0 )
		{
			time = time * ( _radiusChange + offset ) / _radiusChange;
			offset = 0;
		}
		if( oldOffset < 0 )
		{
			time = time * ( _radiusChange + oldOffset ) / _radiusChange;
			oldOffset = 0;
		}
		
		var factor:Float;
		if( d < _oldRadius || d > _radius )
		{
			factor = time * _power * ( offset + oldOffset ) / ( _radius * 2 * d * p.mass );
		}
		else
		{
			var ratio:Float = ( 1 - oldOffset ) / _radiusChange;
			var f1:Float = ratio * time * _power * ( oldOffset + 1 );
			var f2:Float = ( 1 - ratio ) * time * _power * ( offset + 1 );
			factor = ( f1 + f2 ) / ( _radius * 2 * d * p.mass );
		}
		p.velX += x * factor;
		p.velY += y * factor;
	}
}
