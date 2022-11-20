function(enable_doxygen)
  option(ENABLE_DOXYGEN "Enable doxygen doc builds of source" ON)
  if(ENABLE_DOXYGEN)
    set(DOXYGEN_CALLER_GRAPH YES)
    set(DOXYGEN_CALL_GRAPH YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    find_package(Doxygen REQUIRED dot)
    doxygen_add_docs(doxygen-docs ${PROJECT_SOURCE_DIR})
#    set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
#    add_custom_command(
#      OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/doxygen.stamp
#      DEPENDS ${doxyfile}
#      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#      COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
#      COMMAND cmake -E touch ${CMAKE_CURRENT_BINARY_DIR}/doxygen.stamp
#      COMMENT "Generating API documentation with Doxygen"
#      VERBATIM)
#    add_custom_target(doc ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/doxygen.stamp)
  endif()
endfunction()
