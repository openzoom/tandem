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
package tandem.core.zooming.controllers
{
	
import caurina.transitions.Tweener;

import flash.events.Event;
import flash.geom.Rectangle;

import tandem.core.zooming.ZoomModelEvent;
import tandem.events.TandemEvent;
	
public class ZoomTransformationController extends AbstractZoomController
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------    
    
    private const TRANSITION_TYPE : String = "easeOutSine"
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
    public function ZoomTransformationController()
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    public var duration : Number = 0.4
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    override protected function view_addedToStageHandler( event : Event ) : void
    {
        view.addEventListener( TandemEvent.RESIZE, view_resizeHandler )
    }
    
    override protected function view_removedFromStageHandler( event : Event ) : void
    {
        view.removeEventListener( TandemEvent.RESIZE, view_resizeHandler )
    }
    
    override protected function model_changeHandler( event : ZoomModelEvent ) : void
    {
        if( view )
        {
            var modelViewport : Rectangle = model.viewport
            
            var newWidth : Number = viewport.width / modelViewport.width
            var newHeight : Number = viewport.height / modelViewport.height
            var newX : Number = viewport.x - modelViewport.x * newWidth
            var newY : Number = viewport.y - modelViewport.y * newHeight

            if( newX - viewport.x > 0 )
                newX = viewport.x + ( viewport.width - newWidth ) / 2
            
            if( newY - viewport.y > 0 )
                newY = viewport.y + ( viewport.height - newHeight ) / 2

            Tweener.addTween(
                               view,
                               {
                                    width: newWidth,
                                    height: newHeight,
                                    x: newX,
                                    y: newY,
                                    time: duration,
                                    transition: TRANSITION_TYPE
                               }
                            )
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function view_resizeHandler( event : Event ) : void
    {
    	model.viewAspectRatio = view.width / view.height   	
    }
}

}