package br.com.yuiti.pxship;

// Importando bibliotecas
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import motion.Actuate;
import motion.easing.Quad;

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
class PxShip extends Sprite 
{
    /* CONSTANTES DO SPRITE
     * ================================================== */
    
    /**
     * Flag para células vazias.
     */
    private var FLAG_VOID:Int = 0;
    
    /**
     * Flag para células sólidas (bordas).
     */
    private var FLAG_FILL:Int = 1;
    
    /**
     * Flag para células do corpo.
     */
    private var FLAG_BODY:Int = 2;
    
    /**
     * Flag para células do cockpit da nave.
     */
    private var FLAG_PANE:Int = 3;
    
    /**
     * Flag para células dos jatos/thrusters da nave.
     */
    private var FLAG_JETS:Int = 4;
    
    /**
     * Largura do sprite, em píxels.
     */
    private var SPRITE_W = 16;
    
    /**
     * Altura do sprite, em píxels.
     */
    private var SPRITE_H = 16;
    
    
    
    /* ARRAYS PRÉ-DEFINIDOS (PARA COLORAÇÃO)
     * ================================================== */
    
    /**
     * Array contendo os valores de saturação para as cores da nave.
     */
    private var SATURATION:Array<Int> = [
        20, 30, 35, 40, 45, 50, 55, 60, 60, 55, 50, 45, 40, 35, 30, 20
    ];
    
    /**
     * Array contendo os valores de brilho para as cores da nave.
     */
    private var BRIGHTNESS:Array<Int> = [
        40, 45, 50, 55, 60, 65, 70, 80, 80, 70, 65, 60, 55, 50, 45, 40
    ];
    
    
    
    /* ARRAYS COM PRÉ-DEFINIÇÕES DE CÉLULAS
     * ================================================== */
    
    /**
     * Contém pré-definições de células sólidas da nave, representadas pelo 
     * número de index do array de píxels do sprite.
     * 
     * Os valores são definidos pelo construtor.
     */
    private var CELL_FILL:Array<Int>;
    
    /**
     * Contém pré-definições de células do corpo da nave, representadas pelo 
     * número de index do array de píxels do sprite.
     * 
     * Os valores são definidos pelo construtor.
     */
    private var CELL_BODY:Array<Int>;
    
    /**
     * Contém pré-definições de células do cockpit da nave, representadas pelo 
     * número de index do array de píxels do sprite.
     * 
     * Os valores são definidos pelo construtor.
     */
    private var CELL_PANE:Array<Int>;
    
    /**
     * Contém pré-definições de células dos jatos da nave, representadas pelo 
     * número de index do array de píxels do sprite.
     * 
     * Os valores são definidos pelo construtor.
     */
    private var CELL_JETS:Array<Int>;
    
    /**
     * Utilizado na construção do sprite, armazena todos os valores do index de 
     * píxels do sprite.
     */
    private var SHIP_DATA:Array<Int>;
    
    
    
    /* SEED
     * ================================================== */
    
    /**
     * Semente pseudo-aleatória, utilizada na construção do corpo da nave.
     * 
     * Definido no construtor.
     */
    private var SEED_MAIN:Int;
    
    /**
     * Semente pseudo-aleatória, utilizada na definição de cores da nave.
     * 
     * Definido no construtor.
     */
    private var SEED_TINT:Int;
    
    
    
    /* WRAPPERS E CONTAINERS
     * ================================================== */
    
    /**
     * Container para sprite, partículas e exploder.
     */
    private var WRAP:MovieClip;
    
    /**
     * Container para o sprite.
     */
    private var SHIP:MovieClip;
    
    /**
     * Container para partículas.
     */
    private var PARTICLE:MovieClip;
    
    /**
     * Container para os píxels da explosão.
     */
    private var EXPLODER:MovieClip;
    
    /**
     * Handle para BitmapData. Utilizado ao gerar os píxels da explosão.
     */
    private var BITMAP:BitmapData;
    
    
    
