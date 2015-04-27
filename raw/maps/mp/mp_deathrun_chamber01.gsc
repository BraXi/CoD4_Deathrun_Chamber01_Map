/*

	BraXi.

*/
#include common_scripts\utility;
#include maps\mp\_utility;
main()
{
	maps\mp\_load::main();
	maps\mp\mp_deathrun_chamber01_fx::main();

	precache();
	thread braxi\_interactive_objects::init();

	ambientPlay( "ambient_course01" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

//	acid = getEntArray( "acid_area", "targetname" );
//	for( i = 0; i < acid.size; i++ )
//		acid[i] thread acid_think();

	fans = getEntArray( "fan_yaw", "targetname" );
	for( i = 0; i < fans.size; i++ )
		fans[i] thread fan_yaw_think();


	addTriggerToList( "trap1_trigger" );
	addTriggerToList( "trap2_trigger" );
	addTriggerToList( "trap3_trigger" );
	addTriggerToList( "trap4_trigger" );
	addTriggerToList( "trap5_trigger" );
	addTriggerToList( "trap6_trigger" );

	thread trap_one();
	thread trap_two();
	thread trap_three();
	thread trap_four();
	thread trap_five();
	thread trap_six();

	thread moving_platform();

//	thread helicopter_init();
}


precache()
{
	precacheModel( "vehicle_blackhawk_sas_night" );
	precacheModel( "acid_260x680" );
	precacheModel( "com_widescreen_monitor_on_1" );
	precacheModel( "com_widescreen_monitor" );
	precacheModel( "com_computer_keyboard" );
	precacheModel( "com_computer_keyboard_obj" );
}


addTriggerToList( name )
{
	if( !isDefined( level.trapTriggers ) )
	level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );

	level.trapTriggers[level.trapTriggers.size-1] thread trap_activation_trigger_think( level.trapTriggers.size );
}

trap_activation_trigger_think( id )
{
	screen = getEnt( self.target, "targetname" );
	keyboard = getEnt( screen.target, "targetname" );

	keyboard setModel( "com_computer_keyboard_obj" );

	self waittill( "trigger" );

	keyboard setModel( "com_computer_keyboard" );

	level waittill( "trap_"+id+"_done" );
	screen setModel( "com_widescreen_monitor" );
}


fan_yaw_think()
{
	while( 1 )
	{
		self rotateYaw( 360, 2 );
		wait 2;
	}
}

acid_init()
{
	acid = getEntArray( "acid_area", "targetname" );
	for( i = 0; i < acid.size; i++ )
		acid[i] thread acid_think();
}

acid_think()
{
	effects = [];

	self waittill( "trigger" );

	pipes = getEntArray( self.target, "targetname" );

	wait( 3 + randomFloat( 2 ) );

	for( i = 0; i < pipes.size; i++ )
	{
		ent = braxi\_fxutil::createEffect( "oneshotfx" );
		ent.v["origin"] = pipes[i].origin - ( 0,0,110 );
		ent.v["angles"] = (270,0,0);
		ent.v["fxid"] = "acid_pour";
		effects[effects.size] = ent;

		wait( 0.05 + randomFloat( 0.1 ) );
		braxi\_fxutil::TriggerEffect( ent );
	}

	wait 10;
	self thread acid_damage();
	for( i = i; i < 37; i++ )
	{
		self.origin += (0,0,2);
		wait 0.05;
	}


	wait 0.6;
	for( i = 0; i < effects.size; i++ )
		braxi\_fxutil::TriggerEffect( effects[i] );
}

acid_damage()
{
	wait 1.2;
	while( 1 )
	{
		self waittill( "trigger", player );

		if( isDefined( level.activ ) )
			RadiusDamage( player.origin, 2, 5, 5, level.activ );
		else
			RadiusDamage( player.origin, 2, 5, 5 );
	}
}



