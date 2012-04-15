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
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twoD.particles.Particle2D;

/**
 * The RandomDrift action moves the particle by a random small amount every 
 * frame, causing the particle to drift around.
 */

class RandomDrift extends ActionBase
{
	public var driftY(driftYGetter, driftYSetter):Float;
	public var driftX(driftXGetter, driftXSetter):Float;
	
	private var _sizeX:Float;
	private var _sizeY:Float;
	
	/**
	 * The constructor creates a RandomDrift action for use by an emitter. 
	 * To add a RandomDrift to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param driftX The maximum amount of horizontal drift in pixels per second.
	 * @param driftY The maximum amount of vertical drift in pixels per second.
	 */
	public function new( driftX:Float = 0, driftY:Float = 0 )
	{
		super();
		this.driftX = driftX;
		this.driftY = driftY;
	}
	
	/**
	 * The maximum amount of horizontal drift in pixels per second.
	 */
	private function driftXGetter():Float
	{
		return _sizeX / 2;
	}
	private function driftXSetter( value:Float ):Float
	{
		_sizeX = value * 2;
		return _sizeX;
	}
	
	/**
	 * The maximum amount of vertical drift in pixels per second.
	 */
	private function driftYGetter():Float
	{
		return _sizeY / 2;
	}
	private function driftYSetter( value:Float ):Float
	{
		_sizeY = value * 2;
		return _sizeY;
	}
	
	/**
	 * Calculates a random drift for this frame and applies it for the
	 * period of time indicated.
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
		p.velX += ( Math.random() - 0.5 ) * _sizeX * time;
		p.velY += ( Math.random() - 0.5 ) * _sizeY * time;
	}
}
