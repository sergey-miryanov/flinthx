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
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;
import org.flintparticles.common.events.UpdateEvent;
import org.flintparticles.common.utils.FrameUpdater;
import org.flintparticles.threed.renderers.Camera;

/**
 * Base class for keyboard based camera controllers. Tracks the keyboard state for camera controllers.
 */
class KeyboardControllerBase implements CameraController
{
	public var maximumFrameTime(maximumFrameTimeGetter,maximumFrameTimeSetter):Float;
	public var stage(stageGetter,stageSetter):DisplayObject;
	public var useInternalTick(useInternalTickGetter,useInternalTickSetter):Bool;
	public var fixedFrameTime(fixedFrameTimeGetter,fixedFrameTimeSetter):Float;
	public var camera(cameraGetter,cameraSetter):Camera;
	
	private var _stage:DisplayObject;
	private var _camera:Camera;
	private var _running:Bool;
	private var _useInternalTick:Bool;
	private var _maximumFrameTime:Float;
	private var _fixedFrameTime:Float;
	
	private var wDown:Bool;
	private var aDown:Bool;
	private var sDown:Bool;
	private var dDown:Bool;
	private var leftDown:Bool;
	private var rightDown:Bool;
	private var upDown:Bool;
	private var downDown:Bool;
	private var pgUpDown:Bool;
	private var pgDownDown:Bool;
	
	public var autoStart:Bool;

	/**
	 * The constructor creates an OrbitCamera controller.
	 * 
	 * @param stage The display object on which to listen for keyboard input. This should usually
	 * be a reference to the stage.
	 * @param camera The camera to control with this controller.
	 * @param rotationRate The rate at which to rotate the camera when the appropriate keys are 
	 * pressed, in radians per second.
	 * @param trackRate The rate at which to track the camera when the appropriate keys are 
	 * pressed, in units per second.
	 * @param useInternalTick Indicates whether the camera controller should use its
	 * own tick event to update its state. The internal tick process is tied
	 * to the framerate and updates the camera every frame.
	 */
	public function new()
	{
		autoStart = true;
		_running = false;
		_useInternalTick = true;
		_maximumFrameTime = 0.5;
		_fixedFrameTime = 0;
		wDown = false;
		aDown = false;
		sDown = false;
		dDown = false;
		leftDown = false;
		rightDown = false;
		upDown = false;
		downDown = false;
		pgUpDown = false;
		pgDownDown = false;
	}
	
	/**
	 * The maximum duration for a single update frame, in seconds.
	 * 
	 * <p>Under some circumstances related to the Flash player (e.g. on MacOSX, when the 
	 * user right-clicks on the flash movie) the flash movie will freeze for a period. When the
	 * freeze ends, the current frame of the particle system will be calculated as the time since 
	 * the previous frame,  which encompases the duration of the freeze. This could cause the 
	 * system to generate a single frame update that compensates for a long period of time and 
	 * hence moves the particles an unexpected long distance in one go. The result is usually
	 * visually unacceptable and certainly unexpected.</p>
	 * 
	 * <p>This property sets a maximum duration for a frame such that any frames longer than 
	 * this duration are ignored. The default value is 0.5 seconds. Developers don't usually
	 * need to change this from the default value.</p>
	 */
	private function maximumFrameTimeGetter() : Float
	{
		return _maximumFrameTime;
	}
	private function maximumFrameTimeSetter( value : Float ) : Float
	{
		_maximumFrameTime = value;
		return _maximumFrameTime;
	}
	
	/**
	 * Indicates a fixed time (in seconds) to use for every frame. Setting 
	 * this property causes the controller to bypass its frame timing 
	 * functionality and use the given time for every frame. This enables
	 * the particle system to be frame based rather than time based.
	 * 
	 * <p>To return to time based animation, set this value to zero (the 
	 * default).</p>
	 * 
	 * <p>This feature only works if useInternalTick is true (the default).</p>
	 * 
	 * @see #useInternalTick
	 */		
	private function fixedFrameTimeGetter():Float
	{
		return _fixedFrameTime;
	}
	private function fixedFrameTimeSetter( value:Float ):Float
	{
		_fixedFrameTime = value;
		return _fixedFrameTime;
	}

