TARGET=flash

BrownianMotion:
	cp build.nmml examples2D/BrownianMotion
	cd examples2D/BrownianMotion && haxelib run nme test build.nmml ${TARGET}

CatherineWheel:
	cp build.nmml examples2D/CatherineWheel
	cd examples2D/CatherineWheel && haxelib run nme test build.nmml ${TARGET}

ExplodeImage:
	cp build.nmml examples2D/ExplodeImage
	cd examples2D/ExplodeImage && haxelib run nme test build.nmml ${TARGET}

FireAndSmoke:
	cp build.nmml examples2D/FireAndSmoke
	cd examples2D/FireAndSmoke && haxelib run nme test build.nmml ${TARGET}

Firework:
	cp build.nmml examples2D/Firework
	cd examples2D/Firework && haxelib run nme test build.nmml ${TARGET}

Flocking:
	cp build.nmml examples2D/Flocking
	cd examples2D/Flocking && haxelib run nme test build.nmml ${TARGET}

Grass:
	cp build.nmml examples2D/Grass
	cd examples2D/Grass && haxelib run nme test build.nmml ${TARGET}

GravityWells:
	cp build.nmml examples2D/GravityWells
	cd examples2D/GravityWells && haxelib run nme test build.nmml ${TARGET}

LogoFirework:
	cp build.nmml examples2D/LogoFirework
	cd examples2D/LogoFirework && haxelib run nme test build.nmml ${TARGET}

LogoOnFire:
	cp build.nmml examples2D/LogoOnFire
	cd examples2D/LogoOnFire && haxelib run nme test build.nmml ${TARGET}

LogoTween:
	cp build.nmml examples2D/LogoTween
	cd examples2D/LogoTween && haxelib run nme test build.nmml ${TARGET}

MutualGravity:
	cp build.nmml examples2D/MutualGravity
	cd examples2D/MutualGravity && haxelib run nme test build.nmml ${TARGET}

Pachinko:
	cp build.nmml examples2D/Pachinko
	cd examples2D/Pachinko && haxelib run nme test build.nmml ${TARGET}

Rain:
	cp build.nmml examples2D/Rain
	cd examples2D/Rain && haxelib run nme test build.nmml ${TARGET}

Snowfall:
	cp build.nmml examples2D/Snowfall
	cd examples2D/Snowfall && haxelib run nme test build.nmml ${TARGET}

Sparkler:
	cp build.nmml examples2D/Sparkler
	cd examples2D/Sparkler && haxelib run nme test build.nmml ${TARGET}

