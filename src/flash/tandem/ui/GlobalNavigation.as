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
	
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class GlobalNavigation extends Sprite
{	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
    * Constructor.
    */
	public function GlobalNavigation()
	{
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------
    
    public var logo : Sprite
    public var background : Sprite
    public var fullScreenButton : MovieClip
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
	private function addedToStageHandler( event : Event ) : void
	{
		stage.addEventListener( Event.RESIZE, resizeHandler )
		
		fullScreenButton.addEventListener( MouseEvent.CLICK, fullScreenClickHandler )
	 	
	 	// layout
	 	updateDisplayList()
	}
	
	private function resizeHandler( event : Event ) : void
	{	
		updateDisplayList()
	}
	
    private function fullScreenClickHandler( event : MouseEvent ) : void
    {
        toggleFullScreen()
    }
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	private function updateDisplayList() : void
	{	
		background.width = stage.stageWidth
		
		fullScreenButton.x = stage.stageWidth - 40 /* fullScreenButton.width */ - 6
		fullScreenButton.y = 6
	}
	
	private function toggleFullScreen() : void
	{ 
        if( stage.displayState == StageDisplayState.FULL_SCREEN )
        {
            stage.displayState = StageDisplayState.NORMAL
            dispatchEvent( new Event( Event.RESIZE ) )
        }
        else
        {
            stage.displayState = StageDisplayState.FULL_SCREEN
            dispatchEvent( new Event( Event.RESIZE ) )          
        }
        
        updateDisplayList()
	}
}

}