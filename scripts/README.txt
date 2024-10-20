SkyGFX 4.2 for SA by aap/The Hero
=================================

NB: skygfx.dll and skygfx.asi are the exact same file. I only renamed the dll to asi for convenience because some people
are really mad (like really, really mad) that I no longer used .asi as the extension for my mods. So because I'm always
so nice to everyone I've included the file twice now, but YOU DON'T need both.

How to install, requirements, notes:
- Use the compact or hoodlum exe
- Use a DLL/ASI loader and place skygfx.dll/asi where it will find it, place the inis into the same directory
- If you want Neo vehicle reflections or rain droplets, copy the neo directory to your GTA SA root dir
- If you want to use the mobile colorcycle, place colorcycle.dat into your data directory
- SkyGfx will load skygfx1-9.ini, if they can't be found it will fall back to skygfx.ini (F10 cycles through these by default, but see the ini settings)
- In the ini a ; will cause the rest of the line to be ignored
- You should use SilentPatch
- Use a PS2 timecyc.dat or timecycp.dat, the latter comes with the PC game, just rename it.
  If you insist on using a PC timecyc.dat, set usePCTimecyc=1 in the ini
- for a description of the many settings, see the comments in skygfx.ini
- Since the PC vehicles don't work too well with the PS2 reflections (too much reflection), you should use my PS2 vehicles for PC (http://gtaforums.com/topic/759642-sarel-ps2-vehicles-for-pc/)
- To get the big PS2 sun, use the seabed.ipl from the PS2 game (reduces draw distance) and SilentPatch (disables depth test)
- If you're using SAMP, make sure to use SAMPGraphicRestore. As of version 3.6 SkyGFX tries to work around the graphical bugs.
- If you want to get rid of all blurryness, use these ini settings:
	blurLeft=   0
	blurTop=    0
	blurRight=  0
	blurBottom= 0
	radiosityFilterPasses=0

Install the debugmenu to change settings from within the game.

Credits: ThirteenAG for porting the neo water drops from skygfx_vc and implementing blood drops as well
         NTAuthority and Silent for their code and being generally helpful.
         Dexx.
         ASH for the neo reflection files.
	 El Dorado, Snowshoe, Noskillx for helping with debugging
         Everyone else who had suggestions, reported bugs, spotted differences and so on...

For (outdated) screenshots see this: http://imgur.com/a/B4bUS


List of features (roughly in order of implementation)
- PS2 postfx color filter
- PS2 car reflections
- disabled high quality shadows (not in cutscenes yet)
- PS2 grass
- PS2 radiosity
- dual pass to emulate PS2 alpha test (discarded pixels still write color but not depth)
- PS2 color modulation
- disabled far away clouds
- fixed pointlight fog (e.g. disco)
- PS2 infrared vision
- PS2 night vision
- UV animation in day-night pipeline
- Xbox vehicle pipeline
- accurate mobile colorcycle
- force world pipeline via DFF
- disable gamma setting
- Spec vehicle pipeline: PS2 base with Xbox-like specular lighting
- Neo screen rain droplets
- Neo-style screen blood droplets
- Improved Neo car reflections
- Fixed near water square color
- Optional sun glare on cars for VC (thanks to fastman92 for the function address)
- III and VC sharptrails (mainly to be used with GTA UG)
- Transparent aim lockon
- PS2 grain (vision fx and rain)
- Fixed ambient light on buildings, PC lightning flash that illuminates everything optional
- YCbcr colour tweak
- fixed moon phase separately from SilentPatch


More detailed explanation of some ini settings:

ps2Modulate
    The PS2 has a different way of modulating textures with colors than the
fixed function pipeline of Direct3D (or OpenGL for that matter). When no texture
is being used, colors work exactly the same. Modulation means the texture's
color channels are multiplied with the vertex color. When the vertex color is
white (1.0 1.0 1.0 1.0), the resulting color will be the same as that of the
original texture. In D3D white is represented by RGBA [255 255 255 255]. On the
PS2 (when texturing is being used) white is [128 128 128 128] (so each color
channel is a 1.7 fixed point value). This means using values above 128 actually
brightens the texture.
    In San Andreas the building and grass pipelines (also some postfx) make use
of that feature and use color values above 128.
    This can be emulated by a pixel shader or the D3DTOP_MODULATE2X texture op.

dualPass
    The PS2 has a much more customizable alpha test than Direct3D or OpenGL.
