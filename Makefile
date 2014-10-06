TARGET=flash
BUILD=build.nmml

BrownianMotion:
	cp ${BUILD} examples2D/BrownianMotion/build.nmml
	cd examples2D/BrownianMotion && openfl test build.nmml ${TARGET}

CatherineWheel:
	cp ${BUILD} examples2D/CatherineWheel/build.nmml
	cd examples2D/CatherineWheel && openfl test build.nmml ${TARGET}

ExplodeImage:
	cp ${BUILD} examples2D/ExplodeImage/build.nmml
	cd examples2D/ExplodeImage && openfl test build.nmml ${TARGET}

FireAndSmoke:
	cp ${BUILD} examples2D/FireAndSmoke/build.nmml
	cd examples2D/FireAndSmoke && openfl test build.nmml ${TARGET}

Firework:
	cp ${BUILD} examples2D/Firework/build.nmml
	cd examples2D/Firework && openfl test build.nmml ${TARGET}

Flocking:
	cp ${BUILD} examples2D/Flocking/build.nmml
	cd examples2D/Flocking && openfl test build.nmml ${TARGET}

Grass:
	cp ${BUILD} examples2D/Grass/build.nmml
	cd examples2D/Grass && openfl test build.nmml ${TARGET}

GravityWells:
	cp ${BUILD} examples2D/GravityWells/build.nmml
	cd examples2D/GravityWells && openfl test build.nmml ${TARGET}

LogoFirework:
	cp ${BUILD} examples2D/LogoFirework/build.nmml
	cd examples2D/LogoFirework && openfl test build.nmml ${TARGET}

LogoOnFire:
	cp ${BUILD} examples2D/LogoOnFire/build.nmml
	cd examples2D/LogoOnFire && openfl test build.nmml ${TARGET}

LogoTween:
	cp ${BUILD} examples2D/LogoTween/build.nmml
	cd examples2D/LogoTween && openfl test build.nmml ${TARGET}

MutualGravity:
	cp ${BUILD} examples2D/MutualGravity/build.nmml
	cd examples2D/MutualGravity && openfl test build.nmml ${TARGET}

Pachinko:
	cp ${BUILD} examples2D/Pachinko/build.nmml
	cd examples2D/Pachinko && openfl test build.nmml ${TARGET}

Rain:
	cp ${BUILD} examples2D/Rain/build.nmml
	cd examples2D/Rain && openfl test build.nmml ${TARGET}

Snowfall:
	cp ${BUILD} examples2D/Snowfall/build.nmml
	cd examples2D/Snowfall && openfl test build.nmml ${TARGET}

Sparkler:
	cp ${BUILD} examples2D/Sparkler/build.nmml
	cd examples2D/Sparkler && openfl test build.nmml ${TARGET}

