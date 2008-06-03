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

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Rectangle;

import tandem.core.zooming.IZoomController;
import tandem.core.zooming.IZoomModel;
import tandem.core.zooming.IZoomable;
import tandem.core.zooming.ZoomModel;
import tandem.core.zooming.ZoomModelEvent;
import tandem.core.zooming.controllers.ZoomKeyboardController;
import tandem.core.zooming.controllers.ZoomMouseController;
import tandem.core.zooming.controllers.ZoomTransformationController;

public class ZoomViewport extends Sprite implements IZoomModel
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
	public function ZoomViewport()
	{
		createContentMask()
		createModel()
        createControllers()
	}

    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------    
    
    private var contentMask : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------    
	
    //----------------------------------
    //  model
    //----------------------------------
    
	private var model : IZoomModel
	
	//----------------------------------
    //  view
    //----------------------------------
    
	private var _content : DisplayObject
	
	public function get content() : DisplayObject
	{
		return _content
	}
	
	public function set content( value : DisplayObject ) : void
	{
		if( content == value )
		    return
		    
		_content = value
		
        for each( var controller : IZoomController in controllers )
            controller.view = content
		
		applyContentMask()
		
		if( content is IZoomable )
		    IZoomable( content ).model = model
	}
	
    //----------------------------------
    //  controllers
    //----------------------------------
      	
	public var controllers : Array /* of IZoomController */ = []
	
	private var keyboardController : ZoomKeyboardController
	private var mouseController : ZoomMouseController
	private var transformationController : ZoomTransformationController
    
    //----------------------------------
    //  masked
    //----------------------------------
    
    private var _clipContent : Boolean = true
    
    public function get clipContent() : Boolean
    {
        return _clipContent
    }
    
    public function set clipContent( value : Boolean ) : void
    {
    	if( clipContent == value )
    	   return
    	      
        _clipContent = value
        
        applyContentMask()        
    }
    
    //----------------------------------
    //  keyboardNavigationEnabled
    //----------------------------------
    
    private var _keyboardNavigationEnabled : Boolean = true
    
    public function get keyboardNavigationEnabled() : Boolean
    {
        return _keyboardNavigationEnabled
    }
    
    public function set keyboardNavigationEnabled( value : Boolean ) : void
    {   
    	if( keyboardNavigationEnabled == value )
    	    return
    	    
        _keyboardNavigationEnabled = value
        
        if( keyboardNavigationEnabled )
	       addController( keyboardController )
	    else
	       removeController( keyboardController )
    }
    
    //----------------------------------
    //  mouseNavigationEnabled
    //----------------------------------
    
    private var _mouseNavigationEnabled : Boolean = true
    
    public function get mouseNavigationEnabled() : Boolean
    {
        return _mouseNavigationEnabled
    }
    
    public function set mouseNavigationEnabled( value : Boolean ) : void
    {      
        if( mouseNavigationEnabled == value )
            return
            
        _mouseNavigationEnabled = value
        
        if( mouseNavigationEnabled )
           addController( mouseController )
        else
           removeController( mouseController )         
    }
    
    //----------------------------------
    //  enabled
    //----------------------------------
    
    private var _enabled : Boolean = true
    
    public function get enabled() : Boolean
    {
        return _enabled
    }
    
    public function set enabled( value : Boolean ) : void
    {         
        if( enabled == value )
            return
            
        _enabled = value    
        
        if( enabled )
           addController( transformationController )
        else
           removeController( transformationController )
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------
        
    public function get zoom() : Number
    {
    	return model.zoom
    }
    
    //----------------------------------
    //  minZoom
    //----------------------------------
    
    public function get minZoom() : Number
    {
        return model.minZoom
    }
    
    public function set minZoom( value : Number ) : void
    {
        model.minZoom = value
    }
    
    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    public function get maxZoom() : Number
    {
        return model.maxZoom
    }
    
    public function set maxZoom( value : Number ) : void
    {
        model.maxZoom = value
    }
    
    //----------------------------------
    //  viewport
    //----------------------------------
   
    public function get viewport() : Rectangle
    {
        return model.viewport
    }
      
    //----------------------------------
    //  viewAspectRatio
    //----------------------------------
      
    public function get viewAspectRatio() : Number
    {
        return model.viewAspectRatio
    }
    
    public function set viewAspectRatio( value : Number ) : void
    {
        model.viewAspectRatio = value
    }

    //----------------------------------
    //  viewportAspectRatio
    //----------------------------------
 
    public function get viewportAspectRatio() : Number
    {
        return model.viewAspectRatio
    }
    
    public function set viewportAspectRatio( value : Number ) : void
    {
    	model.viewAspectRatio = value
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------
    
    public function zoomBy( value : Number = 1.5, originX : Number = 0.5,
                            originY : Number = 0.5  ) : void
    {
    	model.zoomBy( value, originX / viewport.width, originY / viewport.height )
    }
    
    public function zoomTo( value : Number, originX : Number = 0.5,
                            originY : Number = 0.5  ) : void
    {
        model.zoomTo( value, originX / viewport.width, originY / viewport.height )	
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------
    
    public function moveTo( x : Number, y : Number ) : void
    {
        model.moveTo( x / content.width, y / content.height )	
    }
    
    public function moveBy( x : Number, y : Number ) : void
    {
    	model.moveBy( x / content.width, y / content.height )
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  x
    //----------------------------------    
 
    override public function get x() : Number
    {
        return super.x
    }
    
    override public function set x( value : Number ) : void
    {
    	if( super.x == value )
    	   return
    	
    	super.x = value
    	
    	for each( var controller : IZoomController in controllers )
        {
	        var viewport : Rectangle = controller.viewport
	            viewport.x = value
	            
	        controller.viewport = viewport
        }
    }

    //----------------------------------
    //  y
    //----------------------------------
    
    override public function get y() : Number
    {
        return super.y
    }
    
    override public function set y( value : Number ) : void
    {
        if( super.y == value )
           return
        
        super.y = value
        
        for each( var controller : IZoomController in controllers )
        {
            var viewport : Rectangle = controller.viewport
                viewport.y = value
                
            controller.viewport = viewport
        }
    }
    
    //----------------------------------
    //  width
    //----------------------------------    

    override public function get width() : Number
    {
        return contentMask.width    
    }
    
    override public function set width( value : Number ) : void
    {
        if( contentMask.width == value )
           return
        
        contentMask.width = value
        
        for each( var controller : IZoomController in controllers )
        {
            var viewport : Rectangle = controller.viewport
                viewport.width = value
                
            controller.viewport = viewport
        } 
    }
    
    //----------------------------------
    //  height
    //----------------------------------    

    override public function get height() : Number
    {
        return contentMask.height
    }
    
    override public function set height( value : Number ) : void
    {
        if( contentMask.height == value )
           return
        
        contentMask.height = value
        
        for each( var controller : IZoomController in controllers )
        {
            var viewport : Rectangle = controller.viewport
                viewport.height = value
                
            controller.viewport = viewport
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function model_changeHandler( event : ZoomModelEvent ) : void
    {
        dispatchEvent( event.clone() )	
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function createContentMask() : void
    {
        contentMask = new Shape()
        contentMask.graphics.beginFill( 0x000000, 0 )
        contentMask.graphics.drawRect( 0, 0, 100, 100 )
        contentMask.graphics.endFill()
        
        addChild( contentMask )
    }
    
    private function createModel() : void
    {
        model = new ZoomModel()
        model.addEventListener( ZoomModelEvent.CHANGE, model_changeHandler, false, 0, true )
    } 
       
    private function createControllers() : void
    {
        keyboardController = new ZoomKeyboardController()
        mouseController = new ZoomMouseController()
        transformationController = new ZoomTransformationController()
        
        controllers = [ keyboardController, mouseController, transformationController ]
        
        for each( var controller : IZoomController in controllers )
            controller.model = model
    }
    
    private function addController( controller : IZoomController ) : Boolean
    {
        if( controllers.indexOf( controller ) != -1 )
           return false
           
        controllers.push( controller )
        controller.model = model
        return true 
    }
    
    private function removeController( controller : IZoomController ) : Boolean
    {
        if( controllers.indexOf( controller ) == -1 )
           return false
           
        controllers.splice( controllers.indexOf( controller ), 1 )
        controller.model = null
        controller.view = null
        return true 
    }
    
    private function applyContentMask() : void
    {
        if( content )
            content.mask = clipContent ? contentMask : null  
    }
}

}