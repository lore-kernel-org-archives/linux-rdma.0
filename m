From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org: [Announce] OFED-RDMAoE-1.5-rc6 is
 available]
Date: Mon, 4 Jan 2010 18:05:51 +0200
Message-ID: <20100104160551.GA31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Forwarded message from Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> -----

Date: Mon, 4 Jan 2010 16:44:47 +0200
From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
To: ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Subject: [Announce] OFED-RDMAoE-1.5-rc6 is available
User-Agent: Mutt/1.5.20 (2009-06-14)

OFED-RDMAoE-1.5-rc6 is available. rc5 was not announced but this
tagging is chosen since this version is based on rc6 of the OFED
package.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-rdmaoe-1.5/OFED-RDMAoE-1.5-rc6.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for
OFED 1.5, component RDMAoE


Release information:
--------------------
Linux Operating Systems:
       - RedHat EL4 up6       2.6.9-67.ELsmp
       - RedHat EL4 up7       2.6.9-78.ELsmp
       - RedHat EL4 up8       2.6.9-89.ELsmp
       - RedHat EL5 up2       2.6.18-92.el5
       - RedHat EL5 up3       2.6.18-128.el5
       - RedHat EL5 up4       2.6.18-164.el5
       - SLES10 SP2           2.6.16.60-0.21-smp
       - SLES10 SP3           2.6.16.60-0.54-smp
       - SLES11               2.6.27.19-5-default
       - OEL 4 up7            2.6.9-78.ELsmp
       - OEL 5 up2            2.6.18-92.el5
       - CentOS5.2            2.6.18-92.el5
       - CentOS5.3            2.6.18-128.el5
       - Fedora Cor           2.6.29              *
       - OpenSuSE 11          2.6.25.5-1.1        *
       - kernel.org           2.6.29 and 2.6.30


     * Minimal QA for these versions

Systems:
     * x86_64
     * x86
     * ia64
     * ppc64

Main changes from 1.5 rc4:
============================
1. Updated packages:

libibverbs-1.1.2-0.9.ge04f3ed.tar.gz
libmlx4-1.0-0.4.g57547fb.tar.gz
perftest-1.2.3-0.8.g196d994.tar.gz
ibutils-1.5.1.tar.gz
dapl-2.0.25.tar.gz


- Management packages:

libibumad-1.3.4.tar.gz
libibmad-1.3.4.tar.gz
opensm-3.3.5.tar.gz
infiniband-diags-1.5.5.tar.gz


- MPI packages:

mvapich-1.2.0-3567.src.rpm


2. Bug fixes (attached log file)
Pull bug fixes from ofed_kernel_1_5


Limitations:
============
- SLES10 SP3 on IA64 is not supported yet


Notes:
RDMAoE and mlx4_en capabilities are supported only for x86 and x86_64
architectures.



commit 060af55e25e2f73d6d35e6effe5450892f961e75
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 3 19:44:16 2010 +0200

    Remove this patch since it breaks rdmaoe
    
    will be fixed in next rc
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ff6a4d849c30be0ab4e1977a95ee5651512fee65
Merge: 24194c9 129a51c
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 3 14:52:32 2010 +0200

    Merge branch 'ofed_kernel_1_5' into rdmaoe

commit 129a51ce8dd7407985c96936f723e33e180342e5
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 31 11:25:39 2009 +0200

    sdp: use IB_CQ_VECTOR_LEAST_ATTACHED for cq's
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 63714a73c94ccb758b51d7d901b412113b2df511
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 30 15:43:10 2009 +0200

    sdp: make statistics per cpu
    
    - Caused lots of cache misses during multi stream traffic
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1f3f22e79c24ac733319fbe6ee63a59779e72ac0
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 30 10:10:09 2009 +0200

    sdp: added statistics instead of prints
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 79d63d23b1ac757cd4ed9901c6eb1103c7826ab7
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 27 11:08:26 2009 +0200

    sdp: Fix partial ZCopy send bug + recvmsg with MSG_PEEK support
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f78ba9d2d762cf64bd3c5b3d35e9590487c04fc4
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 27 12:51:16 2009 +0200

    sdp: Set a lower limit to ZCopy threshold
    
    No need to use ZCopy, when the whole packet is sent as SrcAvail payload
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 56ba0fa485ba6c06314653922421400ab82c13af
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 18:43:04 2009 +0200

    mlx4_core: QUERY_STAT_CFG for port enablement
    
    We query the static configuration to check for each port
    whether it is enabled or not, if port is disabled. the port type is
    set to "none", and neither mlx4_en or mlx4_ib attempt to open
    this port.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 24194c9491752ebaff7149080836c168aad6ad5b
Merge: dd0840c d27b31a
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 14:55:49 2009 +0200

    Merge branch 'ofed_kernel_1_5' into rdmaoe

