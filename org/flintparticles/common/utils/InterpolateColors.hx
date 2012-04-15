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

package org.flintparticles.common.utils;
/**
 * This function is used to find a color between two other colors.
 * 
 * @param color1 The first color.
 * @param color2 The second color.
 * @param ratio The proportion of the first color to use. The rest of the color 
 * is made from the second color.
 * @return The color created.
 */
class InterpolateColors
{
	
	public static function interpolate ( color1:Int, color2:Int, ratio:Float ):Int
	{
		var inv:Float = 1 - ratio;
		var red:Int = Math.round( ( ( color1 >>> 16 ) & 255 ) * ratio + ( ( color2 >>> 16 ) & 255 ) * inv );
		var green:Int = Math.round( ( ( color1 >>> 8 ) & 255 ) * ratio + ( ( color2 >>> 8 ) & 255 ) * inv );
		var blue:Int = Math.round( ( ( color1 ) & 255 ) * ratio + ( ( color2 ) & 255 ) * inv );
		var alpha:Int = Math.round( ( ( color1 >>> 24 ) & 255 ) * ratio + ( ( color2 >>> 24 ) & 255 ) * inv );
		return ( alpha << 24 ) | ( red << 16 ) | ( green << 8 ) | blue;
	}
	
}
