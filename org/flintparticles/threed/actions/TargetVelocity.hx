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

package org.flintparticles.threeD.actions;

import nme.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threeD.geom.Vector3DUtils;
import org.flintparticles.threeD.particles.Particle3D;

/**
 * The TargetVelocity action adjusts the velocity of the particle towards the target velocity.
 */
class TargetVelocity extends ActionBase
{
	public var x(xGetter,xSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var z(zGetter,zSetter):Float;
	public var rate(rateGetter,rateSetter):Float;
	public var targetVelocity(targetVelocityGetter,targetVelocitySetter):Vector3D;
	
	private var _vel:Vector3D;
	private var _rate:Float;
	
	/**
	 * The constructor creates a TargetVelocity action for use by 
	 * an emitter. To add a TargetVelocity to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param velX The x coordinate of the target velocity, in pixels per second.
	 * @param velY The y coordinate of the target velocity, in pixels per second.
	 * @param rate Adjusts how quickly the particle reaches the target velocity.
	 * Larger numbers cause it to approach the target velocity more quickly.
	 */
	public function new( targetVelocity:Vector3D = null, rate:Float = 0.1 )
	{
		super();
		this.targetVelocity = targetVelocity != null ? targetVelocity : new Vector3D();
		this.rate = rate;
	}
	
	/**
	 * The x coordinate of the target velocity, in pixels per second.s
	 */
	private function targetVelocityGetter():Vector3D
	{
		return _vel;
	}
	private function targetVelocitySetter( value:Vector3D ):Vector3D
	{
		_vel = Vector3DUtils.cloneVector( value );
		return _vel;
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
		return value;
	}
	
	/**
	 * The x coordinate of the target velocity.
	 */
	private function xGetter():Float
	{
		return _vel.x;
	}
	private function xSetter( value:Float ):Float
	{
		_vel.x = value;
		return value;
	}
	
	/**
	 * The y coordinate of  the target velocity.
	 */
	private function yGetter():Float
	{
		return _vel.y;
	}
	private function ySetter( value:Float ):Float
	{
		_vel.y = value;
		return value;
	}
	
	/**
	 * The z coordinate of the target velocity.
	 */
	private function zGetter():Float
	{
		return _vel.z;
	}
	private function zSetter( value:Float ):Float
	{
		_vel.z = value;
		return value;
	}

	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var v:Vector3D = cast( particle, Particle3D ).velocity;
		var c:Float = _rate * time;
		v.x += ( _vel.x - v.x ) * c;
		v.y += ( _vel.y - v.y ) * c;
		v.z += ( _vel.z - v.z ) * c;
	}
}
