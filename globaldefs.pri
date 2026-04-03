# Support debug and release builds from command line for CI
CONFIG += debug_and_release

# Ensure symbols are always generated
CONFIG += force_debug_info

# Disable asserts on release builds
CONFIG(release, debug|release) {
    DEFINES += NDEBUG
}

# Enable CFG, EHCont, and CET
*-msvc {
    QMAKE_CFLAGS += -guard:cf -guard:ehcont
    QMAKE_CXXFLAGS += -guard:cf -guard:ehcont
    QMAKE_LFLAGS += -guard:cf -guard:ehcont

    contains(QT_ARCH, x86_64) {
        QMAKE_LFLAGS += -cetcompat
    }
}

# Qt 6.7 on newer Apple toolchains may use __yield() from qyieldcpu.h without
# pulling in the arm ACLE declarations first. Force-include the header so arm64
# macOS builds keep working with current Xcode SDKs.
macx:contains(QT_ARCH, arm64) {
    QMAKE_CFLAGS += -include arm_acle.h
    QMAKE_CXXFLAGS += -include arm_acle.h
}

# Enable ASan for Linux or macOS
#CONFIG += sanitizer sanitize_address

# Enable ASan for Windows
#QMAKE_CFLAGS += -fsanitize=address
#QMAKE_CXXFLAGS += -fsanitize=address
#QMAKE_LFLAGS += -incremental:no -wholearchive:clang_rt.asan_dynamic-x86_64.lib -wholearchive:clang_rt.asan_dynamic_runtime_thunk-x86_64.lib
