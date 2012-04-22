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
import org.flintparticles.threeD.particles.Particle3D;


/**
 * The Accelerate Action adjusts the velocity of the particle by a 
 * constant acceleration. This can be used, for example, to simulate
 * gravity.
 */
class Accelerate extends ActionBase
{
	public var x(xGetter,xSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var z(zGetter,zSetter):Float;
	public var acceleration(accelerationGetter, accelerationSetter):Vector3D;
	
	private var _acc:Vector3D;
	
	/**
	 * The constructor creates an Acceleration action for use by an emitter. 
	 * To add an Accelerator to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param acceleration The acceleration to apply, in coordinate units 
	 * per second per second.
	 */
	public function new( acceleration:Vector3D = null )
	{
		super();
		this.acceleration = acceleration != null ? acceleration : new Vector3D();
	}
	
	/**
	 * The acceleration, in coordinate units per second per second.
	 */
	private function accelerationGetter():Vector3D
	{
		return _acc;
	}
	private function accelerationSetter( value:Vector3D ):Vector3D
	{
		_acc = value.clone();
		_acc.w = 0;
		return value;
	}
	
	/**
	 * The x coordinate of the acceleration, in
	 * coordinate units per second per second.
	 */
	private function xGetter():Float
	{
		return _acc.x;
	}
	private function xSetter( value:Float ):Float
	{
		_acc.x = value;
		return value;
	}
	
	/**
	 * The y coordinate of the acceleration, in
	 * coordinate units per second per second.
	 */
	private function yGetter():Float
	{
		return _acc.y;
	}
	private function ySetter( value:Float ):Float
	{
		_acc.y = value;
		return value;
	}
	
	/**
	 * The z coordinate of the acceleration, in
	 * coordinate units per second per second.
	 */
	private function zGetter():Float
	{
		return _acc.z;
	}
	private function zSetter( value:Float ):Float
	{
		_acc.z = value;
		return value;
	}
	
	/**
	 * Applies the acceleration to a particle for the specified time period.
	 * 
	 * <p>This method is called by the emitter and need not be called by the 
	 * user</p>
	 * 
	 * @param emitter The Emitter that created the particle.
	 * @param particle The particle to be updated.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Action#update()
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var v:Vector3D = cast( particle, Particle3D ).velocity;
		v.x += _acc.x * time;
		v.y += _acc.y * time;
		v.z += _acc.z * time;
	}
}