trap_one()
{
	trig = getEnt( "trap1_trigger", "targetname" );
	platform = getEnt( "trap1_platform", "targetname" );
	crusher = getEnt( "trap1_crusher", "targetname" ); // in case platform gets blocked

	trig waittill( "trigger" );
	trig delete();

	crusher enableLinkTo();
	crusher linkTo( platform );

	platform playSound( "chamber1_platform_down" );
	platform moveZ( -116, 1.0, 0.05, 0.2 );
	platform waittill( "movedone" );

	level notify( "trap_1_done" );
}


trap_two()
{
	trig = getEnt( "trap2_trigger", "targetname" );
	
	pipe = getEntArray( "pipe_shootable", "targetname" );
	for( i = 0; i < pipe.size; i++ )
	{
		if( isDefined( pipe[i].script_noteworthy ) && pipe[i].script_noteworthy == "trap2" )
		{
			pipe = pipe[i];
			break;
		}
	}

	user = undefined;
	trig waittill( "trigger", user );
	trig delete();

	if( isDefined( pipe ) )
		pipe notify( "damage", 9999, user, pipe.origin + (0,0,10), (0,313,12), "MOD_PROJECTILE" );

	level notify( "trap_2_done" );
}



trap_three()
{
	trig = getEnt( "trap3_trigger", "targetname" );
	pusher = getEnt( "pusher", "targetname" );
	hurtTrigger = getEnt( pusher.target, "targetname" ); // in case platform gets blocked

	trig waittill( "trigger" );
	trig delete();

	hurtTrigger enableLinkTo();
	hurtTrigger linkTo( pusher );

	pusher moveY( -208, 1, 0.05, 0.2 );
	pusher waittill( "movedone" );
	
	wait 1;
	
	hurtTrigger thread trap_three_crusher( 1 );

	pusher moveY( 208, 1.2 );
	pusher waittill( "movedone" );

	hurtTrigger.canDealDamage = false;

	pusher moveY( 184, 4 );
	wait 2;
	hurtTrigger.canDealDamage = true;

	pusher waittill( "movedone" );

	level notify( "trap_3_done" );
}


trap_three_crusher( time )
{
	level endon( "trap_3_done" );

	wait time;
	self.canDealDamage = true;

	while( 1 )
	{
		self waittill( "trigger", player );

		if( !self.canDealDamage )
			continue;

		if( isDefined( level.activ ) )
			RadiusDamage( player.origin, 2, 100, 100, level.activ );
		else
			RadiusDamage( player.origin, 2, 100, 100 );
	}
}

trap_four()
{
	trig = getEnt( "trap4_trigger", "targetname" );
	brushes = getEntArray( "trap4_brushes", "targetname" );

	trig waittill( "trigger" );
	trig delete();

	brushes[randomInt(2)] notSolid();
	brushes[2+randomInt(2)] notSolid();

	level notify( "trap_4_done" );
}


trap_five()
{
	trig = getEnt( "trap5_trigger", "targetname" );
	pusher = getEnt( "pusher2", "targetname" );

	thread trap_five_platform_front();

	trig waittill( "trigger" );
	trig delete();

	pusher rotateYaw( -90, 0.7, 0.2, 0.05 );
	wait 4.2;
	pusher rotateYaw( 90, 0.7, 0.2, 0.05 );
	wait 1;

	level notify( "trap_5_done" );
}

trap_five_platform_front()
{
	platform = getEntArray( "rotating_platform", "targetname" )[0];

	while( 1 )
	{
		platform rotateYaw( 360, 3 );
		wait 3;
		platform rotateYaw( -360, 3 );
		wait 3;
	}
}


trap_six()
{

	trig = getEnt( "trap6_trigger", "targetname" );
	platform = getEntArray( "rotating_platform", "targetname" )[1];

	trig waittill( "trigger" );
	trig delete();

	while( 1 )
	{
		time = ( 1.7 + randomFloat( 2 ) );
		platform rotateYaw( -360, time );
		wait time;

		time = ( 1.7 + randomFloat( 2 ) );
		platform rotateYaw( 360, time );
		wait time;
	}

	level notify( "trap_6_done" );
}

openDoor()
{
	level.door_trig waittill( "trigger" );
	level.door_trig delete();
	brush = level.door;
	brush moveZ( 120, 7 );
}

