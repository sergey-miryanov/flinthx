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

package org.flintparticles.twod.emitters;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.ParticleFactory;
import org.flintparticles.common.utils.Maths;
import org.flintparticles.twod.particles.Particle2D;
import org.flintparticles.twod.particles.ParticleCreator2D;
import org.flintparticles.common.particles.Particle;

/**
 * The Emitter class manages the creation and ongoing state of particles. It uses a number of
 * utility classes to customise its behaviour.
 * 
 * <p>An emitter uses Initializers to customise the initial state of particles
 * that it creates, their position, velocity, color etc. These are added to the 
 * emitter using the addInitializer  method.</p>
 * 
 * <p>An emitter uses Actions to customise the behaviour of particles that
 * it creates, to apply gravity, drag, fade etc. These are added to the emitter 
 * using the addAction method.</p>
 * 
 * <p>An emitter uses Activities to customise its own behaviour in an ongoing manner, to 
 * make it move or rotate.</p>
 * 
 * <p>An emitter uses a Counter to know when and how many particles to emit.</p>
 * 
 * <p>An emitter uses a Renderer to display the particles on screen.</p>
 * 
 * <p>All timings in the emitter are based on actual time passed, not on frames.</p>
 * 
 * <p>Most functionality is best added to an emitter using Actions,
 * Initializers, Activities, Counters and Renderers. This offers greater 
 * flexibility to combine behaviours witout needing to subclass 
 * the Emitter itself.</p>
 * 
 * <p>The emitter also has position properties - x, y, rotation - that can be used to directly
 * affect its location in the particle system.</p>
 */

class Emitter2D extends Emitter
{
	public var x(xGetter,xSetter):Float;
	//public var defaultParticleFactory(defaultParticleFactoryGetter,null):ParticleFactory;
	public var y(yGetter,ySetter):Float;
	public var rotation(rotationGetter,rotationSetter):Float;
	public var rotRadians(rotRadiansGetter,rotRadiansSetter):Float;
	/**
	 * @private
	 * 
	 * default factory to manage the creation, reuse and destruction of particles
	 */
	private static inline var _creator:ParticleCreator2D = new ParticleCreator2D();
	
	/**
	 * The default particle factory used to manage the creation, reuse and destruction of particles.
	 */
	public static function defaultParticleFactoryGetter():ParticleFactory
	{
		return _creator;
	}
	
	/**
	 * @private
	 */
	private var _x:Float;
	/**
	 * @private
	 */
	private var _y:Float;
	/**
	 * @private
	 */
	private var _rotation:Float; // N.B. Is in radians
	
	/**
	 * Identifies whether the particles should be arranged
	 * into spacially sorted arrays - this speeds up proximity
	 * testing for those actions that need it.
	 */
	public var spaceSort:Bool;
	
	/**
	 * The constructor creates an emitter.
	 */
	public function new()
	{
		super();
		this._x = 0;
		this._y = 0;
		this._rotation = 0;
		this.spaceSort = false;
		_particleFactory = _creator;
	}
	
	/**
	 * Indicates the x coordinate of the Emitter within the particle system's coordinate space.
	 */
	private function xGetter():Float
	{
		return _x;
	}
	private function xSetter( value:Float ):Float
	{
		_x = value;
		return value;
	}
	/**
	 * Indicates the y coordinate of the Emitter within the particle system's coordinate space.
	 */
	private function yGetter():Float
	{
		return _y;
	}
	private function ySetter( value:Float ):Float
	{
		_y = value;
		return value;
	}
	/**
	 * Indicates the rotation of the Emitter, in degrees, within the particle system's coordinate space.
	 */
	private function rotationGetter():Float
	{
		return Maths.asDegrees( _rotation );
	}
	private function rotationSetter( value:Float ):Float
	{
		_rotation = Maths.asRadians( value );
		return value;
	}
	/**
	 * Indicates the rotation of the Emitter, in radians, within the particle system's coordinate space.
	 */
	private function rotRadiansGetter():Float
	{
		return _rotation;
	}
	private function rotRadiansSetter( value:Float ):Float
	{
		_rotation = value;
		return value;
	}
	
	/**
	 * Used internally to initialise the position and rotation of a particle relative to the emitter.
	 */
	override private function initParticle( particle:Particle ):Void
	{
		var p:Particle2D = cast( particle, Particle2D );
		p.x = _x;
		p.y = _y;
		p.previousX = _x;
		p.previousY = _y;
		p.rotation = _rotation;
	}
	
	/**
	 * Used internally and in derived classes to update the emitter.
	 * @param time The duration, in seconds, of the current frame.
	 */
	override private function sortParticles():Void
	{
		if( spaceSort )
		{
			/**
			 * TODO: sort on, check if this works
			 */
			_particles.sort( function(a,b) return Reflect.compare(a.x,b.x) );
			//_particles.sortOn( "x", Array<Dynamic>.NUMERIC );
			var len:Int = _particles.length;
			var i:Int = 0;
			//for ( var i:Int = 0; i < len; ++i )
			while (i < len)
			{
				cast( _particles[ i ], Particle2D ).sortID = i;
				++i;
			}
		}
	}
}
