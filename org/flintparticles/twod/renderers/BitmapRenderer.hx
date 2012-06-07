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

package org.flintparticles.twoD.renderers;

import jota.utils.ArrayUtils;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.display.DisplayObject;
import nme.display.PixelSnapping;
import nme.filters.BitmapFilter;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import org.flintparticles.common.renderers.SpriteRendererBase;
import org.flintparticles.twoD.particles.Particle2D;


/**
 * The BitmapRenderer draws particles onto a single Bitmap display object. The
 * region of the particle system covered by this bitmap object must be defined
 * in the canvas property of the BitmapRenderer. Particles outside this region
 * are not drawn.
 * 
 * <p>The image to be used for each particle is the particle's image property.
 * This is a DisplayObject, but this DisplayObject is not used directly. Instead
 * it is copied into the bitmap with the various properties of the particle 
 * applied. Consequently each particle may be represented by the same 
 * DisplayObject instance and the SharedImage initializer can be used with this 
 * renderer.</p>
 * 
 * <p>The BitmapRenderer allows the use of BitmapFilters to modify the appearance
 * of the bitmap. Every frame, under normal circumstances, the Bitmap used to
 * display the particles is wiped clean before all the particles are redrawn.
 * However, if one or more filters are added to the renderer, the filters are
 * applied to the bitmap instead of wiping it clean. This enables various trail
 * effects by using blur and other filters. You can also disable the clearing
 * of the particles by setting the clearBetweenFrames property to false.</p>
 * 
 * <p>The BitmapRenderer has mouse events disabled for itself and any 
 * display objects in its display list. To enable mouse events for the renderer
 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
 */
class BitmapRenderer extends SpriteRendererBase
{
	public var clearBetweenFrames(clearBetweenFramesGetter,clearBetweenFramesSetter):Bool;
	public var preFilters(preFiltersGetter,preFiltersSetter):Array<Dynamic>;
	public var postFilters(postFiltersGetter,postFiltersSetter):Array<Dynamic>;
	public var canvas(canvasGetter,canvasSetter):Rectangle;
	public var smoothing(smoothingGetter,smoothingSetter):Bool;
	public var bitmapData(bitmapDataGetter, null):BitmapData;
	
	public static inline var ZERO_POINT:Point = new Point( 0, 0 );
	
	/**
	 * @private
	 */
	private var _bitmap:Bitmap;
	
	private var _bitmapData:BitmapData;
	/**
	 * @private
	 */
	private var _preFilters:Array<Dynamic>;
	/**
	 * @private
	 */
	private var _postFilters:Array<Dynamic>;
	/**
	 * @private
	 */
	private var _colorMap:Array<Dynamic>;
	/**
	 * @private
	 */
	private var _smoothing:Bool;
	/**
	 * @private
	 */
	private var _canvas:Rectangle;
	/**
	 * @private
	 */
	private var _clearBetweenFrames:Bool;

	/**
	 * The constructor creates a BitmapRenderer. After creation it should be
	 * added to the display list of a DisplayObjectContainer to place it on 
	 * the stage and should be applied to an Emitter using the Emitter's
	 * renderer property.
	 * 
	 * @param canvas The area within the renderer on which particles can be drawn.
	 * Particles outside this area will not be drawn.
	 * @param smoothing Whether to use smoothing when scaling the Bitmap and, if the
	 * particles are represented by bitmaps, when drawing the particles.
	 * Smoothing removes pixelation when images are scaled and rotated, but it
	 * takes longer so it may slow down your particle system.
	 * 
	 * @see org.flintparticles.twoD.emitters.Emitter#renderer
	 */
	public function new( canvas:Rectangle, smoothing:Bool = false )
	{
		super();
		mouseEnabled = false;
		mouseChildren = false;
		_smoothing = smoothing;
		_preFilters = new Array<Dynamic>();
		_postFilters = new Array<Dynamic>();
		_canvas = canvas;
		_clearBetweenFrames = true;
		createBitmap();
	}
	
	/**
	 * The addFilter method adds a BitmapFilter to the renderer. These filters
	 * are applied each frame, before or after the new particle positions are 
	 * drawn, instead of wiping the display clear. Use of a blur filter, for 
	 * example, will produce a trail behind each particle as the previous images
	 * blur and fade more each frame.
	 * 
	 * @param filter The filter to apply
	 * @param postRender If false, the filter is applied before drawing the particles
	 * in their new positions. If true the filter is applied after drawing the particles.
	 */
	public function addFilter( filter:BitmapFilter, postRender:Bool = false ):Void
	{
		if( postRender )
		{
			_postFilters.push( filter );
		}
		else
		{
			_preFilters.push( filter );
		}
	}
	
