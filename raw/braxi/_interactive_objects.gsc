///////////////////////////////////////////////////////////////
////|         |///|        |///|       |/\  \/////  ///|  |////
////|  |////  |///|  |//|  |///|  |/|  |//\  \///  ////|__|////
////|  |////  |///|  |//|  |///|  |/|  |///\  \/  /////////////
////|          |//|  |//|  |///|       |////\    //////|  |////
////|  |////|  |//|         |//|  |/|  |/////    \/////|  |////
////|  |////|  |//|  |///|  |//|  |/|  |////  /\  \////|  |////
////|  |////|  |//|  | //|  |//|  |/|  |///  ///\  \///|  |////
////|__________|//|__|///|__|//|__|/|__|//__/////\__\//|__|////
///////////////////////////////////////////////////////////////
/*
        "deathrun_ambush" map for Death Run Mod >=1.3
 
        This map is partialy based on singleplayer map 'The Sins of the Father' mission from COD4:SP,
        although it's not an exact remake of that map, I still cannot forget to credit IW for idea.
       
        The map will work harmlessly only with DR 1.3, in 1.2 and older versions of mod it may cause
        undefined behavior such as problems with activator not being able to enter ac130 when
        previous activator leaves the server during game. I'm not going to patch it, 1.2 is a
        piece of history and history should not be changed.
 
        Website: www.braxi.org
        E-mail: paulina1295@o2.pl


fx,props/tincan_bounce


xmodel,com_copypaper_box
fx,props/copypaper_box_exp


xmodel,com_security_camera
xmodel,com_security_camera_destroyed
fx,props/securitycamera_explosion


xmodel,com_tv2_d
xmodel,com_tv1
xmodel,com_tv2
xmodel,com_tv1_testpattern
xmodel,com_tv2_testpattern
fx,explosions/tv_explosion


fx,explosions/exp_pack_doorbreach


pipes:
fx,impacts/pipe_fire
fx,impacts/pipe_water
fx,impacts/pipe_steam

fx,explosions/pipe_explosion64 		
fx,explosions/pipe_explosion128

*/

#include maps\mp\_utility;
#include common_scripts\utility; // array_thread

init()
{
	level.breakables_fx = [];

	tincans = getEntArray( "tincan", "targetname" );
	if( isDefined( tincans ) && tincans.size )
	{
		level.breakables_fx[ "tincan" ] = loadFX( "props/tincan_bounce" );

		array_thread( tincans, ::tincan_think );
	}

	copypaper = getEntArray( "copypaper_box", "targetname" );
	if( isDefined( copypaper ) && copypaper.size )
	{
		level.breakables_fx[ "copypaper_box" ] = loadFX( "props/copypaper_box_exp" );

		array_thread( copypaper, ::copypaper_think );
	}

	security_camera_array = getentarray( "destroyable_security_camera", "targetname" );
	if( isDefined( security_camera_array ) && security_camera_array.size )
	{
		precacheModel( "com_security_camera" );
		precacheModel( "com_security_camera_destroyed" );
		
		level.breakables_fx[ "security_camera_explode" ] = loadFX( "props/securitycamera_explosion" );

		array_thread( security_camera_array, ::security_camera_logic );
	}


	tv_array = getEntArray( "interactive_tv", "targetname" );
	if( isDefined( tv_array ) && tv_array.size )
	{
		precacheModel( "com_tv2_d" );
		precacheModel( "com_tv1" );
		precacheModel( "com_tv2" );
		precacheModel( "com_tv1_testpattern" );
		precacheModel( "com_tv2_testpattern" );
	
		level.breakables_fx[ "tv_explode" ] = loadfx( "explosions/tv_explosion" );

		level.onTVDeath = undefined; // func( tv_ent )
		level.onTVOn = undefined;	// func( tv_ent, user )
		level.onTVOff = undefined;	// func( tv_ent, user )

		array_thread( tv_array, ::tv_logic );
	}


	door_array = getEntArray( "door", "targetname" );
	if( isDefined( door_array ) && door_array.size )
	{
		level.breakables_fx[ "door_break" ] = loadfx( "explosions/exp_pack_doorbreach" );

		array_thread( door_array, ::door_think );
	}

	door_array = getEntArray( "blast_door", "targetname" );
	if( isDefined( door_array ) && door_array.size )
	{
		array_thread( door_array, ::blast_door_think );
	}




	masters = getEntArray( "pipe_shootable", "targetname" );
	if( isDefined( masters ) && masters.size )
	{
		level.pipe_array = [];

		level._effect[ "pipe" ]["gas_impact"]				= loadFX( "impacts/pipe_fire" );
		level._effect[ "pipe" ]["water_impact"]				= loadFX( "impacts/pipe_water" );
		level._effect[ "pipe" ]["steam_impact"]				= loadFX( "impacts/pipe_steam" );

		level._effect["pipe_interactive"]["explode_32"]		= loadFX( "explosions/pipe_explosion64" ); 	
		level._effect["pipe_interactive"]["explode_64"]		= loadFX( "explosions/pipe_explosion64" ); 	
		level._effect["pipe_interactive"]["explode_96"]		= loadFX( "explosions/pipe_explosion128" ); 	
		level._effect["pipe_interactive"]["explode_128"]	= loadFX( "explosions/pipe_explosion128" ); 

		for( i = 0; i < masters.size; i++ )
		{
			level.pipe_array[ level.pipe_array.size ] = masters[i];
			masters[i].numElements = 1;
			masters[i] find_pipes();
		}

		if( isDefined( level.pipe_array ) && level.pipe_array.size )
		{	
			for( i = 0; i < level.pipe_array.size; i++ )
					level.pipe_array[i] thread pipe_think();
		}
	}
}

