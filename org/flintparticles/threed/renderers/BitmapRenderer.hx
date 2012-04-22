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

package org.flintparticles.threeD.renderers;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.PixelSnapping;
import nme.filters.BitmapFilter;
import nme.geom.Matrix;
import nme.geom.Matrix3D;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.geom.Vector3D;
import nme.Vector;
import org.flintparticles.common.renderers.SpriteRendererBase;
import org.flintparticles.threeD.geom.Quaternion;
import org.flintparticles.threeD.particles.Particle3D;

/**
 * The BitmapRenderer is a native Flint 3D renderer that draws particles
 * onto a single Bitmap display object. The particles are drawn face-on to the
 * camera, with perspective applied to position and scale the particles.
 * 
 * <p>The region of the projection plane drawn by this renderer must be 
 * defined in the canvas property of the BitmapRenderer. Particles outside this 
 * region are not drawn.</p>
 * 
 * <p>The image to be used for each particle is the particle's image property.
 * This is a DisplayObject, but this DisplayObject is not used directly. Instead
 * it is copied into the bitmap with the various properties of the particle 
 * applied, including 3D positioning and perspective relative to the renderer's
 * camera position. Consequently each particle may be represented by the same 
 * DisplayObject instance and the SharedImage initializer can be used with this 
 * renderer.</p>
 * 
 * <p>The BitmapRenderer allows the use of BitmapFilters to modify the appearance
 * of the bitmap. Every frame, under normal circumstances, the Bitmap used to
 * display the particles is wiped clean before all the particles are redrawn.
 * However, if one or more filters are added to the renderer, the filters are
 * applied to the bitmap instead of wiping it clean. This enables various trail
 * effects by using blur and other filters.</p>
 * 
 * <p>The BitmapRenderer has mouse events disabled for itself and any 
 * display objects in its display list. To enable mouse events for the renderer
 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
 */
class BitmapRenderer extends SpriteRendererBase
{
	public var preFilters(preFiltersGetter,preFiltersSetter):Array<Dynamic>;
	public var postFilters(postFiltersGetter,postFiltersSetter):Array<Dynamic>;
	public var canvas(canvasGetter,canvasSetter):Rectangle;
	public var smoothing(smoothingGetter,smoothingSetter):Bool;
	public var camera(cameraGetter,cameraSetter):Camera;
	public var zSort(zSortGetter,zSortSetter):Bool;
	public var bitmapData(bitmapDataGetter,null):BitmapData;
	
	public static inline var ZERO_POINT:Point = new Point( 0, 0 );

	public static inline var toDegrees:Float = 180 / Math.PI;
	
	/**
	 * @private
	 */
	private var _zSort:Bool;
	/**
	 * @private
	 */
	private var _camera:Camera;

	/**
	 * @private
	 */
	private var _bitmap:Bitmap;
	
	/**
	 * @private
	 */
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
	private var _halfWidth:Float;
	/**
	 * @private
	 */
	private var _halfHeight:Float;
	/**
	 * @private
	 */
	private var _rawCameraTransform:Vector<Float>;

	/**
	 * The constructor creates a BitmapRenderer. After creation it should be
	 * added to the display list of a DisplayObjectContainer to place it on 
	 * the stage.
	 * 
	 * <p>Emitter's should be added to the renderer using the renderer's
	 * addEmitter method. The renderer displays all the particles created
	 * by the emitter's that have been added to it.</p>
	 * 
	 * @param canvas The area within the renderer on which particles can be drawn.
	 * Particles outside this area will not be drawn.
	 * @param zSort Whether to sort the particles according to their
	 * z order when rendering them or not.
	 * @param smoothing Whether to use smoothing when scaling the Bitmap and, if the
	 * particles are represented by bitmaps, when drawing the particles.
	 * Smoothing removes pixelation when images are scaled and rotated, but it
	 * takes longer so it may slow down your particle system.
	 * 
	 * @see org.flintparticles.twoD.emitters.Emitter#renderer
	 */
	public function new( canvas:Rectangle, zSort:Bool = true, smoothing:Bool = false )
	{
		super();
		_zSort = zSort;
		_camera = new Camera();
		mouseEnabled = false;
		mouseChildren = false;
		_smoothing = smoothing;
		_preFilters = new Array<Dynamic>();
		_postFilters = new Array<Dynamic>();
		_canvas = canvas;
		createBitmap();
	}
	
