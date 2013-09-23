package org.flintparticles.threed.renderers.controllers;

import org.flintparticles.threed.renderers.Camera;

/**
 * The interface for classes that manage the camera state based on key presses or other inputs.
 */
interface CameraController
{
    public var camera(get, set) : Camera;
}