    /* VALORES ACESSÍVEIS
     * ================================================== */
    
    /**
     * Handle para HP da nave.
     * 
     * Valor inicializado pelo construtor ou definido por método interno.
     */
    public var SHIP_HP:Int;
    
    /**
     * Booleana, indica se a nave está "morta" (HP = 0) ou não.
     */
    public var SHIP_DEAD:Bool = false;
    
    /**
     * Handle para velocidade de movimento da nave, em ponto flutuante.
     */
    public var SHIP_SPEED:Float = 0;
    
    
    
    /* CONSTRUTOR
     * ================================================== */
    
    /**
     * Construtor da classe.
     */
    public function new() 
    {
        // Super construtor
        super();
        
        // Definindo seed
        SEED_MAIN = seed();
        SEED_TINT = seed();
        
        // Definindo indexes de células sólidas
        CELL_FILL = [
            cell(7,  5), cell(6,  6), cell(7,  6), 
            cell(6,  7), cell(7, 10), cell(6, 11), 
            cell(7, 11), cell(6, 12)
        ];
        
        // Definindo indexes de células do corpo
        CELL_BODY = [
            cell(7,  1), cell(7,  2), cell(7,  3), 
            cell(6,  4), cell(7,  4), cell(5,  5), 
            cell(6,  5), cell(5,  6), cell(4,  7), 
            cell(5,  7), cell(3,  8), cell(4,  8), 
            cell(5,  8), cell(2,  9), cell(3,  9), 
            cell(4,  9), cell(5,  9), cell(1, 10), 
            cell(2, 10), cell(3, 10), cell(4, 10), 
            cell(5, 10), cell(2, 11), cell(3, 11), 
            cell(4, 11), cell(5, 11), cell(4, 12), 
            cell(5, 12), cell(5, 13)
        ];
        
        // Definindo indexes de células do cockpit
        CELL_PANE = [
            cell(7,  7), cell(6,  8), cell(7,  8), 
            cell(6,  9), cell(7,  9), cell(6, 10)
        ];
        
        // Definindo indexes de células dos jatos
        CELL_JETS = [
            cell(7, 12), cell(6, 13), cell(7, 13), 
            cell(6, 14)
        ];
        
        // Definindo valor da velocidade da nave
        SHIP_SPEED = rand(1, 10) * 1.0;
        
        // Gerando nave
        generate();
    }
    
    
    
    /* GERADOR DE SPRITE
     * ================================================== */
    
