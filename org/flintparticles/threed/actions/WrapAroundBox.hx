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
 * The WrapAroundBox action confines all the particles to a rectangle region. If a
 * particle leaves the rectangle on one side it reenters on the other.
 * 
 * This action has a priority of -20, so that it executes after 
 * all movement has occured.
 */
class WrapAroundBox extends ActionBase
{
	public var minY(minYGetter,minYSetter):Float;
	public var minX(minXGetter,minXSetter):Float;
	public var maxX(maxXGetter,maxXSetter):Float;
	public var maxY(maxYGetter,maxYSetter):Float;
	public var maxZ(maxZGetter,maxZSetter):Float;
	public var minZ(minZGetter,minZSetter):Float;
	
	private var _minX : Float;
	private var _maxX : Float;
	private var _minY : Float;
	private var _maxY : Float;
	private var _minZ : Float;
	private var _maxZ : Float;
	private var _width : Float;
	private var _height : Float;
	private var _depth : Float;

	/**
	 * The constructor creates a WrapAroundBox action for use by an emitter. 
	 * To add a WrapAroundBox to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param minX The minX coordinate of the box.
	 * @param maxX The maxX coordinate of the box.
	 * @param minY The minY coordinate of the box.
	 * @param maxY The maxY coordinate of the box.
	 * @param minZ The minZ coordinate of the box.
	 * @param maxZ The maxZ coordinate of the box.
	 */
	public function new( minX:Float = 0, maxX:Float = 0, minY:Float = 0, maxY:Float = 0, minZ:Float = 0, maxZ:Float = 0 )
	{
		super();
		priority = -20;
		this.minX = minX;
		this.maxX = maxX;
		this.minY = minY;
		this.maxY = maxY;
		this.minZ = minZ;
		this.maxZ = maxZ;
	}
	
	/**
	 * The minX coordinate of the box.
	 */
	private function minXGetter():Float
	{
		return _minX;
	}
	private function minXSetter( value:Float ):Float
	{
		_minX = value;
		_width = _maxX - _minX;
		return _minX;
	}

	/**
	 * The maxX coordinate of the box.
	 */
	private function maxXGetter():Float
	{
		return _maxX;
	}
	private function maxXSetter( value:Float ):Float
	{
		_maxX = value;
		_width = _maxX - _minX;
		return _maxX;
	}

	/**
	 * The minY coordinate of the box.
	 */
	private function minYGetter():Float
	{
		return _minY;
	}
	private function minYSetter( value:Float ):Float
	{
		_minY = value;
		_height = _maxY - _minY;
		return _minY;
	}

	/**
	 * The maxY coordinate of the box.
	 */
	private function maxYGetter():Float
	{
		return _maxY;
	}
	private function maxYSetter( value:Float ):Float
	{
		_maxY = value;
		_height = _maxY - _minY;
		return _maxY;
	}

	/**
	 * The minZ coordinate of the box.
	 */
	private function minZGetter():Float
	{
		return _minZ;
	}
	private function minZSetter( value:Float ):Float
	{
		_minZ = value;
		_depth = _maxZ - _minZ;
		return _minZ;
	}

	/**
	 * The maxZ coordinate of the box.
	 */
	private function maxZGetter():Float
	{
		return _maxZ;
	}
	private function maxZSetter( value:Float ):Float
	{
		_maxZ = value;
		_depth = _maxZ - _minZ;
		return _maxZ;
	}

	/**
	 * Tests whether the particle has left the box and, if so, moves it
	 * to enter on the other side.
	 * 
	 * <p>This method is called by the emitter and need not be called by the 
	 * user</p>
	 * 
	 * @param emitter The Emitter that created the particle.
	 * @param particle The particle to be updated.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Action#update()
	 */
	override public function update( emitter : Emitter, particle : Particle, time : Float ) : Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		if ( p.velocity.x > 0 && p.position.x >= _maxX )
		{
			p.position.x -= _width;
		}
		else if ( p.velocity.x < 0 && p.position.x <= _minX )
		{
			p.position.x += _width;
		}
		if ( p.velocity.y > 0 && p.position.y >= _maxY )
		{
			p.position.y -= _height;
		}
		else if ( p.velocity.y < 0 && p.position.y <= _minY )
		{
			p.position.y += _height;
		}
		if ( p.velocity.z > 0 && p.position.z >= _maxZ )
		{
			p.position.z -= _depth;
		}
		else if ( p.velocity.z < 0 && p.position.z <= _minZ )
		{
			p.position.z += _depth;
		}
	}
}