find_pipes()
{
	ent = self;
	while( isDefined( ent ) && isDefined( ent.target ) ) 
	{
		next = getEnt( ent.target, "targetname" );
		if( next.size )
		{
			level.pipe_array[ level.pipe_array.size ] = next;
			self.numElements ++;
		}
		ent = next;
	}
}


DrawDebugInfo()
{
/#
	ent = self;

	color = ( 1,0.8,0 );
	

	while( isDefined( self ) )
	{
		//Print3d( <origin>, <text>, <color>, <alpha>, <scale>, <duration> )
		//print3d( self.origin + (0,0,8), ("#" + ent getentitynumber() ), (1.0,0.7,0), 1.0, 0.3, 1 );
		if( isDefined( self.target ) )
			print3d( self.origin + (0,0,4), "target: " + self.target, (0,0.8,0), 1.0, 0.3, 1 );
		else
			print3d( self.origin + (0,0,4), "HAS NO TARGET!!!", (0,0.8,0), 1.0, 0.3, 1 );

		if( isDefined( self.numElements ) )
			print3d( self.origin + (0,0,-3), "elements: " + self.numElements, (0,0.8,0), 1.0, 0.3, 1 );


		center = self.origin - (0,0,4);

		forward = vector_scale( anglestoForward( (0,0,0) ), 4 );
		right = vector_scale( anglestoright( (0,0,0) ), 4 );

		a = center + forward - right;
		b = center + forward + right;
		c = center - forward + right;
		d = center - forward - right;
			
		//line(start, end, color, depthTest)
		line( a, b, color, 1 );
		line( b, c, color, 1 );
		line( c, d, color, 1 );
		line( d, a, color, 1 );

		line( a, a + (0, 0, 8), color, 1 );
		line( b, b + (0, 0, 8), color, 1 );
		line( c, c + (0, 0, 8), color, 1 );
		line( d, d + (0, 0, 8), color, 1 );
		
		a = a + (0, 0, 8);
		b = b + (0, 0, 8);
		c = c + (0, 0, 8);
		d = d + (0, 0, 8);
			
		line( a, b, color, 1 );
		line( b, c, color, 1 );
		line( c, d, color, 1 );
		line( d, a, color, 1 );
		wait 0.05;
	}
#/
}

pipe_think()
{
	self thread DrawDebugInfo();
	self.isPipe = true;

	//self.pipe_length = 96;
	self.pipe_length = int(strtok(strtok(self.model,"_")[2],"x")[1]);
	

/*		vec = anglestoforward(self.angles);
		vec1 = vector_multiply(vec, (64,64,64) );
		self.point_A = self.origin + vec1;
		vec1 = vector_multiply(vec, (-64,-64,-64));
		self.point_B = self.origin + vec1;
*/
	vec = vector_scale( anglesToForward(self.angles), self.pipe_length );
	self.point_A = self.origin-vec;
	self.point_B = self.origin+vec;

	switch( strtok( self.model, "_" )[3] )
	{
	case "gas":
		self.type = "gas";
		self.ptr_onDamage = ::pipe_gas_on_damage;
		break;
	case "metal":
		self.type = "water";
		self.ptr_onDamage = ::pipe_void_on_damage;
		break;
	case "ceramic":
		self.type = "steam";
		self.ptr_onDamage = ::pipe_void_on_damage;
		break;
	default:
		self.ptr_onDamage = undefined;
		iprintlnbold( "pipe at (" +self.origin+ ") doesn't have a recognizable type" );
		break;
	}

iprintlnbold( "pipe" );
	self thread pipe_watch_damage();
}

is_pipe()
{
	if( isDefined( self.isPipe ) )
		return true;
	return false;
}

