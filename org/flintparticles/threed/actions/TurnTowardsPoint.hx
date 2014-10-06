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

package org.flintparticles.threed.actions;

import flash.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threed.geom.Vector3DUtils;
import org.flintparticles.threed.particles.Particle3D;


/**
 * The TurnTowardsPoint action causes the particle to constantly adjust its direction
 * so that it travels towards a particular point.
 */
class TurnTowardsPoint extends ActionBase
{
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var z(get, set):Float;
	public var power(get, set):Float;
	public var point(get, set):Vector3D;
	
	private var _point:Vector3D;
	private var _power:Float;
	private var _velDirection:Vector3D;
	private var _toTarget:Vector3D;
	
	/**
	 * The constructor creates a TurnTowardsPoint action for use by 
	 * an emitter. To add a TurnTowardsPoint to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param power The strength of the turn action. Higher values produce a sharper turn.
	 * @param point The point towards which the particle turns.
	 */
	public function new( point:Vector3D = null, power:Float = 0 )
	{
		super();
		_velDirection = new Vector3D();
		_toTarget = new Vector3D();
		this.power = power;
		this.point = point != null ? point : new Vector3D();
	}
	
	/**
	 * The strength of theturn action. Higher values produce a sharper turn.
	 */
	private function get_power():Float
	{
		return _power;
	}
	private function set_power( value:Float ):Float
	{
		_power = value;
		return value;
	}
	
	/**
	 * The point that the particle turns towards.
	 */
	private function get_point():Vector3D
	{
		return _point;
	}
	private function set_point( value:Vector3D ):Vector3D
	{
		_point = Vector3DUtils.clonePoint( value );
		return _point;
	}
	
	/**
	 * The x coordinate of the point that the particle turns towards.
	 */
	private function get_x():Float
	{
		return _point.x;
	}
	private function set_x( value:Float ):Float
	{
		_point.x = value;
		return value;
	}
	
	/**
	 * The y coordinate of  the point that the particle turns towards.
	 */
	private function get_y():Float
	{
		return _point.y;
	}
	private function set_y( value:Float ):Float
	{
		_point.y = value;
		return value;
	}
	
	/**
	 * The z coordinate of the point that the particle turns towards.
	 */
	private function get_z():Float
	{
		return _point.z;
	}
	private function set_z( value:Float ):Float
	{
		_point.z = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		
		var pos:Vector3D = p.position;
		_toTarget.x = _point.x - pos.x;
		_toTarget.y = _point.y - pos.y;
		_toTarget.z = _point.z - pos.z;
		
		if( _toTarget.x == 0 &&  _toTarget.y == 0  && _toTarget.z == 0 )
		{
			return;
		}
		_toTarget.normalize();
		
		var vel:Vector3D = p.velocity;
		var velLength:Float = vel.length;
		
		_velDirection.x = vel.x / velLength;
		_velDirection.y = vel.y / velLength;
		_velDirection.z = vel.z / velLength;
		
		var acc:Float = power * time;
		_velDirection.scaleBy( _toTarget.dotProduct( _velDirection ) );
		_toTarget.decrementBy( _velDirection );
		_toTarget.scaleBy( acc / _toTarget.length );
		p.velocity.incrementBy( _toTarget );
		p.velocity.scaleBy( velLength / p.velocity.length );
	}
}
