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

package org.flintparticles.common.initializers;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.Lifetime;
import org.flintparticles.common.initializers.InitializerBase;

/**
 * The Lifetime Initializer sets a lifetime for the particle. It is
 * usually combined with the Age action to age the particle over its
 * lifetime and destroy the particle at the end of its lifetime.
 */
class Lifetime extends InitializerBase
{
	public var maxLifetime(maxLifetimeGetter,maxLifetimeSetter):Float;
	public var lifetime(lifetimeGetter,lifetimeSetter):Float;
	public var minLifetime(minLifetimeGetter, minLifetimeSetter):Float;
	
	private var _max:Float;
	private var _min:Float;
	
	/**
	 * The constructor creates a Lifetime initializer for use by 
	 * an emitter. To add a Lifetime to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * <p>The lifetime of particles initialized by this class
	 * will be a random value between the minimum and maximum
	 * values set. If no maximum value is set, the minimum value
	 * is used with no variation.</p>
	 * 
	 * @param minLifetime the minimum lifetime for particles
	 * initialized by the instance.
	 * @param maxLifetime the maximum lifetime for particles
	 * initialized by the instance.
	 * 
	 * @see Emitter.addInitializer.
	 */
	public function new( minnew:Float = 0.0, maxnew:Float = -1 )
	{
		super();
		_max = maxnew;
		_min = minnew;
	}
	
	/**
	 * The minimum lifetime for particles initialised by 
	 * this initializer. Should be between 0 and 1.
	 */
	private function minLifetimeGetter():Float
	{
		return _min;
	}
	private function minLifetimeSetter( value:Float ):Float
	{
		_min = value;
		return _min;
	}
	
	/**
	 * The maximum lifetime for particles initialised by 
	 * this initializer. Should be between 0 and 1.
	 */
	private function maxLifetimeGetter():Float
	{
		return _max;
	}
	private function maxLifetimeSetter( value:Float ):Float
	{
		_max = value;
		return _max;
	}
	
	/**
	 * When reading, returns the average of minLifetime and maxLifetime.
	 * When writing this sets both maxLifetime and minLifetime to the 
	 * same lifetime value.
	 */
	private function lifetimeGetter():Float
	{
		return _min == _max ? _min : ( _max + _min ) * 0.5;
	}
	private function lifetimeSetter( value:Float ):Float
	{
		_max = _min = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter:Emitter, particle:Particle ):Void
	{
		if( _max < 0 )
		{
			particle.lifetime = _min;
		}
		else
		{
			particle.lifetime = _min + Math.random() * ( _max - _min );
		}
	}
}
