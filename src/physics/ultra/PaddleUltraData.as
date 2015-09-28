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

public class PaddleUltraData {

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
                            [   Vec2.weak(61,73)   ,  Vec2.weak(61,72)   ,  Vec2.weak(60,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(52,77)   ,  Vec2.weak(52,76)   ,  Vec2.weak(51,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(48,79)   ,  Vec2.weak(48,78)   ,  Vec2.weak(47,79)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(25,82)   ,  Vec2.weak(26,82)   ,  Vec2.weak(25,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(22,80)   ,  Vec2.weak(23,80)   ,  Vec2.weak(22,79)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(21,79)   ,  Vec2.weak(22,79)   ,  Vec2.weak(21,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(19,76)   ,  Vec2.weak(20,76)   ,  Vec2.weak(19,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(19,51)   ,  Vec2.weak(19,52)   ,  Vec2.weak(20,51)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(21,48)   ,  Vec2.weak(21,49)   ,  Vec2.weak(22,48)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(22,46)   ,  Vec2.weak(22,48)   ,  Vec2.weak(24,46)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(24,45)   ,  Vec2.weak(24,46)   ,  Vec2.weak(25,45)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(232,41)   ,  Vec2.weak(231,41)   ,  Vec2.weak(232,42)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(238,44)   ,  Vec2.weak(237,44)   ,  Vec2.weak(238,45)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(239,45)   ,  Vec2.weak(238,45)   ,  Vec2.weak(239,46)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(242,47)   ,  Vec2.weak(241,47)   ,  Vec2.weak(242,48)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(244,48)   ,  Vec2.weak(242,48)   ,  Vec2.weak(244,50)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(245,50)   ,  Vec2.weak(244,50)   ,  Vec2.weak(245,51)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(244,80)   ,  Vec2.weak(244,79)   ,  Vec2.weak(243,80)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(243,81)   ,  Vec2.weak(243,80)   ,  Vec2.weak(242,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(242,82)   ,  Vec2.weak(242,81)   ,  Vec2.weak(241,82)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(221,82)   ,  Vec2.weak(222,82)   ,  Vec2.weak(221,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(69,70)   ,  Vec2.weak(69,69)   ,  Vec2.weak(16,58)   ,  Vec2.weak(67,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(67,71)   ,  Vec2.weak(67,70)   ,  Vec2.weak(65,71)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(57,75)   ,  Vec2.weak(57,74)   ,  Vec2.weak(55,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(44,81)   ,  Vec2.weak(44,80)   ,  Vec2.weak(16,58)   ,  Vec2.weak(42,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(42,82)   ,  Vec2.weak(42,81)   ,  Vec2.weak(16,58)   ,  Vec2.weak(40,82)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(40,83)   ,  Vec2.weak(40,82)   ,  Vec2.weak(16,58)   ,  Vec2.weak(17,69)   ,  Vec2.weak(38,83)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(26,83)   ,  Vec2.weak(28,83)   ,  Vec2.weak(26,82)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(23,81)   ,  Vec2.weak(25,81)   ,  Vec2.weak(23,80)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(20,78)   ,  Vec2.weak(21,78)   ,  Vec2.weak(20,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(18,75)   ,  Vec2.weak(19,75)   ,  Vec2.weak(18,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(20,49)   ,  Vec2.weak(20,51)   ,  Vec2.weak(21,49)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(25,44)   ,  Vec2.weak(25,45)   ,  Vec2.weak(27,44)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(27,43)   ,  Vec2.weak(27,44)   ,  Vec2.weak(29,43)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(29,42)   ,  Vec2.weak(29,43)   ,  Vec2.weak(31,42)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(31,41)   ,  Vec2.weak(31,42)   ,  Vec2.weak(33,41)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(33,40)   ,  Vec2.weak(33,41)   ,  Vec2.weak(35,40)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(35,39)   ,  Vec2.weak(35,40)   ,  Vec2.weak(37,39)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(37,38)   ,  Vec2.weak(37,39)   ,  Vec2.weak(39,38)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(39,37)   ,  Vec2.weak(39,38)   ,  Vec2.weak(41,37)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(41,36)   ,  Vec2.weak(41,37)   ,  Vec2.weak(43,36)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(46,34)   ,  Vec2.weak(46,35)   ,  Vec2.weak(48,34)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(51,32)   ,  Vec2.weak(51,33)   ,  Vec2.weak(53,32)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(53,31)   ,  Vec2.weak(53,32)   ,  Vec2.weak(55,31)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(61,28)   ,  Vec2.weak(61,29)   ,  Vec2.weak(63,28)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(208,30)   ,  Vec2.weak(206,30)   ,  Vec2.weak(208,31)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(213,32)   ,  Vec2.weak(211,32)   ,  Vec2.weak(213,33)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(215,33)   ,  Vec2.weak(213,33)   ,  Vec2.weak(197,70)   ,  Vec2.weak(202,72)   ,  Vec2.weak(215,34)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(223,36)   ,  Vec2.weak(221,36)   ,  Vec2.weak(223,37)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(225,37)   ,  Vec2.weak(223,37)   ,  Vec2.weak(204,73)   ,  Vec2.weak(225,38)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(227,38)   ,  Vec2.weak(225,38)   ,  Vec2.weak(204,73)   ,  Vec2.weak(209,75)   ,  Vec2.weak(227,39)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(229,39)   ,  Vec2.weak(227,39)   ,  Vec2.weak(209,75)   ,  Vec2.weak(209,76)   ,  Vec2.weak(211,76)   ,  Vec2.weak(229,40)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(231,40)   ,  Vec2.weak(229,40)   ,  Vec2.weak(231,41)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(237,43)   ,  Vec2.weak(235,43)   ,  Vec2.weak(237,44)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(241,46)   ,  Vec2.weak(239,46)   ,  Vec2.weak(241,47)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(246,51)   ,  Vec2.weak(245,51)   ,  Vec2.weak(246,53)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(247,53)   ,  Vec2.weak(246,53)   ,  Vec2.weak(247,55)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(247,75)   ,  Vec2.weak(247,73)   ,  Vec2.weak(246,75)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(246,77)   ,  Vec2.weak(246,75)   ,  Vec2.weak(245,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(245,79)   ,  Vec2.weak(245,77)   ,  Vec2.weak(244,79)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(225,84)   ,  Vec2.weak(235,84)   ,  Vec2.weak(225,83)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(219,81)   ,  Vec2.weak(221,81)   ,  Vec2.weak(232,42)   ,  Vec2.weak(229,40)   ,  Vec2.weak(219,80)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(217,80)   ,  Vec2.weak(219,80)   ,  Vec2.weak(229,40)   ,  Vec2.weak(217,79)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(215,79)   ,  Vec2.weak(217,79)   ,  Vec2.weak(229,40)   ,  Vec2.weak(215,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(213,78)   ,  Vec2.weak(215,78)   ,  Vec2.weak(229,40)   ,  Vec2.weak(213,77)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(211,77)   ,  Vec2.weak(213,77)   ,  Vec2.weak(229,40)   ,  Vec2.weak(211,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(204,74)   ,  Vec2.weak(206,74)   ,  Vec2.weak(204,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(202,73)   ,  Vec2.weak(204,73)   ,  Vec2.weak(218,35)   ,  Vec2.weak(215,34)   ,  Vec2.weak(202,72)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(197,71)   ,  Vec2.weak(199,71)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(195,70)   ,  Vec2.weak(197,70)   ,  Vec2.weak(195,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(179,65)   ,  Vec2.weak(181,65)   ,  Vec2.weak(179,64)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(85,65)   ,  Vec2.weak(85,64)   ,  Vec2.weak(16,58)   ,  Vec2.weak(82,65)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(82,66)   ,  Vec2.weak(82,65)   ,  Vec2.weak(16,58)   ,  Vec2.weak(79,66)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(79,67)   ,  Vec2.weak(79,66)   ,  Vec2.weak(16,58)   ,  Vec2.weak(76,67)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,68)   ,  Vec2.weak(76,67)   ,  Vec2.weak(73,68)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(60,74)   ,  Vec2.weak(60,73)   ,  Vec2.weak(57,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(55,76)   ,  Vec2.weak(55,75)   ,  Vec2.weak(52,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(51,78)   ,  Vec2.weak(51,77)   ,  Vec2.weak(48,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(47,80)   ,  Vec2.weak(47,79)   ,  Vec2.weak(44,80)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(17,55)   ,  Vec2.weak(17,58)   ,  Vec2.weak(18,55)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(18,52)   ,  Vec2.weak(18,55)   ,  Vec2.weak(19,52)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(43,35)   ,  Vec2.weak(43,36)   ,  Vec2.weak(46,35)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(48,33)   ,  Vec2.weak(48,34)   ,  Vec2.weak(51,33)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(55,30)   ,  Vec2.weak(55,31)   ,  Vec2.weak(58,30)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(58,29)   ,  Vec2.weak(58,30)   ,  Vec2.weak(61,29)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(63,27)   ,  Vec2.weak(63,28)   ,  Vec2.weak(66,27)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(66,26)   ,  Vec2.weak(66,27)   ,  Vec2.weak(69,26)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,24)   ,  Vec2.weak(73,25)   ,  Vec2.weak(76,24)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(186,23)   ,  Vec2.weak(183,23)   ,  Vec2.weak(186,24)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(194,25)   ,  Vec2.weak(191,25)   ,  Vec2.weak(194,26)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(197,26)   ,  Vec2.weak(194,26)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(200,27)   ,  Vec2.weak(197,27)   ,  Vec2.weak(197,70)   ,  Vec2.weak(200,28)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(203,28)   ,  Vec2.weak(200,28)   ,  Vec2.weak(197,70)   ,  Vec2.weak(203,29)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(206,29)   ,  Vec2.weak(203,29)   ,  Vec2.weak(206,30)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(211,31)   ,  Vec2.weak(208,31)   ,  Vec2.weak(211,32)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(218,34)   ,  Vec2.weak(215,34)   ,  Vec2.weak(218,35)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(221,35)   ,  Vec2.weak(218,35)   ,  Vec2.weak(221,36)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(235,42)   ,  Vec2.weak(232,42)   ,  Vec2.weak(235,43)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(248,55)   ,  Vec2.weak(247,55)   ,  Vec2.weak(247,73)   ,  Vec2.weak(248,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(241,83)   ,  Vec2.weak(241,82)   ,  Vec2.weak(238,83)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(238,84)   ,  Vec2.weak(238,83)   ,  Vec2.weak(221,81)   ,  Vec2.weak(225,83)   ,  Vec2.weak(235,84)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(222,83)   ,  Vec2.weak(225,83)   ,  Vec2.weak(222,82)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(206,75)   ,  Vec2.weak(209,75)   ,  Vec2.weak(206,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(199,72)   ,  Vec2.weak(202,72)   ,  Vec2.weak(199,71)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(188,68)   ,  Vec2.weak(191,68)   ,  Vec2.weak(188,67)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(185,67)   ,  Vec2.weak(188,67)   ,  Vec2.weak(185,66)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(93,63)   ,  Vec2.weak(93,62)   ,  Vec2.weak(16,58)   ,  Vec2.weak(89,63)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(89,64)   ,  Vec2.weak(89,63)   ,  Vec2.weak(16,58)   ,  Vec2.weak(85,64)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,69)   ,  Vec2.weak(73,68)   ,  Vec2.weak(69,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(65,72)   ,  Vec2.weak(65,71)   ,  Vec2.weak(61,72)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(17,73)   ,  Vec2.weak(18,73)   ,  Vec2.weak(17,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(69,25)   ,  Vec2.weak(69,26)   ,  Vec2.weak(73,25)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,23)   ,  Vec2.weak(76,24)   ,  Vec2.weak(80,23)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(80,22)   ,  Vec2.weak(80,23)   ,  Vec2.weak(84,22)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(89,20)   ,  Vec2.weak(89,21)   ,  Vec2.weak(93,20)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(174,20)   ,  Vec2.weak(170,20)   ,  Vec2.weak(174,21)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(183,22)   ,  Vec2.weak(179,22)   ,  Vec2.weak(183,23)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(191,69)   ,  Vec2.weak(195,69)   ,  Vec2.weak(191,68)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(181,66)   ,  Vec2.weak(185,66)   ,  Vec2.weak(181,65)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(175,64)   ,  Vec2.weak(179,64)   ,  Vec2.weak(175,63)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(166,62)   ,  Vec2.weak(170,62)   ,  Vec2.weak(166,61)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(162,61)   ,  Vec2.weak(166,61)   ,  Vec2.weak(162,60)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(103,61)   ,  Vec2.weak(103,60)   ,  Vec2.weak(16,58)   ,  Vec2.weak(98,61)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(98,62)   ,  Vec2.weak(98,61)   ,  Vec2.weak(16,58)   ,  Vec2.weak(93,62)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(84,21)   ,  Vec2.weak(84,22)   ,  Vec2.weak(89,21)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(179,21)   ,  Vec2.weak(174,21)   ,  Vec2.weak(179,22)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(191,24)   ,  Vec2.weak(186,24)   ,  Vec2.weak(191,25)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(170,63)   ,  Vec2.weak(175,63)   ,  Vec2.weak(170,62)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(161,18)   ,  Vec2.weak(154,18)   ,  Vec2.weak(161,19)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(145,59)   ,  Vec2.weak(152,59)   ,  Vec2.weak(145,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(60,73)   ,  Vec2.weak(61,72)   ,  Vec2.weak(16,58)   ,  Vec2.weak(57,74)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(51,77)   ,  Vec2.weak(52,76)   ,  Vec2.weak(16,58)   ,  Vec2.weak(48,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(47,79)   ,  Vec2.weak(48,78)   ,  Vec2.weak(16,58)   ,  Vec2.weak(44,80)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(19,52)   ,  Vec2.weak(17,58)   ,  Vec2.weak(33,41)   ,  Vec2.weak(27,44)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(241,82)   ,  Vec2.weak(242,81)   ,  Vec2.weak(245,77)   ,  Vec2.weak(247,73)   ,  Vec2.weak(232,42)   ,  Vec2.weak(221,81)   ,  Vec2.weak(238,83)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(222,82)   ,  Vec2.weak(225,83)   ,  Vec2.weak(221,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(119,59)   ,  Vec2.weak(119,58)   ,  Vec2.weak(16,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(111,60)   ,  Vec2.weak(111,59)   ,  Vec2.weak(16,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(26,82)   ,  Vec2.weak(28,83)   ,  Vec2.weak(38,83)   ,  Vec2.weak(17,69)   ,  Vec2.weak(20,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(23,80)   ,  Vec2.weak(25,81)   ,  Vec2.weak(20,76)   ,  Vec2.weak(21,78)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(19,75)   ,  Vec2.weak(20,76)   ,  Vec2.weak(17,69)   ,  Vec2.weak(18,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(21,49)   ,  Vec2.weak(20,51)   ,  Vec2.weak(27,44)   ,  Vec2.weak(25,45)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(93,19)   ,  Vec2.weak(93,20)   ,  Vec2.weak(101,19)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(101,18)   ,  Vec2.weak(101,19)   ,  Vec2.weak(197,70)   ,  Vec2.weak(109,18)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(231,41)   ,  Vec2.weak(229,40)   ,  Vec2.weak(232,42)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(237,44)   ,  Vec2.weak(235,43)   ,  Vec2.weak(232,42)   ,  Vec2.weak(247,73)   ,  Vec2.weak(247,55)   ,  Vec2.weak(239,46)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(241,47)   ,  Vec2.weak(239,46)   ,  Vec2.weak(247,55)   ,  Vec2.weak(245,51)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(244,79)   ,  Vec2.weak(245,77)   ,  Vec2.weak(242,81)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(235,85)   ,  Vec2.weak(235,84)   ,  Vec2.weak(227,84)   ,  Vec2.weak(227,85)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(170,19)   ,  Vec2.weak(161,19)   ,  Vec2.weak(170,20)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(38,84)   ,  Vec2.weak(38,83)   ,  Vec2.weak(28,83)   ,  Vec2.weak(28,84)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(154,17)   ,  Vec2.weak(144,17)   ,  Vec2.weak(154,18)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(152,60)   ,  Vec2.weak(162,60)   ,  Vec2.weak(152,59)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(16,69)   ,  Vec2.weak(17,69)   ,  Vec2.weak(16,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(109,17)   ,  Vec2.weak(109,18)   ,  Vec2.weak(197,70)   ,  Vec2.weak(144,17)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(249,58)   ,  Vec2.weak(248,58)   ,  Vec2.weak(248,70)   ,  Vec2.weak(249,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(65,71)   ,  Vec2.weak(67,70)   ,  Vec2.weak(16,58)   ,  Vec2.weak(61,72)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(181,65)   ,  Vec2.weak(185,66)   ,  Vec2.weak(179,64)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(55,75)   ,  Vec2.weak(57,74)   ,  Vec2.weak(16,58)   ,  Vec2.weak(52,76)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(43,36)   ,  Vec2.weak(37,39)   ,  Vec2.weak(17,58)   ,  Vec2.weak(46,35)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(48,34)   ,  Vec2.weak(46,35)   ,  Vec2.weak(17,58)   ,  Vec2.weak(51,33)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(55,31)   ,  Vec2.weak(51,33)   ,  Vec2.weak(17,58)   ,  Vec2.weak(80,23)   ,  Vec2.weak(73,25)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(63,28)   ,  Vec2.weak(61,29)   ,  Vec2.weak(73,25)   ,  Vec2.weak(69,26)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(206,30)   ,  Vec2.weak(203,29)   ,  Vec2.weak(197,70)   ,  Vec2.weak(208,31)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(211,32)   ,  Vec2.weak(208,31)   ,  Vec2.weak(197,70)   ,  Vec2.weak(213,33)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(221,36)   ,  Vec2.weak(218,35)   ,  Vec2.weak(204,73)   ,  Vec2.weak(223,37)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(206,74)   ,  Vec2.weak(209,75)   ,  Vec2.weak(204,73)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(199,71)   ,  Vec2.weak(202,72)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(194,26)   ,  Vec2.weak(191,25)   ,  Vec2.weak(186,24)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(186,24)   ,  Vec2.weak(183,23)   ,  Vec2.weak(179,22)   ,  Vec2.weak(174,21)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(174,21)   ,  Vec2.weak(170,20)   ,  Vec2.weak(161,19)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(161,19)   ,  Vec2.weak(154,18)   ,  Vec2.weak(144,17)   ,  Vec2.weak(197,70)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(120,16)   ,  Vec2.weak(120,17)   ,  Vec2.weak(144,17)   ,  Vec2.weak(144,16)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(93,20)   ,  Vec2.weak(89,21)   ,  Vec2.weak(17,58)   ,  Vec2.weak(145,58)   ,  Vec2.weak(101,19)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(73,68)   ,  Vec2.weak(76,67)   ,  Vec2.weak(16,58)   ,  Vec2.weak(69,69)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(76,24)   ,  Vec2.weak(73,25)   ,  Vec2.weak(80,23)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(191,68)   ,  Vec2.weak(195,69)   ,  Vec2.weak(101,19)   ,  Vec2.weak(179,64)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(33,41)   ,  Vec2.weak(17,58)   ,  Vec2.weak(37,39)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(84,22)   ,  Vec2.weak(80,23)   ,  Vec2.weak(17,58)   ,  Vec2.weak(89,21)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(170,62)   ,  Vec2.weak(175,63)   ,  Vec2.weak(101,19)   ,  Vec2.weak(162,60)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(152,59)   ,  Vec2.weak(162,60)   ,  Vec2.weak(101,19)   ,  Vec2.weak(145,58)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                        s = new Polygon(
                            [   Vec2.weak(179,64)   ,  Vec2.weak(101,19)   ,  Vec2.weak(175,63)   ],
                            mat,
                            filt
                        );
                        s.body = body;
                        s.sensorEnabled = false;
                        s.fluidEnabled = false;
                        s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
                    
                
            

            anchor = (true) ? body.localCOM.copy() : Vec2.get(0,101);
            body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
            body.position.setxy(0,0);

            bodies["MASK_Paddle"] = new BodyPair(body,anchor);
        
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
