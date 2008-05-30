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

public class Timeline extends Sprite
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	/**
	 * Constructor.
	 */
	public function Timeline() : void
	{
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler )
	}
	
	//--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------
    
	public var background : Sprite
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------
	private function addedToStageHandler( event : Event ) : void
	{
		stage.addEventListener( Event.RESIZE, resizeHandler )
	}
	
	private function resizeHandler( event : Event ) : void
	{
		updateDisplayList()
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Layout
    //
    //--------------------------------------------------------------------------
    
	private function updateDisplayList() : void
	{
        // layout component	
	}
}

}