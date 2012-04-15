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

package org.flintparticles.twoD.activities;

import nme.display.DisplayObject;
import org.flintparticles.common.activities.ActivityBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twoD.emitters.Emitter2D;


/**
 * The FollowMouse activity causes the emitter to follow
 * the position of the mouse pointer. The effect is for
 * it to emit particles from the mouse pointer location.
 */
class FollowMouse extends ActivityBase
{
	public var renderer(rendererGetter, rendererSetter):DisplayObject;
	
	private var _renderer:DisplayObject;
	
	/**
	 * The constructor creates a FollowMouse activity for use by 
	 * an emitter. To add a FollowMouse to an emitter, use the
	 * emitter's addActvity method.
	 * 
	 * @param renderer The display object whose coordinate system the mouse position is 
	 * converted to. This is usually the renderer for the particle system created by the emitter.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addActivity()
	 */
	public function new( renderer:DisplayObject = null )
	{
		super();
		this.renderer = renderer;
	}
	
	/**
	 * The display object whose coordinate system the mouse position is converted to. This
	 * is usually the renderer for the particle system created by the emitter.
	 */
	private function rendererGetter():DisplayObject
	{
		return _renderer;
	}
	private function rendererSetter( value:DisplayObject ):DisplayObject
	{
		_renderer = value;
		return _renderer;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter : Emitter, time : Float ) : Void
	{
		var e:Emitter2D = cast( emitter,Emitter2D );
		e.x = _renderer.mouseX;
		e.y = _renderer.mouseY;
	}
}
