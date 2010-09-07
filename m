From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc6 is available
Date: Tue, 07 Sep 2010 18:42:13 +0300
Message-ID: <4C865D55.4080004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050100070701040501030702"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050100070701040501030702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.2-rc6 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc6.tgz
or
http://69.55.239.13/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc6.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  (69.55.231.178) for
OFED 1.5.2

Schedule:
OFED-1.5.2 GA - September 13.

Vladimir & Tziporet

========================================================================
Supported Platforms and Operating Systems
---------------------------------------------
         o   CPU architectures:
               - x86_64
               - x86
               - ppc64
               - ia64

         o   Linux Operating Systems:
               - RedHat EL4 up7        2.6.9-78.ELsmp
               - RedHat EL4 up8        2.6.9-89.ELsmp
               - RedHat EL5 up3        2.6.18-128.el5
               - RedHat EL5 up4        2.6.18-164.el5
               - RedHat EL5 up5        2.6.18-194.el5
               - RedHat EL6 beta       2.6.32-19.el6.x86_64 *
               - SLES10 SP2            2.6.16.60-0.21-smp
               - SLES10 SP3            2.6.16.60-0.54-smp
               - SLES11                2.6.27.19-5-default
               - SLES11 SP1            2.6.32.12-0.7-default *
               - OEL 4 up7             2.6.9-78.ELsmp
               - OEL 4 up8             2.6.9-89.ELsmp
               - CentOS5.3             2.6.18-128.el5
               - CentOS5.4             2.6.18-164.el5
               - Fedora Core12         2.6.31.5-127.fc12    *
               - OpenSuSE 11.2         2.6.31.5-0.1-default *
               - kernel.org            2.6.29, 2.6.30,
                                       2.6.31, 2.6.32 and 2.6.33   *

             * Minimal QA for these versions

Main changes from 1.5.2-rc5:
===========================
1. Updated packages:
	infiniband-diags-1.5.7
	libibmad-1.3.6
	libibumad-1.3.6
	opensm-3.3.7
	libibverbs-1.1.4-0.14.gb6c138b
	libnes-1.1.0
	mstflint-1.4-0.4.g1989698
	mvapich2-1.5.1-0.1.20100905svn4167
	

2. Known issues:
	mpitests compilation fails over mvapich2
	perftest does not support IA64

--------------050100070701040501030702
Content-Type: text/x-log;
 name="ofa_kernel-1.5.2-rc5_rc6.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofa_kernel-1.5.2-rc5_rc6.log"

commit acb980471b90f883eac1a7815a9980e045f47bf7
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Fri Sep 3 10:01:09 2010 -0700

    IB/qib: initialize new portinfo link_layer field
    
    The RoCE changes added a new field to struct ib_port_attr which
    was uninitialized. This patch fixes that.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0e1a3cff35baad33763a100f2adfe7121aaaf0f2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Sep 2 11:08:36 2010 +0300

    truescale.cmds: avoid output of grep errors
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7b35671bf9c5d515c45b596e25eb112d36c118d3
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Sep 1 10:43:18 2010 -0500

    RDMA/nes: Modified FIN handling causes hang in A0 cards
    
    The changing state to CLOSING when FIN is received causes A0 cards to hang and
    the interface will not be active. Now in the FIN handling, a check is made
    if it is A0 card or not.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 84f94bb02415f6d6810c39fd99d8e253c55bf90d
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Sep 1 08:39:27 2010 -0500

    RDMA/nes: turn carrier off on ifdown
    
    This enables bonding driver to detect interface down.  This
    fixes OFED bug 2104.
    https://bugs.openfabrics.org/show_bug.cgi?id=2104
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 788dd9a75c9fb9ddd7463ece175f8a3f31d77db1
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 1 15:34:37 2010 +0300

    mlx4: bug fix in counters
    
    Failure to clear the buffer would cause displaying wrong values.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit da38788240d17b7fff84582c7c2b44ea327e7dcf
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Aug 31 15:59:15 2010 +0300

    Farther optimize ibdev2netdev
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 56482d884e78fa0c8fbdbb9a3da41dc53ce8630b
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Aug 31 11:33:04 2010 +0300

    IPoIB: show dev_id for kernels < 2.6.20
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit dbc19b8b0756aec4dc0b9b02118237d80e6bf6e0
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Aug 31 11:12:20 2010 +0300

    Fix bug in mlx4_en_0050_missing_devid_sysfs-2.6.20.patch
    
    It showed the value of the port instead of dev_id
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1dcb317380d041bfed9376b9190920358998dedf
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 18:21:03 2010 +0300

    ibdev2netdev: Include old implementation
    
    For systems where the net device does not expose dev_id, use old
    implementation. Better this than nothing at all.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit be21f3ad418749b818227f525c4ee5344cb3a4c6
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 16:06:04 2010 +0300

    IB utils: fix ibdev2netdev to work with zero based port numbering
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f7aa8ad1995d3dd28bab19afde348c40f28954fd
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 14:56:47 2010 +0300

    IPoIB: encode port zero based as in mlx4_en
    
    port 1 ==> dev_id 0
    port 2 ==> dev_id 1 etc.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f236dd43603a3c697af649d7bc625ba3a4abb970
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 12:23:37 2010 +0300

    ib utils: update ibdev2netev
    
    Change the sctript to take abvantage of the fact the we have the port number
    written in the dev_id filed on the net device. The script now runs much faster.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c82b7210fdb39c77d752942fde33a29fa641cf83
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 12:19:42 2010 +0300

    mlx4: use gid change event
    
    Use this event to update IB core patches.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a674923c541c3d5a022c2285f10f03b6a55cc1e5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 12:17:41 2010 +0300

    ib_core: Add GID change event
    
    This is needed for IBoE when the HW driver updates the GID table and the change
    should be updated in IB core caches.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b33c9bda24f974d093e05e7a5934d8e976adb6a1
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 10:46:46 2010 +0300

    IPoIB: set dev_id field of IPoIB net_device
    
    Use this in order to be able to associate a device's port to the net device
    that uses it.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f2fc415c99f687c54f68d0870dcc60bf4687cc65
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 30 08:42:41 2010 +0300

    mlx4: Add a new vendor ID method to mlx4
    
    Make method with attribute ID 0xff70 be proccessed by FW.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------050100070701040501030702
