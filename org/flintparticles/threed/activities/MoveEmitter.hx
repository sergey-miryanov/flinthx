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

package org.flintparticles.threeD.activities;

import nme.geom.Vector3D;
import org.flintparticles.common.activities.ActivityBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threeD.emitters.Emitter3D;
import org.flintparticles.threeD.geom.Vector3DUtils;

/**
 * The MoveEmitter activity moves the emitter at a constant velocity.
 */
class MoveEmitter extends ActivityBase
{
	public var x(xGetter,xSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var z(zGetter,zSetter):Float;
	public var velocity(velocityGetter,velocitySetter):Vector3D;
	
	private var _vel:Vector3D;
	
	/**
	 * The constructor creates a MoveEmitter activity for use by 
	 * an emitter. To add a MoveEmitter to an emitter, use the
	 * emitter's addActvity method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addActivity()
	 * 
	 * @param x The x coordinate of the velocity to move the emitter, 
	 * in pixels per second.
	 * @param y The y coordinate of the velocity to move the emitter, 
	 * in pixels per second.
	 */
	public function new( velocity:Vector3D = null )
	{
		super();
		this.velocity = velocity != null ? velocity : new Vector3D();
	}
	
	/**
	 * The velocity to move the emitter, in pixels per second.
	 */
	private function velocityGetter():Vector3D
	{
		return _vel;
	}
	private function velocitySetter( value:Vector3D ):Vector3D
	{
		_vel = Vector3DUtils.cloneVector( value );
		return _vel;
	}
	
	/**
	 * The x coordinate of the velocity to move the emitter, in pixels per second.
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
	 * The y coordinate of  the velocity to move the emitter, in pixels per second.
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
	 * The z coordinate of the velocity to move the emitter, in pixels per second.
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
	override public function update( emitter : Emitter, time : Float ) : Void
	{
		var p:Vector3D = cast( emitter, Emitter3D ).position;
		p.x += _vel.x * time;
		p.y += _vel.y * time;
		p.z += _vel.z * time;
	}
}
