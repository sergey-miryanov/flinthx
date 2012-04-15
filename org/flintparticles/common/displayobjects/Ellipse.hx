/*
* FLINT PARTICLE SYSTEM
* .....................
*
* Author: Xor (Adrian Stutz) for Nothing GmbH
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
 * The Ellipse class is a DisplayObject with a oval shape. The registration point
 * of this diaplay object is in the center of the Ellipse.
 */
class Ellipse extends Shape
{
	public var ellipseWidth(ellipseWidthGetter,ellipseWidthSetter):Float;
	public var ellipseHeight(ellipseHeightGetter,ellipseHeightSetter):Float;
	public var color(colorGetter, colorSetter):Int;
	
	private var _ellipseWidth:Float;
	private var _ellipseHeight:Float;
	private var _color:Int;

	/**
	 * The constructor creates a Dot with a specified radius.
	 * @param radius The radius, in pixels, of the Dot.
	 * @param color The color of the Dot.
	 * @param bm The blendMode for the Dot.
	 */
	public function new( width:Float = 1, height:Float = 1, color:Int = 0xFFFFFF, bm:Dynamic = null )
	{
		super();
		_ellipseWidth = width;
		_ellipseHeight = height;
		_color = color;
		draw();
		if (bm == null) bm = BlendMode.NORMAL;
		blendMode = bm;
	}

	private function draw():Void
	{
		if( _ellipseWidth > 0 && _ellipseHeight > 0 )
		{
			graphics.clear();
			graphics.beginFill( _color );
			graphics.drawEllipse( 0, 0, _ellipseWidth, _ellipseHeight );
			graphics.endFill();
		}
	}

	private function ellipseWidthGetter():Float
	{
		return _ellipseWidth;
	}
	private function ellipseWidthSetter( value:Float ):Float
	{
		_ellipseWidth = value;
		draw();
		return _ellipseWidth;
	}

	private function ellipseHeightGetter():Float
	{
		return _ellipseHeight;
	}
	private function ellipseHeightSetter( value:Float ):Float
	{
		_ellipseHeight = value;
		draw();
		return _ellipseHeight;
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
