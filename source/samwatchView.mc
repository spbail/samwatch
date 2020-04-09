using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Activity;
using Toybox.ActivityMonitor;


class samwatchView extends WatchUi.WatchFace {

	var customFont = null; 
	var customIcons = null;
	var batteryInt = 0;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        customFont = WatchUi.loadResource(Rez.Fonts.customFont);
        customIcons = WatchUi.loadResource(Rez.Fonts.icoFont);  
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    	setClockDisplay();
  		setDateDisplay();
  
//  		setHeartrateDisplay();
		setCaloriesDisplay();
		setStepcountDisplay();
		setBatteryDisplay(dc);
		
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    private function setClockDisplay() {
  		// Get and show the current time
        var clockTime = System.getClockTime();

        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeDisplay");
        view.setText(timeString);
    }
    
 	private function setDateDisplay() {
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$ $2$ $3$", [today.day_of_week, today.day, today.month]);
        var view = View.findDrawableById("DateDisplay");
        view.setText(dateString);
    }
    
	// Currently not used, not quite clear how the FR45 handles this
 	private function setHeartrateDisplay() {  	
		var heartrateDisplay = View.findDrawableById("HeartrateDisplay");

		var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
		var currentHeartrate = heartrateIterator.next().heartRate;
		
		if(currentHeartrate == ActivityMonitor.INVALID_HR_SAMPLE) {
			heartrateDisplay.setText("---");
		}		
		else {
			heartrateDisplay.setText(currentHeartrate.format("%d"));
		}
    }

    private function setStepcountDisplay() {
    	var stepcountDisplay = View.findDrawableById("StepcountDisplay");   
		var steps = ActivityMonitor.getInfo().steps;		
		if (steps!=null) {   
			stepcountDisplay.setText(steps.format("%d"));
		}
    }
    
  	private function setCaloriesDisplay() {
    	var caloriesDisplay = View.findDrawableById("CaloriesDisplay");   
		var calories = ActivityMonitor.getInfo().calories;		
		if (calories!=null) {   
			caloriesDisplay.setText(calories.format("%d"));
		}
    }
       
 	private function setBatteryDisplay(dc) {  	
    	var battery = System.getSystemStats().battery;				
		var batteryDisplay = View.findDrawableById("BatteryDisplay");      
		batteryDisplay.setText(battery.format("%d")+"%");	
		batteryInt = battery;

		// Change the icon based on battery %
		var batteryIcon = View.findDrawableById("BatteryIcon");
		if (battery>75) {batteryIcon.setText("d");}
		if (battery<=75) {batteryIcon.setText("c");}
		if (battery<=50) {batteryIcon.setText("b");}
		if (battery<=25) {batteryIcon.setText("a");}
    }
}