When the alpha test is enabled, every pixel that is to be drawn will be
discarded if it doesn't pass the test. The test is typically passed if a pixel's
alpha value is above or below a reference value. This is typically used to
discard "too transparent" pixels to avoid pixels behind these (almost) invisible
pixels failing the depth test and not being drawn (causing the so called "alpha
bug"). A discarded pixel in D3D or OpenGL is completely discarded and not drawn
at all. On the PS2, however, you can specify what happens to discarded pixels.
In RW the discarded pixel's color is still written to the framebuffer, but it's
depth is not written to the z-buffer.
    To emulate this alpha test all transparent geometry has to be drawn twice:
once to write color and depth for all pixels above the alpha reference value
and once to write only color for all pixels below the reference value.

usePCTimecyc
    The difference in PC and PS2 timecyc files this setting refers to are the
Alpha1/2 values. An alpha value of 1.0 is represented in D3D and OpenGL by 255,
but by 128 on the PS2 (due to the different blending equation of the PS2).
If you use a file with D3D alpha values, set this setting to 1, otherwise 0.
From the stock files, only the PC timecyc.dat has PC alphas. The PS2/Xbox
timecyc.dat (NTSC) and the timecycp.dat (PAL, still present but unused in
the PC game) both have PS2 alphas.

buildingPipe
    This setting controls the CCustomBuildingDNPipeline. If not set, my hook
is completely disabled and you won't get any of the features I implemented for
it. The differences from the default PC pipeline are:
- smooth day-night cycle done in the vertex shader
- dual pass (see above)
- PS2 reflections for reflective buildings
- PS2 color modulation (see above)
- UV animation
    This switch (PS2/PC) effectively only controls the way reflections are done
because the other features are either not configurable or set by a different ini
switch. PC reflections are too intense causing glowing buildings as the camera moves
(e.g. some casino's in LV, the mall behind the garage in Doherty). The PS2
reflections are much less visible so these bugs are almost invisible as well.


For developers:
As of version 3.1 skygfx exports a function that return the current config.
The first field is an int giving the current version. Use this to track
possible struct layout changes. The function declaration is:
Config *GetConfig(void); See skygfx.h for the Config struct.

Changelog (not 100% accurate):
----------

before 3.1: history is fuzzy :D

3.1 (8.7.2017):
 - neo waterdrops (not too well tested, only when raining; thanks to Thirteen AG for porting them from skygfx_vc)
 - neo reflections (thanks to ASH for coming up with nice tweaking table values)
 - fixed multipass distance on cars
 - fixed near water square (not accurate ps2 pipeline though)
 - VC sun glare
 - III/VC trails (mainly for UG)
 - export function to get config (mainly for UG)
 - transparent target lockon
 - ps2 rain grain (no change needed after all)
 - ps2 ambient light for building pipeline (lightning illuminates world is optional)
 - fixed some issues caused by dual pass
 - rewrote *a lot* of pipeline code. visual changes due to that:
   - fixed env1 mapping on cars (should be hardly noticable)
   - wet road effect on buildings

3.2 (2017-07-16):
 - better neo water drops (thanks ThirteenAG)
 - neo-style screen blood drops (thanks ThirteenAG)
 - pc car pipe lighting fix (see ini)

3.3 (2017-08-04):
 - fixed xbox car crash
 - remove VCS trails (needs timecycle to work)

3.4 (2017-09-06):
 - support for debugmenu
 - rewrote pretty much all postfx code, mobile colorcycle is accurate now
 - moving raindrop direction should be fixed now 

3.5 (2017-09-19):
 - YCbCr colour correction
 - neo water-/blooddrop fixes (direction is like on xbox in both versions now)
 - missing colorcycle.dat no longer crashes game
 - misc. smaller stuff

3.6 (2017-09-21):
 - compatible with SAMP (thanks Snowshoe for helping with this)
 - fixed clipping bug
 - fixed raindrop issues (again)
 - fixed moon phase separately from SilentPatch
 - misc. other fixes

3.7 (2018-04-19):
 - fixed Neo reflections
 - implemented Leeds reflections

4.0 (2018-12-12):
 - mobile detail maps
 - mobile vehicle pipeline
 - fixed leeds vehicles
 - changed neo vehicles a bit (carTweakingTable.dat changed)
 - new functions for rendering real-time reflections (neo, leeds, mobile) (this may cause problems!)
 - no specularity on car wheels
 - removed "PC" building pipe and replaced with Xbox-style pipe
 - fixed building pipe assignment (this fixes among others the PC parachute bug)
 - fixed tags
 - fixed neo water/blood drops (thanks ThirteenAG)

4.1 (2019-12-24):
 - implemented radiosity with shaders (blur instead of downsampling)
 - added some more ini options
 - implemented Env vehicle pipeline

5.2 (2020-01-07):
 - implemented per-pixel effects for Env pipeline
 - some more ini options
 - better UG compatibility
