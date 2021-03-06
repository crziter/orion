/*
 * Copyright © 2015-2016 Antti Lamminsalo
 *
 * This file is part of Orion.
 *
 * Orion is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * You should have received a copy of the GNU General Public License
 * along with Orion.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.5
import "../styles.js" as Styles

Rectangle {
    property var entries //QStringList
    property var names: []
    property var selectedItem
    property bool open: list.visible

    id: root

    signal indexChanged(int index)

    function select(item){
        if (item && selectedItem !== item){
            selectedItem = item
            label.text = selectedItem.str

            indexChanged(selectedItem.index)
        }
    }

    function close(){
        list.visible = false
    }

    function setIndex(index){
        label.text = names[index]
    }

    //clip: true
    color: Styles.shadeColor

    Rectangle {
        id: rect
        color: "transparent"
        width: root.width
        height: root.height
        border {
            color: Styles.border
            width: dp(1)
        }
        anchors {
            verticalCenter: parent.verticalCenter
        }

        Text {
            id: label
            text: "-"
            anchors.centerIn: parent
            color: Styles.textColor
            font.pixelSize: Styles.titleFont.extrasmall
            font.bold: true
            ////renderType: Text.NativeRendering
        }
    }


    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            list.visible = !list.visible
        }

        onHoveredChanged: {
            rect.border.color = containsMouse ? Styles.textColor : Styles.border
        }
    }

    onEntriesChanged: {
        console.log("Setting new entries")
        srcModel.clear()
        for (var i = entries.length - 1; i > -1; i--){
            if (entries[i] && entries[i].length > 0){
                srcModel.append( { "itemIndex": i})
            }
        }
    }

    ListView {

        property var hoveredItem

        id: list
        interactive: false
        anchors {
            bottom: rect.top
        }

        width: dp(90)
        height: srcModel.count * root.height

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (list.itemAt(mouseX, mouseY)){
                    list.currentIndex = list.indexAt(mouseX, mouseY)
                    select(list.currentItem)
                }

                list.visible = false
            }

            onPositionChanged: {
                var item = list.itemAt(mouseX, mouseY)
                if (item && list.hoveredItem !== item){
                    if (list.hoveredItem)
                        list.hoveredItem.color = Styles.shadeColor
                    item.color = Styles.ribbonHighlight
                    list.hoveredItem = item
                }
            }
        }

        visible: false

        model: ListModel {
            id: srcModel
        }
        delegate: Rectangle {
            property int index: itemIndex
            property string str: names[index] ? names[index] : ""
            width: root.width
            height: root.height

            color: Styles.shadeColor

            Text {
                text: parent.str
                anchors.centerIn: parent
                color: Styles.textColor
                font.pixelSize: Styles.titleFont.smaller
            }
        }
    }
}
