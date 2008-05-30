////////////////////////////////////////////////////////////////////////////////
//
//  tandem. explore your world.
//  Copyright (c) 2008 Daniel Gasienica (daniel@gasienica.ch)
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
package
{

import com.adobe.viewsource.ViewSource;

import flash.display.Sprite;

import org.hasseg.externalMouseWheel.ExternalMouseWheelSupport;

import tandem.core.Application;

/**
* Bootstrapper
*/
[SWF(width="900", height="600", frameRate="60", backgroundColor="#222222")]
public class tandem extends Sprite
{    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    	
	public function tandem()
	{
        // enable Mac OS X mouse wheel support
        ExternalMouseWheelSupport.getInstance( stage )

		// instantiate tandem
		application = new Application()
		
		// enable view source
        ViewSource.addMenuItem( application, "source/index.html" )

        // go, go, go!
        addChild( application )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------    
    
    private var application : Application
}
	
}