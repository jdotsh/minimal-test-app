TEMPLATE = app

QT += location

SOURCES +=  \
    main.cpp

RESOURCES += qml.qrc

target.path = ~/Desktop/Qt-projects/minimal_test_app
INSTALLS += target

DISTFILES += \
    doc/src/minimal_map.qdoc \
    doc/images/minimal_map.png \
    images/pin.png \
    doc/src/minimal_map.qdoc