	/**
	 * Indicates whether the particles should be sorted in distance order for display.
	 */
	private function zSortGetter():Bool
	{
		return _zSort;
	}
	private function zSortSetter( value:Bool ):Bool
	{
		_zSort = value;
		return _zSort;
	}
	
	/**
	 * The camera controls the view for the renderer
	 */
	private function cameraGetter():Camera
	{
		return _camera;
	}
	private function cameraSetter( value:Camera ):Camera
	{
		_camera = value;
		return _camera;
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
		var i:Int = 0;
		while( i < _preFilters.length )
		{
			if( _preFilters[i] == filter )
			{
				_preFilters.splice( i, 1 );
				return;
			}
			++i;
		}
		//for( i = 0; i < _postFilters.length; ++i )
		i = 0;
		while( i < _postFilters.length )
		{
			if( _postFilters[i] == filter )
			{
				_postFilters.splice( i, 1 );
				return;
			}
			++i;
		}
	}
	
	/**
	 * The array of all filters being applied before rendering.
	 */
	private function preFiltersGetter():Array<Dynamic>
	{
		return _preFilters.slice(_preFilters.length);
	}
	private function preFiltersSetter( value:Array<Dynamic> ):Array<Dynamic>
	{
		var filter:BitmapFilter;
		for( filter in _preFilters )
		{
			removeFilter( filter );
		}
		for( filter in value )
		{
			addFilter( filter, false );
		}
		return value;
	}

	/**
	 * The array of all filters being applied before rendering.
	 */
	private function postFiltersGetter():Array<Dynamic>
	{
		return _postFilters.slice(_postFilters.length);
	}
	private function postFiltersSetter( value:Array<Dynamic> ):Array<Dynamic>
	{
		var filter:BitmapFilter;
		for( filter in _postFilters )
		{
			removeFilter( filter );
		}
		for( filter in value )
		{
			addFilter( filter, true );
		}
		return value;
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
		_bitmap = new Bitmap( null, PixelSnapping.AUTO, _smoothing);
		_bitmapData = new BitmapData( Math.ceil( _canvas.width ), Math.ceil( _canvas.height ), true, 0 );
		_bitmap.bitmapData = _bitmapData;
		addChild( _bitmap );
		_bitmap.x = _canvas.x;
		_bitmap.y = _canvas.y;
		_halfWidth = _bitmapData.width * 0.5;
		_halfHeight = _bitmapData.height * 0.5;
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
		return value;
	}

