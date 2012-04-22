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

package org.flintparticles.threed.initializers;

import nme.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.threed.emitters.Emitter3D;
import org.flintparticles.threed.geom.Quaternion;
import org.flintparticles.threed.particles.Particle3D;
import org.flintparticles.threed.zones.Zone3D;

/**
 * The ColorInit Initializer sets the velocity of the particle. It is
 * usually combined with the Move action to move the particle
 * using this velocity.
 * 
 * <p>The initial velocity is defined using a zone from the 
 * org.flintparticles.threeD.zones package. The use of zones enables diverse 
 * ranges of velocities. For example, to use a specific velocity,
 * a Point zone can be used. To use a varied speed in a specific
 * direction, a LineZone zone can be used. For a fixed speed in
 * a varied direction, a Disc or DiscSector zone with identical
 * inner and outer radius can be used. A Disc or DiscSector with
 * different inner and outer radius produces a range of speeds
 * in a range of directions.</p>
 */

class Velocity extends InitializerBase
{
	public var zone(zoneGetter,zoneSetter):Zone3D;
	
	private var _zone:Zone3D;

	/**
	 * The constructor creates a Velocity initializer for use by 
	 * an emitter. To add a Velocity to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * @param velocity The zone to use for creating the velocity.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( zone:Zone3D = null )
	{
		super();
		this.zone = zone;
	}
	
	/**
	 * The zone.
	 */
	private function zoneGetter():Zone3D
	{
		return _zone;
	}
	private function zoneSetter( value:Zone3D ):Zone3D
	{
		_zone = value;
		return _zone;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter:Emitter, particle:Particle ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		var e:Emitter3D = cast( emitter, Emitter3D );
		var v:Vector3D = zone.getLocation();
		//if( !e.rotation.equals( Quaternion.IDENTITY ) )
		if( !e.rotation.equals( new Quaternion().IDENTITY ) )
		{
			v = e.rotationTransform.transformVector( v );
		}
		p.velocity = v;
	}
}
