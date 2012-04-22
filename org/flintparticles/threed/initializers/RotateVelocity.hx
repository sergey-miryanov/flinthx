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

package org.flintparticles.threeD.initializers;

import nme.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.threeD.geom.Vector3DUtils;
import org.flintparticles.threeD.particles.Particle3D;

/**
 * The RotateVelocity Initializer sets the angular velocity of the particle.
 * It is usually combined with the Rotate action to rotate the particle
 * using this angular velocity.
 */

class RotateVelocity extends InitializerBase
{
	public var maxAngVelocity(maxAngVelocityGetter,maxAngVelocitySetter):Float;
	public var angVelocity(angVelocityGetter,angVelocitySetter):Float;
	public var axis(axisGetter,axisSetter):Vector3D;
	public var minAngVelocity(minAngVelocityGetter,minAngVelocitySetter):Float;
	
	private var _max:Float;
	private var _min:Float;
	private var _axis : Vector3D;

	/**
	 * The constructor creates a RotateVelocity initializer for use by 
	 * an emitter. To add a RotateVelocity to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * <p>The angularVelocity of particles initialized by this class
	 * will be a random value between the minimum and maximum
	 * values set. If no maximum value is set, the minimum value
	 * is used with no variation.</p>
	 * 
	 * @param minAngVelocity The minimum angularVelocity, in 
	 * radians per second, for the particle's angularVelocity.
	 * @param maxAngVelocity The maximum angularVelocity, in 
	 * radians per second, for the particle's angularVelocity.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( axis:Vector3D = null, minAngVelocity:Float = 0, maxAngVelocity:Float = -1 )
	{
		super();
		this.axis = axis;
		this.minAngVelocity = minAngVelocity;
		this.maxAngVelocity = maxAngVelocity;
	}
	
	/**
	 * The axis for the rotation.
	 */
	private function axisGetter():Vector3D
	{
		return _axis;
	}
	private function axisSetter( value:Vector3D ):Vector3D
	{
		_axis = Vector3DUtils.cloneUnit( value );
		return _axis;
	}
	
	/**
	 * The minimum angular velocity value for particles initialised by 
	 * this initializer. Should be between 0 and 1.
	 */
	private function minAngVelocityGetter():Float
	{
		return _min;
	}
	private function minAngVelocitySetter( value:Float ):Float
	{
		_min = value;
		return value;
	}
	
	/**
	 * The maximum angular velocity value for particles initialised by 
	 * this initializer. Should be between 0 and 1.
	 */
	private function maxAngVelocityGetter():Float
	{
		return _max;
	}
	private function maxAngVelocitySetter( value:Float ):Float
	{
		_max = value;
		return value;
	}
	
	/**
	 * When reading, returns the average of minAngVelocity and maxAngVelocity.
	 * When writing this sets both maxAngVelocity and minAngVelocity to the 
	 * same angular velocity value.
	 */
	public function angVelocityGetter():Float
	{
		if( Math.isNaN( _max ) || _min == _max )
		{
			return _min;
		}
		return ( _max + _min ) / 2;
	}
	public function angVelocitySetter( value:Float ):Float
	{
		_max = _min = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter:Emitter, particle:Particle ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		var angle:Float;
		if( Math.isNaN( _max ) || _min == _max )
		{
			angle = _min;
		}
		else
		{
			angle = _min + Math.random() * ( _max - _min );
		}
		var v:Vector3D = p.angVelocity;
		v.x = axis.x * angle;
		v.y = axis.y * angle;
		v.z = axis.z * angle;
	}
}
