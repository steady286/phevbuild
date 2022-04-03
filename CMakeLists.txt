cmake_policy(SET CMP0048 NEW)
cmake_minimum_required(VERSION 3.0)
project("Mitstubishi Outlander PHEV Remote App" LANGUAGES C VERSION 0.0.1)
## include(options.cmake)
include(external/argp/cmake/Findargp.cmake)

set (CMAKE_C_STANDARD 11)
if (UNIX)
  add_definitions (-D__unix__)
endif()

set(TARGET_GROUP production CACHE STRING "Group to build")
set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/install)

if(MQTT_PAHO)
  set(PAHO_BUILD_STATIC ON CACHE INTERNAL "")
  set(PAHO_BUILD_SHARED OFF CACHE INTERNAL "")
  set(PAHO_ENABLE_CPACK OFF CACHE INTERNAL "")
  set(PAHO_WITH_SSL OFF CACHE INTERNAL "")
  add_subdirectory(external/paho_mqtt)
  set(CMAKE_C_FLAGS "-DMQTT_PAHO=true")
  install(TARGETS paho-mqtt3c-static LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
  find_library(PAHO_LIB NAMES paho-mqtt3c-static paho-mqtt3c REQUIRED HINTS ${CMAKE_INSTALL_PREFIX}/lib)

endif()

add_subdirectory(external/cjson)
add_subdirectory(external/msg-core)
add_subdirectory(external/phevcore)
add_subdirectory(external/phevctl)

find_library(ARGP_LIB argp)

if(TARGET_GROUP STREQUAL _production)
    add_executable(phevctl main.c
        src/phevargs.c
    )
    add_executable(decode decode.c)
    target_include_directories(phevctl PUBLIC include ${ARGP} /usr/local/include)
    target_include_directories(decode PUBLIC include /usr/local/include)
    target_link_libraries(phevctl "${PHEV_LIB}" "${MSG_CORE_LIB}" "${CJSON_LIB}" "${PAHO_LIB}" pthread "${ARGP_LIB}")
    target_link_libraries(decode "${PHEV_LIB}" "${MSG_CORE_LIB}" "${CJSON_LIB}" )
elseif(TARGET_GROUP STREQUAL test)
    add_subdirectory(test)
ENDIF()

install(TARGETS phevctl decode RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
