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

import nme.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threeD.geom.Vector3DUtils;
import org.flintparticles.threeD.particles.Particle3D;
import org.flintparticles.threeD.zones.Zone3D;


/**
 * The Jet Action applies an acceleration to the particle only if it is in the specified zone. 
 */

class Jet extends ActionBase
{
	public var x(xGetter,xSetter):Float;
	public var zone(zoneGetter,zoneSetter):Zone3D;
	public var y(yGetter,ySetter):Float;
	public var z(zGetter,zSetter):Float;
	public var invertZone(invertZoneGetter,invertZoneSetter):Bool;
	public var acceleration(accelerationGetter,accelerationSetter):Vector3D;
	
	private var _acc:Vector3D;
	private var _zone:Zone3D;
	private var _invert:Bool;
	
	/**
	 * The constructor creates a Jet action for use by 
	 * an emitter. To add a Jet to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param accelerationX The x coordinate of the acceleration to apply, in pixels 
	 * per second per second.
	 * @param accelerationY The y coordinate of the acceleration to apply, in pixels 
	 * per second per second.
	 * @param zone The zone in which to apply the acceleration.
	 * @param invertZone If false (the default) the acceleration is applied only to particles inside 
	 * the zone. If true the acceleration is applied only to particles outside the zone.
	 */
	public function new( acceleration:Vector3D = null, zone:Zone3D = null, invertZone:Bool = false )
	{
		super();
		this.acceleration = acceleration != null ? acceleration : new Vector3D();
		this.zone = zone;
		this.invertZone = invertZone;
	}
	
	/**
	 * The acceleration, in coordinate units per second per second.
	 */
	private function accelerationGetter():Vector3D
	{
		return _acc;
	}
	private function accelerationSetter( value:Vector3D ):Vector3D
	{
		_acc = Vector3DUtils.cloneVector( value );
		return _acc;
	}
	
	/**
	 * The zone in which to apply the acceleration.
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
	 * If true, the zone is treated as the safe area and being ouside the zone
	 * results in the particle dying. Otherwise, being inside the zone causes the
	 * particle to die.
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
	 * The x coordinate of the acceleration, in coordinate units per second per second.
	 */
	private function xGetter():Float
	{
		return _acc.x;
	}
	private function xSetter( value:Float ):Float
	{
		_acc.x = value;
		return value;
	}
	
	/**
	 * The y coordinate of the acceleration, in coordinate units per second per second.
	 */
	private function yGetter():Float
	{
		return _acc.y;
	}
	private function ySetter( value:Float ):Float
	{
		_acc.y = value;
		return value;
	}
	
	/**
	 * The z coordinate of the acceleration, in coordinate units per second per second.
	 */
	private function zGetter():Float
	{
		return _acc.z;
	}
	private function zSetter( value:Float ):Float
	{
		_acc.z = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		var v:Vector3D = p.velocity;
		if( _zone.contains( p.position ) )
		{
			if( !_invert )
			{
				v.x += _acc.x * time;
				v.y += _acc.y * time;
				v.z += _acc.z * time;
			}
		}
		else
		{
			if( _invert )
			{
				v.x += _acc.x * time;
				v.y += _acc.y * time;
				v.z += _acc.z * time;
			}
		}
	}
}