	/**
	 * Removes a BitmapFilter object from the Renderer.
	 * 
	 * @param filter The BitmapFilter to remove
	 * 
	 * @see addFilter()
	 */
	public function removeFilter( filter:BitmapFilter ):Void
	{
		//for( var i:Int = 0; i < _preFilters.length; ++i )
		for( i in 0 ... _preFilters.length )
		{
			if( _preFilters[i] == filter )
			{
				_preFilters.splice( i, 1 );
				return;
			}
		}
		//for( i = 0; i < _postFilters.length; ++i )
		for( i in 0 ... _postFilters.length )
		{
			if( _postFilters[i] == filter )
			{
				_postFilters.splice( i, 1 );
				return;
			}
		}
	}
	
	/**
	 * The array of all filters being applied before rendering.
	 */
	private function preFiltersGetter():Array<Dynamic>
	{
		/**
		 * TODO: check if clears array
		 */
		ArrayUtils.clear(_preFilters);
		return _preFilters;
	}
	private function preFiltersSetter( value:Array<Dynamic> ):Array<Dynamic>
	{
		var filter:BitmapFilter;
		for( filter in _preFilters.iterator() )
		{
			removeFilter( filter );
		}
		for( filter in value.iterator() )
		{
			addFilter( filter, false );
		}
		return _preFilters;
	}

	/**
	 * The array of all filters being applied before rendering.
	 */
	private function postFiltersGetter():Array<Dynamic>
	{
		/**
		 * TODO: check if clears array
		 */
		ArrayUtils.clear(_preFilters);
		return _postFilters;
	}
	private function postFiltersSetter( value:Array<Dynamic> ):Array<Dynamic>
	{
		var filter:BitmapFilter;
		for( filter in _postFilters.iterator() )
		{
			removeFilter( filter );
		}
		for( filter in value.iterator() )
		{
			addFilter( filter, true );
		}
		return _postFilters;
	}

	/**
	 * Sets a palette map for the renderer. See the paletteMap method in flash's BitmapData object for
	 * information about how palette maps work. The palette map will be applied to the full canvas of the 
	 * renderer after all filters have been applied and the particles have been drawn.
	 */
	public function setPaletteMap( red : Array<Dynamic> = null , green : Array<Dynamic> = null , blue : Array<Dynamic> = null, alpha : Array<Dynamic> = null ) : Void
	{
		_colorMap = new Array<Dynamic>();
		_colorMap[0] = alpha;
		_colorMap[1] = red;
		_colorMap[2] = green;
		_colorMap[3] = blue;
	}
	/**
	 * Clears any palette map that has been set for the renderer.
	 */
	public function clearPaletteMap() : Void
	{
		_colorMap = null;
	}
	
	/**
	 * Create the Bitmap and BitmapData objects
	 */
	private function createBitmap():Void
	{
		if( _canvas == null )
		{
			return;
		}
		if( _bitmap != null && _bitmapData != null )
		{
			_bitmapData.dispose();
			_bitmapData = null;
		}
		if( _bitmap != null )
		{
			removeChild( _bitmap );
			_bitmap = null;
		}
		_bitmapData = new BitmapData( Math.ceil( _canvas.width ), Math.ceil( _canvas.height ), true, 0 );
		_bitmap = new Bitmap( _bitmapData, PixelSnapping.AUTO, _smoothing);
		//_bitmap.bitmapData = _bitmapData;
		addChild( _bitmap );
		_bitmap.x = _canvas.x;
		_bitmap.y = _canvas.y;
	}
	
	/**
	 * The canvas is the area within the renderer on which particles can be drawn.
	 * Particles outside this area will not be drawn.
	 */
	private function canvasGetter():Rectangle
	{
		return _canvas;
	}
	private function canvasSetter( value:Rectangle ):Rectangle
	{
		_canvas = value;
		createBitmap();
		return _canvas;
	}
	
