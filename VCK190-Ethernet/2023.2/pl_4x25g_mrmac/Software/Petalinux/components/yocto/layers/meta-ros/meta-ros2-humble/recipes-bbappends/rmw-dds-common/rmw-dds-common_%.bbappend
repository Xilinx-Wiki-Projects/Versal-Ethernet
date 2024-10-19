# Copyright (c) 2019 LG Electronics, Inc.
# Copyright (c) 2022 Acceleration Robotics S.L. <contact@accelerationrobotics.com>

inherit setuptools3-base

ROS_BUILDTOOL_DEPENDS += " \
    rosidl-parser-native \
    rosidl-adapter-native \
    python3-numpy-native \
    python3-lark-parser-native \
"

# Without the target rosidl-typesupport-{c,cpp}, ament finds the native packages and then fails to link (error: incompatible
# target).
ROS_BUILD_DEPENDS += " \
    fastcdr \
    fastrtps \
    rosidl-typesupport-c \
    rosidl-typesupport-cpp \
    rosidl-typesupport-fastrtps-c \
    rosidl-typesupport-fastrtps-cpp \
    rosidl-runtime-c \
    rosidl-runtime-cpp \
    fastrtps-cmake-module \
    python-cmake-module \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
"

#inherit python3native
