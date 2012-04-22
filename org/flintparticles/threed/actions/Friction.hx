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

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.threeD.particles.Particle3D;

/**
 * The Friction action applies friction to the particle to slow it down when it's moving.
 * The frictional force is constant, irrespective of how fast the particle is moving.
 * For forces proportional to the particle's velocity, use one of the drag effects -
 * LinearDrag and QuadraticDrag.
 * 
 * @see LinearDrag
 * @see QuadraticDrag
 */

class Friction extends ActionBase
{
	public var friction(frictionGetter,frictionSetter):Float;
	
	private var _friction:Float;
	
	/**
	 * The constructor creates a Friction action for use by 
	 * an emitter. To add a Friction to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param friction The amount of friction. A higher number produces a stronger frictional force.
	 */
	public function new( friction:Float = 0 )
	{
		super();
		this.friction = friction;
	}
	
	/**
	 * The amount of friction. A higher number produces a stronger frictional force.
	 */
	private function frictionGetter():Float
	{
		return _friction;
	}
	private function frictionSetter( value:Float ):Float
	{
		_friction = value;
		return _friction;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		var len2:Float = p.velocity.lengthSquared;
		if( len2 == 0 )
		{
			return;
		}
		var scale:Float = 1 - ( _friction * time ) / ( Math.sqrt( len2 ) * p.mass );
		if( scale < 0 )
		{
			p.velocity.x = 0;
			p.velocity.y = 0;
			p.velocity.z = 0;
		}
		else
		{
			p.velocity.scaleBy( scale );
		}
	}
}
