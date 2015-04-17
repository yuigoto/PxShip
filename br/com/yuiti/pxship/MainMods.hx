package br.com.yuiti.pxship;

import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;

class Main extends Sprite 
{
    
    public function new() 
    {
        // Super Construtor
        super();
        
        stage.scaleMode = StageScaleMode.SHOW_ALL;
        
        var ship:PxShip = new PxShip();
        stage.addChild(ship);
        ship.x = 96;
        ship.y = 102;
        
        ship.width = ship.width * 2;
        ship.height = ship.height * 2;
        
        var ship2:PxShip = new PxShip();
        stage.addChild(ship2);
        ship2.x = 160;
        ship2.y = 82;
        
        ship2.width = ship2.width * 2;
        ship2.height = ship2.height * 2;
        
        var ship3:PxShip = new PxShip();
        stage.addChild(ship3);
        ship3.x = 224;
        ship3.y = 102;
        
        ship3.width = ship3.width * 2;
        ship3.height = ship3.height * 2;
        
        ship.addEventListener(Event.ENTER_FRAME, rotate);
        ship.addEventListener(MouseEvent.CLICK, exploder);
        ship2.addEventListener(Event.ENTER_FRAME, rotate);
        ship2.addEventListener(MouseEvent.CLICK, exploder);
        ship3.addEventListener(Event.ENTER_FRAME, rotate);
        ship3.addEventListener(MouseEvent.CLICK, exploder);
    }
    
    public function rotate(e:Event):Void 
    {
        if (e.currentTarget != null) {
            if (e.currentTarget.SHIP_DEAD) {
                var xpos:Int = e.currentTarget.x;
                var ypos:Int = e.currentTarget.y;
                e.currentTarget.removeEventListener(Event.ENTER_FRAME, rotate);
                e.currentTarget.removeEventListener(MouseEvent.CLICK, exploder);
                e.currentTarget.parent.removeChild(e.currentTarget);
                e.currentTarget = null;
                remakeShip(xpos, ypos);
            } else {
                //ship.x = mouseX;
                //ship.y = mouseY;
            }
        } else {
            trace('Dead!');
        }
    }
    
    public function exploder(e:MouseEvent):Void 
    {
        e.currentTarget.exploderBlow();
    }
    
    public function remakeShip(xpos:Int, ypos:Int):Void 
    {
        var ship = new PxShip();
        stage.addChild(ship);
        ship.x = xpos;
        ship.y = ypos;
        
        ship.width = ship.width * 2;
        ship.height = ship.height * 2;
        
        ship.addEventListener(Event.ENTER_FRAME, rotate);
        ship.addEventListener(MouseEvent.CLICK, exploder);
    }
}