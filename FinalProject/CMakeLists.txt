set(target FinalProject)
set( FinalProject_SOURCES
	main.cpp
    scenewave.cpp
)

add_executable( ${target} ${FinalProject_SOURCES} )
target_compile_definitions(${target}
		PRIVATE
		GLFW_INCLUDE_NONE
		)

target_link_libraries( ${target}
		PRIVATE
		ingredients
		glfw
		${OPENGL_gl_LIBRARY}
		)
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/shader DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ./light_map.jpg DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
