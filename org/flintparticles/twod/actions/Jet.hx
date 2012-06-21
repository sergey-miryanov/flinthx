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
import org.flintparticles.twod.zones.Zone2D;

/**
 * The Jet Action applies an acceleration to particles only if they are in 
 * the specified zone. 
 */

class Jet extends ActionBase
{
	public var x(xGetter,xSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var zone(zoneGetter,zoneSetter):Zone2D;
	public var invertZone(invertZoneGetter, invertZoneSetter):Bool;
	
	private var _x:Float;
	private var _y:Float;
	private var _zone:Zone2D;
	private var _invert:Bool;
	
	/**
	 * The constructor creates a Jet action for use by an emitter. 
	 * To add a Jet to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param accelerationX The x component of the acceleration to apply, in 
	 * pixels per second per second.
	 * @param accelerationY The y component of the acceleration to apply, in 
	 * pixels per second per second.
	 * @param zone The zone in which to apply the acceleration.
	 * @param invertZone If false (the default) the acceleration is applied 
	 * only to particles inside the zone. If true the acceleration is applied 
	 * only to particles outside the zone.
	 */
	public function new( accelerationX:Float = 0, accelerationY:Float = 0, zone:Zone2D = null, invertZone:Bool = false )
	{
		super();
		this.x = accelerationX;
		this.y = accelerationY;
		this.zone = zone;
		this.invertZone = invertZone;
	}
	
	/**
	 * The x component of the acceleration to apply, in 
	 * pixels per second per second.
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
	 * The y component of the acceleration to apply, in 
	 * pixels per second per second.
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
	 * The zone in which to apply the acceleration.
	 */
	private function zoneGetter():Zone2D
	{
		return _zone;
	}
	private function zoneSetter( value:Zone2D ):Zone2D
	{
		_zone = value;
		return _zone;
	}
	
	/**
	 * If false (the default) the acceleration is applied 
	 * only to particles inside the zone. If true the acceleration is applied 
	 * only to particles outside the zone.
	 */
	private function invertZoneGetter():Bool
	{
		return _invert;
	}
	private function invertZoneSetter( value:Bool ):Bool
	{
		_invert = value;
		return _invert;
	}
	
	/**
	 * Checks if the particle is inside the zone and, if so, applies the 
	 * acceleration to the particle for the period of time indicated.
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
		if( _zone.contains( p.x, p.y ) )
		{
			if( !_invert )
			{
				p.velX += _x * time;
				p.velY += _y * time;
			}
		}
		else
		{
			if( _invert )
			{
				p.velX += _x * time;
				p.velY += _y * time;
			}
		}
	}
}