    /**
     * Gerador do sprite.
     */
    public function generate():Void 
    {
        // Inicializando wrapper
        WRAP = new MovieClip();
        
        // Inicializando container
        SHIP = new MovieClip();
        
        // Inicializando array de dadps
        SHIP_DATA = new Array<Int>();
        
        // Definindo index final de píxels para marcação
        var area:Int = SPRITE_W * SPRITE_H;
        
        // Marcando todas as células como vazias
        for (i in 0...area) {
            SHIP_DATA[i] = FLAG_VOID;
        }
        
        // Marcando células sólidas permanentes
        for (i in 0...Lambda.count(CELL_FILL)) {
            SHIP_DATA[CELL_FILL[i]] = FLAG_FILL;
        }
        
        // Marcando células no corpo da nave
        for (i in 0...Lambda.count(CELL_BODY)) {
            if ((SEED_MAIN & (1 << i)) > 0) {
                SHIP_DATA[CELL_BODY[i]] = FLAG_BODY;
            } else {
                SHIP_DATA[CELL_BODY[i]] = FLAG_VOID;
            }
        }
        
        // Marcando células no cockpit da nave
        for (i in 0...Lambda.count(CELL_PANE)) {
            if ((SEED_MAIN & (1 << (Lambda.count(CELL_PANE) + i))) > 0) {
                SHIP_DATA[CELL_PANE[i]] = FLAG_BODY;
            } else {
                SHIP_DATA[CELL_PANE[i]] = FLAG_PANE;
            }
        }
        
        // Marcando células dos jatos da nave
        for (i in 0...Lambda.count(CELL_JETS)) {
            if ((SEED_MAIN & (1 << (Lambda.count(CELL_JETS) + i))) > 0) {
                SHIP_DATA[CELL_JETS[i]] = FLAG_JETS;
            } else {
                SHIP_DATA[CELL_JETS[i]] = FLAG_PANE;
            }
        }
        
        // Definindo borda da nave
        for (y in 0...SPRITE_H) {
            for (x in 0...Math.floor(SPRITE_W / 2)) {
                // Se a célula atual fizer parte do corpo, cockpit ou jatos
                if (
                    SHIP_DATA[cell(x, y)] == FLAG_BODY 
                    || SHIP_DATA[cell(x, y)] == FLAG_PANE 
                    || SHIP_DATA[cell(x, y)] == FLAG_JETS 
                ) {
                    // Define borda no topo
                    if (y > 0 && SHIP_DATA[cell(x, y - 1)] == FLAG_VOID) {
                        SHIP_DATA[cell(x, y - 1)] = FLAG_FILL;
                    }
                    
                    // Define borda esquerda
                    if (y > 0 && SHIP_DATA[cell(x - 1, y)] == FLAG_VOID) {
                        SHIP_DATA[cell(x - 1, y)] = FLAG_FILL;
                    }
                    
                    // Define borda direita
                    if (
                        x < Math.floor(SPRITE_W / 2) - 1 
                        && SHIP_DATA[cell(x + 1, y)] == FLAG_VOID
                    ) {
                        SHIP_DATA[cell(x + 1, y)] = FLAG_FILL;
                    }
                    
                    // Define borda embaixo
                    if (y < SPRITE_H && SHIP_DATA[cell(x, y + 1)] == FLAG_VOID) {
                        SHIP_DATA[cell(x, y + 1)] = FLAG_FILL;
                    }
                }
            }
        }
        
        // Colorindo os píxels
        for (y in 0...SPRITE_H) {
            for (x in 0...Math.floor(SPRITE_W / 2)) {
                // Se a célula não for VOID (vazia)
                if (SHIP_DATA[cell(x, y)] != FLAG_VOID) {
                    // Definindo cor do píxel atual
                    if (SHIP_DATA[cell(x, y)] == FLAG_FILL) {
                        // Define a cor da borda
                        var tint = 0x111111;
                        
                        // Inicializando preenchimento
                        SHIP.graphics.beginFill(tint, 1);
                    } else if (SHIP_DATA[cell(x, y)] == FLAG_BODY) {
                        // Define cor do corpo
                        var tint = tintBody(x, y);
                        
                        // Inicializando preenchimento
                        SHIP.graphics.beginFill(tint, 1);
                    } else if (SHIP_DATA[cell(x, y)] == FLAG_PANE) {
                        // Define cor do corpo
                        var tint = tintPane(x, y);
                        
                        // Inicializando preenchimento
                        SHIP.graphics.beginFill(tint, 1);
                    } else if (SHIP_DATA[cell(x, y)] == FLAG_JETS) {
                        // Define cor do corpo
                        var tint = tintJets(x, y);
                        
                        // Inicializando preenchimento
                        SHIP.graphics.beginFill(tint, 1);
                    }
                    
                    // Desenhando píxel
                    SHIP.graphics.drawRect(
                        x, 
                        y, 
                        1, 
                        1
                    );
                        
                    // Desenhando píxel espelhado
                    SHIP.graphics.drawRect(
                        SPRITE_W - x - 1, 
                        y, 
                        1, 
                        1
                    );
                }
            }
        }
        
        // Adiciona partículas de fogo
        particle();
        
        // Adiciona nave ao stage
        WRAP.addChild(SHIP);
        
        // Inicializando exploder
        exploderInit();
        
        //SHIP.visible = false;
        
        // Atualizando posição da nave
        SHIP.x -= SPRITE_W / 2;
        SHIP.y -= SPRITE_H / 2 + 2;
        
        // Atualizando posição das partículas
        PARTICLE.x -= SPRITE_W / 2;
        PARTICLE.y -= SPRITE_H / 2 + 2;
        
        // Atualizando posição do Exploder
        EXPLODER.x -= SPRITE_W / 2;
        EXPLODER.y -= SPRITE_H / 2 + 2;
        
        // Adicionando wrapper
        addChild(WRAP);
    }
    
    
    
