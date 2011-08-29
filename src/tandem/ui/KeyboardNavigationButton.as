////////////////////////////////////////////////////////////////////////////////
//
//  tandem. explore your world.
//  Copyright (c) 2007–2008 Daniel Gasienica (daniel@gasienica.ch)
//
//  tandem is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  tandem is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with tandem. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package tandem.ui
{

import caurina.transitions.Tweener;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class KeyboardNavigationButton extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
    public function KeyboardNavigationButton()
    {
        enabled = true
        mouseOutHandler( null )
        addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler )
        addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler )
    }

    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------

    public var label : TextField

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    private function addedToStageHandler( event : Event ) : void
    {
        addEventListener( MouseEvent.CLICK, clickHandler )
        addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler )
        addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler )
        stage.addEventListener( Event.MOUSE_LEAVE, stage_mouseLeaveHandler )
    }

    private function removedFromStageHandler( event : Event ) : void
    {
        removeEventListener( MouseEvent.CLICK, clickHandler )
        removeEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler )
        removeEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler )
        stage.removeEventListener( Event.MOUSE_LEAVE, stage_mouseLeaveHandler )
    }

    private function clickHandler( event : MouseEvent ) : void
    {
        enabled = false

        Tweener.addTween(
                            this,
                            {
                                alpha: 0,
                                time: 2
                            }
                        )
    }

    private function mouseOverHandler( event : MouseEvent ) : void
    {
        Tweener.addTween(
                            label,
                            {
                                _color: 0xBBBBBB,
                                time: 0.4
                            }
                        )
    }

    private function mouseOutHandler( event : MouseEvent ) : void
    {
        Tweener.addTween(
                            label,
                            {
                                _color: 0x777777,
                                time: 0.3
                            }
                        )
    }

    private function stage_mouseLeaveHandler( event : Event ) : void
    {
        enabled = true

        Tweener.addTween(
                            this,
                            {
                                alpha: 1,
                                time: 2
                            }
                        )
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

    private var _enabled : Boolean = false

    private function get enabled() : Boolean
    {
        return _enabled
    }

    private function set enabled( value : Boolean ) : void
    {
        buttonMode = value
        mouseEnabled = value
        mouseChildren = false
    }
}

}