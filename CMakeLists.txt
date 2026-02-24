cmake_minimum_required(VERSION 3.16)

project(box_to_dead VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appbox_to_dead
    main.cpp
)

qt_add_qml_module(appbox_to_dead
    URI box_to_dead
    QML_FILES
        Main.qml
)

set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "Build examples" FORCE)
add_subdirectory(3rdparty/qml-box2d)

target_link_libraries(appbox_to_dead
    PRIVATE Qt6::Quick qmlbox2d
)

include(GNUInstallDirs)
install(TARGETS appbox_to_dead
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
