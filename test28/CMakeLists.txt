project ( lua C )
cmake_minimum_required ( VERSION 2.8 )

include_directories ( ../lua-5.3.4/src ${CMAKE_CURRENT_BINARY_DIR} )
set ( SRC_CORE ../lua-5.3.4/src/lapi.c ../lua-5.3.4/src/lcode.c ../lua-5.3.4/src/lctype.c ../lua-5.3.4/src/ldebug.c ../lua-5.3.4/src/ldo.c ../lua-5.3.4/src/ldump.c ../lua-5.3.4/src/lfunc.c ../lua-5.3.4/src/lgc.c ../lua-5.3.4/src/llex.c
  ../lua-5.3.4/src/lmem.c ../lua-5.3.4/src/lobject.c ../lua-5.3.4/src/lopcodes.c ../lua-5.3.4/src/lparser.c ../lua-5.3.4/src/lstate.c ../lua-5.3.4/src/lstring.c ../lua-5.3.4/src/ltable.c
  ../lua-5.3.4/src/ltm.c ../lua-5.3.4/src/lundump.c ../lua-5.3.4/src/lvm.c ../lua-5.3.4/src/lzio.c )
set ( SRC_LIB ../lua-5.3.4/src/lauxlib.c ../lua-5.3.4/src/lbaselib.c ../lua-5.3.4/src/lbitlib.c ../lua-5.3.4/src/lcorolib.c ../lua-5.3.4/src/ldblib.c ../lua-5.3.4/src/liolib.c
  ../lua-5.3.4/src/lmathlib.c ../lua-5.3.4/src/loslib.c ../lua-5.3.4/src/lstrlib.c ../lua-5.3.4/src/ltablib.c ../lua-5.3.4/src/lutf8lib.c ../lua-5.3.4/src/loadlib.c ../lua-5.3.4/src/linit.c )

set ( SRC_LUA lua.c )

add_library ( liblua ${SRC_CORE} ${SRC_LIB} )
set_target_properties ( liblua PROPERTIES OUTPUT_NAME lua )

add_library ( libluadll SHARED ${SRC_CORE} ${SRC_LIB} )
target_compile_definitions ( libluadll PRIVATE _CRT_SECURE_NO_WARNINGS LUA_BUILD_AS_DLL )
set_target_properties ( libluadll PROPERTIES OUTPUT_NAME lua53 )

add_executable ( lua ${SRC_LUA} )
target_link_libraries ( lua libluadll )
