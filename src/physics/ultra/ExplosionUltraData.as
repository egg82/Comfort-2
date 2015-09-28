package physics.ultra {

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.geom.Vec2;
import nape.geom.Vec3;
import nape.dynamics.InteractionFilter;
import nape.phys.Material;
import nape.phys.FluidProperties;
import nape.callbacks.CbType;
import nape.callbacks.CbTypeList;
import nape.geom.AABB;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class ExplosionUltraData {

    /**
     * Get position and rotation for graphics placement.
     *
     * Example usage:
     * <code>
     *    space.step(1/60);
     *    space.liveBodies.foreach(updateGraphics);
     *    ...
     *    function updateGraphics(body:Body):void {
     *       var position:Vec3 = PhysicsData.graphicsPosition(body);
     *       var graphic:DisplayObject = body.userData.graphic;
     *       graphic.x = position.x;
     *       graphic.y = position.y;
     *       graphic.rotation = position.z;
     *       position.dispose(); //release to object pool.
     *    }
     * </code>
     * In the case that you are using a flash DisplayObject you can simply
     * use <code>space.liveBodies.foreach(PhysicsData.flashGraphicsUpdate);</code>
     * but if using, let's say Starling you should write the equivalent version
     * of the example above.
     *
     * @param body The Body to get graphical position/rotation of.
     * @return A Vec3 allocated from object pool whose x/y are the position
     *         for graphic, and z the rotation in degrees.
     */
    public static function graphicsPosition(body:Body):Vec3 {
        var pos:Vec2 = body.localPointToWorld(body.userData.graphicOffset as Vec2);
        var ret:Vec3 = Vec3.get(pos.x, pos.y, (body.rotation * 180/Math.PI) % 360);
        pos.dispose();
        return ret;
    }

    /**
     * Method to update a flash DisplayObject assigned to a Body
     *
     * @param body The Body having a flash DisplayObject to update graphic of.
     */
    public static function flashGraphicsUpdate(body:Body):void {
        var position:Vec3 = PhysicsData.graphicsPosition(body);
        var graphic:DisplayObject = body.userData.graphic;
        graphic.x = position.x;
        graphic.y = position.y;
        graphic.rotation = position.z;
        position.dispose(); //release to object pool.
    }

    /**
     * Method to create a Body from the PhysicsEditor exported data.
     *
     * If supplying a graphic (of any type), then this will be stored
     * in body.userData.graphic and an associated body.userData.graphicOffset
     * Vec2 will be assigned that represents the local offset to apply to
     * the graphics position.
     *
     * @param name The name of the Body from the PhysicsEditor exported data.
     * @param graphic (optional) A graphic to assign and find a local offset for.
                      This can be of any type, but should have a getBounds function
                      that works like that of the flash DisplayObject to correctly
                      determine a graphicOffset.
     * @return The constructed Body.
     */
    public static function createBody(name:String,graphic:*=null):Body {
        var xret:BodyPair = lookup(name);
        if(graphic==null) return xret.body.copy();

        var ret:Body = xret.body.copy();
        graphic.x = graphic.y = 0;
        graphic.rotation = 0;
        var bounds:Rectangle = graphic.getBounds(graphic);
        var offset:Vec2 = Vec2.get(bounds.x-xret.anchor.x, bounds.y-xret.anchor.y);

        ret.userData.graphic = graphic;
        ret.userData.graphicOffset = offset;

        return ret;
    }

    /**
     * Register a Material object with the name used in the PhysicsEditor data.
     *
     * @param name The name of the Material in the PhysicsEditor data.
     * @param material The Material object to be assigned to this name.
     */
    public static function registerMaterial(name:String,material:Material):void {
        if(materials==null) materials = new Dictionary();
        materials[name] = material;
    }

    /**
     * Register a InteractionFilter object with the name used in the PhysicsEditor data.
     *
     * @param name The name of the InteractionFilter in the PhysicsEditor data.
     * @param filter The InteractionFilter object to be assigned to this name.
     */
    public static function registerFilter(name:String,filter:InteractionFilter):void {
        if(filters==null) filters = new Dictionary();
        filters[name] = filter;
    }

    /**
     * Register a FluidProperties object with the name used in the PhysicsEditor data.
     *
     * @param name The name of the FluidProperties in the PhysicsEditor data.
     * @param properties The FluidProperties object to be assigned to this name.
     */
    public static function registerFluidProperties(name:String,properties:FluidProperties):void {
        if(fprops==null) fprops = new Dictionary();
        fprops[name] = properties;
    }

    /**
     * Register a CbType object with the name used in the PhysicsEditor data.
     *
     * @param name The name of the CbType in the PhysicsEditor data.
     * @param cbType The CbType object to be assigned to this name.
     */
    public static function registerCbType(name:String,cbType:CbType):void {
        if(types==null) types = new Dictionary();
        types[name] = cbType;
    }

    //----------------------------------------------------------------------

    private static var bodies   :Dictionary;
    private static var materials:Dictionary;
    private static var filters  :Dictionary;
    private static var fprops   :Dictionary;
    private static var types    :Dictionary;
    private static function material(name:String):Material {
        if(name=="default") return new Material();
        else {
            if(materials==null || materials[name] === undefined)
                throw "Error: Material with name '"+name+"' has not been registered";
            return materials[name] as Material;
        }
    }
    private static function filter(name:String):InteractionFilter {
        if(name=="default") return new InteractionFilter();
        else {
            if(filters==null || filters[name] === undefined)
                throw "Error: InteractionFilter with name '"+name+"' has not been registered";
            return filters[name] as InteractionFilter;
        }
    }
    private static function fprop(name:String):FluidProperties {
        if(name=="default") return new FluidProperties();
        else {
            if(fprops==null || fprops[name] === undefined)
                throw "Error: FluidProperties with name '"+name+"' has not been registered";
            return fprops[name] as FluidProperties;
        }
    }
    private static function cbtype(outtypes:CbTypeList, nameList:String):void {
        var names:Array = nameList.split(",");
        for(var i:int = 0; i<names.length; i++) {
            var name:String = names[i].replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
            if(name=="") continue;

            if(types[name] === undefined)
                throw "Error: CbType with name '"+name+"' has not been registered";

            outtypes.add(types[name] as CbType);
        }
    }

    private static function lookup(name:String):BodyPair {
        if(bodies==null) init();
        if(bodies[name] === undefined) throw "Error: Body with name '"+name+"' does not exist";
        return bodies[name] as BodyPair;
    }

    //----------------------------------------------------------------------

    private static function init():void {
        bodies = new Dictionary();

        var body:Body;
        var mat:Material;
        var filt:InteractionFilter;
        var prop:FluidProperties;
        var cbType:CbType;
        var s:Shape;
        var anchor:Vec2;

        
            body = new Body();
            cbtype(body.cbTypes,"");

            
                mat = material("default");
                filt = filter("default");
                prop = fprop("default");

                
                    
                        s = new Polygon(
                            [   Vec2.weak(195,249)   ,  Vec2.weak(195,248)   ,  Vec2.weak(194,249)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(192,251)   ,  Vec2.weak(192,250)   ,  Vec2.weak(133,251)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(191,252)   ,  Vec2.weak(191,251)   ,  Vec2.weak(133,251)   ,  Vec2.weak(133,252)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(190,253)   ,  Vec2.weak(190,252)   ,  Vec2.weak(134,252)   ,  Vec2.weak(134,253)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(188,256)   ,  Vec2.weak(188,255)   ,  Vec2.weak(187,256)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(187,257)   ,  Vec2.weak(187,256)   ,  Vec2.weak(186,257)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(183,264)   ,  Vec2.weak(183,263)   ,  Vec2.weak(182,264)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(181,267)   ,  Vec2.weak(181,266)   ,  Vec2.weak(180,267)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(179,270)   ,  Vec2.weak(179,269)   ,  Vec2.weak(178,270)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(176,275)   ,  Vec2.weak(176,274)   ,  Vec2.weak(175,275)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(174,278)   ,  Vec2.weak(174,277)   ,  Vec2.weak(173,278)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(172,281)   ,  Vec2.weak(172,280)   ,  Vec2.weak(171,281)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(169,286)   ,  Vec2.weak(169,285)   ,  Vec2.weak(168,286)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(167,289)   ,  Vec2.weak(167,288)   ,  Vec2.weak(166,289)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(165,292)   ,  Vec2.weak(165,291)   ,  Vec2.weak(159,290)   ,  Vec2.weak(160,292)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(160,293)   ,  Vec2.weak(161,293)   ,  Vec2.weak(164,292)   ,  Vec2.weak(160,292)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(158,290)   ,  Vec2.weak(159,290)   ,  Vec2.weak(166,289)   ,  Vec2.weak(158,289)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(156,287)   ,  Vec2.weak(157,287)   ,  Vec2.weak(173,278)   ,  Vec2.weak(175,275)   ,  Vec2.weak(156,286)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(155,286)   ,  Vec2.weak(156,286)   ,  Vec2.weak(155,285)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(152,281)   ,  Vec2.weak(153,281)   ,  Vec2.weak(152,280)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(150,278)   ,  Vec2.weak(151,278)   ,  Vec2.weak(150,277)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(148,275)   ,  Vec2.weak(149,275)   ,  Vec2.weak(148,274)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(144,268)   ,  Vec2.weak(145,268)   ,  Vec2.weak(144,267)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(141,263)   ,  Vec2.weak(142,263)   ,  Vec2.weak(141,262)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(139,260)   ,  Vec2.weak(140,260)   ,  Vec2.weak(139,259)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(137,257)   ,  Vec2.weak(138,257)   ,  Vec2.weak(137,256)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(135,254)   ,  Vec2.weak(189,253)   ,  Vec2.weak(135,253)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(132,251)   ,  Vec2.weak(192,250)   ,  Vec2.weak(195,248)   ,  Vec2.weak(132,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(131,250)   ,  Vec2.weak(195,248)   ,  Vec2.weak(131,249)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(128,248)   ,  Vec2.weak(129,248)   ,  Vec2.weak(128,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,195)   ,  Vec2.weak(79,195)   ,  Vec2.weak(78,194)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,192)   ,  Vec2.weak(77,192)   ,  Vec2.weak(76,134)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(75,191)   ,  Vec2.weak(76,191)   ,  Vec2.weak(76,134)   ,  Vec2.weak(75,134)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(72,189)   ,  Vec2.weak(73,189)   ,  Vec2.weak(72,188)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(71,188)   ,  Vec2.weak(72,188)   ,  Vec2.weak(71,187)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(68,186)   ,  Vec2.weak(69,186)   ,  Vec2.weak(68,185)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(63,183)   ,  Vec2.weak(64,183)   ,  Vec2.weak(63,182)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(60,181)   ,  Vec2.weak(61,181)   ,  Vec2.weak(60,180)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(55,178)   ,  Vec2.weak(56,178)   ,  Vec2.weak(55,177)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(50,175)   ,  Vec2.weak(51,175)   ,  Vec2.weak(50,174)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(47,173)   ,  Vec2.weak(48,173)   ,  Vec2.weak(47,172)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(44,171)   ,  Vec2.weak(45,171)   ,  Vec2.weak(44,170)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(41,169)   ,  Vec2.weak(42,169)   ,  Vec2.weak(41,168)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(36,166)   ,  Vec2.weak(37,166)   ,  Vec2.weak(36,160)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(33,164)   ,  Vec2.weak(34,164)   ,  Vec2.weak(34,161)   ,  Vec2.weak(33,161)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(32,163)   ,  Vec2.weak(33,163)   ,  Vec2.weak(33,162)   ,  Vec2.weak(32,162)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(36,159)   ,  Vec2.weak(36,160)   ,  Vec2.weak(37,166)   ,  Vec2.weak(39,167)   ,  Vec2.weak(37,159)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(39,157)   ,  Vec2.weak(39,158)   ,  Vec2.weak(40,157)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(42,155)   ,  Vec2.weak(42,156)   ,  Vec2.weak(43,155)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(45,153)   ,  Vec2.weak(45,154)   ,  Vec2.weak(46,153)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(48,151)   ,  Vec2.weak(48,152)   ,  Vec2.weak(49,151)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(51,149)   ,  Vec2.weak(51,150)   ,  Vec2.weak(52,149)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(58,145)   ,  Vec2.weak(58,146)   ,  Vec2.weak(59,145)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(63,142)   ,  Vec2.weak(63,143)   ,  Vec2.weak(64,142)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(66,140)   ,  Vec2.weak(66,141)   ,  Vec2.weak(67,140)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(71,137)   ,  Vec2.weak(71,138)   ,  Vec2.weak(72,137)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(72,136)   ,  Vec2.weak(72,137)   ,  Vec2.weak(73,136)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,133)   ,  Vec2.weak(77,192)   ,  Vec2.weak(79,195)   ,  Vec2.weak(77,133)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(77,132)   ,  Vec2.weak(79,195)   ,  Vec2.weak(78,132)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,131)   ,  Vec2.weak(79,195)   ,  Vec2.weak(79,131)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(80,128)   ,  Vec2.weak(80,129)   ,  Vec2.weak(81,128)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(129,76)   ,  Vec2.weak(129,77)   ,  Vec2.weak(130,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(132,74)   ,  Vec2.weak(132,75)   ,  Vec2.weak(191,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(133,73)   ,  Vec2.weak(133,74)   ,  Vec2.weak(191,74)   ,  Vec2.weak(191,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(135,70)   ,  Vec2.weak(135,71)   ,  Vec2.weak(136,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(136,69)   ,  Vec2.weak(136,70)   ,  Vec2.weak(137,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(138,66)   ,  Vec2.weak(138,67)   ,  Vec2.weak(139,66)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(140,63)   ,  Vec2.weak(140,64)   ,  Vec2.weak(141,63)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(143,58)   ,  Vec2.weak(143,59)   ,  Vec2.weak(144,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(145,55)   ,  Vec2.weak(145,56)   ,  Vec2.weak(146,55)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(147,52)   ,  Vec2.weak(147,53)   ,  Vec2.weak(148,52)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(149,49)   ,  Vec2.weak(149,50)   ,  Vec2.weak(150,49)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(152,44)   ,  Vec2.weak(152,45)   ,  Vec2.weak(153,44)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(154,41)   ,  Vec2.weak(154,42)   ,  Vec2.weak(155,41)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(156,38)   ,  Vec2.weak(156,39)   ,  Vec2.weak(157,38)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(159,33)   ,  Vec2.weak(159,34)   ,  Vec2.weak(165,35)   ,  Vec2.weak(164,33)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(161,30)   ,  Vec2.weak(161,31)   ,  Vec2.weak(162,31)   ,  Vec2.weak(162,30)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(163,31)   ,  Vec2.weak(161,31)   ,  Vec2.weak(160,33)   ,  Vec2.weak(163,32)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(164,32)   ,  Vec2.weak(163,32)   ,  Vec2.weak(160,33)   ,  Vec2.weak(164,33)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(166,35)   ,  Vec2.weak(165,35)   ,  Vec2.weak(158,36)   ,  Vec2.weak(157,38)   ,  Vec2.weak(166,36)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(170,42)   ,  Vec2.weak(169,42)   ,  Vec2.weak(170,43)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(172,45)   ,  Vec2.weak(171,45)   ,  Vec2.weak(172,46)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(174,48)   ,  Vec2.weak(173,48)   ,  Vec2.weak(174,49)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(175,49)   ,  Vec2.weak(174,49)   ,  Vec2.weak(175,50)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(178,54)   ,  Vec2.weak(177,54)   ,  Vec2.weak(178,55)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(180,57)   ,  Vec2.weak(179,57)   ,  Vec2.weak(180,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(183,62)   ,  Vec2.weak(182,62)   ,  Vec2.weak(183,63)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(186,67)   ,  Vec2.weak(185,67)   ,  Vec2.weak(186,68)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(188,70)   ,  Vec2.weak(187,70)   ,  Vec2.weak(134,73)   ,  Vec2.weak(188,71)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(189,71)   ,  Vec2.weak(188,71)   ,  Vec2.weak(134,73)   ,  Vec2.weak(189,72)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(190,72)   ,  Vec2.weak(134,73)   ,  Vec2.weak(190,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(192,74)   ,  Vec2.weak(132,75)   ,  Vec2.weak(129,77)   ,  Vec2.weak(192,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(193,75)   ,  Vec2.weak(129,77)   ,  Vec2.weak(193,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(250,128)   ,  Vec2.weak(249,128)   ,  Vec2.weak(250,129)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(252,131)   ,  Vec2.weak(251,131)   ,  Vec2.weak(251,194)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,132)   ,  Vec2.weak(252,132)   ,  Vec2.weak(251,194)   ,  Vec2.weak(253,191)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(254,133)   ,  Vec2.weak(253,133)   ,  Vec2.weak(253,191)   ,  Vec2.weak(254,191)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(255,134)   ,  Vec2.weak(254,134)   ,  Vec2.weak(254,190)   ,  Vec2.weak(255,190)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(258,136)   ,  Vec2.weak(257,136)   ,  Vec2.weak(258,137)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(259,137)   ,  Vec2.weak(258,137)   ,  Vec2.weak(259,138)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(264,140)   ,  Vec2.weak(263,140)   ,  Vec2.weak(264,141)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(267,142)   ,  Vec2.weak(266,142)   ,  Vec2.weak(267,143)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(272,145)   ,  Vec2.weak(271,145)   ,  Vec2.weak(272,146)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(275,147)   ,  Vec2.weak(274,147)   ,  Vec2.weak(275,148)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(278,149)   ,  Vec2.weak(277,149)   ,  Vec2.weak(278,150)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(283,152)   ,  Vec2.weak(282,152)   ,  Vec2.weak(283,153)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(286,154)   ,  Vec2.weak(285,154)   ,  Vec2.weak(286,155)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(289,156)   ,  Vec2.weak(288,156)   ,  Vec2.weak(289,157)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(294,159)   ,  Vec2.weak(293,159)   ,  Vec2.weak(294,164)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(297,161)   ,  Vec2.weak(296,161)   ,  Vec2.weak(296,162)   ,  Vec2.weak(297,162)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(296,164)   ,  Vec2.weak(296,161)   ,  Vec2.weak(294,160)   ,  Vec2.weak(294,164)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(294,165)   ,  Vec2.weak(294,164)   ,  Vec2.weak(293,159)   ,  Vec2.weak(291,158)   ,  Vec2.weak(293,165)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(291,167)   ,  Vec2.weak(291,166)   ,  Vec2.weak(290,167)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(286,170)   ,  Vec2.weak(286,169)   ,  Vec2.weak(285,170)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(283,172)   ,  Vec2.weak(283,171)   ,  Vec2.weak(282,172)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(280,174)   ,  Vec2.weak(280,173)   ,  Vec2.weak(279,174)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(279,175)   ,  Vec2.weak(279,174)   ,  Vec2.weak(278,175)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(274,178)   ,  Vec2.weak(274,177)   ,  Vec2.weak(273,178)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(269,181)   ,  Vec2.weak(269,180)   ,  Vec2.weak(268,181)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(264,184)   ,  Vec2.weak(264,183)   ,  Vec2.weak(263,184)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(259,187)   ,  Vec2.weak(259,186)   ,  Vec2.weak(258,187)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(256,189)   ,  Vec2.weak(255,135)   ,  Vec2.weak(255,189)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(252,194)   ,  Vec2.weak(252,193)   ,  Vec2.weak(251,194)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(261,255)   ,  Vec2.weak(260,255)   ,  Vec2.weak(260,256)   ,  Vec2.weak(261,256)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(260,257)   ,  Vec2.weak(260,252)   ,  Vec2.weak(259,252)   ,  Vec2.weak(259,257)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(70,256)   ,  Vec2.weak(75,256)   ,  Vec2.weak(71,250)   ,  Vec2.weak(70,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(164,294)   ,  Vec2.weak(164,292)   ,  Vec2.weak(161,293)   ,  Vec2.weak(161,294)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(72,69)   ,  Vec2.weak(72,75)   ,  Vec2.weak(73,75)   ,  Vec2.weak(76,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(194,250)   ,  Vec2.weak(194,249)   ,  Vec2.weak(192,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(189,255)   ,  Vec2.weak(189,253)   ,  Vec2.weak(188,255)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(186,259)   ,  Vec2.weak(186,257)   ,  Vec2.weak(136,254)   ,  Vec2.weak(185,259)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(185,261)   ,  Vec2.weak(185,259)   ,  Vec2.weak(136,254)   ,  Vec2.weak(138,257)   ,  Vec2.weak(184,261)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(184,263)   ,  Vec2.weak(184,261)   ,  Vec2.weak(183,263)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(182,266)   ,  Vec2.weak(182,264)   ,  Vec2.weak(181,266)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(180,269)   ,  Vec2.weak(180,267)   ,  Vec2.weak(179,269)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(178,272)   ,  Vec2.weak(178,270)   ,  Vec2.weak(147,272)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(177,274)   ,  Vec2.weak(177,272)   ,  Vec2.weak(176,274)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(175,277)   ,  Vec2.weak(175,275)   ,  Vec2.weak(174,277)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(173,280)   ,  Vec2.weak(173,278)   ,  Vec2.weak(172,280)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(171,283)   ,  Vec2.weak(171,281)   ,  Vec2.weak(170,283)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(170,285)   ,  Vec2.weak(170,283)   ,  Vec2.weak(169,285)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(168,288)   ,  Vec2.weak(168,286)   ,  Vec2.weak(167,288)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(166,291)   ,  Vec2.weak(166,289)   ,  Vec2.weak(159,290)   ,  Vec2.weak(165,291)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(159,292)   ,  Vec2.weak(160,292)   ,  Vec2.weak(159,290)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(157,289)   ,  Vec2.weak(166,289)   ,  Vec2.weak(170,283)   ,  Vec2.weak(171,281)   ,  Vec2.weak(157,287)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(154,285)   ,  Vec2.weak(155,285)   ,  Vec2.weak(154,283)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(153,283)   ,  Vec2.weak(154,283)   ,  Vec2.weak(175,275)   ,  Vec2.weak(153,281)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(151,280)   ,  Vec2.weak(152,280)   ,  Vec2.weak(151,278)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(149,277)   ,  Vec2.weak(150,277)   ,  Vec2.weak(149,275)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(147,274)   ,  Vec2.weak(148,274)   ,  Vec2.weak(147,272)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(146,272)   ,  Vec2.weak(147,272)   ,  Vec2.weak(182,264)   ,  Vec2.weak(184,261)   ,  Vec2.weak(146,270)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(145,270)   ,  Vec2.weak(146,270)   ,  Vec2.weak(184,261)   ,  Vec2.weak(145,268)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(143,267)   ,  Vec2.weak(144,267)   ,  Vec2.weak(143,265)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(142,265)   ,  Vec2.weak(143,265)   ,  Vec2.weak(184,261)   ,  Vec2.weak(142,263)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(140,262)   ,  Vec2.weak(141,262)   ,  Vec2.weak(140,260)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(138,259)   ,  Vec2.weak(139,259)   ,  Vec2.weak(138,257)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(136,256)   ,  Vec2.weak(137,256)   ,  Vec2.weak(136,254)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(129,249)   ,  Vec2.weak(131,249)   ,  Vec2.weak(129,248)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(79,197)   ,  Vec2.weak(80,197)   ,  Vec2.weak(200,78)   ,  Vec2.weak(82,124)   ,  Vec2.weak(81,128)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(77,194)   ,  Vec2.weak(78,194)   ,  Vec2.weak(77,192)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,190)   ,  Vec2.weak(75,190)   ,  Vec2.weak(73,189)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(69,187)   ,  Vec2.weak(71,187)   ,  Vec2.weak(69,186)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(66,185)   ,  Vec2.weak(68,185)   ,  Vec2.weak(69,139)   ,  Vec2.weak(66,141)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(64,184)   ,  Vec2.weak(66,184)   ,  Vec2.weak(64,183)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(61,182)   ,  Vec2.weak(63,182)   ,  Vec2.weak(61,181)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(58,180)   ,  Vec2.weak(60,180)   ,  Vec2.weak(61,144)   ,  Vec2.weak(58,146)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(56,179)   ,  Vec2.weak(58,179)   ,  Vec2.weak(56,178)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(53,177)   ,  Vec2.weak(55,177)   ,  Vec2.weak(54,148)   ,  Vec2.weak(53,176)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(51,176)   ,  Vec2.weak(53,176)   ,  Vec2.weak(51,175)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(48,174)   ,  Vec2.weak(50,174)   ,  Vec2.weak(48,173)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(45,172)   ,  Vec2.weak(47,172)   ,  Vec2.weak(45,171)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(42,170)   ,  Vec2.weak(44,170)   ,  Vec2.weak(42,169)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(39,168)   ,  Vec2.weak(41,168)   ,  Vec2.weak(39,158)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(37,167)   ,  Vec2.weak(39,167)   ,  Vec2.weak(37,166)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(34,165)   ,  Vec2.weak(36,165)   ,  Vec2.weak(36,160)   ,  Vec2.weak(34,160)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(37,158)   ,  Vec2.weak(37,159)   ,  Vec2.weak(39,167)   ,  Vec2.weak(39,158)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(40,156)   ,  Vec2.weak(40,157)   ,  Vec2.weak(42,156)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(43,154)   ,  Vec2.weak(43,155)   ,  Vec2.weak(45,154)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(46,152)   ,  Vec2.weak(46,153)   ,  Vec2.weak(48,152)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(49,150)   ,  Vec2.weak(49,151)   ,  Vec2.weak(51,150)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(52,148)   ,  Vec2.weak(52,149)   ,  Vec2.weak(54,148)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(54,147)   ,  Vec2.weak(55,177)   ,  Vec2.weak(58,179)   ,  Vec2.weak(56,147)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(56,146)   ,  Vec2.weak(56,147)   ,  Vec2.weak(58,179)   ,  Vec2.weak(58,146)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(59,144)   ,  Vec2.weak(59,145)   ,  Vec2.weak(61,144)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(61,143)   ,  Vec2.weak(61,144)   ,  Vec2.weak(63,182)   ,  Vec2.weak(66,184)   ,  Vec2.weak(63,143)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(64,141)   ,  Vec2.weak(64,142)   ,  Vec2.weak(66,141)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(67,139)   ,  Vec2.weak(67,140)   ,  Vec2.weak(69,139)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(69,138)   ,  Vec2.weak(69,139)   ,  Vec2.weak(71,187)   ,  Vec2.weak(75,190)   ,  Vec2.weak(71,138)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,135)   ,  Vec2.weak(73,136)   ,  Vec2.weak(75,135)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(79,129)   ,  Vec2.weak(79,131)   ,  Vec2.weak(80,129)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(127,77)   ,  Vec2.weak(127,78)   ,  Vec2.weak(200,78)   ,  Vec2.weak(200,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(130,75)   ,  Vec2.weak(130,76)   ,  Vec2.weak(132,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(134,71)   ,  Vec2.weak(134,73)   ,  Vec2.weak(135,71)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(137,67)   ,  Vec2.weak(137,69)   ,  Vec2.weak(138,67)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(139,64)   ,  Vec2.weak(139,66)   ,  Vec2.weak(140,64)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(141,61)   ,  Vec2.weak(141,63)   ,  Vec2.weak(184,65)   ,  Vec2.weak(182,62)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(142,59)   ,  Vec2.weak(142,61)   ,  Vec2.weak(143,59)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(144,56)   ,  Vec2.weak(144,58)   ,  Vec2.weak(145,56)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(146,53)   ,  Vec2.weak(146,55)   ,  Vec2.weak(147,53)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(148,50)   ,  Vec2.weak(148,52)   ,  Vec2.weak(149,50)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(150,47)   ,  Vec2.weak(150,49)   ,  Vec2.weak(173,48)   ,  Vec2.weak(151,47)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(151,45)   ,  Vec2.weak(151,47)   ,  Vec2.weak(152,45)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(153,42)   ,  Vec2.weak(153,44)   ,  Vec2.weak(154,42)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(155,39)   ,  Vec2.weak(155,41)   ,  Vec2.weak(156,39)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(157,36)   ,  Vec2.weak(157,38)   ,  Vec2.weak(158,36)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(158,34)   ,  Vec2.weak(158,36)   ,  Vec2.weak(165,35)   ,  Vec2.weak(159,34)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(160,31)   ,  Vec2.weak(160,33)   ,  Vec2.weak(161,31)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(165,33)   ,  Vec2.weak(164,33)   ,  Vec2.weak(165,35)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(167,36)   ,  Vec2.weak(166,36)   ,  Vec2.weak(157,38)   ,  Vec2.weak(167,38)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(168,38)   ,  Vec2.weak(157,38)   ,  Vec2.weak(168,40)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(169,40)   ,  Vec2.weak(168,40)   ,  Vec2.weak(169,42)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(171,43)   ,  Vec2.weak(170,43)   ,  Vec2.weak(171,45)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(173,46)   ,  Vec2.weak(172,46)   ,  Vec2.weak(173,48)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(176,50)   ,  Vec2.weak(175,50)   ,  Vec2.weak(176,52)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(177,52)   ,  Vec2.weak(176,52)   ,  Vec2.weak(142,61)   ,  Vec2.weak(177,54)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(179,55)   ,  Vec2.weak(178,55)   ,  Vec2.weak(179,57)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(181,58)   ,  Vec2.weak(180,58)   ,  Vec2.weak(181,60)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(182,60)   ,  Vec2.weak(142,61)   ,  Vec2.weak(182,62)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(184,63)   ,  Vec2.weak(183,63)   ,  Vec2.weak(184,65)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(185,65)   ,  Vec2.weak(184,65)   ,  Vec2.weak(137,69)   ,  Vec2.weak(134,73)   ,  Vec2.weak(185,67)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(187,68)   ,  Vec2.weak(186,68)   ,  Vec2.weak(187,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(195,76)   ,  Vec2.weak(129,77)   ,  Vec2.weak(195,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(259,68)   ,  Vec2.weak(254,68)   ,  Vec2.weak(258,70)   ,  Vec2.weak(259,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(251,129)   ,  Vec2.weak(250,129)   ,  Vec2.weak(251,131)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(257,135)   ,  Vec2.weak(255,135)   ,  Vec2.weak(257,136)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(261,138)   ,  Vec2.weak(259,138)   ,  Vec2.weak(261,185)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(263,139)   ,  Vec2.weak(261,139)   ,  Vec2.weak(263,140)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(266,141)   ,  Vec2.weak(264,141)   ,  Vec2.weak(266,142)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(269,143)   ,  Vec2.weak(267,143)   ,  Vec2.weak(266,182)   ,  Vec2.weak(269,180)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(271,144)   ,  Vec2.weak(269,144)   ,  Vec2.weak(271,145)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(274,146)   ,  Vec2.weak(272,146)   ,  Vec2.weak(274,147)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(277,148)   ,  Vec2.weak(275,148)   ,  Vec2.weak(277,149)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(280,150)   ,  Vec2.weak(278,150)   ,  Vec2.weak(280,173)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(282,151)   ,  Vec2.weak(280,151)   ,  Vec2.weak(282,152)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(285,153)   ,  Vec2.weak(283,153)   ,  Vec2.weak(285,154)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(288,155)   ,  Vec2.weak(286,155)   ,  Vec2.weak(288,156)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(291,157)   ,  Vec2.weak(289,157)   ,  Vec2.weak(291,166)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(293,158)   ,  Vec2.weak(291,158)   ,  Vec2.weak(293,159)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(296,160)   ,  Vec2.weak(294,160)   ,  Vec2.weak(296,161)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(293,166)   ,  Vec2.weak(293,165)   ,  Vec2.weak(291,158)   ,  Vec2.weak(291,166)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(290,168)   ,  Vec2.weak(290,167)   ,  Vec2.weak(288,168)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(288,169)   ,  Vec2.weak(288,168)   ,  Vec2.weak(283,153)   ,  Vec2.weak(282,152)   ,  Vec2.weak(280,151)   ,  Vec2.weak(286,169)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(285,171)   ,  Vec2.weak(285,170)   ,  Vec2.weak(283,171)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(282,173)   ,  Vec2.weak(282,172)   ,  Vec2.weak(280,173)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(278,176)   ,  Vec2.weak(278,175)   ,  Vec2.weak(276,176)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(276,177)   ,  Vec2.weak(276,176)   ,  Vec2.weak(269,144)   ,  Vec2.weak(274,177)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(273,179)   ,  Vec2.weak(273,178)   ,  Vec2.weak(271,179)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(271,180)   ,  Vec2.weak(271,179)   ,  Vec2.weak(269,144)   ,  Vec2.weak(269,180)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(268,182)   ,  Vec2.weak(268,181)   ,  Vec2.weak(266,182)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(266,183)   ,  Vec2.weak(266,182)   ,  Vec2.weak(264,141)   ,  Vec2.weak(261,139)   ,  Vec2.weak(264,183)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(263,185)   ,  Vec2.weak(263,184)   ,  Vec2.weak(261,185)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(261,186)   ,  Vec2.weak(261,185)   ,  Vec2.weak(259,138)   ,  Vec2.weak(255,135)   ,  Vec2.weak(259,186)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(258,188)   ,  Vec2.weak(258,187)   ,  Vec2.weak(256,188)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,193)   ,  Vec2.weak(253,191)   ,  Vec2.weak(252,193)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(198,248)   ,  Vec2.weak(198,247)   ,  Vec2.weak(125,246)   ,  Vec2.weak(128,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(125,247)   ,  Vec2.weak(128,247)   ,  Vec2.weak(125,246)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(75,226)   ,  Vec2.weak(75,229)   ,  Vec2.weak(76,226)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,214)   ,  Vec2.weak(78,217)   ,  Vec2.weak(79,214)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(103,75)   ,  Vec2.weak(100,75)   ,  Vec2.weak(103,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(236,71)   ,  Vec2.weak(236,72)   ,  Vec2.weak(258,75)   ,  Vec2.weak(239,71)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(257,78)   ,  Vec2.weak(257,75)   ,  Vec2.weak(256,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(256,81)   ,  Vec2.weak(256,78)   ,  Vec2.weak(255,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,94)   ,  Vec2.weak(253,91)   ,  Vec2.weak(252,94)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(252,97)   ,  Vec2.weak(252,94)   ,  Vec2.weak(251,97)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(251,197)   ,  Vec2.weak(249,128)   ,  Vec2.weak(248,124)   ,  Vec2.weak(250,197)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(259,258)   ,  Vec2.weak(259,252)   ,  Vec2.weak(257,242)   ,  Vec2.weak(256,257)   ,  Vec2.weak(256,258)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,257)   ,  Vec2.weak(256,257)   ,  Vec2.weak(257,242)   ,  Vec2.weak(253,256)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(114,247)   ,  Vec2.weak(114,246)   ,  Vec2.weak(110,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(110,248)   ,  Vec2.weak(110,247)   ,  Vec2.weak(106,248)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(106,249)   ,  Vec2.weak(106,248)   ,  Vec2.weak(102,249)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(102,250)   ,  Vec2.weak(102,249)   ,  Vec2.weak(98,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(83,254)   ,  Vec2.weak(83,253)   ,  Vec2.weak(79,254)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(79,255)   ,  Vec2.weak(79,254)   ,  Vec2.weak(75,255)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(74,229)   ,  Vec2.weak(74,233)   ,  Vec2.weak(75,229)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,222)   ,  Vec2.weak(76,226)   ,  Vec2.weak(77,222)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(79,210)   ,  Vec2.weak(79,214)   ,  Vec2.weak(80,210)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(81,124)   ,  Vec2.weak(81,128)   ,  Vec2.weak(82,124)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(79,106)   ,  Vec2.weak(80,106)   ,  Vec2.weak(79,102)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,102)   ,  Vec2.weak(79,102)   ,  Vec2.weak(78,98)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,93)   ,  Vec2.weak(77,93)   ,  Vec2.weak(76,89)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(74,84)   ,  Vec2.weak(75,84)   ,  Vec2.weak(76,70)   ,  Vec2.weak(76,69)   ,  Vec2.weak(74,80)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(87,71)   ,  Vec2.weak(83,71)   ,  Vec2.weak(87,72)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(91,72)   ,  Vec2.weak(87,72)   ,  Vec2.weak(91,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(95,73)   ,  Vec2.weak(91,73)   ,  Vec2.weak(95,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(107,76)   ,  Vec2.weak(103,76)   ,  Vec2.weak(77,93)   ,  Vec2.weak(80,106)   ,  Vec2.weak(107,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(214,76)   ,  Vec2.weak(214,77)   ,  Vec2.weak(218,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(228,73)   ,  Vec2.weak(228,74)   ,  Vec2.weak(258,75)   ,  Vec2.weak(232,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(232,72)   ,  Vec2.weak(232,73)   ,  Vec2.weak(258,75)   ,  Vec2.weak(236,72)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(245,69)   ,  Vec2.weak(245,70)   ,  Vec2.weak(258,75)   ,  Vec2.weak(249,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(254,67)   ,  Vec2.weak(254,68)   ,  Vec2.weak(258,68)   ,  Vec2.weak(258,67)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(258,70)   ,  Vec2.weak(254,68)   ,  Vec2.weak(249,68)   ,  Vec2.weak(249,69)   ,  Vec2.weak(258,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(249,124)   ,  Vec2.weak(248,124)   ,  Vec2.weak(249,128)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(252,215)   ,  Vec2.weak(251,215)   ,  Vec2.weak(252,219)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,219)   ,  Vec2.weak(252,219)   ,  Vec2.weak(253,223)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(256,234)   ,  Vec2.weak(255,234)   ,  Vec2.weak(213,247)   ,  Vec2.weak(256,238)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(257,238)   ,  Vec2.weak(256,238)   ,  Vec2.weak(213,247)   ,  Vec2.weak(240,253)   ,  Vec2.weak(257,242)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(249,256)   ,  Vec2.weak(253,256)   ,  Vec2.weak(257,242)   ,  Vec2.weak(249,255)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(245,255)   ,  Vec2.weak(249,255)   ,  Vec2.weak(257,242)   ,  Vec2.weak(245,254)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(226,251)   ,  Vec2.weak(230,251)   ,  Vec2.weak(226,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(217,249)   ,  Vec2.weak(221,249)   ,  Vec2.weak(217,248)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(213,248)   ,  Vec2.weak(217,248)   ,  Vec2.weak(213,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(98,251)   ,  Vec2.weak(98,250)   ,  Vec2.weak(93,251)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(93,252)   ,  Vec2.weak(93,251)   ,  Vec2.weak(88,252)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(88,253)   ,  Vec2.weak(88,252)   ,  Vec2.weak(83,253)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(71,245)   ,  Vec2.weak(71,250)   ,  Vec2.weak(75,256)   ,  Vec2.weak(72,245)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(77,217)   ,  Vec2.weak(77,222)   ,  Vec2.weak(78,217)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(81,116)   ,  Vec2.weak(82,116)   ,  Vec2.weak(200,78)   ,  Vec2.weak(81,111)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(80,111)   ,  Vec2.weak(81,111)   ,  Vec2.weak(200,78)   ,  Vec2.weak(127,78)   ,  Vec2.weak(80,106)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(77,98)   ,  Vec2.weak(78,98)   ,  Vec2.weak(77,93)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(75,89)   ,  Vec2.weak(76,89)   ,  Vec2.weak(75,84)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,80)   ,  Vec2.weak(74,80)   ,  Vec2.weak(76,69)   ,  Vec2.weak(73,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(100,74)   ,  Vec2.weak(95,74)   ,  Vec2.weak(100,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(218,75)   ,  Vec2.weak(218,76)   ,  Vec2.weak(223,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(223,74)   ,  Vec2.weak(223,75)   ,  Vec2.weak(228,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(255,86)   ,  Vec2.weak(255,81)   ,  Vec2.weak(254,86)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(254,91)   ,  Vec2.weak(254,86)   ,  Vec2.weak(253,91)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(250,108)   ,  Vec2.weak(250,103)   ,  Vec2.weak(249,108)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(251,210)   ,  Vec2.weak(250,210)   ,  Vec2.weak(125,246)   ,  Vec2.weak(198,247)   ,  Vec2.weak(251,215)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(255,229)   ,  Vec2.weak(254,229)   ,  Vec2.weak(213,247)   ,  Vec2.weak(255,234)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(258,242)   ,  Vec2.weak(257,242)   ,  Vec2.weak(258,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(259,247)   ,  Vec2.weak(258,247)   ,  Vec2.weak(259,252)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(240,254)   ,  Vec2.weak(245,254)   ,  Vec2.weak(257,242)   ,  Vec2.weak(240,253)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(235,253)   ,  Vec2.weak(240,253)   ,  Vec2.weak(235,252)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(230,252)   ,  Vec2.weak(235,252)   ,  Vec2.weak(230,251)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(221,250)   ,  Vec2.weak(226,250)   ,  Vec2.weak(221,249)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(72,239)   ,  Vec2.weak(72,245)   ,  Vec2.weak(75,256)   ,  Vec2.weak(73,239)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,233)   ,  Vec2.weak(73,239)   ,  Vec2.weak(75,256)   ,  Vec2.weak(75,255)   ,  Vec2.weak(74,233)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(113,77)   ,  Vec2.weak(107,77)   ,  Vec2.weak(80,106)   ,  Vec2.weak(113,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(208,77)   ,  Vec2.weak(208,78)   ,  Vec2.weak(214,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(239,70)   ,  Vec2.weak(239,71)   ,  Vec2.weak(258,75)   ,  Vec2.weak(245,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(251,103)   ,  Vec2.weak(251,97)   ,  Vec2.weak(250,103)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(249,114)   ,  Vec2.weak(249,108)   ,  Vec2.weak(248,114)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(254,223)   ,  Vec2.weak(253,223)   ,  Vec2.weak(254,229)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(83,70)   ,  Vec2.weak(76,70)   ,  Vec2.weak(83,71)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(168,40)   ,  Vec2.weak(157,38)   ,  Vec2.weak(151,47)   ,  Vec2.weak(169,42)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(194,249)   ,  Vec2.weak(195,248)   ,  Vec2.weak(192,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(188,255)   ,  Vec2.weak(189,253)   ,  Vec2.weak(136,254)   ,  Vec2.weak(186,257)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(183,263)   ,  Vec2.weak(184,261)   ,  Vec2.weak(182,264)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(181,266)   ,  Vec2.weak(182,264)   ,  Vec2.weak(147,272)   ,  Vec2.weak(180,267)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(179,269)   ,  Vec2.weak(180,267)   ,  Vec2.weak(147,272)   ,  Vec2.weak(178,270)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(176,274)   ,  Vec2.weak(177,272)   ,  Vec2.weak(147,272)   ,  Vec2.weak(148,274)   ,  Vec2.weak(149,275)   ,  Vec2.weak(175,275)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(174,277)   ,  Vec2.weak(175,275)   ,  Vec2.weak(173,278)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(172,280)   ,  Vec2.weak(173,278)   ,  Vec2.weak(157,287)   ,  Vec2.weak(171,281)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(169,285)   ,  Vec2.weak(170,283)   ,  Vec2.weak(168,286)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(167,288)   ,  Vec2.weak(168,286)   ,  Vec2.weak(166,289)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(155,285)   ,  Vec2.weak(156,286)   ,  Vec2.weak(175,275)   ,  Vec2.weak(154,283)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(152,280)   ,  Vec2.weak(153,281)   ,  Vec2.weak(175,275)   ,  Vec2.weak(151,278)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(150,277)   ,  Vec2.weak(151,278)   ,  Vec2.weak(175,275)   ,  Vec2.weak(149,275)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(144,267)   ,  Vec2.weak(145,268)   ,  Vec2.weak(184,261)   ,  Vec2.weak(143,265)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(141,262)   ,  Vec2.weak(142,263)   ,  Vec2.weak(184,261)   ,  Vec2.weak(140,260)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(139,259)   ,  Vec2.weak(140,260)   ,  Vec2.weak(184,261)   ,  Vec2.weak(138,257)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(137,256)   ,  Vec2.weak(138,257)   ,  Vec2.weak(136,254)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(129,248)   ,  Vec2.weak(131,249)   ,  Vec2.weak(195,248)   ,  Vec2.weak(128,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,194)   ,  Vec2.weak(79,195)   ,  Vec2.weak(77,192)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,189)   ,  Vec2.weak(75,190)   ,  Vec2.weak(71,187)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(69,186)   ,  Vec2.weak(71,187)   ,  Vec2.weak(69,139)   ,  Vec2.weak(68,185)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(64,183)   ,  Vec2.weak(66,184)   ,  Vec2.weak(63,182)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(61,181)   ,  Vec2.weak(63,182)   ,  Vec2.weak(61,144)   ,  Vec2.weak(60,180)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(56,178)   ,  Vec2.weak(58,179)   ,  Vec2.weak(55,177)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(51,175)   ,  Vec2.weak(53,176)   ,  Vec2.weak(54,148)   ,  Vec2.weak(48,152)   ,  Vec2.weak(50,174)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(48,173)   ,  Vec2.weak(50,174)   ,  Vec2.weak(48,152)   ,  Vec2.weak(42,156)   ,  Vec2.weak(47,172)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(45,171)   ,  Vec2.weak(47,172)   ,  Vec2.weak(42,156)   ,  Vec2.weak(40,157)   ,  Vec2.weak(39,158)   ,  Vec2.weak(44,170)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(42,169)   ,  Vec2.weak(44,170)   ,  Vec2.weak(39,158)   ,  Vec2.weak(41,168)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(43,155)   ,  Vec2.weak(42,156)   ,  Vec2.weak(45,154)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(46,153)   ,  Vec2.weak(45,154)   ,  Vec2.weak(48,152)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(49,151)   ,  Vec2.weak(48,152)   ,  Vec2.weak(51,150)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(52,149)   ,  Vec2.weak(51,150)   ,  Vec2.weak(54,148)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(59,145)   ,  Vec2.weak(58,146)   ,  Vec2.weak(61,144)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(64,142)   ,  Vec2.weak(63,143)   ,  Vec2.weak(66,184)   ,  Vec2.weak(66,141)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(67,140)   ,  Vec2.weak(66,141)   ,  Vec2.weak(69,139)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,136)   ,  Vec2.weak(71,138)   ,  Vec2.weak(75,190)   ,  Vec2.weak(75,135)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(80,129)   ,  Vec2.weak(79,131)   ,  Vec2.weak(79,195)   ,  Vec2.weak(81,128)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(130,76)   ,  Vec2.weak(129,77)   ,  Vec2.weak(132,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(135,71)   ,  Vec2.weak(134,73)   ,  Vec2.weak(137,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(138,67)   ,  Vec2.weak(137,69)   ,  Vec2.weak(184,65)   ,  Vec2.weak(139,66)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(140,64)   ,  Vec2.weak(139,66)   ,  Vec2.weak(184,65)   ,  Vec2.weak(141,63)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(143,59)   ,  Vec2.weak(142,61)   ,  Vec2.weak(176,52)   ,  Vec2.weak(174,49)   ,  Vec2.weak(173,48)   ,  Vec2.weak(144,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(145,56)   ,  Vec2.weak(144,58)   ,  Vec2.weak(173,48)   ,  Vec2.weak(146,55)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(147,53)   ,  Vec2.weak(146,55)   ,  Vec2.weak(173,48)   ,  Vec2.weak(148,52)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(149,50)   ,  Vec2.weak(148,52)   ,  Vec2.weak(173,48)   ,  Vec2.weak(150,49)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(152,45)   ,  Vec2.weak(151,47)   ,  Vec2.weak(153,44)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(154,42)   ,  Vec2.weak(153,44)   ,  Vec2.weak(155,41)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(156,39)   ,  Vec2.weak(155,41)   ,  Vec2.weak(157,38)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(170,43)   ,  Vec2.weak(169,42)   ,  Vec2.weak(151,47)   ,  Vec2.weak(171,45)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(172,46)   ,  Vec2.weak(171,45)   ,  Vec2.weak(151,47)   ,  Vec2.weak(173,48)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(175,50)   ,  Vec2.weak(174,49)   ,  Vec2.weak(176,52)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(178,55)   ,  Vec2.weak(177,54)   ,  Vec2.weak(142,61)   ,  Vec2.weak(179,57)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(180,58)   ,  Vec2.weak(179,57)   ,  Vec2.weak(142,61)   ,  Vec2.weak(181,60)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(183,63)   ,  Vec2.weak(182,62)   ,  Vec2.weak(184,65)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(186,68)   ,  Vec2.weak(185,67)   ,  Vec2.weak(134,73)   ,  Vec2.weak(187,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(250,129)   ,  Vec2.weak(249,128)   ,  Vec2.weak(251,194)   ,  Vec2.weak(251,131)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(257,136)   ,  Vec2.weak(255,135)   ,  Vec2.weak(259,138)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(263,140)   ,  Vec2.weak(261,139)   ,  Vec2.weak(264,141)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(266,142)   ,  Vec2.weak(264,141)   ,  Vec2.weak(266,182)   ,  Vec2.weak(267,143)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(271,145)   ,  Vec2.weak(269,144)   ,  Vec2.weak(276,176)   ,  Vec2.weak(279,174)   ,  Vec2.weak(280,173)   ,  Vec2.weak(272,146)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(274,147)   ,  Vec2.weak(272,146)   ,  Vec2.weak(280,173)   ,  Vec2.weak(275,148)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(277,149)   ,  Vec2.weak(275,148)   ,  Vec2.weak(280,173)   ,  Vec2.weak(278,150)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(285,154)   ,  Vec2.weak(283,153)   ,  Vec2.weak(288,168)   ,  Vec2.weak(290,167)   ,  Vec2.weak(291,166)   ,  Vec2.weak(286,155)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(288,156)   ,  Vec2.weak(286,155)   ,  Vec2.weak(291,166)   ,  Vec2.weak(289,157)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(285,170)   ,  Vec2.weak(286,169)   ,  Vec2.weak(280,151)   ,  Vec2.weak(283,171)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(282,172)   ,  Vec2.weak(283,171)   ,  Vec2.weak(280,151)   ,  Vec2.weak(280,173)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(278,175)   ,  Vec2.weak(279,174)   ,  Vec2.weak(276,176)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(273,178)   ,  Vec2.weak(274,177)   ,  Vec2.weak(269,144)   ,  Vec2.weak(271,179)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(268,181)   ,  Vec2.weak(269,180)   ,  Vec2.weak(266,182)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(263,184)   ,  Vec2.weak(264,183)   ,  Vec2.weak(261,139)   ,  Vec2.weak(261,185)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(258,187)   ,  Vec2.weak(259,186)   ,  Vec2.weak(255,135)   ,  Vec2.weak(256,188)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(252,193)   ,  Vec2.weak(253,191)   ,  Vec2.weak(251,194)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,217)   ,  Vec2.weak(77,222)   ,  Vec2.weak(228,74)   ,  Vec2.weak(79,214)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(100,75)   ,  Vec2.weak(95,74)   ,  Vec2.weak(103,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,91)   ,  Vec2.weak(255,81)   ,  Vec2.weak(83,253)   ,  Vec2.weak(114,246)   ,  Vec2.weak(251,97)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(83,71)   ,  Vec2.weak(76,70)   ,  Vec2.weak(75,84)   ,  Vec2.weak(77,93)   ,  Vec2.weak(103,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(75,229)   ,  Vec2.weak(74,233)   ,  Vec2.weak(75,255)   ,  Vec2.weak(256,78)   ,  Vec2.weak(257,75)   ,  Vec2.weak(228,74)   ,  Vec2.weak(76,226)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(253,223)   ,  Vec2.weak(251,215)   ,  Vec2.weak(198,247)   ,  Vec2.weak(213,247)   ,  Vec2.weak(254,229)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(98,250)   ,  Vec2.weak(110,247)   ,  Vec2.weak(83,253)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(78,98)   ,  Vec2.weak(80,106)   ,  Vec2.weak(77,93)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,89)   ,  Vec2.weak(77,93)   ,  Vec2.weak(75,84)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(218,76)   ,  Vec2.weak(214,77)   ,  Vec2.weak(80,210)   ,  Vec2.weak(79,214)   ,  Vec2.weak(228,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(230,251)   ,  Vec2.weak(240,253)   ,  Vec2.weak(226,250)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(221,249)   ,  Vec2.weak(226,250)   ,  Vec2.weak(213,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(251,97)   ,  Vec2.weak(114,246)   ,  Vec2.weak(249,108)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(226,250)   ,  Vec2.weak(240,253)   ,  Vec2.weak(213,247)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(113,78)   ,  Vec2.weak(80,106)   ,  Vec2.weak(127,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(82,116)   ,  Vec2.weak(82,124)   ,  Vec2.weak(200,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(80,197)   ,  Vec2.weak(80,210)   ,  Vec2.weak(208,78)   ,  Vec2.weak(200,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(208,78)   ,  Vec2.weak(80,210)   ,  Vec2.weak(214,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(77,222)   ,  Vec2.weak(76,226)   ,  Vec2.weak(228,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(250,210)   ,  Vec2.weak(248,124)   ,  Vec2.weak(114,246)   ,  Vec2.weak(125,246)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(248,124)   ,  Vec2.weak(248,114)   ,  Vec2.weak(114,246)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(248,114)   ,  Vec2.weak(249,108)   ,  Vec2.weak(114,246)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(83,253)   ,  Vec2.weak(255,81)   ,  Vec2.weak(256,78)   ,  Vec2.weak(75,255)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                
            

            anchor = (true) ? body.localCOM.copy() : Vec2.get(0,327);
            body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
            body.position.setxy(0,0);

            bodies["MASK_Explosion"] = new BodyPair(body,anchor);
        
    }
}
}

import nape.phys.Body;
import nape.geom.Vec2;

class BodyPair {
    public var body:Body;
    public var anchor:Vec2;
    public function BodyPair(body:Body,anchor:Vec2):void {
        this.body = body;
        this.anchor = anchor;
    }
}
