package br.com.yuiti.pxship;

import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;

class Main extends Sprite 
{
    var ship:PxShip;
    
    public function new() 
    {
        // Super Construtor
        super();
        
        // stage.scaleMode = StageScaleMode.SHOW_ALL;
        
        ship = new PxShip();
        stage.addChild(ship);
        ship.x = 200;
        ship.y = 160;
        
        ship.width = ship.width * 1;
        ship.height = ship.height * 1;
        
        ship.addEventListener(Event.ENTER_FRAME, rotate);
        ship.addEventListener(MouseEvent.CLICK, exploder);
    }
    
    public function rotate(e:Event):Void 
    {
        if (ship != null) {
            if (ship.SHIP_DEAD) {
                ship.removeEventListener(Event.ENTER_FRAME, rotate);
                ship.removeEventListener(MouseEvent.CLICK, exploder);
                ship.parent.removeChild(ship);
                ship = null;
                remakeShip();
            } else {
                ship.x = mouseX;
                ship.y = mouseY;
            }
        } else {
            trace('Dead!');
        }
    }
    
    public function exploder(e:MouseEvent):Void 
    {
        ship.exploderBlow();
    }
    
    public function remakeShip():Void 
    {
        ship = new PxShip();
        stage.addChild(ship);
        ship.x = 200;
        ship.y = 160;
        
        ship.width = ship.width * 1;
        ship.height = ship.height * 1;
        
        ship.addEventListener(Event.ENTER_FRAME, rotate);
        ship.addEventListener(MouseEvent.CLICK, exploder);
    }
}