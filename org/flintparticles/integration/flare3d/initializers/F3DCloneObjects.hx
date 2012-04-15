/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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

package org.flintparticles.integration.flare3d.initializers;
	import org.flintparticles.common.utils.WeightedArray;
	import org.flintparticles.integration.flare3d.initializers.F3DCloneObjects;
	import org.flintparticles.common.initializers.ImageInitializerBase;

	
	/**
	 * The A3D4CloneObjects Initializer sets the 3D Object to use 
	 * to draw the particle in a 3D scene. It selects one of multiple objects 
	 * that are passed to it and calls the clone method of the object to create
	 * the particle object. It is used with the Flare3D renderer when
	 * particles should be represented by a 3D object.
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 * 
	 * @see org.flintparticles.common.Initializers.SetImageProperties
	 */
	class F3DCloneObjects extends ImageInitializerBase
	{
		private var _objects:WeightedArray;
		
		/**
		 * The constructor creates an A3D4CloneObjects initializer for use by 
		 * an emitter. To add an A3D4CloneObjects to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param objects An array containing the Pivot3D objects to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each Pivot3D object. If no weighting
		 * values are passed, the images are used with equal probability.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function new( objects:Array<Dynamic> = null, weights:Array<Dynamic> = null, usePool:Bool = false, fillPool:uint = 0 )
		{
			super( usePool );
			_objects = new WeightedArray();
			if( objects == null )
			{
				return;
			}
			var len:Int = objects.length;
			var i:Int;
			if( weights != null && weights.length == len )
			{
				for (i in 0...len) 
				{
					_objects.add( objects[i], weights[i] );
				}
			}
			else
			{
				for (i in 0...len) 
				{
					_objects.add( objects[i], 1 );
				}
			}
			if( fillPool > 0 )
			{
				this.fillPool( fillPool );
			}
		}
		
		public function addObject( object:Pivot3D, weight:Float = 1 ):Void
		{
			_objects.add( object, weight );
			if( _usePool )
			{
				clearPool();
			}
		}
		
		public function removeObject( object:Pivot3D ):Void
		{
			_objects.remove( object );
			if( _usePool )
			{
				clearPool();
			}
		}
		
		/**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by cloning one of the original Object3D objects.
		 */
		override public function createImage():Object
		{
			return Pivot3D( _objects.getRandomValue() ).clone();
		}
	}
