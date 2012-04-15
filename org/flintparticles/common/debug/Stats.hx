package org.flintparticles.common.debug;

import nme.Lib;
import nme.events.Event;
import nme.system.System;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import org.flintparticles.common.debug.ParticleFactoryStats;
import org.flintparticles.common.debug.Stats;

/**
 * A simple stats display object showing the frame-rate, the memory usage and the number of particles in use.
 */
class Stats extends TextField
{
	static public inline var FACTOR : Float = 1 / ( 1024 * 1024 );
	private var timer : Int;
	private var fps : Int;
	private var next : Int;
	private var mem : Float;
	private var max : Float;

	public function new( color : Int = 0xFFFFFF, bgColor : Int = 0 ) : Void
	{
		super();
		
		max = 0;

		var tf : TextFormat = new TextFormat();
		tf.color = color;
		tf.font = '_sans';
		tf.size = 9;
		tf.leading = -1;

		backgroundColor = bgColor;
		background = true;
		defaultTextFormat = tf;
		multiline = true;
		selectable = false;
		mouseEnabled = false;
		autoSize = TextFieldAutoSize.LEFT;

		addEventListener( Event.ADDED_TO_STAGE, start );
		addEventListener( Event.REMOVED_FROM_STAGE, stop );
	}

	private function start( e : Event ) : Void
	{
		addEventListener( Event.ENTER_FRAME, update );
		text = "";
		next = timer + 1000;
	}

	private function stop( e : Event ) : Void
	{
		removeEventListener( Event.ENTER_FRAME, update );
	}

	private function update( e : Event ) : Void
	{
		timer = flash.Lib.getTimer();

		if ( timer > next )
		{
			next = timer + 1000;
			//mem = cast( (System.totalMemory * Stats.FACTOR).toFixed( 3 ), Float );
			mem = cast( (System.totalMemory * Stats.FACTOR), Float );
			if ( max < mem )
			{
				max = mem;
			}

			text = "FPS: " + fps + " / " + stage.frameRate + "\nMEMORY: " + mem + "\nMAX MEM: " + max + "\nPARTICLES: " + ParticleFactoryStats.numParticles;

			fps = 0;
		}

		fps++;
	}
}
