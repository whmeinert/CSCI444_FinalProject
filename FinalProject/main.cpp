#include "scenerunner.h"
#include "scenewave.h"

#include <memory>

int main(int argc, char *argv[])
{
	SceneRunner runner("Final Project - Water Caustics");

	std::unique_ptr<Scene> scene;
	scene = std::unique_ptr<Scene>( new SceneWave() );

	return runner.run(std::move(scene));
}
