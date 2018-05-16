
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
        name: "osm" // OpenStreetMap map provider
    }

// The following timer has been implemented to prevent the app crashing when removing markers with the remove method of the ListModel
// The crash has been found to be caused by a bug in  Qt 5.10.1, solved in Qt5.11dev

    Timer {
        id: deleteTimer
        interval: 0;
        running: false;
        repeat: false
        onTriggered: markerModel.removeElement_real()
    }

// The ListModel where the position of the markers are stored
// Also contains the function to draw and update the polygon when markers change, and the function to remove the marker with the timer to prevent crash
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

        // Custom remove method implemented with a timer to prevent crashing

        function removeElement(idx) {
            markerModel.indexToRemove = idx
            deleteTimer.start()
        }

        // Custom method to draw the plygon on the map

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
        center: QtPositioning.coordinate(43.59, 13.50) // Starting coordinates: Ancona, the city where I am studying :)
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

        // Using a ListModel to store the coordinates we can easy apply the markers over a map using MapItemView
        // I used the MapQuickItem class with an image component (a marker)

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

                        // The marker removal calls a custom removeElement method from the ListModel
                        // The default remove method caused the app to crash due to a bug in Qt 5.10.1

                        MouseArea {
                            id:  maRemove
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

        // The following MouseArea is used to add the markers to the ListModel
        // Markers removal is handled inside the MapItemView class

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
