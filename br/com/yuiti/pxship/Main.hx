package br.com.yuiti.pxship;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import openfl.Assets;

/**
 * PxShip :: Procedural Pixelated Spaceship Generator
 * ==================================================
 * 
 * Based on "Pixel Spaceships", by Dave Bollinger, but this one uses a 
 * different mask for the ships, as to avoid copyright problems. :)
 * 
 * I've also added a sprite exploder example.
 * 
 * Instructions are in portuguese, though. :P
 * 
 * Projeto baseado em "Pixel Spaceships" de Dave Bollinger (2006).
 * 
 * Gerador de espaçonaves estilo 8-bit, com base em um mapa de pixels 
 * pré-definidos.
 * 
 * Muito do código é baseado em uma versão HTML5 do gerador criada pelo 
 * programador "mtheall".
 * 
 * A grade de píxels utilizada neste projeto, porém, é de autoria minha.
 * 
 * @author Fabio Yuiti Goto <lab@yuiti.com.br>
 * @version 1.0
 */
class Main extends Sprite 
{
    var bg0:BitmapData;
    var bg1:BitmapData;
    var bg2:BitmapData;
    var wt0:Bitmap;
    var cl1:Bitmap;
    var cl2:Bitmap;
    
    public function new() 
    {
        // Super Construtor
        super();
        
        stage.scaleMode = StageScaleMode.NO_BORDER;
        
        // Carregando bg
        bg0 = Assets.getBitmapData("img/water.png");
        bg1 = Assets.getBitmapData("img/c1.png");
        bg2 = Assets.getBitmapData("img/c2.png");
        
        wt0 = new Bitmap(bg0);
        cl1 = new Bitmap(bg1);
        cl2 = new Bitmap(bg2);
        
        wt0.width = wt0.width;
        wt0.height = wt0.height;
        
        cl1.width = cl1.width;
        cl1.height = cl1.height;
        
        cl2.width = cl2.width;
        cl2.height = cl2.height;
        
        
        wt0.y = -180;
        cl1.y = -180;
        cl2.y = -180;
        
        addChild(wt0);
        addChild(cl1);
        addChild(cl2);
        
        wt0.addEventListener(Event.ENTER_FRAME, move0);
        cl1.addEventListener(Event.ENTER_FRAME, move1);
        cl2.addEventListener(Event.ENTER_FRAME, move2);
        
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
    
    public function move0(e:Event):Void 
    {
        wt0.y += 1;
        
        if (wt0.y >= 0) {
            wt0.y = -180;
        }
    }
    
    public function move1(e:Event):Void 
    {
        cl1.y += 4;
        
        if (cl1.y >= 0) {
            cl1.y = -180;
        }
    }
    
    public function move2(e:Event):Void 
    {
        cl2.y += 8;
        
        if (cl2.y >= 0) {
            cl2.y = -180;
        }
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