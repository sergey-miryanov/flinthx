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
import org.flintparticles.common.events.ParticleEvent;
import org.flintparticles.twod.particles.Particle2D;
import org.flintparticles.twod.zones.Zone2D;


/**
 * The CollisionZone action detects collisions between particles and a zone, 
 * modifying the particles' velocities in response to the collision. All 
 * particles are approximated to a circular shape for the collisions.
 * 
 * <p>This action has a priority of -30, so that it executes after most other 
 * actions.</p>
 */

class CollisionZone extends ActionBase
{
	public var zone(zoneGetter,zoneSetter):Zone2D;
	public var bounce(bounceGetter, bounceSetter):Float;
	
	private var _bounce:Float;
	private var _zone:Zone2D;
	
	/**
	 * The constructor creates a CollisionZone action for use by  an emitter.
	 * To add a CollisionZone to all particles managed by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param zone The zone that the particles should collide with.
	 * @param bounce The coefficient of restitution when the particles collide. 
	 * A value of 1 gives a pure elastic collision, with no energy loss. A 
	 * value between 0 and 1 causes the particles to loose enegy in the 
	 * collision. A value greater than 1 causes the particle to gain energy 
	 * in the collision.
	 */
	public function new( zone:Zone2D = null, bounce:Float = 1 )
	{
		super();
		priority = -30;
		this.bounce = bounce;
		this.zone = zone;
	}

	/**
	 * The zone that the particles should collide with.
	 */
	public function zoneGetter():Zone2D
	{
		return _zone;
	}
	public function zoneSetter( value:Zone2D ):Zone2D
	{
		_zone = value;
		return _zone;
	}
	
	/**
	 * The coefficient of restitution when the particles collide. A value of 
	 * 1 gives a pure elastic collision, with no energy loss. A value
	 * between 0 and 1 causes the particles to loose enegy in the collision. 
	 * A value greater than 1 causes the particles to gain energy in the collision.
	 */
	public function bounceGetter():Float
	{
		return _bounce;
	}
	public function bounceSetter( value:Float ):Float
	{
		_bounce = value;
		return _bounce;
	}

	/**
	 * Checks for collisions between the particle and the zone.
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
		var collide:Bool = _zone.collideParticle( cast( particle,Particle2D ), _bounce );
		if( collide && emitter.hasEventListener( ParticleEvent.ZONE_COLLISION ) )
		{
			var ev:ParticleEvent = new ParticleEvent( ParticleEvent.ZONE_COLLISION, particle );
			ev.otherObject = _zone;
			emitter.dispatchEvent( ev );
		}
	}
}
