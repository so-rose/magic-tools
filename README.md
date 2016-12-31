## magic-tools - tools for Magic Lantern!

Just some utilities for prepping CF cards, compiling post tools, compiling ML itself, and managing the source code.


## Cool Functions
Things we can do.

* Prepare a Magic Lantern SD/CF card: Run `./formatML.sh` (with options; see -h option) in the **prep_card** folder.
* Auto build ML binary: Run `./mkML.sh` in the **bin** folder.
* Build post proc tools: Run `./mkToolStack.sh' and potentially `./mkDcraw.sh` in the **tools** folder.


## How to make it work
Before doing anything, run: `./prepAll.sh`. This will compile stuff & get the ML source code.

**For Debian/Ubuntu:**

Make sure to install the ARM toolchain: `sudo apt-get install gcc-arm-none-eabi` (ARM_PATH is already set correctly to /usr).

**If you are not on Debian/Ubuntu:**

1. Get gcc version 5.4.1 or similar.
2. Enter src. Run `./getArm.sh`. 
3. Edit src/patches/armpath.patch: On the "ARM_PATH" line beggining with "+", replace "/usr" with "~/gcc-arm-none-eabi-5_4-2016q3"

*Other gcc versions: In the patch file, put in your gcc version and corresponding working gcc-arm-none-eabi path (Browse https://launchpad.net/gcc-arm-embedded for that)*