moving_platform()
{
	brush = getEnt( "moving_platform", "targetname" );

	points = [];
	points[points.size] = getEnt( brush.target, "targetname" ).origin;
	points[points.size] = brush.origin;

	wait .05;
	while(1)
	{
		brush stopLoopSound();
		brush playLoopSound( "platform_move" );
		brush moveTo( points[0], 2, 0.2, 0.3 );
		
		wait 2;
		
		brush stopLoopSound();
		brush playLoopSound( "platform_beep" );

		wait 1;

		brush stopLoopSound();
		brush playLoopSound( "platform_move" );
		brush moveTo( points[1], 2, 0.2, 0.3 );

		wait 2;

		brush stopLoopSound();
		brush playLoopSound( "platform_beep" );

		wait 1;
	}
}


helicopter_set_defaults()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 40, 25 );	
	self setyawspeed( 75, 45, 45 );
	//self setjitterparams( (30, 30, 30), 4, 6 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 32 );
	self setturningability(1.0);

	self.maxhealth = 1500;
	self.health = self.maxhealth;

	self setDamageStage( 3 );
}


//eFlak88 SetLookAtEnt( eFlaktarget );


helicopter_init()
{
	wait 5;

	start = ( -128, 224, 848 );
	p = getentarray( "player", "classname" )[0];


	while( !p meleebuttonpressed() )
		wait 0.05;

	level.chopper = spawnHelicopter( p, start, (0,90,0), "cobra_mp", "vehicle_blackhawk_sas_night" );
	level.chopper playLoopSound( "chamber1_helicopter_over" );
	level.chopper helicopter_set_defaults();

	wait 0.1;
	level.chopper helicopter_setturrettargetent( p );
	level.chopper thread helicopter_searchlight_on();
}




helicopter_setturrettargetent( ent )
{
	level.helicopter_aimtarget = ent;
	level.chopper SetTurretTargetEnt( level.helicopter_aimtarget );
}

helicopter_getturrettargetent()
{
	return level.helicopter_aimtarget;
}


helicopter_searchlight_off()
{
	if ( isdefined( level.fx_ent ) )	
		level.fx_ent delete();
}

helicopter_searchlight_on()
{
	while ( distance( helicopter_getturrettargetent().origin, self.origin ) > 7000 )
	{
		wait 0.2;
	}

	self helicopter_searchlight_off();
	
//	self startIgnoringSpotLight();

//	self spawn_searchlight_target();
//	self helicopter_setturrettargetent( self.spotlight_default_target );

	self.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
	self.dlight setModel( "tag_origin" );

	self thread helicopter_searchlight_effect();

	level.fx_ent = spawn( "script_model", self gettagorigin("tag_barrel") );
	level.fx_ent setModel( "tag_origin" );
	level.fx_ent linkto( self, "tag_barrel", ( 0,0,0 ), ( 0,0,0 ) );

	wait 0.5;
	playfxontag (level._effect["spotlight"], level.fx_ent, "tag_origin");


}


helicopter_searchlight_effect()
{
	self endon("death");

	self.dlight.spot_radius = 256;
	
	count = 0;
	while( true )
	{
		targetent = self helicopter_getturrettargetent();

		if( !isDefined( targetent ) )
		{
			wait 0.1;
			continue;
		}
		

		self SetVehGoalPos( targetent.origin + (-200,0,930), 1 );
		self waittillmatch( "goal" );

		//self SetTurretTargetEnt( level.helicopter_aimtarget ); //, level.helicopter_aimtarget.origin );

		/*self.dlight.spot_radius = 128;

		vector = anglestoforward( self gettagangles( "tag_barrel" ) );
		start = self gettagorigin( "tag_barrel" );
		end = self gettagorigin( "tag_barrel" ) + vector_multiply ( vector, 3000 );

		trace = bullettrace( start, end, false, self );
		dropspot = trace[ "position" ];
		dropspot = dropspot + vector_multiply ( vector, -96 );

		self.dlight moveto( dropspot, .5 );*/

		wait .8;
	}
}