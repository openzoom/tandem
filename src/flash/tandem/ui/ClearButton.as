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
import flash.events.MouseEvent;

public class ClearButton extends Sprite
{	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
	public function ClearButton()
	{
        buttonMode = true
        mouseOutHandler( null )
        addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler )
        addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler )
	}
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function mouseOverHandler( event : MouseEvent ) : void
    {
        Tweener.addTween(
                            this,
                            {
                                _color: 0xBBBBBB,
                                time: 0.4                         
                            }
                        )
    }
    
    private function mouseOutHandler( event : MouseEvent ) : void
    {
        Tweener.addTween(
                            this,
                            {
                                _color: 0x777777,
                                time: 0.3                         
                            }
                        )
    }
}

}