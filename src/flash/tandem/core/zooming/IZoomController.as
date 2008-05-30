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
package tandem.core.zooming
{

import flash.display.DisplayObject;
import flash.geom.Rectangle;

public interface IZoomController
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  view
    //----------------------------------

    function get view() : DisplayObject
    function set view( value : DisplayObject ) : void

    //----------------------------------
    //  viewport
    //----------------------------------

    function get viewport() : Rectangle        
    function set viewport( value : Rectangle ) : void
    
    //----------------------------------
    //  model
    //----------------------------------
    
    function get model() : IZoomModel
    function set model( value : IZoomModel ) : void
}

}