	/**
	 * Indicates whether the controller should manage its own internal update
	 * tick. The internal update tick is tied to the frame rate and updates
	 * the particle system every frame.
	 * 
	 * <p>If users choose not to use the internal tick, they have to call
	 * the controller's update method with the appropriate time parameter every
	 * time they want the controller to update the camera.</p>
	 */		
	private function useInternalTickGetter():Bool
	{
		return _useInternalTick;
	}
	private function useInternalTickSetter( value:Bool ):Bool
	{
		if( _useInternalTick != value )
		{
			_useInternalTick = value;
			if( _running )
			{
				if( _useInternalTick )
				{
					//FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, false, 0, true );
					FrameUpdater.instance().addEventListener( UpdateEvent.UPDATE, updateEventListener );
				}
				else
				{
					FrameUpdater.instance().removeEventListener( UpdateEvent.UPDATE, updateEventListener );
				}
			}
		}
		return _useInternalTick;
	}
	
	/**
	 * The camera to control with this controller.
	 */
	public function cameraGetter():Camera
	{
		return _camera;
	}
	public function cameraSetter( value:Camera ):Camera
	{
		_camera = value;
		return _camera;
	}
	
	/**
	 * The stage - used for listening to keyboard events
	 */
	private function stageGetter():DisplayObject
	{
		return _stage;
	}
	private function stageSetter( value:DisplayObject ):DisplayObject
	{
		if( _stage != null )
		{
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
		}
		_stage = value;
		//_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown, false, 0, true );
		_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		//_stage.addEventListener( KeyboardEvent.KEY_UP, keyUp, false, 0, true );
		_stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
		return _stage;
	}
	
	private function keyDown( ev:KeyboardEvent ):Void
	{
		switch( ev.keyCode )
		{
			case Keyboard.UP:
				upDown = true;
			case Keyboard.DOWN:
				downDown = true;
			case Keyboard.LEFT:
				leftDown = true;
			case Keyboard.RIGHT:
				rightDown = true;
			case 87:
				wDown = true;
			case 65:
				aDown = true;
			case 83:
				sDown = true;
			case 68:
				dDown = true;
			case 33:
				pgUpDown = true;
			case 34:
				pgDownDown = true;
			default:
		}
	}
	
	private function keyUp( ev:KeyboardEvent ):Void
	{
		switch( ev.keyCode )
		{
			case Keyboard.UP:
				upDown = false;
			case Keyboard.DOWN:
				downDown = false;
			case Keyboard.LEFT:
				leftDown = false;
			case Keyboard.RIGHT:
				rightDown = false;
			case 87:
				wDown = false;
			case 65:
				aDown = false;
			case 83:
				sDown = false;
			case 68:
				dDown = false;
			case 33:
				pgUpDown = false;
			case 34:
				pgDownDown = false;
		}
	}
	
	/**
	 * Update event listener used to fire the update function when using teh internal tick.
	 */
	private function updateEventListener( ev:UpdateEvent ):Void
	{
		if( _fixedFrameTime > 0 )
		{
			update( _fixedFrameTime );
		}
		else
		{
			update( ev.time );
		}
	}
	
	public function update( time:Float ):Void
	{
		if( !_running || time > _maximumFrameTime )
		{
			return;
		}
		updateCamera( time );
	}
	
	private function updateCamera( time:Float ):Void
	{
		
	}
	
	/**
	 * Starts the controller.
	 */
	public function start():Void
	{
		if( _useInternalTick )
		{
			//FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, false, 0, true );
			FrameUpdater.instance().addEventListener( UpdateEvent.UPDATE, updateEventListener );
		}
		_running = true;
	}
	

	
	/**
	 * Stops the controller.
	 */
	public function stop():Void
	{
		if( _useInternalTick )
		{
			FrameUpdater.instance().removeEventListener( UpdateEvent.UPDATE, updateEventListener );
		}
		_running = false;
	}
}
