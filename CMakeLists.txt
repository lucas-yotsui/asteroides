cmake_minimum_required(VERSION 3.14...3.22)
# ---- Project ----
project(ExemploSfml VERSION 1.0 LANGUAGES CXX)
set(PROJECT_BIN "game.bin")
include(cmake/all.cmake)

find_package(SFML 2.5 COMPONENTS graphics REQUIRED)

#copiar o arquivo de fonte
set(EXTRA_DIST
    fonts/OpenSans-Bold.ttf
  )

set(EXTRA_DIST_1
	textures/jato.png
)

set(EXTRA_DIST_2
	textures/asteroide.png
)

set(EXTRA_DIST_3
	textures/asteroide2.png
)

set(EXTRA_DIST_4
	textures/asteroide3.png
)

set(EXTRA_DIST_5
	recordes.txt
)

#copiar a textura do jogador
foreach(ASSET ${EXTRA_DIST})
    file(COPY ${ASSET} DESTINATION ${CMAKE_BINARY_DIR}/fonts)
endforeach()

foreach(ASSET ${EXTRA_DIST_1})
    file(COPY ${ASSET} DESTINATION ${CMAKE_BINARY_DIR}/textures)
endforeach()

foreach(ASSET ${EXTRA_DIST_2})
    file(COPY ${ASSET} DESTINATION ${CMAKE_BINARY_DIR}/textures)
endforeach()

foreach(ASSET ${EXTRA_DIST_3})
    file(COPY ${ASSET} DESTINATION ${CMAKE_BINARY_DIR}/textures)
endforeach()

foreach(ASSET ${EXTRA_DIST_4})
    file(COPY ${ASSET} DESTINATION ${CMAKE_BINARY_DIR}/textures)
endforeach()

foreach(ASSET ${EXTRA_DIST_5})
    file(COPY ${ASSET} DESTINATION ${CMAKE_BINARY_DIR})
endforeach()

add_subdirectory(source)
add_executable(${PROJECT_BIN} app/main.cpp)
target_link_libraries(${PROJECT_BIN} ${PROJECT_NAME} project_options project_warnings sfml-graphics)
