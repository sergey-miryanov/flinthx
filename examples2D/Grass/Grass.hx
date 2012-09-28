/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org/
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
import org.flintparticles.common.actions.Age;
import org.flintparticles.common.actions.ScaleImage;
import org.flintparticles.common.counters.Blast;
import org.flintparticles.common.initializers.ColorInit;
import org.flintparticles.common.initializers.Lifetime;
import org.flintparticles.twod.actions.Accelerate;
import org.flintparticles.twod.actions.Move;
import org.flintparticles.twod.emitters.Emitter2D;
import org.flintparticles.twod.initializers.Position;
import org.flintparticles.twod.initializers.Velocity;
import org.flintparticles.twod.zones.DiscSectorZone;
import org.flintparticles.twod.zones.DiscZone;
import flash.geom.Point;

class Grass extends Emitter2D
{

	public function new()
	{
    super ();

		counter = new Blast(100);
		addInitializer(new Position(new DiscZone(new Point(0, 0), 40)));
		addInitializer(new Velocity(new DiscSectorZone(new Point(0, 0), 80, 40, -5 * Math.PI / 8, -3 * Math.PI / 8)));
		addInitializer(new ColorInit(0xFF006600, 0xFF009900));
		addInitializer(new Lifetime(7));
		addAction(new Move());
		addAction(new Age());
		addAction(new ScaleImage(4, 1));
		addAction(new Accelerate(0, 10));
	}

}

