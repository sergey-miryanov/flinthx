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

package org.flintparticles.twod.actions;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twod.particles.Particle2D;

/**
 * The TurnTowardsPoint action causes the particle to constantly adjust its 
 * direction so that it travels towards a particular point.
 */

class TurnTowardsPoint extends ActionBase
{
	public var x(xGetter,xSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var power(powerGetter, powerSetter):Float;
	
	private var _x:Float;
	private var _y:Float;
	private var _power:Float;
	
	/**
	 * The constructor creates a TurnTowardsPoint action for use by an emitter. 
	 * To add a TurnTowardsPoint to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param power The strength of the turn action. Higher values produce a sharper turn.
	 * @param x The x coordinate of the point towards which the particle turns.
	 * @param y The y coordinate of the point towards which the particle turns.
	 */
	public function new( x:Float = 0, y:Float = 0, power:Float = 0 )
	{
		super();
		this.power = power;
		this.x = x;
		this.y = y;
	}
	
	/**
	 * The strength of the turn action. Higher values produce a sharper turn.
	 */
	private function powerGetter():Float
	{
		return _power;
	}
	private function powerSetter( value:Float ):Float
	{
		_power = value;
		return _power;
	}
	
	/**
	 * The x coordinate of the point that the particle turns towards.
	 */
	private function xGetter():Float
	{
		return _x;
	}
	private function xSetter( value:Float ):Float
	{
		_x = value;
		return _x;
	}
	
	/**
	 * The y coordinate of the point that the particle turns towards.
	 */
	private function yGetter():Float
	{
		return _y;
	}
	private function ySetter( value:Float ):Float
	{
		_y = value;
		return _y;
	}
	
	/**
	 * Calculates the direction to the focus point and turns the particle towards 
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
		var velLength:Float = Math.sqrt( p.velX * p.velX + p.velY * p.velY );
		var dx:Float = p.velX / velLength;
		var dy:Float = p.velY / velLength;
		var acc:Float = power * time;
		var targetX:Float = _x - p.x;
		var targetY:Float = _y - p.y;
		var len:Float = Math.sqrt( targetX * targetX + targetY * targetY );
		if( len == 0 )
		{
			return;
		}
		targetX /= len;
		targetY /= len;
		var dot:Float = targetX * dx + targetY * dy;
		var perpX:Float = targetX - dx * dot;
		var perpY:Float = targetY - dy * dot;
		var factor:Float = acc / Math.sqrt( perpX * perpX + perpY * perpY );
		p.velX += perpX * factor;
		p.velY += perpY * factor;
		factor = velLength / Math.sqrt( p.velX * p.velX + p.velY * p.velY );
		p.velX *= factor;
		p.velY *= factor;
	}
}
