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

package org.flintparticles.twod.initializers;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.twod.particles.Particle2D;

/**
 * The RotationAbsolute Initializer sets the rotation of the particle. The rotation is
 * independent of the rotation of the emitter.
 */

class RotationAbsolute extends InitializerBase
{
	public var angle(angleGetter,angleSetter):Float;
	public var maxAngle(maxAngleGetter,maxAngleSetter):Float;
	public var minAngle(minAngleGetter, minAngleSetter):Float;
	
	private var _min : Float;
	private var _max : Float;

	/**
	 * The constructor creates a RotationAbsolute initializer for use by 
	 * an emitter. To add a RotationAbsolute to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * <p>The rotation of particles initialized by this class
	 * will be a random value between the minimum and maximum
	 * values set. If no maximum value is set, the minimum value
	 * is used with no variation.</p>
	 * 
	 * @param minAngle The minimum angle, in radians, for the particle's rotation.
	 * @param maxAngle The maximum angle, in radians, for the particle's rotation.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( minAngle : Float = 0, maxAngle : Float = 0 )
	{
		super();
		this.minAngle = minAngle;
		this.maxAngle = maxAngle;
	}
	
	/**
	 * The minimum angle for particles initialised by 
	 * this initializer.
	 */
	private function minAngleGetter():Float
	{
		return _min;
	}
	private function minAngleSetter( value:Float ):Float
	{
		_min = value;
		return _min;
	}
	
	/**
	 * The maximum angle for particles initialised by 
	 * this initializer.
	 */
	private function maxAngleGetter():Float
	{
		return _max;
	}
	private function maxAngleSetter( value:Float ):Float
	{
		_max = value;
		return _max;
	}
	
	/**
	 * When reading, returns the average of minAngle and maxAngle.
	 * When writing this sets both maxAngle and minAngle to the 
	 * same angle value.
	 */
	private function angleGetter():Float
	{
		return _min == _max ? _min : ( _max + _min ) / 2;
	}
	private function angleSetter( value:Float ):Float
	{
		_max = _min = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter : Emitter, particle : Particle ) : Void
	{
		var p:Particle2D = cast( particle,Particle2D );
		if( Math.isNaN( _max ) )
		{
			p.rotation = _min;
		}
		else
		{
			p.rotation = _min + Math.random() * ( _max - _min );
		}
	}
}
