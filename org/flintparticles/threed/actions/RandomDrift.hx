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

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threeD.particles.Particle3D;

/**
 * The RandomDrift action moves the particle by a random small amount every frame,
 * causing the particle to drift around.
 */

class RandomDrift extends ActionBase
{
	public var driftZ(driftZGetter,driftZSetter):Float;
	public var driftY(driftYGetter,driftYSetter):Float;
	public var driftX(driftXGetter,driftXSetter):Float;
	
	private var _driftX:Float;
	private var _driftY:Float;
	private var _driftZ:Float;
	
	/**
	 * The constructor creates a RandomDrift action for use by 
	 * an emitter. To add a RandomDrift to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param driftX The maximum amount of horizontal drift in pixels per second.
	 * @param driftY The maximum amount of vertical drift in pixels per second.
	 */
	public function new( driftX:Float = 0, driftY:Float = 0, driftZ:Float = 0 )
	{
		super();
		this.driftX = driftX;
		this.driftY = driftY;
		this.driftZ = driftZ;
	}
	
	/**
	 * The maximum amount of horizontal drift in pixels per second.
	 */
	private function driftXGetter():Float
	{
		return _driftX / 2;
	}
	private function driftXSetter( value:Float ):Float
	{
		_driftX = value * 2;
		return _driftX;
	}
	
	/**
	 * The maximum amount of vertical drift in pixels per second.
	 */
	private function driftYGetter():Float
	{
		return _driftY / 2;
	}
	private function driftYSetter( value:Float ):Float
	{
		_driftY = value * 2;
		return _driftY;
	}
	
	/**
	 * The maximum amount of vertical drift in pixels per second.
	 */
	private function driftZGetter():Float
	{
		return _driftZ / 2;
	}
	private function driftZSetter( value:Float ):Float
	{
		_driftZ = value * 2;
		return _driftZ;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		p.velocity.x += ( Math.random() - 0.5 ) * _driftX * time;
		p.velocity.y += ( Math.random() - 0.5 ) * _driftY * time;
		p.velocity.z += ( Math.random() - 0.5 ) * _driftZ * time;
	}
}
