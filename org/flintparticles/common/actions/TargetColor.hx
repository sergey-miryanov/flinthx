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
import org.flintparticles.common.actions.TargetColor;
import org.flintparticles.common.actions.ActionBase;

/**
 * The TargetColor action adjusts the color of the particle towards a 
 * target color. On every update the color of the particle moves a 
 * little closer to the target color. The rate at which particles approach
 * the target is controlled by the rate property.
 */
class TargetColor extends ActionBase
{
	public var rate(rateGetter,rateSetter):Float;
	public var targetColor(targetColorGetter, targetColorSetter):Int;
	
	private var _red:Int;
	private var _green:Int;
	private var _blue:Int;
	private var _alpha:Int;
	private var _rate:Float;
	
	/**
	 * The constructor creates a TargetColor action for use by an emitter. 
	 * To add a TargetColor to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param targetColor The target color. This is a 32 bit color of the form 
	 * 0xAARRGGBB.
	 * @param rate Adjusts how quickly the particle reaches the target color.
	 * Larger numbers cause it to approach the target color more quickly.
	 */
	public function new( targetColor:Int= 0xFFFFFF, rate:Float = 0.1 )
	{
		super();
		_red = ( targetColor >>> 16 ) & 255;
		_green = ( targetColor >>> 8 ) & 255;
		_blue = ( targetColor ) & 255;
		_alpha = ( targetColor >>> 24 ) & 255;
		_rate = rate;
	}
	
	/**
	 * The target color. This is a 32 bit color of the form 0xAARRGGBB.
	 */
	private function targetColorGetter():Int
	{
		return ( _alpha << 24 ) | ( _red << 16 ) | ( _green << 8 ) | _blue;
	}
	private function targetColorSetter( value:Int ):Int
	{
		_red 	= Std.int(( value >>> 16 ) & 255);
		_green 	= Std.int(( value >>> 8 ) & 255);
		_blue 	= Std.int(( value ) & 255);
		_alpha 	= Std.int(( value >>> 24 ) & 255);
		return null;
	}
	
	/**
	 * Adjusts how quickly the particle reaches the target color.
	 * Larger numbers cause it to approach the target color more quickly.
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
	 * Adjusts the color of the particle based on its current color, the target 
	 * color and the time elapsed.
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
		if( ! particle.dictionary.get(this) )
		{
			particle.dictionary.set(this, new ColorFloat( particle.color ));
		}
		var dicObj:ColorFloat = cast(particle.dictionary.get(this),ColorFloat);
		
		var inv:Float = _rate * time;
		if( inv > 1 )
		{
			inv = 1;
		}
		var ratio:Float = 1 - inv;
		
		dicObj.red = dicObj.red * ratio + _red * inv;
		dicObj.green = dicObj.green * ratio + _green * inv;
		dicObj.blue = dicObj.blue * ratio + _blue * inv;
		dicObj.alpha = dicObj.alpha * ratio + _alpha * inv;
		particle.color = dicObj.getColor();
	}
}

class ColorFloat
{
	public var red:Float;
	public var green:Float;
	public var blue:Float;
	public var alpha:Float;

	public function new( color:Int )
	{
		red = ( color >>> 16 ) & 255;
		green = ( color >>> 8 ) & 255;
		blue = ( color ) & 255;
		alpha = ( color >>> 24 ) & 255;
	}

	public function getColor():Int
	{
		return ( Math.round( alpha ) << 24 ) | ( Math.round( red ) << 16 ) | ( Math.round( green ) << 8 ) | Math.round( blue );
	}
}
