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

import tandem.core.IZoomable;
import tandem.core.ZoomController;
import tandem.core.ZoomModel;

public class ZoomContainer extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
	public function ZoomContainer()
	{
		background = new Shape()
		background.graphics.beginFill( 0x000000, 0 )
		background.graphics.drawRect( 0, 0, 100, 100 )
		background.graphics.endFill()
		
		addChild( background )
		
		_model = new ZoomModel()
		
		controller = new ZoomController()
		controller.model = model
	}
    
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------    
    
    private var background : Shape
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------    
	
    //----------------------------------
    //  model
    //----------------------------------
    	
	private var _model : ZoomModel
	   
    public function get model() : ZoomModel
    {
        return _model
    }
	
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
		_view = value
		
		controller.view = view
		
		masked = masked
		
		if( view is IZoomable )
		    IZoomable( view ).model = model
	}
	
    //----------------------------------
    //  controller
    //----------------------------------
      	
	private var controller : ZoomController
    
    //----------------------------------
    //  masked
    //----------------------------------
    
    private var _masked : Boolean = true
    
    public function get masked() : Boolean
    {
        return _masked
    }
    
    public function set masked( value : Boolean ) : void
    {   
        _masked = value
        
        if( view )
            view.mask = masked ? background : null        	
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
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
    	
        var viewport : Rectangle = controller.viewport
            viewport.x = value
        
        controller.viewport = viewport
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
        
        var viewport : Rectangle = controller.viewport
            viewport.y = value
        
        controller.viewport = viewport
    }
    
    //----------------------------------
    //  width
    //----------------------------------    

    override public function get width() : Number
    {
        return background.width    
    }
    
    override public function set width( value : Number ) : void
    {
        if( background.width == value )
           return
        
        background.width = value
        
        var viewport : Rectangle = controller.viewport
            viewport.width = value
        
        controller.viewport = viewport  
    }
    
    //----------------------------------
    //  height
    //----------------------------------    

    override public function get height() : Number
    {
        return background.height
    }
    
    override public function set height( value : Number ) : void
    {
        if( background.height == value )
           return
        
        background.height = value
        
        var viewport : Rectangle = controller.viewport
            viewport.height = value
        
        controller.viewport = viewport  
    }
}

}