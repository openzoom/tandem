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

import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Rectangle;

import tandem.core.zooming.IZoomController;
import tandem.core.zooming.IZoomModel;
import tandem.core.zooming.ZoomModelEvent;

/* abstract */ public class AbstractZoomController implements IZoomController
{	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
    * Constructor.
    */
	public function AbstractZoomController() : void
	{
		// AbstractZoomController is an abstract class. 
        // Please extend it with your own, concrete Controller.
	}
		
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  view
    //----------------------------------
    
    private var _view : DisplayObject
    
	public function get view() : DisplayObject
	{
		return _view
	}
	
	public function set view( value : DisplayObject ) : void
	{	
		if( view == value )
		    return	 
		
		_view = value
	    
	    if( view == null )
	    {
	       view_removedFromStageHandler( null )
	       return
	    }
		
        view.addEventListener( Event.ADDED_TO_STAGE, view_addedToStageHandler,
                               false, 0, true )
        view.addEventListener( Event.REMOVED_FROM_STAGE, view_removedFromStageHandler,
                               false, 0, true )
        
        if( view.stage )
            view_addedToStageHandler( null )			
        
        model.viewAspectRatio = view.width / view.height
	}
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : Rectangle = new Rectangle( 0, 0, 100, 100 )
    
    public function get viewport() : Rectangle
    {
    	return _viewport.clone()
    }
        
    public function set viewport( value : Rectangle ) : void
    {
        _viewport = value
        
        if( model )
            model.viewportAspectRatio = _viewport.width / _viewport.height
    }
    
    //----------------------------------
    //  model
    //----------------------------------
    
    private var _model : IZoomModel
    
	public function get model() : IZoomModel
	{
		return _model
	}
	
	public function set model( value : IZoomModel ) : void
	{
		if( model == value )
		    return
		 
		_model = value
		
		if( model )
            model.addEventListener( ZoomModelEvent.CHANGE, model_changeHandler, false, 0, true )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Abstract Event Handlers
    //
    //--------------------------------------------------------------------------
    
    protected function view_addedToStageHandler( event : Event ) : void
    {
    }
    
    protected function view_removedFromStageHandler( event : Event ) : void
    {
    }
	
	protected function model_changeHandler( event : ZoomModelEvent ) : void
	{
	}
}

}