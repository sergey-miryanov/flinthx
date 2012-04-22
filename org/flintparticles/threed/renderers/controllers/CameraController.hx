package org.flintparticles.threeD.renderers.controllers;

import org.flintparticles.threeD.renderers.Camera;

/**
 * The interface for classes that manage the camera state based on key presses or other inputs.
 */
interface CameraController
{
	public function cameraGetter():Camera;
	public function cameraSetter( value:Camera ):Camera;
}
