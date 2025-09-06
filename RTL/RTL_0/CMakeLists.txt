cmake_minimum_required(VERSION 3.28.3)
project(RTL_0)

# init default
if(NOT DEFINED PROGRAM)
    set(PROGRAM adder2)
endif()
message(STATUS "Using PROGRAM = ${PROGRAM}")

set(VERILOG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/RTL/${PROGRAM}")
set(SIM_NAME "${PROGRAM}_top_tb")

# find tools
find_program(IVERILOG_EXECUTABLE iverilog)
find_program(VVP_EXECUTABLE vvp)
if(NOT IVERILOG_EXECUTABLE OR NOT VVP_EXECUTABLE)
    message(FATAL_ERROR "iverilog or vvp not found!")
endif()

# gather sources
file(GLOB VERILOG_SOURCES "${VERILOG_DIR}/*.v")
message(STATUS "Found Verilog sources:")
foreach(f ${VERILOG_SOURCES})
    message(STATUS "  ${f}")
endforeach()

# simulation target
add_custom_target(sim
    COMMAND ${IVERILOG_EXECUTABLE} -o ${CMAKE_CURRENT_BINARY_DIR}/${SIM_NAME}.vvp ${VERILOG_SOURCES}
    COMMAND ${VVP_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/${SIM_NAME}.vvp
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Compiling and simulating Verilog: ${PROGRAM}/${SIM_NAME}"
)
