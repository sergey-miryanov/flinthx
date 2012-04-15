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

package org.flintparticles.twoD.initializers;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.utils.WeightedArray;

/**
 * The ScaleAllsInit initializer sets the scale of the particles image
 * and adjusts its mass and collision radius accordingly. It selects 
 * one of multiple scales, using optional weighting values to produce an uneven
 * distribution for the scales.
 * 
 * <p>If you want to adjust only the image size use
 * the ScaleImageInit initializer.</p>
 * 
 * <p>This initializer has a priority of -10 to ensure it occurs after 
 * mass and radius assignment classes like CollisionRadiusInit and MassInit.</p>
 * 
 * @see org.flintparticles.common.initializers.ScaleImagesInit
 */

class ScaleAllsInit extends InitializerBase
{
	private var _scales:WeightedArray;
	private var _mxmlScales:Array<Dynamic>;
	private var _mxmlWeights:Array<Dynamic>;
	
	/**
	 * The constructor creates a ScaleAllsInit initializer for use by 
	 * an emitter. To add a ScaleAllsInit to all particles created by 
	 * an emitter, use the emitter's addInitializer method.
	 * 
	 * @param colors An array containing the scales to use for 
	 * each particle created by the emitter.
	 * @param weights The weighting to apply to each scale. If no weighting
	 * values are passed, the scales are all assigned a weighting of 1.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( scales:Array<Dynamic> = null, weights:Array<Dynamic> = null )
	{
		priority = -10;
		_scales = new WeightedArray();
		if( scales == null )
		{
			return;
		}
		init( scales, weights );
	}
	
	override public function addedToEmitter( emitter:Emitter ):Void
	{
		if( _mxmlScales )
		{
			init( _mxmlScales, _mxmlWeights );
			_mxmlScales = null;
			_mxmlWeights = null;
		}
	}
	
	private function init( scales:Array<Dynamic> = null, weights:Array<Dynamic> = null ):Void
	{
		_scales.clear();
		var len:Int = scales.length;
		var i:Int;
		if( weights != null && weights.length == len )
		{
			for (i in 0...len) 
			{
				_scales.add( scales[i], weights[i] );
			}
		}
		else
		{
			for (i in 0...len) 
			{
				_scales.add( scales[i], 1 );
			}
		}
	}
	
	public function addScale( scale:Float, weight:Float = 1 ):Void
	{
		_scales.add( scale, weight );
	}
	
	public function removeScale( scale:Float ):Void
	{
		_scales.remove( scale );
	}
	
	public function set scales( value:Array<Dynamic> ):Void
	{
		if( value.length == 1 && value[0] is String )
		{
			_mxmlScales = String( value[0] ).split( "," );
		}
		else
		{
			_mxmlScales = value;
		}
		checkStartValues();
	}
	
	public function set weights( value:Array<Dynamic> ):Void
	{
		if( value.length == 1 && value[0] is String )
		{
			_mxmlWeights = String( value[0] ).split( "," );
		}
		else
		{
			_mxmlWeights = value;
		}
		checkStartValues();
	}
	
	private function checkStartValues():Void
	{
		if( _mxmlScales && _mxmlWeights )
		{
			init( _mxmlScales, _mxmlWeights );
			_mxmlScales = null;
			_mxmlWeights = null;
		}
	}

	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter:Emitter, particle:Particle ):Void
	{
		var scale:Float = _scales.getRandomValue();
		particle.scale = scale;
		particle.mass *= scale * scale;
		particle.collisionRadius *= scale;
	}
}
