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
package tandem.core
{

import caurina.transitions.Tweener;
import caurina.transitions.properties.ColorShortcuts;

import com.adobe.webapis.flickr.FlickrService;
import com.adobe.webapis.flickr.PagedPhotoList;
import com.adobe.webapis.flickr.Photo;
import com.adobe.webapis.flickr.User;
import com.adobe.webapis.flickr.events.FlickrResultEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.system.Security;
import flash.utils.setTimeout;

import tandem.events.TandemEvent;
import tandem.model.ApplicationModel;
import tandem.ui.GlobalNavigation;
import tandem.ui.GlobalNavigationComponent;
import tandem.ui.MemoryIndicator;
import tandem.ui.MemoryIndicatorComponent;
import tandem.ui.Timeline;
import tandem.ui.ZoomNavigator;
import tandem.ui.ZoomViewport;
import tandem.ui.views.StreamView;

    
public class Application extends Sprite
{	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
    * Constructor.
    */
	public function Application()
	{
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true )
    }
       
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------    
    
    private const DEFAULT_USER_ADDRESS : String = "gasi"
    private const DEFAULT_USER_ID : String = "72389028@N00"
    
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------    
    
    private var globalNavigation : GlobalNavigation
    private var memoryIndicator : MemoryIndicator
    private var timeline : Timeline
    
    private var viewport : ZoomViewport
    private var navigator : ZoomNavigator 
    
    private var view : DisplayObject
    

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var numPhotos : int = 363

    // Data Model
    private var model : ApplicationModel = ApplicationModel.getInstance()
    private var done : Boolean = false

    private var page : int = 1
    private var pageSize : int = 500
    private var extras : String = "date_taken"
     
       
    //--------------------------------------------------------------------------
    //
    //  Event Handler: Stage
    //
    //--------------------------------------------------------------------------
    
    private function addedToStageHandler( event : Event ) : void
    {
        // Code in constructor is interpreted by
        // AVM, therefore move processing-intensive code
        // outside, so it can be processed by the JIT compiler
        initialize()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Initialization
    //
    //--------------------------------------------------------------------------
    
    private function initialize() : void
    {
        stage.align = StageAlign.TOP_LEFT
        stage.scaleMode = StageScaleMode.NO_SCALE
        
        initializeLibraries()
        initializeSecurity()
        registerListeners()
        createChildren()
        updateDisplayList()
                  
        model.service = new FlickrService( model.API_KEY )
        model.service.addEventListener( FlickrResultEvent.PEOPLE_GET_PUBLIC_PHOTOS,
                                        getPublicPhotosHandler )
    }
    
    private function initializeSecurity() : void
    {
        // TODO: Smells bad… =(
        Security.loadPolicyFile( "http://static.flickr.com/crossdomain.xml" )
        
        Security.loadPolicyFile( "http://farm1.static.flickr.com/crossdomain.xml" )
        Security.loadPolicyFile( "http://farm2.static.flickr.com/crossdomain.xml" )
        Security.loadPolicyFile( "http://farm3.static.flickr.com/crossdomain.xml" )
        Security.loadPolicyFile( "http://farm4.static.flickr.com/crossdomain.xml" )

        Security.loadPolicyFile( "http://l.yimg.com/crossdomain.xml" )
    }
    
    private function initializeLibraries() : void
    {
        // Tweener
        ColorShortcuts.init()
    }
    
    private function registerListeners() : void
    {
        stage.addEventListener( Event.RESIZE, resizeHandler )
        addEventListener( TandemEvent.APPLICATION_COMPLETE, applicationCompleteHandler )
        
        SWFAddress.addEventListener( SWFAddressEvent.CHANGE, swfAddressChangeHandler )
    }
    
    //--------------------------------------------------------------------------
    //
    //  User Interface
    //
    //--------------------------------------------------------------------------
    
    private function createChildren() : void
    {
        createTimeline()
        createGlobalNavigation()
        createMemoryIndicator()
    }
    
	private function createViewport() : void
	{
		done = false
		model.photos = []
		
		if( view )
		    removeChild( view )
		  
		if( navigator )
		    removeChild( navigator )
		
		// view
        view = new StreamView()
        
		// container
		viewport = new ZoomViewport()
        viewport.view = view
        
        // navigator
        navigator = new ZoomNavigator()
        navigator.model = viewport
        navigator.alpha = 0
        
        // add children to display list
        addChildAt( viewport, 0 )
        addChildAt( view, 1 )
        addChildAt( navigator, 2 )
        
        // call service
        model.service.people.getPublicPhotos( model.user.nsid, extras,
                                              Math.min( pageSize, numPhotos ),
                                              page )
        
        // initial layout
        updateDisplayList()
    }
		
	private function createTimeline() : void
	{
		//timeline = new TimelineComponent()
		//addChild( timeline )
	}
		
	private function createGlobalNavigation() : void
	{
		globalNavigation = new GlobalNavigationComponent()
		addChild( globalNavigation )
	}
	
	private function createMemoryIndicator() : void
	{
		memoryIndicator = new MemoryIndicatorComponent()
		addChild( memoryIndicator )
	}
    
    //--------------------------------------------------------------------------
    //
    //  SWFAdress
    //
    //--------------------------------------------------------------------------
    
    private function swfAddressChangeHandler( event : SWFAddressEvent ) : void
    {    
        var user : String
        var action : String = SWFAddress.getPathNames()[ 0 ]
        var flickrNSIDPattern : RegExp = /[0-9]*@N[0-9]*/
        
        if( action == "photos" )
        {
	        // Long URL, e.g. http://flickr.com/photos/gasi
	        // or http://flickr.com/photos/72389028@N00
        	user = SWFAddress.getPathNames()[ 1 ]
        }
        else
        {
	        // Short URL, e.g. http://flickr.com/gasi
        	user = SWFAddress.getPathNames()[ 0 ]
        }
        
        if( user == null )
        {
			// Default user
            SWFAddress.setValue( "photos/" + DEFAULT_USER_ADDRESS + "/" )
        } 
        else if( flickrNSIDPattern.test( user ) )
        {
        	// Look up Flickr NSID, e.g. 72389028@N00
            model.service.people.getInfo( user )
            model.service.addEventListener( FlickrResultEvent.PEOPLE_GET_INFO, getInfoHandler )
        }
        else
        {
	        // Look up Flickr URL
    		model.service.urls.lookupUser( "http://flickr.com/photos/" + user + "/" )
    		model.service.addEventListener( FlickrResultEvent.URLS_LOOKUP_USER, lookupUserHandler )
        }
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Application
    //
    //--------------------------------------------------------------------------
            
    private function resizeHandler( event : Event ) : void
    {
        updateDisplayList()
    }
    
    private function applicationCompleteHandler( event : Event ) : void
    {
        Tweener.addTween(
                           navigator,
                           {
                               alpha: 1,
                               time: 2,
                               delay: 0.5
                           }
                        )
                        
       updateDisplayList()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Service
    //
    //--------------------------------------------------------------------------
    
    private function getPublicPhotosHandler( event : FlickrResultEvent ) : void
    {
        if( event.success )
        {
            var result : PagedPhotoList = PagedPhotoList( event.data.photos )

            model.photos = model.photos.concat(
                                 result.photos.map(
		                                    function( item : *,
		                                             ...ignored ) : Photo
		                                    {
		                                        return Photo( item )              	
		                                    }
			                     )
			                   )
            
            if( model.photos.length >= Math.min( numPhotos, result.total ) && !done )
            {
                done = true
                
                if( view is StreamView )
                    StreamView( view ).dataProvider = model.photos.slice( 0, numPhotos )
                    
                dispatchEvent( new TandemEvent( TandemEvent.APPLICATION_COMPLETE ) )
            }
            
            if( result.page < result.pages && !done )
            {
                page++
                model.service.people.getPublicPhotos( model.user.nsid, extras, pageSize, page )
            } 
        }           
    }
    
    private function lookupUserHandler( event : FlickrResultEvent ) : void
    {
        if( event.success )
        {
            model.user = User( event.data.user )
            createViewport()
            SWFAddress.setTitle( "tandem — " + model.user.username + " (" + model.user.nsid + ")" )
        }
        else
        {
            // Default
            SWFAddress.setValue( "photos/" + DEFAULT_USER_ADDRESS + "/" )
        }
    }
    
    private function getInfoHandler( event : FlickrResultEvent ) : void
    {
        if( event.success )
        {
            model.user = User( event.data.user )
            createViewport()
            SWFAddress.setTitle( "tandem — " + model.user.username + " (" + model.user.nsid + ")" )
        }
        else
        {
            // Default
            SWFAddress.setValue( "photos/" + DEFAULT_USER_ADDRESS + "/" )
        }
    }
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Layout
    //
    //--------------------------------------------------------------------------
    
	private function updateDisplayList() : void
	{
        // Navigation
        if( globalNavigation )
        {
            globalNavigation.x = 0
            globalNavigation.y = 0
        }
		
        // Viewport
        if( viewport )
        {
            viewport.x = 0
            viewport.y = 0
            viewport.width = stage.stageWidth
            viewport.height = stage.stageHeight
        }
        		
		// Navigator
        if( navigator )
        {
            navigator.x = stage.stageWidth - navigator.width - 12
            navigator.y = 12
        }
	 
		// Timeline
		if( timeline )
		{
			timeline.width = stage.stageWidth
			timeline.y = stage.stageHeight - timeline.height		
		}
		
		// Memory Indicator
		if( memoryIndicator )
		{
            memoryIndicator.x = stage.stageWidth - memoryIndicator.width - 10
            memoryIndicator.y = stage.stageHeight - memoryIndicator.height - 10
		}
	}
}

}