commit d27b31a67badee64cc9f741cacf90c9eaf671217
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 14:46:20 2009 +0200

    IB/mlx4: fix post_recv wq overflow check
    
    the post recv flow should check wq overflow using the recv and not the send cq
    
    Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit dd0840c4566fc2d7feb1aef6b0ab8fd2c67ea685
Merge: c470c41 1e6a206
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 13:53:07 2009 +0200

    Merge branch 'ofed_kernel_1_5' into rdmaoe

commit c470c41f150ed545799fc5d1ed2dc161123ee80e
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 13:39:49 2009 +0200

    ib core: Adapt port protocol to link layer usage
    
    This an intering solution until I make the code changes that make use of link
    layer in the kernel.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1e6a206b3ba30f83784563cdf81992dc5da32d53
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 13:38:01 2009 +0200

    mlx4_en: Added pci device ID table
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5266f322dcdb1d250a67ce14df9c7cccc7574095
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 13:33:39 2009 +0200

    mlx4_core: Added Device ID range for future devices
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit eff7374668b9fd847742e7ba32d78252ee26da97
Merge: f0923c2 b679f78
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 24 10:41:28 2009 +0200

    Merge branch 'ofed_kernel_1_5' into rdmaoe

commit b679f78599b59bb9087a816e163b233c045d98ec
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 22 18:13:20 2009 +0200

    sdp: Fix ZCopy sink not working
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1b6ce93a1ccee8d38bc88a7114abd77dae3410be
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 22 15:22:44 2009 +0200

    Revert "mlx4_core: Added CX3 device IDs"
    
    This reverts commit 6b1c739631ecde05bc674d2351e28d93a6c7f8f4.

commit 2dbe8f24fc424a31ceea533558710c6400b42313
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 22 15:22:39 2009 +0200

    Revert "mlx4_en: Added device ids table"
    
    This reverts commit 6617c6af3326dae1363bcba40158e02d19e02143.

commit 8da853924c888e943787ea5646a4173df12fd809
Author: Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Mon Dec 21 16:16:49 2009 +0200

    IPoIB: Clear ipoib_neigh.dgid in ipoib_neigh_alloc()
    
    IPoIB can miss a change in destination GID under some conditions.  The
    problem is caused when ipoib_neigh->dgid contains a stale address.
    The fix is to set ipoib_neigh->dgid to zero in ipoib_neigh_alloc().
    
    This can happen when a system using bonding on its IPoIB interfaces
    has switched its active interface from interface A to B and back to A.
    The system that fails over will not correctly processes the 2nd
    address change, as described below.
    
    When an address has changed neighbor->ha is updated with the new
    address.  Each neighbor has an associated ipoib_neigh.
    ipoib_neigh->dgid also holds a copy of the remote node's hardware
    address.  When an address changes neighbor->ha is updated by the
    network layer (arp code) with the new address.  IPoIB detects this
    change in ipoib_start_xmit() by comparing neighbor->ha with
    ipoib_neigh->dgid.  The bug is that ipoib_neigh->dgid may already
    contain the new address (A) thus the change from B to A is missed by
    ipoib.  Here is the sequence of events:
    
        ipoib_neigh->dgid = A  and  neighbor->ha = A
    
    The address is switched to B (the first switch)
    
        neighbor->ha = B
    
    The change is seen in ipoib_start_xmit() -- neighbor->ha !=
    ipoib_neigh->dgid so ipoib_neigh is released, and a new one is
    allocated.
    
    The allocator may return the same chunk of memory that was just
    released, therefore ipoib_neigh->dgid still contains A at this point.
    
    ipoib_neigh->dgid should be updated in neigh_add_path(), but if the
    following conditions are true dgid is not updated:
    
            1) __path_find() returns a path
            2) path->ah is NULL
    
    The remote system now switches from address B to A, neighbor->ha is
    updated to A.
    
    Now we have again : ipoib_neigh->dgid = A  and  neighbor->ha = A
    Since the addresses are the same ipoib won't process the change in
    address.  Fix this by zeroing out the dgid field when allocating a new
    struct ipoib_neigh.
    
    Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit c5edf35d2baa2ba8169856be56fd6830c5946abe
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 13:07:49 2009 +0200

    kernel_addons: for fcoe RH5.3
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9f3ae03fc7f7994ebfcfda0f614a95baf5e8bcb2
Merge: d427319 85aba0b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 13:44:27 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~amirv/ofed_1_5 into ofed_kernel_1_5

commit 85aba0b72f16ad16c55bae1f1c8fd5ca485a4882
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 13:23:28 2009 +0200

    sdp: fixed compilation warning
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 84ebd9f8515b5eca679e5baa9ea460d85cc9ac09
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 11:45:37 2009 +0200

    sdp: ZCopy SrcAvail payload size limit fixed + fix ZCopy rx for small packets
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d4273197d3002e3ba6001e8392acdc86cd73fdbc
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 10:22:27 2009 +0200

    kernel_addons: for fcoe SLES11
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c4b755ced0d5b60191ec4f00289cd4272866c65b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 17 12:04:15 2009 +0200

    Add 2.6.32 kernel support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c97e720ff5c252d3f1ccbc7d4ebdc02b79cac618
