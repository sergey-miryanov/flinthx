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

/**
 * The GravityWell action applies a force on the particle to draw it towards
 * a single point. The force applied is inversely proportional to the square
 * of the distance from the particle to the point.
 */

class GravityWell extends ActionBase
{
	public var x(xGetter,xSetter):Float;
	public var y(yGetter,ySetter):Float;
	public var z(zGetter,zSetter):Float;
	public var power(powerGetter,powerSetter):Float;
	public var epsilon(epsilonGetter,epsilonSetter):Float;
	public var position(positionGetter, positionSetter):Vector3D;
	
	private var _position:Vector3D;
	private var _power:Float;
	private var _epsilonSq:Float;
	private var _gravityConst:Float; // just scales the power to a more reasonable number
	
	/**
	 * The constructor creates a GravityWell action for use by 
	 * an emitter. To add a GravityWell to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param power The strength of the force - larger numbers produce a stringer force.
	 * @param position The point towards which the force draws the particles.
	 * @param epsilon The minimum distance for which gravity is calculated. Particles closer
	 * than this distance experience a gravity force as it they were this distance away.
	 * This stops the gravity effect blowing up as distances get small. For realistic gravity 
	 * effects you will want a small epsilon ( ~1 ), but for stable visual effects a larger
	 * epsilon (~100) is often better.
	 */
	public function new( power:Float = 0, position:Vector3D = null, epsilon:Float = 100 )
	{
		super();
		this.power = power;
		this.position = position != null ? position : new Vector3D();
		this.epsilon = epsilon;
		_gravityConst = 10000;
	}
	
	/**
	 * The strength of the gravity force.
	 */
	private function powerGetter():Float
	{
		return _power / _gravityConst;
	}
	private function powerSetter( value:Float ):Float
	{
		_power = value * _gravityConst;
		return value;
	}
	
	/**
	 * The x coordinate of the center of the gravity force.
	 */
	private function positionGetter():Vector3D
	{
		return _position;
	}
	private function positionSetter( value:Vector3D ):Vector3D
	{
		_position = Vector3DUtils.clonePoint( value );
		return value;
	}
	
	/**
	 * The x coordinate of the point that the force pulls the particles towards.
	 */
	private function xGetter():Float
	{
		return _position.x;
	}
	private function xSetter( value:Float ):Float
	{
		_position.x = value;
		return value;
	}
	
	/**
	 * The y coordinate of the point that the force pulls the particles towards.
	 */
	private function yGetter():Float
	{
		return _position.y;
	}
	private function ySetter( value:Float ):Float
	{
		_position.y = value;
		return value;
	}
	
	/**
	 * The z coordinate of the point that the force pulls the particles towards.
	 */
	private function zGetter():Float
	{
		return _position.z;
	}
	private function zSetter( value:Float ):Float
	{
		_position.z = value;
		return value;
	}
	
	/**
	 * The minimum distance for which the gravity force is calculated. 
	 * Particles closer than this distance experience the gravity as it they were 
	 * this distance away. This stops the gravity effect blowing up as distances get 
	 * small.
	 */
	private function epsilonGetter():Float
	{
		return Math.sqrt( _epsilonSq );
	}
	private function epsilonSetter( value:Float ):Float
	{
		_epsilonSq = value * value;
		return _epsilonSq;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		if( particle.mass == 0 )
		{
			return;
		}
		var p:Particle3D = cast( particle, Particle3D );
		var offset:Vector3D = _position.subtract( p.position );
		var dSq:Float = offset.lengthSquared;
		if( dSq == 0 )
		{
			return;
		}
		var d:Float = Math.sqrt( dSq );
		if( dSq < _epsilonSq ) dSq = _epsilonSq;
		var factor:Float = ( _power * time ) / ( dSq * d );
		offset.scaleBy( factor );
		p.velocity.incrementBy( offset );
	}
}