    /* PARTÍCULAS
     * ================================================== */
    
    /**
     * Gera partículas para o "jato" da nave.
     */
    public function particle():Void 
    {
        // Inicializando wrapper
        PARTICLE = new MovieClip();
        
        // Adicionando partículas
        for (i in 6...11) {
            for (j in 6...10) {
                // Definindo píxel
                var part:MovieClip = new MovieClip();
                
                // Pseudo número para definir cor
                var nums:Int = rand(1, 3);
                
                // Definindo cor
                switch (nums) {
                    case 1:
                        part.graphics.beginFill(0xEDD400, 1);
                    case 2:
                        part.graphics.beginFill(0xCE5C00, 1);
                    case 3:
                        part.graphics.beginFill(0xffff99, 1);
                }
                
                // Desenhando
                part.graphics.drawRect(j, i, 1, 1);
                part.graphics.endFill();
                
                // Adicionando ao wrapper
                PARTICLE.addChild(part);
            }
        }
        
        // Adiciona ao stage
        WRAP.addChild(PARTICLE);
        
        // Adicionando evento de partícula
        PARTICLE.addEventListener(Event.ENTER_FRAME, particleMove);
    }
    
    /**
     * Movimenta as partículas do jato.
     * 
     * @param e
     */
    public function particleMove(e:Event):Void 
    {
        for (i in 0...Math.floor(PARTICLE.numChildren)) {
            // Puxando píxel
            var part = PARTICLE.getChildAt(i);
            
            // Movendo o píxel
            part.y += rand(1, 3);
            part.alpha -= rand(1, 3) * 0.09;
            
            // Resetando o y, caso alpha seja 0
            if (part.alpha <= 0) {
                part.x = rand(-1, 1);
                part.y = 6;
                part.alpha = 1;
            }
        }
    }
    
    
    /* MÉTODOS PARA EXPLOSÃO E IMPLOSÃO
     * ================================================== */
    
    /**
     * Inicializa o MovieClip container dos píxels para a explosão.
     */
    private function exploderInit():Void 
    {
        // Inicializando BitmapData, extraíndo cores dos píxels
        BITMAP = new BitmapData(
            Math.floor(SPRITE_W), 
            Math.floor(SPRITE_H), 
            true, 
            0x000000
        );
        
        // Desenhando BitmapData
        BITMAP.draw(SHIP);
        
        // Inicializando wrapper
        EXPLODER = new MovieClip();
        
        // Posicionando
        EXPLODER.x = SHIP.x;
        EXPLODER.y = SHIP.y;
        
        // Variáveis de loop (eixos)
        var i:Int = 0; // Altura
        var j:Int = 0; // Largura
        
        // Extraíndo píxels
        for (i in 0...Math.round(SPRITE_H)) {
            for (j in 0...Math.round(SPRITE_W)) {
                if (BITMAP.getPixel(j, i) > 0) {
                    // Definindo cor do píxel
                    var tint = new BitmapData(1, 1, false, BITMAP.getPixel(j, i));
                    
                    // Definindo píxel (movieclip)
                    var part:MovieClip = exploderPart(tint);
                    
                    // Definindo coordenadas
                    part.x = j;
                    part.y = i;
                    
                    // Adicionando ao wrapper
                    EXPLODER.addChild(part);
                    
                    // Ocultando wrapper
                    EXPLODER.visible = false;
                }
            }
        }
        
        // Adicionando exploder
        WRAP.addChild(EXPLODER);
    }
    
