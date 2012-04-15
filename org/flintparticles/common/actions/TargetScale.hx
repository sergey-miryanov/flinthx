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

package org.flintparticles.common.actions;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.actions.TargetScale;
import org.flintparticles.common.actions.ActionBase;

/**
 * The TargetScale action adjusts the scale of the particle towards a 
 * target scale. On every update the scale of the particle moves a 
 * little closer to the target scale. The rate at which particles approach
 * the target is controlled by the rate property.
 */
class TargetScale extends ActionBase
{
	public var targetScale(targetScaleGetter,targetScaleSetter):Float;
	public var rate(rateGetter,rateSetter):Float;
	private var _scale:Float;
	private var _rate:Float;
	
	/**
	 * The constructor creates a TargetScale action for use by an emitter. 
	 * To add a TargetScale to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param targetScale The target scale for the particle. 1 is normal size.
	 * @param rate Adjusts how quickly the particle reaches the target scale.
	 * Larger numbers cause it to approach the target scale more quickly.
	 */
	public function new( targetScale:Float= 1, rate:Float = 0.1 )
	{
		super();
		_scale = targetScale;
		_rate = rate;
	}
	
	/**
	 * The target scale for the particle. 1 is normal size.
	 */
	public function targetScaleGetter():Float
	{
		return _scale;
	}
	public function targetScaleSetter( value:Float ):Float
	{
		_scale = value;
		return _scale;
	}
	
	/**
	 * Adjusts how quickly the particle reaches the target scale.
	 * Larger numbers cause it to approach the target scale more quickly.
	 */
	public function rateGetter():Float
	{
		return _rate;
	}
	public function rateSetter( value:Float ):Float
	{
		_rate = value;
		return _rate;
	}
	
	/**
	 * Adjusts the scale of the particle based on its current scale, the target 
	 * scale and the time elapsed.
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
		particle.scale += ( _scale - particle.scale ) * _rate * time;
	}
}
