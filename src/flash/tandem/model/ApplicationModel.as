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
package tandem.model
{
	
import com.adobe.webapis.flickr.FlickrService;
import com.adobe.webapis.flickr.User;

import flash.events.EventDispatcher;

public class ApplicationModel extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    // If you don't have this file, please adjust api-key-sample.as and rename it!
	include "../api-key.as"	
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
	public var service : FlickrService
	public var photos : Array = []
	public var user : User = new User()
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
	public function ApplicationModel() 
	{   
		if ( instance != null )
			throw new Error( "Hey, I'm a singleton, please don't instantiate me!" )
		 
		instance = this
	}

    //--------------------------------------------------------------------------
    //
    //  Method: Access
    //
    //--------------------------------------------------------------------------
    
    private static var instance : ApplicationModel
    
	public static function getInstance() : ApplicationModel 
	{
		if ( instance == null )
			instance = new ApplicationModel()
		
			return instance
	}
}

}