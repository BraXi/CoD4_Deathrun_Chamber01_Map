// CoD4 In-Game Effects Manipulation Tool by BraXi 1.0 (2013-11-14)
// Entities places: 15
main()
{
	precache();

    // Effect #0
    ent = braxi\_fxutil::CreateEffect( "soundfx" );
    ent.v[ "origin" ] = ( 1035.35, -707.17, 70.1278 );
    ent.v[ "angles" ] = ( 0, 0, 0 );
    ent.v[ "soundalias" ] = "dead_soon";

    // Effect #1
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 3.4736, 196.714, -136.354 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #2
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 0.552653, 407.958, -152.56 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #3
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 7.82129, 616.816, -133.425 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #4
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 31.9095, 899.092, -121.905 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #5
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 317.571, 892.011, -127.375 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #6
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 607.562, 905.352, -140.251 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #7
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 901.162, 895.577, -120.444 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #8
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1169.32, 894.984, -133.231 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #9
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1343.8, 648.569, -142.232 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #10
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1336.03, 896.766, -143.376 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #11
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1345.54, 332.705, -138.54 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #12
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1342.69, -8.04349, -138.54 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #13
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1344.78, -319.404, -135.235 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    // Effect #14
    ent = braxi\_fxutil::CreateEffect( "loopfx" );
    ent.v[ "origin" ] = ( 1342.66, -619.985, -127.326 );
    ent.v[ "angles" ] = ( 270, 0, 0 );
    ent.v[ "fxid" ] = "dust_alley";
    ent.v[ "repeatDelay" ] = 10;

    braxi\_fxutil::init_effects();
}

precache()
{
	level._effect[ "acid_pour" ]	= loadFX( "maps/mp_deathrun_chamber1/acid_pour" );
	level._effect[ "spotlight" ]	= loadFX( "misc/hunted_spotlight_model" );
    level._effect[ "dust_alley" ]	= loadFX( "smoke/amb_smoke_add" );
	level._effect[ "dust" ]			= loadFX( "smoke/amb_dust" );
	level._effect[ "dust_wind_ch" ]   = loadFX( "dust/dust_wind_leaves_chernobyl" );
}