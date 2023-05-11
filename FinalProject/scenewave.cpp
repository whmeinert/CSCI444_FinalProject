#include "scenewave.h"
#include "texture.h"

#include <iostream>
using std::endl;
using std::cerr;

#include <glm/gtc/matrix_transform.hpp>
using glm::vec3;
using glm::mat4;

SceneWave::SceneWave() : time(0),sphere(1,16,16) , plane(13.0f, 10.0f, 200, 200), ground( 13, 10, 200, 200) {}

void SceneWave::initScene()
{
    compileAndLinkShader();

    glClearColor(0.5f,0.5f,0.5f,1.0f);
    glEnable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ZERO);

    glActiveTexture(GL_TEXTURE0);
    Texture::loadTexture("light_map.jpg");

    prog.setUniform("Light.Intensity", vec3(1.0f,1.0f,1.0f) );
    prog.setUniform("Light.Position", glm::vec4(0.0f,10.0f,20.0f, 0.0f) );
	angle = glm::half_pi<float>();
}

void SceneWave::update( float t )
{
    time = t;
}

void SceneWave::render()
{
    prog.setUniform("Time", time);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    view = glm::lookAt(vec3(3.1415f/1.0f,3.0f,12.0f), vec3(0.0f,-4.0f,0.0f), vec3(0.0f,1.0f,0.0f));
    projection = glm::perspective(glm::radians(60.0f), (float)width/height, 0.3f, 100.0f);

    prog.setUniform("Material.Kd", 29/255.0f,162/255.0f,216/255.0f);
    prog.setUniform("Material.Ks", 0.8f, 0.8f, 0.8f);
    prog.setUniform("Material.Ka", 0.3f, 0.3f, 0.3f);
    prog.setUniform("Material.Shininess", 100.0f);
    prog.setUniform("Amp", 0.1f);
    prog.setUniform("alpha", 1.0f);
    prog.setUniform("dist", 1.0f);
    prog.setUniform("isGround", false);
    prog.setUniform("isSphere", false);
    model = mat4(1.0f);
    setMatrices();
    plane.render();


    prog.setUniform("Material.Kd", 246/255.0f,215/255.0f,176/255.0f);
    prog.setUniform("Material.Ks", 0.8f, 0.8f, 0.8f);
    prog.setUniform("Material.Ka", 0.2f, 0.2f, 0.2f);
    prog.setUniform("Material.Shininess", 5.0f);
    prog.setUniform("Amp", 0.1f);
    prog.setUniform("alpha", 1.0f);
    prog.setUniform("dist", 2.0f);
    prog.setUniform("isGround", true);
    prog.setUniform("isSphere", false);
    model = mat4(1.0f);
    model = glm::translate(model, glm::vec3(0, -5, 0));
    setMatrices();
    ground.render();
}

void SceneWave::setMatrices()
{
    mat4 mv = view * model;
    prog.setUniform("ModelViewMatrix", mv);
    prog.setUniform("NormalMatrix",
                    glm::mat3( vec3(mv[0]), vec3(mv[1]), vec3(mv[2]) ));
    prog.setUniform("MVP", projection * mv);
}

void SceneWave::resize(int w, int h)
{
    glViewport(0,0,w,h);
    width = w;
    height = h;
    projection = glm::perspective(glm::radians(60.0f), (float)w/h, 0.3f, 100.0f);
}

void SceneWave::compileAndLinkShader()
{
	try {
		prog.compileShader("shader/wave_vert.glsl");
		prog.compileShader("shader/wave_frag.glsl");

    	prog.link();
    	prog.use();
    } catch(GLSLProgramException &e ) {
    	cerr << e.what() << endl;
 		exit( EXIT_FAILURE );
    }
}
