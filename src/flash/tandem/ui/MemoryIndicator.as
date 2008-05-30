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

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.text.TextField;


public class MemoryIndicator extends Sprite
{	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
	public function MemoryIndicator()
	{
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler )
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
		stage.addEventListener( Event.ENTER_FRAME, enterFrameHandler,
		                        false, 0, true )
	}
	
	private function enterFrameHandler( event : Event ) : void
	{
		label.text = ( System.totalMemory / 1024 / 1024 ).toFixed( 2 )
		                 .toString() + "MB"
	}
}

}