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
 * The TweenPosition action adjusts the particle's position between two
 * locations as it ages. This action
 * should be used in conjunction with the Age action.
 */

class TweenPosition extends ActionBase
{
	public var end(endGetter,endSetter):Vector3D;
	public var start(startGetter,startSetter):Vector3D;
	
	private var _start:Vector3D;
	private var _end:Vector3D;
	private var _diff:Vector3D;
	
	/**
	 * The constructor creates a TweenPosition action for use by 
	 * an emitter. To add a TweenPosition to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param startX The x value for the particle at the
	 * start of its life.
	 * @param startY The y value for the particle at the
	 * start of its life.
	 * @param endX The x value of the particle at the end of its
	 * life.
	 * @param endY The y value of the particle at the end of its
	 * life.
	 */
	public function new( start:Vector3D = null, end:Vector3D = null )
	{
		super();
		this.start = start != null ? start : new Vector3D();
		this.end = end != null ? end : new Vector3D();
	}
	
	/**
	 * The x position for the particle at the start of its life.
	 */
	private function startGetter():Vector3D
	{
		return _start;
	}
	private function startSetter( value:Vector3D ):Vector3D
	{
		_start = Vector3DUtils.clonePoint( value );
		if( _end != null )
		{
			_diff = _start.subtract( _end );
		}
		return _start;
	}
	
	/**
	 * The X value for the particle at the end of its life.
	 */
	private function endGetter():Vector3D
	{
		return _end;
	}
	private function endSetter( value:Vector3D ):Vector3D
	{
		_end = Vector3DUtils.clonePoint( value );
		if( _start != null )
		{
			_diff = _start.subtract( _end );
		}
		return _end;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Vector3D = cast( particle, Particle3D ).position;
		var r:Float = particle.energy;
		p.x = _diff.x * r + _end.x;
		p.y = _diff.y * r + _end.y;
		p.z = _diff.z * r + _end.z;
	}
}