	/**
	 * Controls whether the display is cleared between each render frame.
	 * If you use pre-render filters, this value is ignored and the display is
	 * not cleared. If you use no filters or only post-render filters, this value 
	 * governs whether the screen is cleared.
	 * 
	 * <p>For BitmapRenderer and PixelRenderer, this value defaults to true.
	 * For BitmapLineRenderer it defaults to false.</p>
	 */
	private function clearBetweenFramesGetter():Bool
	{
		return _clearBetweenFrames;
	}
	private function clearBetweenFramesSetter( value:Bool ):Bool
	{
		_clearBetweenFrames = value;
		return _clearBetweenFrames;
	}
	
	private function smoothingGetter():Bool
	{
		return _smoothing;
	}
	private function smoothingSetter( value:Bool ):Bool
	{
		_smoothing = value;
		if( _bitmap != null )
		{
			_bitmap.smoothing = value;
		}
		return _smoothing;
	}
	
	/**
	 * @inheritDoc
	 */
	override private function renderParticles( particles:Array<Dynamic> ):Void
	{
		if( _bitmap == null )
		{
			return;
		}
		var i:Int;
		var len:Int;
		_bitmapData.lock();
		len = _preFilters.length;
		for (i in 0...len) 
		{
			_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _preFilters[i] );
		}
		if( _clearBetweenFrames && len == 0 )
		{
			_bitmapData.fillRect( _bitmap.bitmapData.rect, 0 );
		}
		len = particles.length;
		if ( len > 0 )
		{
			i = len;
			while( i > 0 ) // draw new particles first so they are behind old particles
			{
				i--;
				drawParticle( cast( particles[i],Particle2D ) );
			}
		}
		len = _postFilters.length;
		for (i in 0...len) 
		{
			_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _postFilters[i] );
		}
		if( _colorMap != null )
		{
			/**
			 * TODO: no palleteMap function in cpp?
			 */
			#if flash
			_bitmapData.paletteMap( _bitmapData, _bitmapData.rect, ZERO_POINT, _colorMap[1] , _colorMap[2] , _colorMap[3] , _colorMap[0] );
			#end
		}
		_bitmapData.unlock();
	}
	
	/**
	 * Used internally here and in derived classes to alter the manner of 
	 * the particle rendering.
	 * 
	 * @param particle The particle to draw on the bitmap.
	 */
	private function drawParticle( particle:Particle2D ):Void
	{
		var matrix:Matrix;
		matrix = particle.matrixTransform;
		matrix.translate( -_canvas.x, -_canvas.y );
		//: source, ?matrix, ?colorTransform, ?blendMode, ?clipRect, ?smoothing
		#if flash
		_bitmapData.draw( particle.image, matrix, particle.colorTransform, cast( particle.image, DisplayObject ).blendMode, null, _smoothing );
		#else
		//var pimage:DisplayObject = cast( particle.image, DisplayObject );
		//var blendMode:String = cast( pimage.blendMode, String );
		//_bitmapData.draw( particle.image, matrix, particle.colorTransform, blendMode, null, _smoothing );
		var pimage:DisplayObject = cast( particle.image, DisplayObject );
		var blendMode:String = "NORMAL";
		switch(pimage.blendMode)
		{
			case BlendMode.NORMAL:
				blendMode = "NORMAL";
			case BlendMode.LAYER:
				blendMode = "LAYER";
			case BlendMode.MULTIPLY:
				blendMode = "MULTIPLY";
			case BlendMode.SCREEN:
				blendMode = "SCREEN";
			case BlendMode.LIGHTEN:
				blendMode = "LIGHTEN";
			case BlendMode.DARKEN:
				blendMode = "DARKEN";
			case BlendMode.DIFFERENCE:
				blendMode = "DIFFERENCE";
			case BlendMode.ADD:
				blendMode = "ADD";
			case BlendMode.SUBTRACT:
				blendMode = "SUBTRACT";
			case BlendMode.INVERT:
				blendMode = "INVERT";
			case BlendMode.ALPHA:
				blendMode = "ALPHA";
			case BlendMode.ERASE:
				blendMode = "ERASE";
			case BlendMode.OVERLAY:
				blendMode = "OVERLAY";
			case BlendMode.HARDLIGHT:
				blendMode = "HARDLIGHT";
			default:
				blendMode = "NORMAL";
		}
		#if flash || cpp
		_bitmapData.draw( particle.image, matrix, particle.colorTransform, blendMode, null, _smoothing );
		#end
		#end
	}
	
	/**
	 * The bitmap data of the renderer.
	 */
	private function bitmapDataGetter() : BitmapData
	{
		return _bitmapData;
	}
}
