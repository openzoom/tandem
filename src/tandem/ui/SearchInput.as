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
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class SearchInput extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    private const PROMPT : String = "Search"
    private const PROMPT_FORMAT : TextFormat = new TextFormat( null, null, 0x666666, null, true )
    private const INPUT_FORMAT : TextFormat  = new TextFormat( null, null, 0x999999, null, false )

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
    public function SearchInput()
    {
        input.text = PROMPT
        hideClearButton()

        addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler )
        addEventListener( KeyboardEvent.KEY_UP, keyUpHandler )

        input.addEventListener( FocusEvent.FOCUS_IN, input_focusInHandler )
        input.addEventListener( FocusEvent.FOCUS_OUT, input_focusOutHandler )

        clearButton.addEventListener( MouseEvent.CLICK, clearButton_mouseClickHandler )
    }

    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------

    public var input : TextField
    public var clearButton : ClearButton

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    private function keyDownHandler( event : KeyboardEvent ) : void
    {
        event.stopImmediatePropagation()

        if( input.length > 0 )
           showClearButton()
        else
           hideClearButton()
    }

    private function keyUpHandler( event : KeyboardEvent ) : void
    {
        event.stopImmediatePropagation()
    }

    private function input_focusInHandler( event : FocusEvent ) : void
    {
        if( input.text == PROMPT )
        {
           input.text = ""
           input.setTextFormat( PROMPT_FORMAT )
        }
    }

    private function input_focusOutHandler( event : FocusEvent ) : void
    {
        if( input.text == "" )
        {
           input.text = PROMPT
           input.setTextFormat( INPUT_FORMAT )
           hideClearButton()
        }
    }

    private function clearButton_mouseClickHandler( event : MouseEvent ) : void
    {
        input.text = ""
        hideClearButton()
    }


    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------

    private function showClearButton() : void
    {
        clearButton.mouseEnabled = true
        Tweener.addTween(
                            clearButton,
                            {
                                alpha: 1,
                                time: 0.5
                            }
                        )
    }

    private function hideClearButton() : void
    {
        clearButton.mouseEnabled = false
        Tweener.addTween(
                            clearButton,
                            {
                                alpha: 0,
                                time: 0.7
                            }
                        )
    }
}

}