From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Fwd: linux-next: Tree for Sep 29
Date: Thu, 5 Oct 2017 10:08:44 +0300
Message-ID: <CALq1K=+y6mqp_bDwSVoUo8U5cPCD7VRdHerS=weTmCUC0mTGzw@mail.gmail.com>
References: <20170929154838.4a3bc675@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170929154838.4a3bc675-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I don't know how many of you are following LKML and linux-next lists,
but be aware of the following Stephen's announcement.
*******
News: I will not be doing linux-next releases from Setp 30 to Oct 30
(inclusive).
*******

Thanks

---------- Forwarded message ----------
From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Date: Fri, Sep 29, 2017 at 8:48 AM
Subject: linux-next: Tree for Sep 29
To: Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Hi all,

News: I will not be doing linux-next releases from Setp 30 to Oct 30
(inclusive).

Changes since 20170928:

The net-next tree gained a build failure, due to in interaction with the
net tree, for which I applied a merge fix patch.

The drm tree still had its build failure for which I applied a fix patch.

The ipmi tree lost its build failure.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 2815
 2768 files changed, 96917 insertions(+), 40111 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" and checkout or reset to the new
master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log
files in the Next directory.  Between each merge, the tree was built
with a ppc64_defconfig for powerpc and an allmodconfig (with
CONFIG_BUILD_DOCSRC=n) for x86_64, a multi_v7_defconfig for arm and a
native build of tools/perf. After the final fixups (if any), I do an
x86_64 modules_install followed by builds for x86_64 allnoconfig,
powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig, allyesconfig
and pseries_le_defconfig and i386, sparc and sparc64 defconfig. And
finally, a simple boot test of the powerpc pseries_le_defconfig kernel
in qemu.

Below is a summary of the state of the merge.

I am currently merging 267 trees (counting Linus' and 41 trees of bug
fix patches pending for the current merge release).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

--
Cheers,
Stephen Rothwell

