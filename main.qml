
import QtQuick 2.0
import QtQuick.Window 2.0
import QtLocation 5.6
import QtPositioning 5.6

Window {
    width: 812
    height: 512
    visible: true

    Plugin {
        id: mapPlugin
        name: "osm" // "mapboxgl", "esri", ...
        // specify plugin parameters if necessary
        // PluginParameter {
        //     name:
        //     value:
        // }
    }

    Timer {
        id: deleteTimer
        interval: 0;
        running: false;
        repeat: false
        onTriggered: markerModel.removeElement_real()
    }

    ListModel {
        id: markerModel
        property int elementId : 0
        property int indexToRemove : -1
        function removeElement_real() {
            for (var i = 0; i < markerModel.count; i++)
                if (markerModel.get(i).idx === indexToRemove) {
                    markerModel.remove(i)
                    break
                }
        }

        function removeElement(idx) {
            markerModel.indexToRemove = idx
            deleteTimer.start()
        }

        function updatePolygon() {
            if (markerModel.count < 3)
                polygon.visible = false
            else
                polygon.visible = true
            var path = []
            for (var i = 0; i < markerModel.count; i++) {
                var elem = markerModel.get(i)
                var crd = QtPositioning.coordinate(elem.varLatitude, elem.varLongitude)
                path.push(crd)
            }
            polygon.path = path
        }

        onCountChanged: updatePolygon()
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(43.59, 13.50) // coordinate iniziali
        zoomLevel: 10
        z: 100

        MapPolygon {
            id: polygon
            opacity: 0.4
            border.width : 1.5
            border.color : 'black'
            color: 'blue'
            visible: true
        }

        MapItemView {
            id: mapView
            model: markerModel
            delegate: Component {
                id: markerDelegate
                MapQuickItem {
                    id: marker
                    property int index: idx
                    coordinate: QtPositioning.coordinate(varLatitude, varLongitude)
                    anchorPoint.x: ima.width / 2
                    anchorPoint.y: ima.height
                    sourceItem: Image {

                        property real zoomImage: 0.6
                        id: ima
                        source: "qrc:/images/pin.png"
                        width: zoomImage*100
                        height: zoomImage*100

                        MouseArea {
                            id:  maPippo
                            anchors.fill: parent
                            onDoubleClicked: {
                                markerModel.removeElement(index)
                                markerModel.elementId -= 1
                            }
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                var point = Qt.point(mouseX, mouseY)
                var co = map.toCoordinate(point)
                markerModel.append({varLatitude: co.latitude, varLongitude: co.longitude, idx: markerModel.elementId})
                markerModel.elementId += 1
            }
        }
    }
}
