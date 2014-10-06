TARGET=flash
BUILD=build.nmml

all: BrownianMotion CatherineWheel ExplodeImage FireAndSmoke Flocking \
	Grass GravityWells LogoFirework LogoOnFire LogoTween MutualGravity \
	Pachinko Rain Snowfall Sparkler

BrownianMotion:
	cp ${BUILD} examples2D/BrownianMotion/build.nmml
	cd examples2D/BrownianMotion && lime build build.nmml ${TARGET}

CatherineWheel:
	cp ${BUILD} examples2D/CatherineWheel/build.nmml
	cd examples2D/CatherineWheel && lime build build.nmml ${TARGET}

ExplodeImage:
	cp ${BUILD} examples2D/ExplodeImage/build.nmml
	cd examples2D/ExplodeImage && lime build build.nmml ${TARGET}

FireAndSmoke:
	cp ${BUILD} examples2D/FireAndSmoke/build.nmml
	cd examples2D/FireAndSmoke && lime build build.nmml ${TARGET}

Firework:
	cp ${BUILD} examples2D/Firework/build.nmml
	cd examples2D/Firework && lime build build.nmml ${TARGET}

Flocking:
	cp ${BUILD} examples2D/Flocking/build.nmml
	cd examples2D/Flocking && lime build build.nmml ${TARGET}

Grass:
	cp ${BUILD} examples2D/Grass/build.nmml
	cd examples2D/Grass && lime build build.nmml ${TARGET}

GravityWells:
	cp ${BUILD} examples2D/GravityWells/build.nmml
	cd examples2D/GravityWells && lime build build.nmml ${TARGET}

LogoFirework:
	cp ${BUILD} examples2D/LogoFirework/build.nmml
	cd examples2D/LogoFirework && lime build build.nmml ${TARGET}

LogoOnFire:
	cp ${BUILD} examples2D/LogoOnFire/build.nmml
	cd examples2D/LogoOnFire && lime build build.nmml ${TARGET}

LogoTween:
	cp ${BUILD} examples2D/LogoTween/build.nmml
	cd examples2D/LogoTween && lime build build.nmml ${TARGET}

MutualGravity:
	cp ${BUILD} examples2D/MutualGravity/build.nmml
	cd examples2D/MutualGravity && lime build build.nmml ${TARGET}

Pachinko:
	cp ${BUILD} examples2D/Pachinko/build.nmml
	cd examples2D/Pachinko && lime build build.nmml ${TARGET}

Rain:
	cp ${BUILD} examples2D/Rain/build.nmml
	cd examples2D/Rain && lime build build.nmml ${TARGET}

Snowfall:
	cp ${BUILD} examples2D/Snowfall/build.nmml
	cd examples2D/Snowfall && lime build build.nmml ${TARGET}

Sparkler:
	cp ${BUILD} examples2D/Sparkler/build.nmml
	cd examples2D/Sparkler && lime build build.nmml ${TARGET}

