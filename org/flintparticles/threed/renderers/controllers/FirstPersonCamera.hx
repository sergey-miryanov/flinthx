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

package org.flintparticles.threed.renderers.controllers;

import nme.display.DisplayObject;
import org.flintparticles.threed.renderers.Camera;

/**
 * Sets keyboard input to make a renderer's camera track, pan and tilt in response to 
 * keyboard input.
 * 
 * <p>After assigning a camera to an instance of this class, the camera responds to the
 * following keyboard input</p>
 * 
 * <ul>
 * <li>Up arrow key - tilt down.</li>
 * <li>Down arrow key - tilt up.</li>
 * <li>Left arrow key - pan left.</li>
 * <li>Right arrow key - pan right.</li>
 * <li>W key - track in.</li>
 * <li>S key - track out.</li>
 * <li>A key - track left.</li>
 * <li>D key - track right.</li>
 * <li>Page up key - raise the camera.</li>
 * <li>Page down key - lower the camera.</li>
 * </ul>
 */
class FirstPersonCamera extends KeyboardControllerBase
{
	public var rotationRate(rotationRateGetter,rotationRateSetter):Float;
	public var trackRate(trackRateGetter,trackRateSetter):Float;
	
	private var _rotationRate:Float;
	private var _trackRate:Float;
	
	/**
	 * The constructor creates an FirstPersonCamera controller.
	 * 
	 * @param stage The display object on which to listen for keyboard input. This should usually
	 * be a reference to the stage.
	 * @param camera The camera to control from the keyboard.
	 * @param rotationRate The rate at which to rotate the camera when the appropriate keys are 
	 * pressed, in radians per second.
	 * @param trackRate The rate at which to track the camera when the appropriate keys are 
	 * pressed, in units per second.
	 * @param useInternalTick Indicates whether the camera controller should use its
	 * own tick event to update its state. The internal tick process is tied
	 * to the framerate and updates the camera every frame.
	 */
	public function new( stage:DisplayObject = null, camera:Camera = null, rotationRate:Float = 1, trackRate:Float = 200, useInternalTick:Bool = true )
	{
		if( camera != null )
		{
			this.camera = camera;
		}
		if( stage != null )
		{
			this.stage = stage;
		}
		this.rotationRate = rotationRate;
		this.trackRate = trackRate;
		this.useInternalTick = useInternalTick;
	}
	
	/**
	 * The rate at which to rotate the camera when the appropriate keys are 
	 * pressed, in radians per second.
	 */
	public function rotationRateGetter():Float
	{
		return _rotationRate;
	}
	public function rotationRateSetter( value:Float ):Float
	{
		_rotationRate = value;
		return value;
	}
	
	/**
	 * The rate at which to track the camera when the appropriate keys are 
	 * pressed, in units per second.
	 */
	public function trackRateGetter():Float
	{
		return _trackRate;
	}
	public function trackRateSetter( value:Float ):Float
	{
		_trackRate = value;
		return value;
	}
	
	
	override private function updateCamera( time:Float ):Void
	{
		if( wDown )
		{
			camera.dolly( _trackRate * time );
		}
		if( sDown )
		{
			camera.dolly( -_trackRate * time );
		}
		if( aDown )
		{
			camera.track( -_trackRate * time );
		}
		if( dDown )
		{
			camera.track( _trackRate * time );
		}
		if( pgUpDown )
		{
			camera.lift( _trackRate * time );
		}
		if( pgDownDown )
		{
			camera.lift( -_trackRate * time );
		}
		if( leftDown )
		{
			camera.pan( -_rotationRate * time );
		}
		if( rightDown )
		{
			camera.pan( _rotationRate * time );
		}
		if( upDown )
		{
			camera.tilt( -_rotationRate * time );
		}
		if( downDown )
		{
			camera.tilt( _rotationRate * time );
		}
	}
}
