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

import nme.display.DisplayObject;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twoD.particles.Particle2D;


/**
 * The TurnAwayFromMouse action causes the particle to constantly adjust its direction
 * so that it travels away from the mouse pointer.
 */

class TurnAwayFromMouse extends ActionBase
{
	public var renderer(rendererGetter,rendererSetter):DisplayObject;
	public var power(powerGetter, powerSetter):Float;
	
	private var _power:Float;
	private var _renderer:DisplayObject;
	
	/**
	 * The constructor creates a TurnAwayFromMouse action for use by an emitter. 
	 * To add a TurnAwayFromMouse to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param power The strength of the turn action. Higher values produce a sharper turn.
	 * @param renderer The display object whose coordinate system the mouse position is 
	 * converted to. This is usually the renderer for the particle system created by the emitter.
	 */
	public function new( power:Float = 0, renderer:DisplayObject = null )
	{
		super();
		this.power = power;
		this.renderer = renderer;
	}
	
	/**
	 * The strength of the turn action. Higher values produce a sharper turn.
	 */
	public function powerGetter():Float
	{
		return _power;
	}
	public function powerSetter( value:Float ):Float
	{
		_power = value;
		return _power;
	}

	/**
	 * The display object whose coordinate system the mouse position is converted to. This
	 * is usually the renderer for the particle system created by the emitter.
	 */
	public function rendererGetter():DisplayObject
	{
		return _renderer;
	}
	public function rendererSetter( value:DisplayObject ):DisplayObject
	{
		_renderer = value;
		return _renderer;
	}
	
	/**
	 * Calculates the direction to the mouse and turns the particle towards 
	 * this direction.
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
		var turnLeft:Bool = ( ( p.y - _renderer.mouseY ) * p.velX + ( _renderer.mouseX - p.x ) * p.velY < 0 );
		var newAngle:Float;
		if ( turnLeft )
		{
			newAngle = Math.atan2( p.velY, p.velX ) - _power * time;
			
		}
		else
		{
			newAngle = Math.atan2( p.velY, p.velX ) + _power * time;
		}
		var len:Float = Math.sqrt( p.velX * p.velX + p.velY * p.velY );
		p.velX = len * Math.cos( newAngle );
		p.velY = len * Math.sin( newAngle );
		var overturned:Bool = ( ( p.y - _renderer.mouseY ) * p.velX + ( _renderer.mouseX - p.x ) * p.velY < 0 ) != turnLeft;
		if( overturned )
		{
			var dx:Float = p.x - _renderer.mouseX;
			var dy:Float = p.y - _renderer.mouseY;
			var factor:Float = len / Math.sqrt( dx * dx + dy * dy );
			p.velX = dx * factor;
			p.velY = dy * factor;
		}
	}
}