pipe_watch_damage()
{
	self endon("deleting");

	self.maxhealth = 600;
	self.health = self.maxhealth;

	self setCanDamage( true );
	
	P = (0,0,0); //just to initialize P as a vector
	self.numfx = 0;

	while( isDefined( self ) )
	{
		self waittill( "damage", damage, attacker, direction_vec, P, type );

		if( type == "MOD_MELEE" || type == "MOD_IMPACT" || type == "MOD_FALLING" || type == "MOD_EXPLOSIVE" )
			continue;
		if( !isDefined(attacker) || isDefined( attacker ) && attacker is_pipe() || isDefined( attacker ) && attacker == level|| isDefined( attacker ) && attacker == self ) // lets not blow up the whole map again lol
			continue;

//		if( !distance( (0,0,0), P ) )
//			P = (2,2,2);

		self.numfx ++;
		vec = vectorFromLineToPoint( self.point_A, self.point_B, P );

//		playFx( level._effect[ "pipe" ][ self.type+"_impact" ], P, direction_vec );	
		playFx( level._effect[ "pipe" ][ self.type+"_impact" ], P, vec );	
		self.numfx ++;

		self.health -= damage;

		if( isDefined( self.ptr_onDamage ) )
			self thread [[self.ptr_onDamage]]( attacker, damage, vec, P, type );
	}
}

pipe_void_on_damage( attacker, damage, direction_vec, P, type )
{
	// nothing here
}

pipe_gas_on_damage( attacker, damage, direction_vec, P, type )
{
	if( self.health > 0 )
		return;

	self notify( "deleting" );

	wait 0.4 + randomFloat(0.5);

	nextPipe = undefined;
	if( isDefined( self.target ) && getEntArray( self.target, "targetname" ).size )
		nextPipe = getEnt( self.target, "targetname" );

	vec = vectorFromLineToPoint( self.point_A, self.point_B, P );
	playFx( level._effect["pipe_interactive"]["explode_"+self.pipe_length], self.origin, anglesToUp( self.angles ), anglesToForward( self.angles )  );
	self playSound( "explo_rock" );

	if( isPlayer( attacker ) && isPlayer( attacker ) )
		radiusDamage( self.origin, int(self.pipe_length*2), 250, 30, attacker );
	else
		radiusDamage( self.origin, int(self.pipe_length*2), 250, 30, self );

	earthQuake( 0.46, 1.6, self.origin, 600 );

	self delete();
	wait 0.1;
	if( isDefined( nextPipe ) )
	{
		if( isPlayer( attacker ) && isPlayer( attacker ) )
			nextPipe notify( "damage", 9999, attacker, nextPipe.origin + (0,0,10), (0,313,12), "MOD_PROJECTILE" );
		else
			nextPipe notify( "damage", 9999, undefined, nextPipe.origin + (0,0,10), (0,313,12), "MOD_PROJECTILE" );
	}

}

tincan_think()
{
	if ( self.classname != "script_model" )
		return;
	
	self setCanDamage( true );
	self waittill( "damage", damage, ent, direction_vec, direction_org, type );
	
	//direction_org = ( self.origin - (0,0,randomint( 50 ) + 50) );
	//direction_org = ent.origin;
	
	direction_vec = vectornormalize( self.origin - direction_org );
	direction_vec = vectorScale( direction_vec, .5 + randomfloat( 1 ) );
	
	self notify( "death" );
	playfx( level.breakables_fx[ "tincan" ], self.origin, direction_vec );
	self delete();
}


copypaper_think()
{
	if ( self.classname != "script_model" )
		return;
	
	self setCanDamage( true );
	self waittill( "damage", damage, ent, direction_vec, direction_org, type );
	
	direction_vec = vectornormalize( self.origin - direction_org );
	direction_vec = vectorScale( direction_vec, .5 + randomfloat( 1 ) );
	
	self notify( "death" );
	playfx( level.breakables_fx[ "copypaper_box" ], self.origin, direction_vec );
	self delete();
}



security_camera_logic()
{
	self setCanDamage( true );
	self setModel( "com_security_camera" );

	self waittill( "damage", damage, other, direction_vec, P, type );
	
	self setModel( "com_security_camera_destroyed" );
	playFxOnTag( level.breakables_fx[ "security_camera_explode" ], self, "tag_deathfx" );
}




/****************************
Interactive TV

	script_model ("targetname" = "interactive_tv")
		 |
		 | .target
		\|/
	trigger_use(_touch)

****************************/

tv_logic()
{
	self setCanDamage( true );

	self.damageModel = "com_tv2_d";
	self.offModel = "com_tv2";
	self.onModel = "com_tv2_testpattern";

	if( IsSubStr( self.model, "1" ) )
	{
		self.offModel = "com_tv1";
		self.onModel = "com_tv1_testpattern";
	}

	self.useTrig = getEnt( self.target, "targetname" );
	if( self.useTrig.classname == "trigger_use" )
		self.useTrig useTriggerRequireLookAt();
	self.useTrig setCursorHint( "HINT_NOICON" );
		
	self thread tv_damage();
	self thread tv_trig();
}

