import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

// modal and dim to get correct touch behaviour:
// now tapping outside the ComboBox only closes
// ComboBox without triggering Buttons or so
// https://bugreports.qt.io/browse/QTBUG-61971
ComboBox {
    popup.modal: true
    popup.dim: false

    // workaround iOS https://bugreports.qt.io/browse/QTBUG-61935
    popup.implicitHeight: popup.contentItem.implicitHeight
    // end workaround 61935

    // checking this from Drawer:
    // interactive: !modalMenuOpen
    popup.onAboutToShow: {
        appWindow.modalMenuOpen = true
    }
    popup.onAboutToHide: {
        appWindow.modalMenuOpen = false
    }
}