Merge: 890154b 47542fd
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 17 08:18:49 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6 into ofed_kernel_1_5

commit 890154bcad6cea2a0884fdb8a9398a4d2f83c6ca
Merge: 6617c6a 71bf534
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 17 08:16:59 2009 +0200

    Merge branch 'code-drop/20091216' of git://git.openfabrics.org/~agrover/ofed_1_5/linux-2.6 into ofed_kernel_1_5

commit 47542fd9bd8a6893a465a553209674d83f3f661e
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Wed Dec 16 17:19:55 2009 -0800

    IB/qib: fix RHEL 4 U8 backport for /dev/ipath
    
    The /dev/ipath* files were not being created by udev because
    a "dev" file in /sys/class/ipath/... was not created. Newer versions
    of udev don't seem to have this requirement. Also, vmalloc_to_page()
    doesn't seem to check for zero and panics the system so fix that too.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 52bda772f225ec11a011f05c61ca97d85e6024db
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Wed Dec 16 17:18:22 2009 -0800

    IB/qib: set serdes parameters based on QSFP data and attenuation
    
    The code to set the serdes parameters was rather ad-hoc and based
    on early releases of vendor's cables before the full QSFP data was
    programmed. This patch makes the process more robust and uses the
    attenuation field if available.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 6617c6af3326dae1363bcba40158e02d19e02143
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 16 20:15:33 2009 +0200

    mlx4_en: Added device ids table
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6b1c739631ecde05bc674d2351e28d93a6c7f8f4
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 16 20:14:13 2009 +0200

    mlx4_core: Added CX3 device IDs
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 71bf5340293416a450b7602a2974767ee0d2e1f2
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Dec 14 14:38:56 2009 -0800

    RDS: sendmsg() should check sndtimeo, not rcvtimeo
    
    Most likely cut n paste error - sendmsg() was checking sock_rcvtimeo.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit f44833d17d7d3aa46f8cc9633e4322193a2fdc79
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 15:43:14 2009 +0200

    ipoib: remove RH4.8 backport
    LRO backport is not required on RH4.8
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c148e3b2719aa7b1aeeb29f31c3eabb97192804f
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 15:08:05 2009 +0200

    mlx4_en: Updated driver version and date
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 274d7d19e99f6c7cf3920db57657dcb44ede3707
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 14:46:01 2009 +0200

    mlx4_en: Compilation warning fix on 32 bit systems
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c03011092215ec5b686e56caad419c4f9ba1b27a
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 14:17:34 2009 +0200

    mlx4_core: Cleanup for port type configuration
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 806ede537437fedff7cb5e6eca19d7b01d2b3f34
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 13:37:53 2009 +0200

     mlx4_en: Fix a crash with prioritiesed vlan packets
    
    Ensure that packets are assigned to rings according to
    priorities only when pfcrx is enabled, otherwise, go through
    the "regular" hash mechanism
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7a754bf9bde2cc2891b959f54044dfd3c2657293
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 10:10:58 2009 +0200

    Revert "rdma/cm: Fixup IPv6 support and IPv4 routing corner cases for RDMA CM"
    
    This reverts commit 430a426e24df958ea0a89cdf22030b4ba2da5bfb.

commit f5807d0d3b6bce6a6351b8a328eeb927977d0363
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 10:10:51 2009 +0200

    Revert "Backport patches for rdma cm"
    
    This reverts commit 87e6436fbeb514e97b02e0364854c010e1f4ac5c.

commit 262d44220b10172f3de9b04a55e5a19735f4eb40
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Dec 14 09:57:41 2009 +0200

    nfsrdma: Fix NFS Inode reference error
    https://bugs.openfabrics.org/show_bug.cgi?id=1756
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit f68fb1fba76137a61dd81d74104166737b72aaec
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 10 19:15:43 2009 +0200

    kernel_addons: for fcoe RH5.4
    
    if_ether.h: adding print_mac inline
    compiler.h: adding maybe_unused define for if_ether above
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 87e6436fbeb514e97b02e0364854c010e1f4ac5c
Author: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Sun Dec 13 17:29:07 2009 +0200

    Backport patches for rdma cm
    
    Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 430a426e24df958ea0a89cdf22030b4ba2da5bfb
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 12:25:04 2009 +0200

    rdma/cm: Fixup IPv6 support and IPv4 routing corner cases for RDMA CM
    
    Signed-off-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-of-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4683b8715524fd1a8360a792ee6674ef7aced112
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 13 09:52:16 2009 +0200

    sdp: small spec compliancy fixes in code
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>


----- End forwarded message -----
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