	/**
	 * This method draws the particles in the bitmap image, positioning and
	 * scaling them according to their positions relative to the camera 
	 * viewport.
	 * 
	 * <p>This method is called internally by Flint and shouldn't need to be called
	 * by the user.</p>
	 * 
	 * @param particles The particles to be rendered.
	 */
	override private function renderParticles( particles:Array<Dynamic> ):Void
	{
		if( _bitmap == null )
		{
			return;
		}
		_rawCameraTransform = _camera.transform.rawData;
		var i:Int;
		var len:Int;
		var particle:Particle3D;
		_bitmapData.lock();
		len = _preFilters.length;
		for (i in 0...len) 
		{
			_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _preFilters[i] );
		}
		if( len == 0 && _postFilters.length == 0 )
		{
			_bitmapData.fillRect( _bitmapData.rect, 0 );
		}
		len = particles.length;
		for (i in 0...len) 
		{
			particle = cast( particles[i], Particle3D );
			var p:Vector3D = particle.position;
			var pp:Vector3D = particle.projectedPosition;
			
			//The following is very much more efficient than
			//particle.projectedPosition = camera.transform.transformVector( particle.position );
			pp.x = _rawCameraTransform[0] * p.x + _rawCameraTransform[4] * p.y + _rawCameraTransform[8] * p.z + _rawCameraTransform[12] * p.w;
			pp.y = _rawCameraTransform[1] * p.x + _rawCameraTransform[5] * p.y + _rawCameraTransform[9] * p.z + _rawCameraTransform[13] * p.w;
			pp.z = _rawCameraTransform[2] * p.x + _rawCameraTransform[6] * p.y + _rawCameraTransform[10] * p.z + _rawCameraTransform[14] * p.w;
			pp.w = _rawCameraTransform[3] * p.x + _rawCameraTransform[7] * p.y + _rawCameraTransform[11] * p.z + _rawCameraTransform[15] * p.w;

			particle.zDepth = pp.z;
		}
		if( _zSort )
		{
			particles.sort( sortOnZ );
		}
		for (i in 0...len) 
		{
			drawParticle( cast( particles[i], Particle3D ) );
		}
		len = _postFilters.length;
		for (i in 0...len) 
		{
			_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _postFilters[i] );
		}
		if( _colorMap != null )
		{
			_bitmapData.paletteMap( _bitmapData, _bitmapData.rect, ZERO_POINT, _colorMap[1] , _colorMap[2] , _colorMap[3] , _colorMap[0] );
		}
		_bitmapData.unlock();
	}
	
	/**
	 * @private
	 */
	private function sortOnZ( p1:Particle3D, p2:Particle3D ):Int
	{
		return Std.int(p2.zDepth - p1.zDepth);
	}

	/**
	 * Used internally here and in derived classes to render a single particle.
	 * Each particle is positioned and perspective scaling applied here.
	 * 
	 * <p>Derived classes can modify the rendering of individual particles
	 * by overriding this method.</p>
	 * 
	 * @param particle The particle to draw on the bitmap.
	 */
	private function drawParticle( particle:Particle3D ):Void
	{
		var pos:Vector3D = particle.projectedPosition;
		if( pos.z < _camera.nearPlaneDistance || pos.z > _camera.farPlaneDistance )
		{
			return;
		}
		var scale:Float = particle.scale * _camera.projectionDistance / pos.z;
		pos.project();
		
		var rot:Float = 0;
		var f:Vector3D;
		//if( particle.rotation.equals( Quaternion.IDENTITY ) )
		if( particle.rotation.equals( new Quaternion().IDENTITY ) )
		{
			f = particle.faceAxis;
		}
		else
		{
			var m:Matrix3D = particle.rotation.toMatrixTransformation();
			f = m.transformVector( particle.faceAxis );
		}
		var facing:Vector3D = new Vector3D();
		
		// The following is very much more efficient than
		// facing = camera.transform.transformVector( f );
		facing.x = _rawCameraTransform[0] * f.x + _rawCameraTransform[4] * f.y + _rawCameraTransform[8] * f.z + _rawCameraTransform[12] * f.w;
		facing.y = _rawCameraTransform[1] * f.x + _rawCameraTransform[5] * f.y + _rawCameraTransform[9] * f.z + _rawCameraTransform[13] * f.w;
		facing.z = _rawCameraTransform[2] * f.x + _rawCameraTransform[6] * f.y + _rawCameraTransform[10] * f.z + _rawCameraTransform[14] * f.w;
		facing.w = _rawCameraTransform[3] * f.x + _rawCameraTransform[7] * f.y + _rawCameraTransform[11] * f.z + _rawCameraTransform[15] * f.w;
		
		if( facing.x != 0 || facing.y != 0 )
		{
			rot = Math.atan2( facing.y, facing.x );
		}

		var matrix:Matrix;
		if( rot > 0 )
		{
			var cos:Float = scale * Math.cos( rot );
			var sin:Float = scale * Math.sin( rot );
			matrix = new Matrix( cos, sin, -sin, cos, pos.x + _halfWidth, pos.y + _halfHeight );
		}
		else
		{
			matrix = new Matrix( scale, 0, 0, scale, pos.x + _halfWidth, pos.y + _halfHeight );
		}

		_bitmapData.draw( particle.image, matrix, particle.colorTransform, cast( particle.image, DisplayObject ).blendMode, null, _smoothing );
	}
	
	/**
	 * The bitmap data of the renderer.
	 */
	private function bitmapDataGetter() : BitmapData
	{
		return _bitmapData;
	}
}
