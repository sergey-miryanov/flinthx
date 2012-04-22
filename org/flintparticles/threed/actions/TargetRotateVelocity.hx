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

package org.flintparticles.threed.actions;

import nme.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threed.geom.Vector3DUtils;
import org.flintparticles.threed.particles.Particle3D;

/**
 * The TargetRotateVelocity action adjusts the angular velocity of the particle towards the target angular velocity.
 */
class TargetRotateVelocity extends ActionBase
{
	public var rotateSpeed(rotateSpeedGetter,rotateSpeedSetter):Float;
	public var rate(rateGetter,rateSetter):Float;
	public var axis(axisGetter,axisSetter):Vector3D;
	
	private var _rotateSpeed:Float;
	private var _axis:Vector3D;
	private var _angVel:Vector3D;
	private var _rate:Float;
	
	/**
	 * The constructor creates a TargetRotateVelocity action for use by 
	 * an emitter. To add a TargetRotateVelocity to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param axis The axis the velocity acts around.
	 * @param angVelocity The target angular velocity, in radians per second.
	 * @param rate Adjusts how quickly the particle reaches the target angular velocity.
	 * Larger numbers cause it to approach the target angular velocity more quickly.
	 */
	public function new( axis:Vector3D = null, rotateSpeed:Float = 0, rate:Float = 0.1 )
	{
		super();
		_rotateSpeed = 0;
		this.rotateSpeed = rotateSpeed;
		if( axis != null )
		{
			this.axis = axis;
		}
		this.rate = rate;
	}
	
	/**
	 * Adjusts how quickly the particle reaches the target angular velocity.
	 * Larger numbers cause it to approach the target angular velocity more quickly.
	 */
	private function rateGetter():Float
	{
		return _rate;
	}
	private function rateSetter( value:Float ):Float
	{
		_rate = value;
		return _rate;
	}
	
	/**
	 * The axis for the target angular velocity.
	 */
	private function axisGetter():Vector3D
	{
		return _axis;
	}
	private function axisSetter( value:Vector3D ):Vector3D
	{
		_axis = Vector3DUtils.cloneUnit( value );
		_angVel = _axis.clone();
		_angVel.scaleBy( _rotateSpeed );
		return _axis;
	}
	
	/**
	 * The size of the target angular velocity.
	 */
	private function rotateSpeedGetter():Float
	{
		return _rotateSpeed;
	}
	private function rotateSpeedSetter( value:Float ):Float
	{
		_rotateSpeed = value;
		if( _axis != null )
		{
			_angVel = _axis.clone();
			_angVel.scaleBy( _rotateSpeed );
		}
		return _rotateSpeed;
	}

	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var v:Vector3D = cast( particle, Particle3D ).angVelocity;
		var c:Float = _rate * time;
		v.x += ( _angVel.x - v.x ) * c;
		v.y += ( _angVel.y - v.y ) * c;
		v.z += ( _angVel.z - v.z ) * c;
	}
}
