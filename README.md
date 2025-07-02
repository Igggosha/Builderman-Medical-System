# Builderman Medical System
 a medical system, together with a gun system that I created ages ago


 ### rant
 this was built for a game that was never released
 all the assets in this repo were created by Igggosha except for the fork of SecureCast
 as this is literally a game that was stripped of all unrelated assets, it has SecureCast
 initialised and set up
 there are hooks for vehicle-mounted weapons, as those were in the game, but I don't remember
 which were which

## Contents
 this contains SecureCast, its implementation, a gun implementing it, a gore system and a medical
 system
 the gun has a limited size magazine, recoil and interacts with the gore and medical systems (which is
 why it is included) - dig in the script unwisely placed inside the tool to see how it works, because
 I don't remember


 the gore and medical systems are woven together in weird ways

 ### Medical system

 the gore system places **wounds** on characters when they are shot - they leak **blood**, of which each 
 character has *5 liters*.
 the medical system allows the player to place a **tourniquet** on an injured limb to slow down the leaking of blood quickly, however it needs to be taken off in 5 minutes to avoid **gangrene**; if **gangrene** sets in, the limb needs to be **amputated**, or it will be dealing constant damage to the character; **gauze** can be used instead to slow the flow better, but it takes longer to apply. **stitching** a wound removes it entirely, but it takes the longest.

 when a character is shot, they get **pain**. this impairs their vision. it can be mitigated with **painkillers**, but
 they may not be sufficient in a serious injury. therefore, using **morphine** may be a good idea for those cases.
 however, be vary - **morphine** significantly slows the patient's heart rate. if it falls too low (or they fall unconscious
 for any other reason), they may need to be resuscitated. **Caffeine** can be used as a stimulant to raise heart rate in those
 cases - it also improves speed. however, **epinephrine** gives a quicker, sharper boost in heart rate that has less of the stimulant effect of caffeine.  however, if the character's heart rate falls to 0, they will need **CPR**. be careful when using
 caffeine and epi too - if the heart rate gets too fast, they may go into a heart attack, and might need to get a **defibrillator** used on them.
 if a character loses too much blood, they fall unconscious and die. a **blood bag** can be used to give them 1.5 liters of blood. if you have someone with enough blood to spare, you can **draw blood** from them to fill a blood bag for someone else.

 if you are giving treatments to someone else who is conscious and is not handcuffed, they will need to accept it first.

### Gore system
 this one's simpler - it will place wounds with every gunshot, and if enough wounds are placed part of a limb is sliced off, or a torso is split in half

### Surrender system
 a player can surrender to be at someone else's mercy if they run out of ammo. in that case, they can get **searched**, their items removed and thrown out. they can also be handcuffed, and then medical procedures can be used on them without their agreement.

i think thats it

### Notes
 the system requires a few folders to be placed in workspace under the BGS folder
 please put me in the credits if you use this for a big project thanks