    /**
     * Gera um movieclip, referente ao píxel fornecido na forma de BitmapData 
     * ao declarar o método, retornando o mesmo.
     * 
     * @param bd Dados de um píxel do sprite, na forma de BitmapData
     * @return
     */
    private function exploderPart(bd:BitmapData):MovieClip 
    {
        // Inicializando
        var part:MovieClip = new MovieClip();
        // Preenchendo com a cor selecionada
        part.graphics.beginFill(bd.getPixel(0, 0));
        // Desenhando e finalizando o preenchimento
        part.graphics.drawRect(0, 0, 1, 1);
        part.graphics.endFill();
        // Retornaod
        return part;
    }
    
    /**
     * Explode a nave.
     */
    public function exploderBlow():Void 
    {
        // Contador de partículas
        var counts:Int = 0;
        
        // Define alpha do exploder
        EXPLODER.alpha = 1;
        
        // Ocultando movieclip
        SHIP.visible = false;
        
        // Ocultando jato
        PARTICLE.visible = false;
        
        // Definindo o index de ship (apenas se não utilizar WRAPPER)
        // setChildIndex(SHIP, numChildren - 1);
        
        // Exibindo exploder
        EXPLODER.visible = true;
        
        // Animando explosão com Actuate
        for (i in 0...Math.floor(EXPLODER.numChildren)) {
            // Puxando píxel
            var part = EXPLODER.getChildAt(i);
            
            // Exibindo exploder (certificando)
            EXPLODER.visible = true;
            
            // Definindo destino da partícula
            var posx = Math.random() * SPRITE_W * 4 - SPRITE_W * 1.5;
            var posy = Math.random() * SPRITE_H * 4 - SPRITE_H * 1.5;
            
            // Animando
            Actuate.tween(
                part, 
                1, 
                {
                    alpha : 0, 
                    x : posx, 
                    y : posy
                }
            ).ease(Quad.easeOut).onComplete(
                function() {
                    // Definindo sprite como "morto"
                    SHIP_DEAD = true;
                }
            );
        }
    }
    
    
    
    /* MÉTODOS PARA OPERAÇÕES COM NÚMEROS E CÉLULAS
     * ================================================== */
    
    /**
     * Calcula o valor do index do píxel nas coordenadas fornecidas.
     * 
     * @param x Posição do píxel no eixo X
     * @param y Posição do píxel no eixo Y
     * @return
     */
    private function cell(x:Int, y:Int):Int 
    {
        return (y * SPRITE_W) + x;
    }
    
    /**
     * Define um número pseudo-aleatório, para definir o formato da nave e, 
     * também, a cor da mesma.
     * 
     * @return
     */
    private function seed():Int 
    {
        return Math.floor(Math.random() * 4 * 1024 * 1024 * 1024);
    }
    
