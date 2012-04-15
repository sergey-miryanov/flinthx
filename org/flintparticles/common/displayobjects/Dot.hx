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

package org.flintparticles.common.displayObjects;

import nme.display.Shape;
import nme.display.BlendMode;

/**
 * The Dot class is a DisplayObject with a circle shape. The registration point
 * of this diaplay object is in the center of the Dot.
 */

class Dot extends Shape 
{
	public var radius(radiusGetter,radiusSetter):Float;
	public var color(colorGetter, colorSetter):Int;
	
	private var _radius:Float;
	private var _color:Int;
	
	/**
	 * The constructor creates a Dot with a specified radius.
	 * @param radius The radius, in pixels, of the Dot.
	 * @param color The color of the Dot.
	 * @param bm The blendMode for the Dot.
	 */
	public function new( radius:Float = 1, color:Int = 0xFFFFFF, bm:Dynamic = null )
	{
		super();
		_radius = radius;
		_color = color;
		draw();
		if (bm == null) bm = BlendMode.NORMAL;
		blendMode = bm;
	}
	
	private function draw():Void
	{
		graphics.clear();
		graphics.beginFill( _color );
		graphics.drawCircle( 0, 0, _radius );
		graphics.endFill();
	}
	
	private function radiusGetter():Float
	{
		return _radius;
	}
	private function radiusSetter( value:Float ):Float
	{
		_radius = value;
		draw();
		return _radius;
	}
	
	private function colorGetter():Int
	{
		return _color;
	}
	private function colorSetter( value:Int ):Int
	{
		_color = value;
		draw();
		return _color;
	}
}