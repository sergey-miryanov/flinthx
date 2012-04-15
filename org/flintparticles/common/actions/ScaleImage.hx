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
import org.flintparticles.common.actions.ScaleImage;
import org.flintparticles.common.actions.ActionBase;

/**
 * The ScaleImage action adjusts the size of the particles imnage as it ages.
 * It uses the particle's energy level to decide what size the particle
 * should be.
 * 
 * <p>Usually a particle's energy changes from 1 to 0 over its lifetime, but
 * this can be altered via the easing function set within the age action.</p>
 * 
 * <p>This action should be used in conjunction with the Age action.</p>
 * 
 * <p>If you also want to adjust the mass and collision radius of the particle, use
 * the ScaleAll action.</p>
 * 
 * @see org.flintparticles.twoD.actions.ScaleAll
 * @see org.flintparticles.threeD.actions.ScaleAll
 * @see org.flintparticles.common.actions.Action
 * @see org.flintparticles.common.actions.Age
 */

class ScaleImage extends ActionBase
{
	public var startScale(startScaleGetter,startScaleSetter):Float;
	public var endScale(endScaleGetter, endScaleSetter):Float;
	
	private var _diffScale:Float;
	private var _endScale:Float;
	
	/**
	 * The constructor creates a ScaleImage action for use by an emitter. 
	 * To add a ScaleImage to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param startScale The scale factor for the particle when its energy
	 * is 1 - usually at the start of its lifetime. A scale of 1 is normal size.
	 * @param endScale The scale factor for the particle when its energy
	 * is 0 - usually at the end of its lifetime. A scale of 1 is normal size.
	 */
	public function new( startScale:Float = 1, endScale:Float = 1 )
	{
		super();
		_diffScale = startScale - endScale;
		_endScale = endScale;
	}
	
	/**
	 * The scale factor for the particle when its energy
	 * is 1 - usually at the start of its lifetime. A scale of 1 is normal size.
	 */
	private function startScaleGetter():Float
	{
		return _endScale + _diffScale;
	}
	private function startScaleSetter( value:Float ):Float
	{
		_diffScale = value - _endScale;
		return _diffScale;
	}
	
	/**
	 * The scale factor for the particle when its energy
	 * is 0 - usually at the end of its lifetime. A scale of 1 is normal size.
	 */
	private function endScaleGetter():Float
	{
		return _endScale;
	}
	private function endScaleSetter( value:Float ):Float
	{
		_diffScale = _endScale + _diffScale - value;
		_endScale = value;
		return _endScale;
	}
	
	/**
	 * Sets the scale of the particle based on the values defined
	 * and the particle's energy level.
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
		particle.scale = _endScale + _diffScale * particle.energy;
	}
}
