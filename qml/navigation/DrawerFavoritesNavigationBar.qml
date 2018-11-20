// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../common"

Pane {
    id: myBar

    // on tablet in landscape: center buttons
    property int occupiedWidth: favoritesModel.length * (56+36)
    property int availableMargin: (appWindow.safeWidth - occupiedWidth) / 2
    property int extraSpace: favBackButton.visible? 56+24 : 0

    Material.elevation: 8
    z: 1
    property real activeOpacity: iconFolder == "black" ?  0.87 : 1.0
    property real inactiveOpacity: iconFolder == "black" ? 0.26 : 0.56
    leftPadding: isTabletInLandscape? drawerWidth : 0
    rightPadding: 0
    topPadding: 0
    height: (isDarkTheme? 56 + darkDivider.height : 56) + unsafeArea.unsafeBottomMargin
    // Using Divider as workaround for bug:
    // Material.elevation: 8 not 'visible' if dark theme
    HorizontalDivider {
        id: darkDivider
        visible: isDarkTheme
    }
    RowLayout {
        focus: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: isTabletInLandscape? availableMargin - extraSpace : 0
        anchors.rightMargin: isTabletInLandscape? availableMargin : 0

        anchors.top: isDarkTheme? darkDivider.bottom : parent.top
        spacing: 0
        // MENU Button
        DrawerFavoritesMenuButton {
        }
        // BACK BUTTON (Tablet in Landscape)
        ToolButton {
            id: favBackButton
            focusPolicy: Qt.NoFocus
            visible: isTabletInLandscape && initDone && navigationModel[navigationIndex].canGoBack && destinations.itemAt(navigationIndex).item.depth > 1
            Image {
                id: contentImage
                anchors.centerIn: parent
                source: "qrc:/images/"+iconFolder+"/arrow_back.png"
            }
            ColorOverlay {
                id: colorOverlay
                anchors.fill: contentImage
                source: contentImage
                color: primaryColor
            }
            onClicked: {
                destinations.itemAt(navigationIndex).item.goBack()
            }
        } // backButton
        //
        Repeater {
            id: favoritesButtonRepeater
            model: favoritesModel
            DrawerFavoritesNavigationButton {
                id: myButton
            }
        } // repeater
    } // RowLayout
    function replaceIcon(position, theIconName) {
        favoritesButtonRepeater.itemAt(position).theIcon = theIconName
    }
    function replaceText(position, theText) {
        favoritesButtonRepeater.itemAt(position).theText = theText
    }
} // bottomNavigationBar
