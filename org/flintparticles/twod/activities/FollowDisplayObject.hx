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
import nme.geom.Point;
import org.flintparticles.common.activities.ActivityBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.utils.DisplayObjectUtils;
import org.flintparticles.twoD.emitters.Emitter2D;

/**
 * The FollowDisplayObject activity causes the emitter to follow
 * the position and rotation of a DisplayObject. The purpose is for the emitter
 * to emit particles from the location of the DisplayObject.
 */
class FollowDisplayObject extends ActivityBase
{
	public var renderer(rendererGetter,rendererSetter):DisplayObject;
	public var displayObject(displayObjectGetter, displayObjectSetter):DisplayObject;
	
	private var _renderer:DisplayObject;
	private var _displayObject:DisplayObject;
	
	/**
	 * The constructor creates a FollowDisplayObject activity for use by 
	 * an emitter. To add a FollowDisplayObject to an emitter, use the
	 * emitter's addActvity method.
	 * 
	 * @param renderer The display object whose coordinate system the DisplayObject's position is 
	 * converted to. This is usually the renderer for the particle system created by the emitter.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addActivity()
	 */
	public function new( displayObject:DisplayObject = null, renderer:DisplayObject = null )
	{
		super();
		this.displayObject = displayObject;
		this.renderer = renderer;
	}
	
	/**
	 * The DisplayObject whose coordinate system the DisplayObject's position is converted to. This
	 * is usually the renderer for the particle system created by the emitter.
	 */
	public function rendererGetter():DisplayObject
	{
		return _renderer;
	}
	public function rendererSetter( value:DisplayObject ):DisplayObject
	{
		_renderer = value;
		return _renderer;
	}
	
	/**
	 * The display object that the emitter follows.
	 */
	public function displayObjectGetter():DisplayObject
	{
		return _displayObject;
	}
	public function displayObjectSetter( value:DisplayObject ):DisplayObject
	{
		_displayObject = value;
		return _displayObject;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function update( emitter : Emitter, time : Float ) : Void
	{
		var e:Emitter2D = cast( emitter,Emitter2D );
		var p:Point = new Point( 0, 0 );
		p = _displayObject.localToGlobal( p );
		p = _renderer.globalToLocal( p );
		var r:Float = 0;
		r = DisplayObjectUtils.localToGlobalRotation( _displayObject, r );
		r = DisplayObjectUtils.globalToLocalRotation( _renderer, r );
		e.x = p.x;
		e.y = p.y;
		e.rotation = r;
	}
}
