////////////////////////////////////////////////////////////////////////////////
//
//  tandem. explore your world.
//  Copyright (c) 2007–2008 Daniel Gasienica (daniel@gasienica.ch)
//
//  The IZoomModel interface is inspired by the work of
//  Rick Companje, http://www.companje.nl/
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
package tandem.core.zooming
{

import flash.events.IEventDispatcher;
import flash.geom.Rectangle;

public interface IZoomModel extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------
        
    function get zoom() : Number
    
    //----------------------------------
    //  minZoom
    //----------------------------------
    
    function get minZoom() : Number
    function set minZoom( value : Number ) : void
    
    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    function get maxZoom() : Number
    function set maxZoom( value : Number ) : void
    
    //----------------------------------
    //  viewport
    //----------------------------------
   
    function get viewport() : Rectangle
      
    //----------------------------------
    //  viewAspectRatio
    //----------------------------------
      
    function get viewAspectRatio() : Number
    function set viewAspectRatio( value : Number ) : void

    //----------------------------------
    //  viewportAspectRatio
    //----------------------------------
 
    function get viewportAspectRatio() : Number
    function set viewportAspectRatio( value : Number ) : void
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------
    
    function zoomBy( value : Number = 1.5, originX : Number = 0.5, originY : Number = 0.5  ) : void
    function zoomTo( value : Number, originX : Number = 0.5, originY : Number = 0.5  ) : void

    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------
    
    function moveTo( x : Number, y : Number ) : void
    function moveBy( x : Number, y : Number ) : void
}

}