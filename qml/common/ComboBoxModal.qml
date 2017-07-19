import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ComboBox {
    popup.modal: true
    popup.dim: false
    popup.onAboutToShow: {
        appWindow.modalMenuOpen = true
    }
    popup.onAboutToHide: {
        appWindow.modalMenuOpen = false
    }
}
