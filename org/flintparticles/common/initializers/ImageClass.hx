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

package org.flintparticles.common.initializers;

import org.flintparticles.common.initializers.ImageInitializerBase;
import org.flintparticles.common.initializers.ImageClass;

/**
 * The ImageClass Initializer sets the DisplayObject to use to draw
 * the particle. It is used with the DisplayObjectRenderer. When using the
 * BitmapRenderer it is more efficient to use the SharedImage Initializer.
 * 
 * <p>This class includes an object pool for reusing DisplayObjects when particles die.</p>
 * 
 * <p>To enable use of the object pool, it was necessary to alter the constructor so the 
 * parameters for the image class are passed as an array rather than as plain values.</p>
 */
class ImageClass extends ImageInitializerBase
{
	public var imageClass(imageClassGetter,imageClassSetter):Dynamic;
	public var parameters(parametersGetter, parametersSetter):Array<Dynamic>;
	
	private var _imageClass:Dynamic;
	private var _parameters:Array<Dynamic>;
	
	/**
	 * The constructor creates an ImageClass initializer for use by 
	 * an emitter. To add an ImageClass to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * @param imageClass The class to use when creating
	 * the particles' DisplayObjects.
	 * @param parameters The parameters to pass to the constructor
	 * for the image class.
	 * @param usePool Indicates whether particles should be reused when a particle dies.
	 * @param fillPool Indicates how many particles to create immediately in the pool, to
	 * avoid creating them when the particle effect is running.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( imageClass:Dynamic = null, parameters : Array<Dynamic> = null, usePool:Bool = false, fillPool:Int = 0 )
	{
		super( usePool );
		_imageClass = imageClass;
		_parameters = parameters != null ? parameters : [];
		if( fillPool > 0 )
		{
			this.fillPool( fillPool );
		}
		
	}
	
	/**
	 * The class to use when creating
	 * the particles' DisplayObjects.
	 */
	private function imageClassGetter():Dynamic
	{
		return _imageClass;
	}
	private function imageClassSetter( value:Dynamic ):Dynamic
	{
		_imageClass = value;
		if( _usePool )
		{
			clearPool();
		}
		return _imageClass;
	}
	
	/**
	 * The parameters to pass to the constructor
	 * for the image class.
	 */
	private function parametersGetter():Array<Dynamic>
	{
		return _parameters;
	}
	private function parametersSetter( value:Array<Dynamic> ):Array<Dynamic>
	{
		_parameters = value;
		if( _usePool )
		{
			clearPool();
		}
		return _parameters;
	}
	
	/**
	 * Used internally, this method creates an image object for displaying the particle 
	 * by calling the image class constructor with the supplied parameters.
	 */
	override public function createImage() : Dynamic
	{
		//return construct( _imageClass, _parameters );
		return Type.createInstance( _imageClass, _parameters );
	}
}