$ git checkout master
$ git reset --hard stable
Merging origin/master (770b782f555d Merge tag 'acpi-4.14-rc3' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging fixes/master (820bf5c419e4 Merge tag 'scsi-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi)
Merging kbuild-current/fixes (cd4175b11685 Merge branch
'parisc-4.14-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging arc-current/for-curr (ef6c1bae4792 arc: remove redundant
UTS_MACHINE define in arch/arc/Makefile)
Merging arm-current/fixes (746a272e4414 ARM: 8692/1: mm: abort uaccess
retries upon fatal signal)
Merging m68k-current/for-linus (558d5ad276c9 m68k/mac: Avoid
soft-lockup warning after mach_power_off)
Merging metag-fixes/fixes (b884a190afce metag/usercopy: Add missing fixups)
Merging powerpc-fixes/fixes (d8bd9f3f0925 powerpc: Handle MCE on
POWER9 with only DSISR bit 30 set)
Merging sparc/master (23198ddffb6c sparc32: Add cmpxchg64().)
Merging fscrypt-current/for-stable (42d97eb0ade3 fscrypt: fix renaming
and linking special files)
Merging net/master (9d538fa60bad net: Set sk_prot_creator when cloning
sockets to the right proto)
Merging ipsec/master (dd269db84908 xfrm: don't call
xfrm_policy_cache_flush under xfrm_state_lock)
Merging netfilter/master (7f4f7dd4417d netfilter: ipset: ipset list
may return wrong member count for set with timeout)
Merging ipvs/master (f7fb77fc1235 netfilter: nft_compat: check
extension hook mask only if set)
Merging wireless-drivers/master (3e747fa18202 Merge ath-current from ath.git)
Merging mac80211/master (265698d7e613 nl80211: fix null-ptr
dereference on invalid mesh configuration)
Merging sound-current/for-linus (bfc81a8bc18e ALSA: usb-audio: Check
out-of-bounds access by corrupted buffer descriptor)
Merging pci-current/for-linus (9561475db680 PCI: Fix race condition
with driver_override)
Merging driver-core.current/driver-core-linus (850fdec8d2fd driver
core: remove DRIVER_ATTR)
Merging tty.current/tty-linus (c91261437985 serial: sccnxp: Fix error
handling in sccnxp_probe())
Merging usb.current/usb-linus (8fec9355a968 USB: cdc-wdm: ignore
-EPIPE from GetEncapsulatedResponse)
Merging usb-gadget-fixes/fixes (c3cdce45f8d3 usb: dwc3: of-simple: Add
compatible for Spreadtrum SC9860 platform)
Merging usb-serial-fixes/usb-linus (c496ad835c31 USB: serial: cp210x:
add support for ELV TFD500)
Merging usb-chipidea-fixes/ci-for-usb-stable (cbb22ebcfb99 usb:
chipidea: core: check before accessing ci_role in ci_role_show)
Merging phy/fixes (26e03d803c81 phy: rockchip-typec: Don't set the aux
voltage swing to 400 mV)
Merging staging.current/staging-linus (b2e312061c5e Merge tag
'iio-fixes-for-4.14a' of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into
staging-linus)
Merging char-misc.current/char-misc-linus (549e658a0919 Drivers: hv:
fcopy: restore correct transfer length)
Merging input-current/for-linus (05f5c3857647 Input: elan_i2c - extend
Flash-Write delay)
Merging crypto-current/master (40784d72aeeb crypto: axis - hide an
unused variable)
Merging ide/master (b671e1703394 PNP: ide: constify pnp_device_id)
Merging vfio-fixes/for-linus (796b755066dd vfio/pci: Fix handling of
RC integrated endpoint PCIe capability size)
Merging kselftest-fixes/fixes (eefd95e1f3d4 selftests: timers:
set-timer-lat: Fix hang when testing unsupported alarms)
Merging backlight-fixes/for-backlight-fixes (68feaca0b13e backlight:
pwm: Handle EPROBE_DEFER while requesting the PWM)
Merging ftrace-fixes/for-next-urgent (6224beb12e19 tracing: Have
branch tracer use recursive field of task struct)
Merging nand-fixes/nand/fixes (ee02f73e04c0 mtd: nand: atmel: Fix EDO
mode check)
Merging spi-nor-fixes/spi-nor/fixes (5771a8c08880 Linux v4.13-rc1)
Merging mfd-fixes/for-mfd-fixes (0f0fc5c09005 Revert "mfd: da9061: Fix
to remove BBAT_CONT register from chip model")
Merging v4l-dvb-fixes/fixes (db6321a1af84 media: platform:
VIDEO_QCOM_CAMSS should depend on HAS_DMA)
Merging reset-fixes/reset/fixes (544e3bf4f0e8 reset: Restrict
RESET_HSDK to ARC_SOC_HSDK or COMPILE_TEST)
Merging drm-intel-fixes/for-linux-next-fixes (2ba7d7e04371
drm/i915/bios: ignore HDMI on port A)
Merging drm-misc-fixes/for-linux-next-fixes (a98c75fcd0ec drm/tegra:
trace: Fix path to include)
Merging kbuild/for-next (cd4175b11685 Merge branch 'parisc-4.14-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging uuid/for-next (c0020756315e efi: switch to use new generic UUID API)
Merging dma-mapping/for-next (6d57339890c9 dma-coherent: fix
rmem_dma_device_init regression)
Merging asm-generic/master (a351e9b9fc24 Linux 4.11)
Merging arc/for-next (cc4a41fe5541 Linux 4.13-rc7)
Merging arm/for-next (67715a8964fc Merge branches 'fixes' and 'misc'
into for-next)
Merging arm-perf/for-next/perf (e884f80cf2a7 arm64: perf: add support
for Cortex-A35)
Merging arm-soc/for-next (ed3b42e5f399 ARM: SoC: Document merges)
Merging actions/for-next (2a6a17c006da Merge branch 'v4.15/dt' into next)
Merging alpine/alpine/for-next (a1144b2b1ec4 ARM: dts: alpine: add
valid clock-frequency values)
Merging amlogic/for-next (293cd5ae9884 Merge branch 'v4.14/drivers'
into tmp/aml-rebuild)
Merging aspeed/for-next (0eead81e7847 Merge branches 'dt-for-v4.14'
and 'defconfig-for-v4.14' into for-next)
Merging at91/at91-next (819b0a26fdd8 Merge tag 'at91-fixes' into at91-next)
Merging bcm2835/for-next (e83e7335d059 Merge branch
anholt/bcm2835-defconfig-next into for-next)
Merging berlin/berlin/for-next (5153351425c9 Merge branch 'berlin/dt'
into berlin/for-next)
Merging cortex-m/for-next (f719a0d6a854 ARM: efm32: switch to
vendor,device compatible strings)
Merging imx-mxs/for-next (88beee7ca525 Merge branch 'imx/defconfig'
into for-next)
Merging keystone/next (f922ce7bbcf5 Merge branch
'for_4.14/keystone_dts' into next)
Merging mvebu/for-next (d04177d6b4d2 Merge branch 'mvebu/dt64' into
mvebu/for-next)
Merging omap/for-next (fa2cc631e60b Merge branch 'omap-for-v4.15/soc'
into for-next)
Merging omap-pending/for-next (c20c8f750d9f ARM: OMAP2+: hwmod: fix
_idle() hwmod state sanity check sequence)
Merging reset/reset/next (66f2be767b22 reset: socfpga: build the
reset-socfpga for Stratix10 SOC)
Merging qcom/for-next (b212aba8f7bf Merge tag 'qcom-drivers-for-4.14'
into final-for-sure-4.14)
Merging realtek/for-next (74e912bc01df Merge branch 'v4.15/dt64' into next)
Merging renesas/next (4383639823e5 Merge branch 'dt-for-v4.15' into next)
Merging rockchip/for-next (0b224812590c Merge branch
'v4.14-armsoc/fixes64' into for-next)
Merging rpi/for-rpi-next (bc0195aad0da Linux 4.2-rc2)
Merging samsung/for-next (2ea659a9ef48 Linux 4.12-rc1)
Merging samsung-krzk/for-next (3bf689f9275f ARM: dts: exynos: Add dwc3
SUSPHY quirk)
Merging sunxi/sunxi/for-next (3b428b0f8e9b Merge branches
'sunxi/dt-for-4.15' and 'sunxi/dt64-for-4.15' into sunxi/for-next)
Merging tegra/for-next (b4aed883ebbe Merge branch
for-4.14/arm/defconfig into for-next)
Merging arm64/for-next/core (d1be5c99a034 arm64: cleanup
{COMPAT_,}SET_PERSONALITY() macro)
Merging clk/clk-next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging clk-samsung/for-next (8834b0950156 clk: samsung: Delete a
memory allocation error message in clk-cpu.c)
Merging c6x/for-linux-next (62016565bb04 c6x: remove unused
KTHREAD_SIZE definition)
Merging cris/for-next (8f50f2a1b46a cris: No need to append -O2 and
$(LINUXINCLUDE))
Merging h8300/h8300-next (58c57526711f h8300: Add missing include file
to asm/io.h)
Merging hexagon/linux-next (02cc2ccfe771 Revert "Hexagon: fix signal.c
compile error")
Merging ia64/next (fbb0e4da96f4 ia64: salinfo: use a waitqueue instead
a sema down/up combo)
Merging m68k/for-next (10df0ba4c2c2 m68k/defconfig: Update defconfigs
for v4.14-rc1)
Merging m68knommu/for-next (6f75ec3ed368 m68k: allow ColdFire m5441x
parts to run with MMU enabled)
Merging metag/for-next (e3cd7f013bac metag/mm: Drop pointless increment)
Merging microblaze/next (428dbf156cc5 arch: change default endian for
microblaze)
Merging mips/mips-for-linux-next (f6cccc012695 Merge branches
'4.14-fixes' and '4.15-features' into mips-for-linux-next)
Merging nios2/for-next (65d1e3ddeae1 nios2: time: Read timer in
get_cycles only if initialized)
Merging openrisc/for-next (56ce2f25ab0d openrisc: add forward
declaration for struct vm_area_struct)
Merging parisc-hd/for-next (3229c9219c30 parisc: Add CPU topology support)
Merging powerpc/next (5080332c2c89 powerpc/64s: Add workaround for P9
vector CI load issue)
Merging fsl/next (a4e89ffb5923 powerpc/e6500: Update machine check for
L1D cache err)
Merging mpc5xxx/next (39e69f55f857 powerpc: Introduce the use of the
managed version of kzalloc)
Merging s390/features (0a5aa4846f4b s390/ccwgroup: tie a ccwgroup
driver to its ccw driver)
Merging sparc-next/master (9cd6681cb116 Merge branch 'for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging sh/for-next (6e2fbfdd585f sh: fix futex FUTEX_OP_SET op on
userspace addresses)
Merging tile/master (637f23abca87 tile: array underflow in setup_maxnodemem())
Merging uml/linux-next (6d20e6b235aa um: return negative in tuntap_open_tramp())
Merging unicore32/unicore32 (bc27113620ca unicore32-oldabi: add oldabi
syscall interface)
CONFLICT (content): Merge conflict in arch/unicore32/include/asm/Kbuild
Merging xtensa/xtensa-for-next (271335b9726e Merge branch
'xtensa-fixes' into xtensa-for-next)
Merging fscrypt/master (c250b7dd8e73 fscrypt: make ->dummy_context()
return bool)
Merging befs/for-next (5771a8c08880 Linux v4.13-rc1)
Merging btrfs/next (5226fcac7841 squashfs: Add zstd support)
Merging btrfs-kdave/for-next (3d90af17fbee Merge branch
'for-next-next-v4.14-20170925' into for-next-20170925)
Merging ceph/master (717e6f2893eb ceph: avoid panic in
create_session_open_msg() if utsname() returns NULL)
Merging cifs/for-next (fcbc4b4c7f5d cifs: handle large EA requests
more gracefully in smb2+)
Merging configfs/for-next (19e72d3abb63 configfs: Introduce
config_item_get_unless_zero())
Merging ecryptfs/next (be280b25c328 ecryptfs: remove private bin2hex
implementation)
Merging ext3/for_next (4c6bb69663b3 quota: Fix quota corruption with
generic/232 test)
Merging ext4/dev (b5f515735bea ext4: avoid Y2038 overflow in recently_deleted())
Merging f2fs/dev (e365806ac289 Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging freevxfs/for-next (bf1bb4b460c8 freevxfs: update Kconfig information)
Merging fscache/fscache (d52bd54db8be Merge branch 'akpm' (patches from Andrew))
Merging fuse/for-next (5b97eeacbd80 fuse: getattr cleanup)
Merging jfs/jfs-next (f070e5ac9bc7 jfs: preserve i_mode if
__jfs_set_acl() fails)
Merging nfs/linux-next (e19b205be43d Linux 4.14-rc2)
Merging nfsd/nfsd-next (7d34cd12061d MAINTAINERS: associate linux/fs.h
with VFS instead of file locking)
Merging orangefs/for-next (0b08273c8ab7 orangefs: Adjust three checks
for null pointers)
Merging overlayfs/overlayfs-next (939ae4efd51c ovl: fix false positive
ESTALE on lookup)
Merging v9fs/for-next (a333e4bf2556 fs/9p: use fscache mutex rather
than spinlock)
Merging ubifs/linux-next (89b68cd92663 UBI: Fix two typos in comments)
Merging xfs/for-next (5e5c943c1f25 xfs: revert "xfs: factor rmap btree
size into the indlen calculations")
Merging file-locks/locks-next (3b9f8ed25dbe Merge branch 'for-4.14' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata)
Merging vfs/for-next (f8340cc34799 mips: switch to {get,put}_compat_sigset())
Merging vfs-jk/vfs (030b533c4fd4 fs: Avoid premature clearing of capabilities)
Merging vfs-miklos/next (0eb8af4916a5 vfs: use helper for calling f_op->fsync())
Merging printk/for-next (077a1cc06f72 printk: Clean up do_syslog()
error handling)
Merging pci/next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging pstore/for-next/pstore (e19b205be43d Linux 4.14-rc2)
Merging hid/for-next (abbc4db7a3a0 Merge branch 'for-4.14/upstream'
into for-next)
Merging i2c/i2c/for-next (aeb068c57214 i2c: i2c-stm32f7: add driver)
Merging jdelvare-hwmon/master (08d27eb20666 Merge branch 'for-linus'
of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging dmi/master (e181b8c089da firmware: dmi_scan: Fix handling of
empty DMI strings)
Merging hwmon-staging/hwmon-next (0fc85a358283 hwmon: (sht15) remove
redundant check on status and send of status value)
Merging jc_docs/docs-next (5cb5c31cdf24 scripts/kernel-doc: warn on
excess enum value descriptions)
Merging v4l-dvb/master (d5426f4c2eba media: staging: atomisp: use
clock framework for camera clocks)
Merging v4l-dvb-next/master (1efdf1776e22 media: leds: as3645a: add
V4L2_FLASH_LED_CLASS dependency)
Merging fbdev/fbdev-for-next (23e9f4ef99dd video/console: Update BIOS
dates list for GPD win console rotation DMI quirk)
Merging pm/linux-next (273a1f886725 Merge branch 'pm-cpufreq' into linux-next)
Merging idle/next (306899f94804 x86 tsc: Add the Intel Denverton
Processor to native_calibrate_tsc())
Merging thermal/next (02bc1bd0498c Merge branch 'imx-nvmem' into next)
Merging thermal-soc/next (aa647852c32a Merge branch 'work-linus' into work-next)
Merging ieee1394/for-next (72f3c27aa646 firewire: net: max MTU off by one)
Merging dlm/next (9e1b0211c5dd dlm: recheck kthread_should_stop()
before schedule())
Merging swiotlb/linux-next (69369f52d28a swiotlb-xen: implement
xen_swiotlb_get_sgtable callback)
Merging net-next/master (de9c8a6a5f08 Merge branch 'hns3-dcb')
CONFLICT (content): Merge conflict in lib/kobject_uevent.c
Applying: net: dsa: merge fix patch for removal of phy
Merging ipsec-next/master (a1b831f23a2b xfrm: eradicate size_t)
Merging netfilter-next/master (80cee03bf1d6 Merge branch 'linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6)
Merging nfc-next/master (bd751808f9ff NFC: trf7970a: Correct register
settings for 27MHz clock)
Merging ipvs-next/master (a910d20aa007 netfilter: ipvs: Fix space
before '[' error.)
Merging wireless-drivers-next/master (96cbe3d638e4 b43: make const
arrays static, reduces object code size)
Merging bluetooth/master (76c539162f61 Bluetooth: btmrvl: *_err() and
*_info() strings should end with newlines)
Merging mac80211-next/master (1bd773c077de wireless: set correct
mandatory rate flags)
Merging rdma/for-next (1848757c3d8b Merge branches 'hns' and 'misc'
into k.o/for-next)
Merging gfs2/for-next (c2c4be28c248 gfs2: Always update inode ctime in set_acl)
Merging mtd/master (36de80740008 mtd: nand: atmel: fix buffer overflow
in atmel_pmecc_user)
Merging l2-mtd/master (d1f936d73683 Merge tag 'nand/for-4.14' of
git://git.infradead.org/l2-mtd into mtd/next)
Merging nand/nand/next (e8901f3ab5b5 dt-bindings: nand: denali: reduce
the register space in the example)
Merging spi-nor/spi-nor/next (90074de6630f mtd: spi-nor: fix DMA
unsafe buffer issue in spi_nor_read_sfdp())
Merging crypto/master (f0e2ce58f853 crypto: brcm - Explicity ACK
mailbox message)
Merging drm/drm-next (754270c7c562 Merge branch 'drm-next-4.15' of
git://people.freedesktop.org/~agd5f/linux into drm-next)
Applying: drm/amd/powerplay: uniquify ci_send_msg_to_smc
Merging drm-panel/drm/panel/for-next (e4bac408b084 drm/panel: simple:
Add support for Winstar WF35LTIACD)
Merging drm-intel/for-linux-next (4dd504f7d98a drm/i915: Use
memset64() to prefill the GTT page)
Merging drm-tegra/drm/tegra/for-next (65d5d30ccebd drm/tegra: trace:
Fix path to include)
Merging drm-misc/for-linux-next (7f909d9c74f3 drm/rockchip: Rely on
the default best_encoder() behavior)
Merging drm-exynos/exynos-drm/for-next (7d1e04231461 Merge tag
'usercopy-v4.8-rc8' of
git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux)
Merging drm-msm/msm-next (642e5ef8c6c4 drm/msm: fix _NO_IMPLICIT fencing case)
Merging hdlcd/for-upstream/hdlcd (fee4964f0a6c drm/arm: hdlcd: remove
unused variables)
Merging mali-dp/for-upstream/mali-dp (e46477b8f23c drm: mali-dp:
Restore commit_tail behaviour to the runtime_pm friendly version.)
Merging sunxi-drm/sunxi-drm/for-next (7dafb83edd32 Merge branches
'sunxi/drm-fixes-for-4.13' and 'sunxi/drm-for-4.14' into
sunxi-drm/for-next)
Merging imx-drm/imx-drm/next (9303519985ed drm/imx: parallel-display:
use correct connector enum)
Merging etnaviv/etnaviv/next (65375b873cb5 drm/etnaviv: switch GEM
allocations to __GFP_RETRY_MAYFAIL)
Merging kconfig/for-next (6f7da290413b Linux 4.12)
Merging regmap/for-next (1874021ec3a8 Merge remote-tracking branches
'regmap/topic/const' and 'regmap/topic/namespace' into regmap-next)
Merging sound/for-next (729fbfc92a45 ALSA: line6: add support for POD
HD DESKTOP)
Merging sound-asoc/for-next (ca23461fc30b Merge remote-tracking
branches 'asoc/topic/tas571x', 'asoc/topic/tfa9879',
'asoc/topic/ts3a277e', 'asoc/topic/wm97xx' and 'asoc/topic/zte' into
asoc-next)
Merging modules/modules-next (0bf8bf50eddc module: Remove const
attribute from alias for MODULE_DEVICE_TABLE)
Merging input/next (8d25fee28450 Input: usbtouchscreen - use EXPERT
instead of EMBEDDED for EasyTouch)
Merging block/for-next (0b508bc926bd block: fix a build error)
Merging lightnvm/for-next (1c6286f26301 lightnvm: fix some error code
in pblk-init.c)
Merging device-mapper/for-next (bd86e3205952 dm crypt: fix memory leak
in crypt_ctr_cipher_old())
Merging pcmcia/master (e8e68fd86d22 pcmcia: do not break
rsrc_nonstatic when handling anonymous cards)
Merging mmc/next (5aa83fb178e3 mmc-host: mxcmmc: use setup_timer() helper.)
Merging kgdb/kgdb-next (7a6653fca500 kdb: Fix handling of
kallsyms_symbol_next() return value)
Merging md/for-next (7d5d7b5058fb md/raid5: cap worker count)
Merging mfd/for-mfd-next (b01e9348e106 mfd: intel_soc_pmic:
Differentiate between Bay and Cherry Trail CRC variants)
Merging backlight/for-backlight-next (2606706e4d7b backlight:
gpio_backlight: Delete pdata inversion)
Merging battery/for-next (5d01fd38a3b0 power: supply: bq27xxx: enable
writing capacity values for bq27421)
Merging omap_dss2/for-next (c456a2f30de5 video: smscufx: remove unused variable)
Merging regulator/for-next (e19b205be43d Linux 4.14-rc2)
Merging security/next-testing (ab5348c9c23c security: fix description
of values returned by cap_inode_need_killpriv)
Merging integrity/next (ed301d2614d2 ima: define "fs_unsafe" builtin policy)
CONFLICT (add/add): Merge conflict in security/apparmor/include/sig_names.h
Merging keys/keys-next (8ab2a6905b28 KEYS: Add documentation for
asymmetric keyring restrictions)
Merging selinux/next (7c620ece125c selinux: Use kmem_cache for hashtab_node)
Merging tpmdd/next (d24fc04f4cc6 tpm: fix type of a local variables in
tpm_tis_spi.c)
Merging watchdog/master (4cb30b044a8f watchdog: mei_wdt: constify
mei_cl_device_id)
Merging iommu/next (74ebe8c61aa7 Merge branches 'iommu/fixes',
'arm/omap', 'arm/exynos' and 'core' into next)
Merging dwmw2-iommu/master (910170442944 iommu/vt-d: Fix PASID table allocation)
Merging vfio/next (417fb50d5516 vfio: platform: constify amba_id)
Merging trivial/for-next (6fbc8798d946 tty: fix comment for
__tty_alloc_driver())
Merging audit/next (462d9d959613 audit: use audit_set_enabled() in
audit_enable())
Merging devicetree/for-next (092267d260d2 Merge branch 'dt-printf-v2'
into dt/next)
Merging mailbox/mailbox-for-next (1da92afbbfcd mailbox:
bcm-flexrm-mailbox: Use txdone_ack instead of txdone_poll)
Merging spi/for-next (e0e4c1bd49ea Merge remote-tracking branches
'spi/topic/slave' and 'spi/topic/spreadtrum' into spi-next)
Merging tip/auto-latest (31b2e7211636 Merge branch 'timers/urgent')
Merging clockevents/clockevents/next (6ec6257f8981 MAINTAINERS: Fix
path and add bindings to timers)
Merging edac/linux_next (345fb0a9a634 Merge tag 'edac_for_4.11' of
git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp)
Merging edac-amd/for-next (88ae80aa609c EDAC, skx_edac: Handle systems
with segmented PCI busses)
Merging irqchip/irqchip/for-next (c1ae3cfa0e89 Linux 4.11-rc1)
Merging ftrace/for-next (170b3b1050e2 tracing: Apply trace_clock
changes to instance max buffer)
Merging rcu/rcu/next (9111b9361f2e EXP: Fine-grained timer diagnostics)
Merging kvm/linux-next (31afb2ea2b10 KVM: VMX: simplify and fix
vmx_vcpu_pi_load)
Merging kvm-arm/next (9b87e7a8bfb5 KVM: arm/arm64: Support uaccess of GICC_APRn)
Merging kvm-mips/next (dc44abd6aad2 KVM: MIPS/Emulate: Properly
implement TLBR for T&E)
Merging kvm-ppc/kvm-ppc-next (67f8a8c1151c KVM: PPC: Book3S HV: Fix
bug causing host SLB to be restored incorrectly)
Merging kvms390/next (c95c895303ed KVM: s390: vsie: cleanup mcck reinjection)
Merging xen-tip/linux-next (0d805ee70a69 xen/mmu: Call
xen_cleanhighmap() with 4MB aligned for page tables mapping)
Merging percpu/for-next (1fa4df3e6889 percpu: fix iteration to prevent
skipping over block)
Merging workqueues/for-next (ebb2c2437d80 Merge tag 'mmc-v4.14-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc)
Merging drivers-x86/for-next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging chrome-platform/for-next (859eb05676f6 platform/chrome: Use
proper protocol transfer function)
Merging hsi/for-next (67ddd75771b6 HSI: core: Use kcalloc() in two functions)
Merging leds/for-next (f292bbfaa69d leds: Replace flags bit shift with
BIT() macros)
Merging ipmi/for-next (b79bba15b3f2 ipmi: remove redundant
initialization of bmc)
Merging driver-core/driver-core-next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging usb/usb-next (38502ef49f96 usb: storage: make const arrays
static, reduces object code size)
Merging usb-gadget/next (0852659ef071 usb: gadget: f_ncm/u_ether: Move
'SKB reserve' quirk setup to u_ether)
Merging usb-serial/usb-next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging usb-chipidea-next/ci-for-usb-next (fc5b920c3b9b usb: chipidea:
do charger detection in vbus session)
Merging phy-next/next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging tty/tty-next (be7da1a2b714 serial: imx: default to half duplex rs485)
Merging char-misc/char-misc-next (e701c67c30e6 nvmem: remove unneeded
IS_ENABLED(CONFIG_NVMEM) conditional)
Merging extcon/extcon-next (f12c89504cb8 extcon: make extcon_info
static const, fixes warning)
Merging staging/staging-next (b6e2b3e1c53c staging: speakup: Fix
comment block coding style)
Merging mux/for-next (aae4e7a8bc44 Linux 4.13-rc4)
Merging slave-dma/next (626f9d448571 Merge branch 'fixes' into next)
Merging cgroup/for-next (b9d66d0a0071 Merge branch 'for-4.15' into for-next)
Merging scsi/for-next (74316f626715 Merge branch 'misc' into for-next)
Merging scsi-mkp/for-next (7dad16913b76 scsi: libsas: remove unused
variable sas_ha)
Merging target-updates/for-next (04229774f692 tcmu: Oops in unmap_thread_fn())
Merging target-merge/for-next-merge (2994a7518317 cxgb4: update
Kconfig and Makefile)
Merging target-bva/for-next (2ea659a9ef48 Linux 4.12-rc1)
Merging libata/for-next (9826313227fe Merge branch 'for-4.15' into for-next)
Merging binfmt_misc/for-next (4af75df6a410 binfmt_misc: add F option
description to documentation)
Merging vhost/linux-next (ac7380709f65 vhost: fix end of range for access_ok)
Merging rpmsg/for-next (7148e5c13dd7 Merge branches 'hwspinlock-next',
'rpmsg-next' and 'rproc-next' into for-next)
Merging gpio/for-next (45f54d0b89b4 Merge branch 'devel' into for-next)
Merging pinctrl/for-next (31c2edff2034 Merge branch 'devel' into for-next)
Merging pinctrl-samsung/for-next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging pwm/for-next (7755daf5e7e8 Merge branch 'for-4.14/drivers'
into for-next)
Merging dma-buf/for-next (194cad44c4e1 dma-buf/sync_file: improve
Kconfig description for Sync Files)
CONFLICT (content): Merge conflict in drivers/dma-buf/Kconfig
Merging userns/for-next (076a9bcacfc7 signal/mips: Remove FPE_FIXME
usage from mips)
Merging ktest/for-next (f7c6401ff84a ktest: Make sure wait_for_input
does honor the timeout)
Merging random/dev (72e5c740f633 random: reorder READ_ONCE() in get_random_uXX)
Merging aio/master (2a8a98673c13 fs: aio: fix the increment of aio-nr
and counting against aio-max-nr)
Merging kselftest/next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging y2038/y2038 (69973b830859 Linux 4.9)
Merging luto-misc/next (2dcd0af568b0 Linux 4.6)
Merging borntraeger/linux-next (e76d21c40bd6 Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net)
Merging livepatching/for-next (26d8d1e9bb48 Merge branch
'for-4.12/upstream-fixes' into for-next)
Merging coresight/next (096d08d830e9 coresight: Extend the PIDR mask
to cover relevant bits in PIDR2)
Merging rtc/rtc-next (74717b28cb32 rtc: set the alarm to the next
expiring timer)
Merging hwspinlock/for-next (bd5717a4632c hwspinlock: qcom: Correct
msb in regmap_field)
Merging nvdimm/libnvdimm-for-next (2bd6bf03f4c1 Linux 4.14-rc1)
Merging dax-misc/dax-misc (4d9a2c874667 dax: Remove i_mmap_lock protection)
Merging idr/idr-4.11 (f0f3f2d0a3e0 radix tree test suite: Specify -m32
in LDFLAGS too)
Merging kspp/for-next/kspp (be53cdda2fdd lkdtm: Update usercopy tests
for whitelisting)
Merging akpm-current/current (f5185a067d62
kernel-reboot-add-devm_register_reboot_notifier-fix)
CONFLICT (content): Merge conflict in include/linux/sched/mm.h
$ git checkout -b akpm remotes/origin/akpm/master
Applying: iopoll: avoid -Wint-in-bool-context warning
Applying: MAINTAINERS: update TPM driver infrastructure changes
Applying: drivers/pcmcia/sa1111_badge4.c: avoid unused function warning
Applying: sparc64: NG4 memset 32 bits overflow
Applying: lib/crc-ccitt: add CCITT-FALSE CRC16 variant
Merging akpm/master (4ca222de662d lib/crc-ccitt: add CCITT-FALSE CRC16 variant)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