tv_trig()
{
	self.useTrig endon( "death" );
	
	while( isDefined( self ) )
	{		
		wait 0.2;
		self.useTrig waittill( "trigger", user );
		// it would be nice to play a sound here
		
		if ( self.model == self.offModel )
		{
			self notify( "on" );

			self setModel( self.onModel );
			if( isDefined( level.onTVOn ) )
				[[ level.onTVOn ]]( self, user );
		}
		else
		{
			self notify( "off" );

			self setModel( self.offModel );
			if( isDefined( level.onTVOff ) )
				[[ level.onTVOff ]]( self, user );
		}
	}
}


tv_damage()
{
	other = undefined;
	while( isDefined( self ) )
	{
		self waittill( "damage", damage, other, direction_vec, P, type );

		if( !isAlive( other ) || !isPlayer( other ) )
			continue;
		break;			
	}
			
	if( isDefined( level.onTVDeath ) )
		[[ level.onTVDeath ]]( self, other );
	
	self notify( "off" );
	self.useTrig notify( "death" );
		
	self setModel( self.damageModel );

	playFxOnTag( level.breakables_fx[ "tv_explode" ], self, "tag_fx" );
	self playSound( "tv_shot_burst" );

	self.useTrig delete();
}

door_think()
{
	triggers = getEntArray( self.target, "targetname" );
	for( i = 0; i < triggers.size; i++ )
	{
		triggers[i] thread door_trigger_think( self );
	}

	self.canUse = true;


	if( !isDefined( self.script_health ) || !self.script_health )
	{
		return;
	}

	allowedDamageMethods = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE MOD_IMPACT MOD_MELEE";

	self SetCanDamage( true );
	self.health = self.script_health;

	while( self.health > 0 )
	{
		self waittill( "damage", damage, other, direction_vec, P, mod );

		if( !isAlive( other ) || !isPlayer( other ) || !isSubstr( allowedDamageMethods, mod ) )
			continue;

		self.health -= damage;		
	}


	self notify( "broken" );

	for( i = 0; i < triggers.size; i++ )
		triggers[i] delete();

	self.angles = (0,0,0);
	self hide();
	self notSolid();
	wait 0.05;

	playFX( level.breakables_fx[ "door_break" ], self.origin );
	self playSound( "detpack_explo_wood" );

	wait 4;
	self delete();
}


door_trigger_think( door )
{
	door endon( "broken" );

	DOOR_CLOSED = 0;
	DOOR_OPEN_IN = 1;
	DOOR_OPEN_OUT = 2;

	door.currentState = DOOR_CLOSED;

	while( isDefined( self ) && isDefined( door ) )
	{
		self waittill( "trigger", user );
		
		if( !door.canUse )
			continue;
		door.canUse = false;

		newState = 0;
		rotateYaw = 0;
		switch( door.currentState )
		{
		case 0: /*DOOR_CLOSED*/
			if( self.script_noteworthy == "outside" )
			{
				newState = DOOR_OPEN_IN;
				if( door.script_noteworthy == "left" )
					rotateYaw = 90;
				else if( door.script_noteworthy == "right" )
					rotateYaw = -90;
			}
			else if( self.script_noteworthy == "inside" )
			{
				newState = DOOR_OPEN_OUT;
				if( door.script_noteworthy == "left" )
					rotateYaw = -90;
				else if( door.script_noteworthy == "right" )
					rotateYaw = 90;
			}
			break;

		case 1: /*DOOR_OPEN_IN*/
			newState = DOOR_CLOSED;
				if( door.script_noteworthy == "left" )
					rotateYaw = -90;
				else if( door.script_noteworthy == "right" )
					rotateYaw = 90;
			break;

		case 2: /*DOOR_OPEN_OUT*/
			newState = DOOR_CLOSED;
				if( door.script_noteworthy == "left" )
					rotateYaw = 90;
				else if( door.script_noteworthy == "right" )
					rotateYaw = -90;
			break;
		}

		door.currentState = newState;

		door rotateYaw( rotateYaw, 0.7 );
		door waittill( "rotatedone" );

		door.canUse = true;
	}
}



blast_door_think()
{
	trig = self;
	door = getEnt( self.target, "targetname" );
	clip = getEnt( door.target, "targetname" );

	clip linkTo( door );

	trig waittill( "trigger" );
	trig delete();

	door moveZ( 96, 2.3, 0.4, 0.4 );
	door playSound( "blast_door_open" );
}