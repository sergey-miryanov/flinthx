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

package org.flintparticles.twoD.actions;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twoD.particles.Particle2D;

/**
 * The WrapAroundBox action confines all the particles to a rectangle region. If a
 * particle leaves the rectangle on one side it reenters on the other.
 * 
 * This action has a priority of -20, so that it executes after 
 * all movement has occured.
 */
class WrapAroundBox extends ActionBase
{
	public var top(topGetter,topSetter):Float;
	public var right(rightGetter,rightSetter):Float;
	public var left(leftGetter,leftSetter):Float;
	public var bottom(bottomGetter, bottomSetter):Float;
	
	private var _left : Float;
	private var _top : Float;
	private var _right : Float;
	private var _bottom : Float;
	private var _width : Float;
	private var _height : Float;

	/**
	 * The constructor creates a WrapAroundBox action for use by 
	 * an emitter. To add a WrapAroundBox to all particles created by an emitter, 
	 * use the emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param left The left coordinate of the box.
	 * @param top The top coordinate of the box.
	 * @param right The right coordinate of the box.
	 * @param bottom The bottom coordinate of the box.
	 */
	public function new( left:Float = 0, top:Float = 0, right:Float = 0, bottom:Float = 0 )
	{
		super();
		priority = -20;
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
	}

	/**
	 * The left coordinate of the box.
	 */
	public function leftGetter():Float
	{
		return _left;
	}
	public function leftSetter( value:Float ):Float
	{
		_left = value;
		_width = _right - _left;
		return _left;
	}

	/**
	 * The top coordinate of the box.
	 */
	public function topGetter():Float
	{
		return _top;
	}
	public function topSetter( value:Float ):Float
	{
		_top = value;
		_height = _bottom - _top;
		return _top;
	}

	/**
	 * The left coordinate of the box.
	 */
	public function rightGetter():Float
	{
		return _right;
	}
	public function rightSetter( value:Float ):Float
	{
		_right = value;
		_width = _right - _left;
		return _right;
	}

	/**
	 * The left coordinate of the box.
	 */
	public function bottomGetter():Float
	{
		return _bottom;
	}
	public function bottomSetter( value:Float ):Float
	{
		_bottom = value;
		_height = _bottom - _top;
		return _bottom;
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
		var p:Particle2D = cast( particle,Particle2D );
		if ( p.velX > 0 && p.x >= _right )
		{
			p.x -= _width;
		}
		else if ( p.velX < 0 && p.x <= _left )
		{
			p.x += _width;
		}
		if ( p.velY > 0 && p.y >= _bottom )
		{
			p.y -= _height;
		}
		else if ( p.velY < 0 && p.y <= _top )
		{
			p.y += _height;
		}
	}
}