Content-Type: text/csv;
 name="bugs-2010-09-07.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2010-09-07.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgo3NjcsIm1h
am9yIiwiUDMiLCJPdGhlciIsInN3aXNlQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09M
VkVEIiwiRklYRUQiLCJOb24gYmFja3BvcnQgS2VybmVscyB0aGF0IGRvbid0IGJ1aWxkIGlu
IGdlbmFsbG9jIGNhdXNlIGNvbXBpbGUgZXJyb3JzIGZvciBjeGdiMyIKMjAyNiwibWFqb3Ii
LCJQMiIsIlNMRVMgMTAiLCJhcmxpbi5yLmRhdmlzQGludGVsLmNvbSIsIkNMT1NFRCIsIkZJ
WEVEIiwiV2hhdCdzIHRoZSBjdXJyZW50IHRhcmdldCByZWxlYXNlIGRhdGUgZm9yIE9GRUQg
MS41LjIgPyIKMjAzNSwibm9ybWFsIiwiUDMiLCJDZW50T1MgNSIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkludGVybWl0dGVudCBmYWJyaWMgZXJyb3Jz
IHRyaWdnZXJzIGJ1Z3MgaW4gU0RQIHcvemVyby1jb3B5IGVuYWJsZWQiCjIwNTIsIm5vcm1h
bCIsIlAzIiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlZFUklGSUVEIiwiRklY
RUQiLCJWZXJ5IGhpZ2ggbGF0ZW5jeSB3aXRoIG5ldHBlcmYgU0RQIHdpdGggbXNnIHNpemUg
NjVrIgoyMDcwLCJjcml0aWNhbCIsIlAzIiwiU0xFUyAxMSIsInZsYWRAbWVsbGFub3guY28u
aWwiLCJWRVJJRklFRCIsIkZJWEVEIiwiRmFpbGVkIHRvIGNvbXBpbGUgT0ZFRDEuNS4yLVJD
MiBvbiBzbGVzMTEgc3AxIC0gb3Blbi1pc2NzaSBmYWlsZWQiCjIwOTUsIm5vcm1hbCIsIlAz
IiwiQWxsIiwiYm9zQHBhdGhzY2FsZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiRXJyb3Ig
bWVzc2FnZSB3aGVuIHJlc3RhcnRpbmcgdGhlIHN0YWNrIC0gT0ZFRCAxLjUuMiBSQzMiCjIx
MDQsIm1ham9yIiwiUDMiLCJTTEVTIDExIiwia3J6eXN6dG9mLnNwcnphY3prb3dza2lAaW50
ZWwuY29tIiwiVkVSSUZJRUQiLCJGSVhFRCIsImJvbmRpbmcgZG9lc24ndCBkZXRlY3QgcG9y
dCBmYWlsdXJlIHdpdGggTmV0RWZmZWN0IgoyMTA1LCJtYWpvciIsIlAzIiwiUkhFTCA1Iiwi
c2Vhbi5oZWZ0eUBpbnRlbC5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiT0ZFRC0xLjUuMi0y
MDEwMDgyMy0wNjAwIGZhaWxzIHRvIGluc3RhbGwgdW5kZXIgUmVkSGF0NS40eDg2Ig==
--------------050100070701040501030702--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
