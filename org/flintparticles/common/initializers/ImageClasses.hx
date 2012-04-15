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

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.utils.WeightedArray;
import org.flintparticles.common.initializers.ImageInitializerBase;
import org.flintparticles.common.initializers.ImageClasses;

/**
 * The ImageClasses Initializer sets the DisplayObject to use to draw
 * the particle. It selects one of multiple images that are passed to it.
 * It is used with the DisplayObjectRenderer. When using the
 * BitmapRenderer it is more efficient to use the SharedImage Initializer.
 * 
 * <p>This class includes an object pool for reusing DisplayObjects when particles die.</p>
 */
class ImageClasses extends ImageInitializerBase
{
	private var _images:WeightedArray;
	private var _mxmlImages:Array<Dynamic>;
	private var _mxmlWeights:Array<Dynamic>;
	
	/**
	 * The constructor creates a ImageClasses initializer for use by 
	 * an emitter. To add a ImageClasses to all particles created by 
	 * an emitter, use the emitter's addInitializer method.
	 * 
	 * @param images An array containing the classes to use for 
	 * each particle created by the emitter. Each item in the array may be a class or an array 
	 * containing a class and a number of parameters to pass to the constructor.
	 * @param weights The weighting to apply to each displayObject. If no weighting
	 * values are passed, the images are used with equal probability.
	 * @param usePool Indicates whether particles should be reused when a particle dies.
	 * @param fillPool Indicates how many particles to create immediately in the pool, to
	 * avoid creating them when the particle effect is running.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( images:Array<Dynamic> = null, weights:Array<Dynamic> = null, usePool:Bool = false, fillPool:Int = 0 )
	{
		super( usePool );
		_images = new WeightedArray();
		if( images == null )
		{
			return;
		}
		init( images, weights );
		if( fillPool > 0 )
		{
			this.fillPool( fillPool );
		}
		
	}
	
	override public function addedToEmitter( emitter:Emitter ):Void
	{
		super.addedToEmitter( emitter );
		if( _mxmlImages != null )
		{
			init( _mxmlImages, _mxmlWeights );
			_mxmlImages = null;
			_mxmlWeights = null;
		}
	}
	
	private function init( images:Array<Dynamic> = null, weights:Array<Dynamic> = null ):Void
	{
		_images.clear();
		var len:Int = images.length;
		var i:Int;
		if( weights != null && weights.length == len )
		{
			for (i in 0...len) 
			{
				addImage( images[i], weights[i] );
			}
		}
		else
		{
			for (i in 0...len) 
			{
				addImage( images[i], 1 );
			}
		}
	}
	
	public function addImage( image:Dynamic, weight:Float = 1 ):Void
	{
		if( Std.is(image, Array) )
		{
			/**
			 * TODO: used to get a clone of the array?
			 */
			//var parameters:Array<Dynamic> = cast( image, Array<Dynamic> ).concat();
			var parameters:Array<Dynamic> = cast( image, Array<Dynamic> ).concat(null);
			var img:Dynamic = parameters.shift();
			_images.add( new Pair( img, parameters ), weight );
		}
		else
		{
			_images.add( new Pair( image, [] ), weight );
		}
		if( _usePool )
		{
			clearPool();
		}
	}
	
	public function removeImage( image:Dynamic ):Void
	{
		_images.remove( image );
		if( _usePool )
		{
			clearPool();
		}
	}

	public function imagesSetter( value:Array<Dynamic> ):Void
	{
		_mxmlImages = value;
		checkStartValues();
		if( _usePool )
		{
			clearPool();
		}
	}
	
	public function weightsSetter( value:Array<Dynamic> ):Void
	{
		if( value.length == 1 && Std.is(value[0], String) )
		{
			_mxmlWeights = cast( value[0],String ).split( "," );
		}
		else
		{
			_mxmlWeights = value;
		}
		checkStartValues();
		if( _usePool )
		{
			clearPool();
		}
	}
	
	private function checkStartValues():Void
	{
		if( _mxmlImages != null && _mxmlWeights != null )
		{
			init( _mxmlImages, _mxmlWeights );
			_mxmlImages = null;
			_mxmlWeights = null;
		}
	}

	/**
	 * Used internally, this method creates an image object for displaying the particle 
	 * by calling the constructor of one of the supplied image classes.
	 */
	override public function createImage() : Dynamic
	{
		var img:Pair = _images.getRandomValue();
		/**
		 * TODO: check if this creates a new instance correctly
		 */
		return Type.createInstance(img.image, img.parameters);
		//return construct( img.image, img.parameters );
	}
}

class Pair
{
	public var image:Dynamic;
	public var parameters:Array<Dynamic>;

	public function new( image:Dynamic, parameters:Array<Dynamic> )
	{
		this.image = image;
		this.parameters = parameters;
	}
}
