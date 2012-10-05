TARGET=flash
BUILD=build.nmml

BrownianMotion:
	cp ${BUILD} examples2D/BrownianMotion/build.nmml
	cd examples2D/BrownianMotion && haxelib run nme test build.nmml ${TARGET}

CatherineWheel:
	cp ${BUILD} examples2D/CatherineWheel/build.nmml
	cd examples2D/CatherineWheel && haxelib run nme test build.nmml ${TARGET}

ExplodeImage:
	cp ${BUILD} examples2D/ExplodeImage/build.nmml
	cd examples2D/ExplodeImage && haxelib run nme test build.nmml ${TARGET}

FireAndSmoke:
	cp ${BUILD} examples2D/FireAndSmoke/build.nmml
	cd examples2D/FireAndSmoke && haxelib run nme test build.nmml ${TARGET}

Firework:
	cp ${BUILD} examples2D/Firework/build.nmml
	cd examples2D/Firework && haxelib run nme test build.nmml ${TARGET}

Flocking:
	cp ${BUILD} examples2D/Flocking/build.nmml
	cd examples2D/Flocking && haxelib run nme test build.nmml ${TARGET}

Grass:
	cp ${BUILD} examples2D/Grass/build.nmml
	cd examples2D/Grass && haxelib run nme test build.nmml ${TARGET}

GravityWells:
	cp ${BUILD} examples2D/GravityWells/build.nmml
	cd examples2D/GravityWells && haxelib run nme test build.nmml ${TARGET}

LogoFirework:
	cp ${BUILD} examples2D/LogoFirework/build.nmml
	cd examples2D/LogoFirework && haxelib run nme test build.nmml ${TARGET}

LogoOnFire:
	cp ${BUILD} examples2D/LogoOnFire/build.nmml
	cd examples2D/LogoOnFire && haxelib run nme test build.nmml ${TARGET}

LogoTween:
	cp ${BUILD} examples2D/LogoTween/build.nmml
	cd examples2D/LogoTween && haxelib run nme test build.nmml ${TARGET}

MutualGravity:
	cp ${BUILD} examples2D/MutualGravity/build.nmml
	cd examples2D/MutualGravity && haxelib run nme test build.nmml ${TARGET}

Pachinko:
	cp ${BUILD} examples2D/Pachinko/build.nmml
	cd examples2D/Pachinko && haxelib run nme test build.nmml ${TARGET}

Rain:
	cp ${BUILD} examples2D/Rain/build.nmml
	cd examples2D/Rain && haxelib run nme test build.nmml ${TARGET}

Snowfall:
	cp ${BUILD} examples2D/Snowfall/build.nmml
	cd examples2D/Snowfall && haxelib run nme test build.nmml ${TARGET}

Sparkler:
	cp ${BUILD} examples2D/Sparkler/build.nmml
	cd examples2D/Sparkler && haxelib run nme test build.nmml ${TARGET}