    /**
     * Retorna um número aleatório entre os valores mínimo e máximo declarados.
     * 
     * A declaração de valores é totalmente opcional. Os valores padrão mínimo 
     * e máximo são, respectivamente, 1 e 2147483647
     * 
     * @param min Valor mínimo
     * @param max Valor máximo
     * @return
     */
    private function rand(min:Int = 1, max:Int = 2147483647):Int 
    {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
    
    /**
     * Converte um valor decimal, entre 0 e 255, em seu respectivo hexadecimal.
     * 
     * Valores negativos são convertidos para 0, assim como valorea maiores que 
     * 255 são convertidos para 255.
     * 
     * @param nums Valor para conversão
     * @return
     */
    private function dechex(nums:Int):String 
    {
        // Verificando limites
        if (nums < 0) nums = 0;
        if (nums > 255) nums = 255;
        
        // Convertendo para string hexadecimal
        return StringTools.hex(nums, 2);
    }
    
    
    
    /* MÉTODOS PARA CORES
     * ================================================== */
    
    /**
     * Converte valores de uma cor no formato HSV para RGB, retornando a mesma 
     * em um formato inteiro próprio para uso em Haxe/ActionScript.
     * 
     * @param h Valor da matiz, float, entre 0 e 360
     * @param s Valor da saturação, float, entre 0 e 1
     * @param v Valor do brilho, float, entre 0 e 1
     * @return
     */
    private function HSVtoRGB(h:Float, s:Float, v:Float):Int 
    {
        // Variáveis internas
        var r, g, b, i, f, p, q, t;
        
        // Caso a saturação seja 0, é retornada uma cor em escala de cinza
        if (s == 0) {
            // Definindo matiz de cinza
            var gray = dechex(Math.floor(v * 255));
            
            // Retornando
            return Std.parseInt("0x" + gray + gray + gray);
        }
        
        // Definindo valores de cor
        i = Math.floor(h * 6);
        f = h * 6 - i;
        p = v * (1 - s);
        q = v * (1 - f * s);
        t = v * (1 * (1 - f) * s);
        
        // Definindo valores RGB finais
        switch (i % 6) {
            case 1:
                r = q;
                g = v;
                b = p;
            case 2:
                r = p;
                g = v;
                b = t;
            case 3:
                r = p;
                g = q;
                b = v;
            case 4:
                r = t;
                g = p;
                b = v;
            case 5:
                r = v;
                g = p;
                b = q;
            default:
                r = v;
                g = t;
                b = p;
        }
        
        // Retornando cor
        return Std.parseInt(
            "0x" 
            + dechex(Math.floor(r * 255)) 
            + dechex(Math.floor(g * 255)) 
            + dechex(Math.floor(b * 255)) 
        );
    }
    
    /**
     * Define a cor de um píxel, nas coordenadas indicadas, no corpo da nave.
     * 
     * @param x Posição do píxel no eixo X
     * @param y Posição do píxel no eixo Y
     * @return
     */
    private function tintBody(x:Int, y:Int):Int 
    {
        // Definindo saturação
        var s:Float = (SATURATION[y] - 10) / 100;
        
        // Definindo brilho
        var b:Float = BRIGHTNESS[x] / 100 * 0.8;
        
        // Definindo a matiz
        var h:Float;
        
        // Utilizando operações bit-a-bit para definir valores
        if (y < 6) {
            h = (SEED_TINT >> 8) & 0xFF;
        } else if (y < 9) {
            h = (SEED_TINT >> 16) & 0xFF;
        } else {
            h = (SEED_TINT >> 24) & 0xFF;
        }
        
        // Retornando
        return HSVtoRGB(360 * h / 256, s, b);
    }
    
    /**
     * Define a cor de um píxel, nas coordenadas indicadas, no cockpit da nave.
     * 
     * @param x Posição do píxel no eixo X
     * @param y Posição do píxel no eixo Y
     * @return
     */
    private function tintPane(x:Int, y:Int):Int 
    {
        // Definindo saturação
        var s:Float = (SATURATION[y] - 20) / 100;
        
        // Definindo brilho
        var b:Float = (BRIGHTNESS[x] + 18) / 100;
        
        // Definindo a matiz
        var h:Float = SEED_TINT & 0xFF;
        
        // Retornando
        return HSVtoRGB(360 * h / 256, s, b);
    }
    
    /**
     * Define a cor de um píxel, nas coordenadas indicadas, nos jatos da nave.
     * 
     * @param x Posição do píxel no eixo X
     * @param y Posição do píxel no eixo Y
     * @return
     */
    private function tintJets(x:Int, y:Int):Int 
    {
        // Definindo saturação
        var s:Float = (SATURATION[y] - 20) / 100;
        
        // Definindo brilho
        var b:Float = (BRIGHTNESS[x] - 18) / 100;
        
        // Definindo a matiz
        var h:Float;
        
        // Utilizando operações bit-a-bit para definir valores
        if (y < 8) {
            h = (SEED_TINT >> 8) & 0xFF;
        } else if (y < 12) {
            h = (SEED_TINT >> 16) & 0xFF;
        } else {
            h = (SEED_TINT >> 24) & 0xFF;
        }
        
        // Retornando
        return HSVtoRGB(360 * h / 256, s, b);
    }
}