From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.1 rc1 release is available
Date: Sun, 14 Feb 2010 11:18:16 +0200
Message-ID: <4B77BFD8.40107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010206090600090005000503"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010206090600090005000503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OFED 1.5.1-rc1 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5.1/release/OFED-1.5.1-rc1.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.1

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
         - SLES10 SP2            2.6.16.60-0.21-smp
         - SLES10 SP3            2.6.16.60-0.54-smp
         - SLES11                2.6.27.19-5-default
         - OEL 4 up7             2.6.9-78.ELsmp
         - OEL 4 up8             2.6.9-89.ELsmp
         - CentOS5.3             2.6.18-128.el5
         - CentOS5.4             2.6.18-164.el5
         - Fedora Core12         2.6.31.5-127.fc12    *
         - OpenSuSE 11.2         2.6.31.5-0.1-default *
         - kernel.org            2.6.29, 2.6.30,
                                 2.6.31 and 2.6.32    *

       * Minimal QA for these versions

Main changes from 1.5:
=====================
1. Added RoCEE support
2. updated Open MPI to rev 1.4.1
3. Updated MVAPICH2 to rev 1.4-2
4. Updated DAPL to rev 2.0.26
5. Added extended atomic operations to ConnectX (kernel only)
6. Bug fixes




--------------010206090600090005000503
Content-Type: text/plain;
 name="ofed_kernel-1.5-1.5.1-rc1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5-1.5.1-rc1.log"

commit 95af56b8c3576e040e3bd06f5167b5cf2e16ad0a
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 11 13:00:30 2010 +0200

    IB/core: Fix the ability to check for a receive by testing opcode & IB_WC_RECV
    
    The previous patch that add support for masked atomic operation
    breaks the ability to check for a receive by testing opcode & IB_WC_RECV.
    This patch fixes this issue.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 96aded67b664b28939535845af00bf71aba85027
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 11 11:38:02 2010 +0200

    rocee/cma: bug fix in cma_resolve_iboe_route()
    
    make sure interface is bound and netdev found before proceeding with
    cma_resolve_iboe_route(). Failure to do so can result in kernel oops.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit db05a7050eec3f9fa369b67774a2ab0875d2cf02
Author: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Feb 10 10:04:27 2010 +0200

    rdma/cm: revert associating an RDMA device when binding to loopback
    
    Revert the following change from commit
    6f8372b69c3198e06cecb1df2cb9682d0c55e657:
    
       The defined behavior of rdma_bind_addr is to associate an RDMA
       device with an rdma_cm_id, as long as the user specified a non-
       zero address.  (ie they weren't just trying to reserve a port)
       Currently, if the loopback address is passed to rdma_bind_addr,
       no device is associated with the rdma_cm_id.  Fix this.
    
    It turns out that openmpi depends on rdma_bind_addr NOT associating
    any RDMA device when binding to a loopback address.  Openmpi is
    being updated to correct this, but until a new openmpi release is
    available, maintain the previous behavior: allow rdma_bind_addr to
    succeed, but do not bind to a device.
    
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 3c43e70f78c2251cbf2eb54fe30f7cb13601c774
Merge: 45f08da baa5070
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 10 09:40:05 2010 +0200

    Merge branch 'ofed_1_5' of ssh://sofa.openfabrics.org/home/swise/scm/ofed_kernel into ofed_kernel_1_5

commit baa5070c056c52019a4027d10b600ae5df5ceece
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Tue Feb 9 15:16:50 2010 -0600

    svcrdma: Fixes to the NFSRDMA patch files.
    
    Signed-off-by: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 45f08da4451f76a7637f8bfa2d06607c9a7c66f1
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Feb 9 10:43:02 2010 +0200

    ofa_kernel.spec: Fix ibdev2netdev installation
    
    ibdev2netdev will be installed if mlx4 kernel module selected for installation
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a4d3aae90bf9c88af01b145dd9fbbc2382c57dcd
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 8 14:26:18 2010 +0200

    mlx4_en: Ignoring missing vpd
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 72eafe294c55c77ac3e3bc50a89dcd8dae7ba80a
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 8 11:30:48 2010 +0200

    Fix backport patches for kernels <= 2.6.21
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b50bbce79639329ca857f26fbf50120b2372e708
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 8 11:12:37 2010 +0200

    mlx4/IB: Add support for enhanced atomic operations
    
    Added support for masked atomic operations.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8ae1b84f0d8901948085b952bc4a86d921ea05a6
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 8 11:11:32 2010 +0200

    IB/core: Add support for enhanced atomic operations
    
    - Add a new IB_WR_ATOMIC_MASKED_CMP_AND_SWP and IB_WR_ATOMIC_MASKED_FETCH_AND_ADD send
    opcodes that can be used to mark a "masked atomic compare and swap" and
    "masked atomic fetch and add" work request correspondingly.
    - Add IB_DEVICE_MASKED_ATOMIC capability bit.
    - Add mask fields to atomic struct of ib_send_wr
    - Add new opcodes to ib_wc_opcode
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 983e117ff68b071cb160a7a8ce02244fed45d2a4
Merge: 3e7a44f feba462
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Feb 7 12:07:51 2010 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~amirv/ofed_1_5 into ofed_kernel_1_5

commit feba462d9055b2f3a0b77dbad8db0514d911442a
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 4 17:31:52 2010 +0200

    sdp: BUG1899 - fix warnings on RH4.8 by avoiding multiple deletions on the same timer.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3e7a44f0ede1c1d0612a11d96a9b6954a455e314
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 4 16:36:03 2010 +0200

    ofed_scripts: Renamed ibdev2eth -> ibdev2netdev
    
    Script name changed after adding IPoIB interfaces support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5a7496f73c4e207e67dc5d2b6687eb5964428d5e
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 4 16:02:23 2010 +0200

    ofa_kernel.spec: Fix files installation
    
    Create missing /usr/bin directory
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 00e1c15d9bbeb4a23919defbba0fc1fc7553a939
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 4 12:53:51 2010 +0200

    ib_core/rocee: fix failure to initilalize spinlock
    
    ib_sa_add_one() skips calling ib_register_mad_agent() for rocee ports, but also
    failed to initialize the port spinlock which is still used.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ba1f35e562e7d4dfdc46e015fc7427127ff43512
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 3 14:00:48 2010 +0200

    CMA: Fix iWarp failures to bind to a device
    
    rdma_addr_get_sgid() relies on dev_addr->transport to retrieve the correct GID
    based on the hardware address. However, when called from cma_acquire_dev(), the
    transport field is not yet valid. The solution is to avoid calling
    rdma_addr_get_sgid() from cma_acquire_dev() and find the device based on it's
    GID: for ethernet, assume first it is rocee and search the GID table, if not
    found generate the GID by copying it from the hardware address.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3467dec0e02e33c4666b92fb7193bc308fbfcfcb
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 4 12:18:28 2010 +0200

    ofed_scripts: Added ibdev2eth script
    
    When working with RoCEE, you may need to know how to associate (ib device, port)
    with eth device. The ibdev2eth script does just that.
    This is especially useful when there are a number of HCAs in the system.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 774e45b826d81d1c6ad2c3e2f1d993f3125d2466
Merge: 6fff638 f8ab933
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 3 19:58:12 2010 +0200

    Merge branch 'ofed_1_5' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/~swise/scm/ofed_kernel into ofed_kernel_1_5

commit 6fff63846eb4de7b301d6417640cb65965cb1bb5
Author: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Date:   Tue Feb 2 11:11:04 2010 +0200

    Fix 2.6.3[12] user_mad backports
    
    The ib_umad_port's sm_sem semaphore is initialized as a mutex which
    although it builds (with a warning) badly breaks at runtime.
    
      Fix this by using the proper initialization function sema_init().
    
      Also fix those DOSish end of lines.
    
    Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

commit ce27ef63091d76784bc09e0e494c22a61468a2d3
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Feb 1 15:32:13 2010 -0800

    qlgc_vnic: Fix typo in header guard
    
    A typo in the header guard may cause compilation errors
    against Xen-enabled kernels.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 40fbb82255896a5c39b35035e2fd5202246b6508
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 31 11:17:20 2010 +0200

    mlx4_en: No need to set smaller tx queue len
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a2b7387dd83a4ca41ac4367cc8092cef59051893
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 31 10:57:47 2010 +0200

    mlx4_en: removed redundant backport for vlan_features
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f89895b1b3f1ae2af850fa98a6c8ccd81f3938e8
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 24 11:49:50 2010 +0200

    mlx4_en: Setting offloads for vlan interfaces
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f8ab9334621cc7b109ce2e692fe5bbb39af766c2
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Fri Jan 29 09:24:53 2010 -0600

    cxgb3: advertise 256K max CQ depth.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 7323ca442eae728964419a63b1101ff344cb0637
Author: Tina Yang <Tina.Yang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu Jan 28 16:19:41 2010 -0800

    RDS: Fix send locking issue
    
    Fix a deadlock between rds_rdma_send_complete() and
    rds_send_remove_from_sock() when rds socket lock and
    rds message lock are acquired out-of-order.
    
    Signed-off-by: Tina Yang <Tina.Yang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 26d8079f3f31a08569d6fe4fac726617eaf5d2d1
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jan 20 15:01:05 2010 -0800

    RDS: Fix congestion issues for loopback
    
    We have two kinds of loopback: software (via loop transport)
    and hardware (via IB). sw is used for 127.0.0.1, and doesn't
    support rdma ops. hw is used for sends to local device IPs,
    and supports rdma. Both are used in different cases.
    
    For both of these, when there is a congestion map update, we
    want to call rds_cong_map_updated() but not actually send
    anything -- since loopback local and foreign congestion maps
    point to the same spot, they're already in sync.
    
    The old code never called sw loop's xmit_cong_map(),so
    rds_cong_map_updated() wasn't being called for it. sw loop
    ports would not work right with the congestion monitor.
    
    Fixing that meant that hw loopback now would send congestion maps
    to itself. This is also undesirable (racy), so we check for this
    case in the ib-specific xmit code.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 64120f74851b94b7a49f32e0b1202dd6b944e0d5
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Jan 26 15:28:42 2010 -0600

    cxgb3: bump fw to 7.8
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 5d6a8491f0075d1b964a7bff460535b56692ea7f
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Jan 26 15:28:42 2010 -0600

    iw_cxgb3: Add big cqs patch.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit b57100b0c9654859359fdee005c2d8b756e61913
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Jan 26 15:28:41 2010 -0600

    cxgb3: Doorbell overflow avoidance/recovery.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 1ed36496633af886879b97b478c2b0833ecc10d4
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Jan 26 15:28:35 2010 -0600

    Core: Add idr_for_each() to backports.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 6d1ad4a5df4589a280b5d6cbb21a7e91b2df2089
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Jan 26 13:41:47 2010 -0600

    cxgb3: Allow read/write of t3 regs.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit e2ccd34b1d3d8af083bd922be46b351ac6a0057e
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Jan 26 12:33:16 2010 +0200

    mlx4_core: adjust T11 fix so that it does not overwrite other flag bits.
    
    The T11 patch wrote an entire byte in the INIT_HCA flags dword.  Correct this
    so that only a single bit gets set.
    
    In addition, change T11 logic so that the T11 bit gets set only if the ConnectX
    supports T11 format.
    
    Adjust fix mlx4_1310 RoCEE so that it does not collide.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit b6d857394b9fb76c628088e5207e2137eb937499
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jan 24 17:12:34 2010 +0200

    sdp: must use ib_sg_dma_*, not sg_dma_* for mapping
    
    This fixes OFED bug 1895, althoug some warnings are still generated,
    when running qperf sdp_bw with large sizes (using zcopy), on the
    truescale adapters.
    
    Signed-off-by: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 985bfdd2a130c05b275d21e27c2b0f1fde4191bd
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 21 11:56:42 2010 +0200

    kernel_addons: for fcoe RH5.2
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1cf680464b85e1eff7c8a935d03ac3c456c51cae
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 21 09:43:57 2010 +0200

    kernel_fixes: adding t11 module parameter
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c2e6887a72d6db0ad6d7f19c531d533ffe39de75
Author: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Jan 17 11:34:35 2010 +0200

    iser: Add backport for RHEL 5.4
    
    patch the ofed provided iser code to match the RHEL 5.4 provided
    iser code, mainly by doing iscsi2_xxx instead of iscsi_xxx calls.
    This trivial transformation works since the 5.4 iser/iscsi stack
    was upgraded to 2.6.30 or so.
    
    Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit a2d4b687aa050f21dffcbe922e82db54cc3d9fd9
Author: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Jan 17 11:31:51 2010 +0200

    IB/iser: Rewrite SG handling for RDMA logic
    
    After dma-mapping an SG list provided by the SCSI midlayer, iser has
    to make sure the mapped SG is "aligned for RDMA" in the sense that its
    possible to produce one mapping in the HCA IOMMU which represents the
    whole SG. Next, the mapped SG is formatted for registration with the HCA.
    
    This patch re-writes the logic that does the above, to make it clearer
    and simpler. It also fixes a bug in the being aligned for RDMA checks,
    where a "start" check wasn't done but rather only "end" check.
    
    Signed-off-by: Alexander Nezhinsky <alexandern-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit 921bfa2708441a6b30ac2cd5bf0372f269551a76
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 13 13:30:20 2010 +0200

    Fix RHEL4U[6-8] backports
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 070b34d4a72dcbff6ac39b408bfabcf1bdce7ebc
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 12 19:02:01 2010 +0200

    rocee: Fix SLES10 SP3 backport
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a2bf1fdf807bfbdc136c919a225097c6fbaf9aea
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 12 14:15:46 2010 +0200

    Fix backport for netif_oper_up
    
    For kernels that do not provide it, suffice with netif_running()
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e42e22b7942e6bf40cd7b9b926679c54aba61116
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jan 12 11:19:57 2010 +0200

    Update backports for dev_get_by_index
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 93f7c9d1e7b16476b8ab134193be86efb74b1e5f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jan 11 22:29:28 2010 +0200

    Fix backports
    
    Remove net_eq calls for kernels that do not support it.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 94e4afe453846babd2e6fd641bc0f9a454b3c480
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jan 11 18:51:46 2010 +0200

    Fix compilation errors after adding RoCEE
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4297fe4c8642cba55642265863e5d359b8cb79b2
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 7 16:11:13 2010 +0200

    Fix backports after adding RoCEE
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 44fc4a53e979b5d95b0362e63be64bef6cbb1fe4
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jan 7 11:04:43 2010 +0200

    Add support for RoCEE
    
    Add support for RoCEE based on v7 of the patches sent to the rmda mailing list.
    Also add support for counters in mlx4.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3a8f3b86da8cfb9b19048cda7073874cfb795d58
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jan 6 13:30:02 2010 +0200

    fixes: add get_prot_dev for dev_translate_for_fcoib.patch
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7c3e183793968ad9d2353215d5a6f7df63a82b2f
Author: David J. Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Tue Dec 15 09:43:08 2009 -0800

    bacmports: create an if_inet6.h kernel_addon for the 2.6.9-[67,78,89]
    kernels.
    
    Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    
    ------------------------------------------------------
     .../backport/2.6.9_U6/include/net/if_inet6.h       |   20 ++++++++++++++++++++
     .../backport/2.6.9_U7/include/net/if_inet6.h       |   20 ++++++++++++++++++++
     .../backport/2.6.9_U8/include/net/if_inet6.h       |   20 ++++++++++++++++++++
     3 files changed, 60 insertions(+), 0 deletions(-)

commit 8d3b1a25d2f883515c8dfb4d40d8765b7919029a
Author: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Sun Dec 13 17:29:07 2009 +0200

    Backport patches for rdma cm
    
    Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2c0ff2f658441a52d30864f865499535fea6990b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 12:25:04 2009 +0200

    rdma/cm: Fixup IPv6 support and IPv4 routing corner cases for RDMA CM
    
    Signed-off-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-of-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5d96b90156bd87f1578f6497eda6c3150a16736d
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 4 21:25:53 2010 -0800

    RDS/TCP: Wait to wake thread when write space available
    
    Instead of waking the send thread whenever any send space is available,
    wait until it is at least half empty. This is modeled on how
    sock_def_write_space() does it, and may help to minimize context
    switches.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 7f4f82ec58c10dab756f3dc78f536d1893239806
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 4 21:11:40 2010 -0800

    RDS: use IB_CQ_VECTOR_LEAST_ATTACHED for cq's
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit f3ac1b5ad844c0b5ffc736b46915e33f1205ff72
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu Dec 17 11:02:27 2009 -0800

    RDS: update copy_to_user state in tcp transport
    
    Other transports use rds_page_copy_user, which updates our
    s_copy_to_user counter. TCP doesn't, so it needs to explicity
    call rds_stats_add().
    
    Reported-by: Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

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

--------------010206090600090005000503
Content-Type: text/csv;
 name="bugs-2010-02-14.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2010-02-14.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxODk5LCJt
YWpvciIsIlAzIiwiUkhFTCA0IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIs
IkZJWEVEIiwiR2V0dGluZyB0aW1lciByZWxhdGVkIHdhcm5pbmdzIHdoZW4gcnVubmluZyBz
ZHAgdGVzdHMgb24gUkhFTCA0LjgiCjE5MDcsIm1ham9yIiwiUDMiLCJSSEVMIDUiLCJhbmR5
Lmdyb3ZlckBvcmFjbGUuY29tIiwiUkVTT0xWRUQiLCJJTlZBTElEIiwiUnVubmluZyDigJhy
ZHMtdG9vbHMvcmRzLWdlbiDigJNsIDQwOTbigJkgb3ZlciBSb0NFRSByZXN1bHRzIGluIGtl
cm5lbCBwYW5pYyIKMTkwOCwibWFqb3IiLCJQMyIsIlJIRUwgNSIsImFuZHkuZ3JvdmVyQG9y
YWNsZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiUnVubmluZyDigJhyZHMtdG9vbHMvcmRz
LWdlbiDigJNsIDQwOTbigJkgb3ZlciBSb0NFRSByZXN1bHRzIGluIGtlcm5lbCBwYW5pYyIK
MTkxMCwibWFqb3IiLCJQMyIsIkFsbCIsImVsaUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVE
IiwiRklYRUQiLCJSdW5uaW5nIHVjbWF0b3NlIG92ZXIgUm9DRUUgcmVzdWx0cyBpbiBLZXJu
ZWwgcGFuaWMiCjE5MjAsImNyaXRpY2FsIiwiUDMiLCJBbGwiLCJlbGlAbWVsbGFub3guY28u
aWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiT0ZFRF8xXzVfMSBkb2Vzbid0IHN1cHBvcnQgRHJl
eGxlcidzIGRldmljZSBJRHMiCjE5MDAsIm5vcm1hbCIsIlAzIiwiQWxsIiwiamFja21AbWVs
bGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiVGhlIGV4YW1wbGUgdGVzdCBJYnZf
c3JxX3Bpbmdwb25nIGFsd2F5cyBmYWlsIHdoZW4gcnVuIG92ZXIgSUIgbGluayIKMTkwMSwi
bm9ybWFsIiwiUDMiLCJBbGwiLCJqYWNrbUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
SU5WQUxJRCIsIlRoZSBleGFtcGxlIHRlc3QgSWJ2X3NycV9waW5ncG9uZyBhbHdheXMgZmFp
bCB3aGVuIHJ1biBvdmVyIElCIGxpbmsiCjE5MDIsIm5vcm1hbCIsIlAzIiwiQWxsIiwiamFj
a21AbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIklOVkFMSUQiLCJUaGUgZXhhbXBsZSB0
ZXN0IElidl9zcnFfcGluZ3BvbmcgYWx3YXlzIGZhaWwgd2hlbiBydW4gb3ZlciBJQiBsaW5r
IgoxOTAzLCJub3JtYWwiLCJQMyIsIkFsbCIsImphY2ttQG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJJTlZBTElEIiwiVGhlIGV4YW1wbGUgdGVzdCBJYnZfc3JxX3Bpbmdwb25nIGFs
d2F5cyBmYWlsIHdoZW4gcnVuIG92ZXIgSUIgbGluayIKMTg4Nywibm9ybWFsIiwiUDMiLCJB
bGwiLCJqb2hhbm5AZ2VvcmdleC5vcmciLCJSRVNPTFZFRCIsIkZJWEVEIiwicXBlcmYgZG9l
c24ndCBzdXBwb3J0IG9wZXJhdGlvbiBiZXR3ZWVuIEREUiBhbmQgUURSIHNlcnZlcnMiCjE4
MjEsIm1ham9yIiwiUDMiLCJSSEVMIDUiLCJtb25pc0B2b2x0YWlyZS5jb20iLCJSRVNPTFZF
RCIsIkZJWEVEIiwiQ3Jhc2ggaW4gYm9uZGluZyIKMTkyMSwibWlub3IiLCJQMyIsIlJIRUwg
NSIsIm1vbmlzQHZvbHRhaXJlLmNvbSIsIlJFU09MVkVEIiwiSU5WQUxJRCIsIkluc3RhbGxh
dGlvbiBwYXRjaCBoYXMgYnJva2VuIGh1bmsiCjE3NzQsImNyaXRpY2FsIiwiUDMiLCJTTEVT
IDExIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlZFUklGSUVEIiwiRklYRUQiLCJJbnN0YWxs
aW5nIE9GRUQxLjUgUkMxIG9uIFNMRVMxMSBvbiBtYWNoaW5lIHdpdGggT0ZFRC1kaXN0cm8g
ZG9lcyBub3QgcmVtb3ZlIG9mZWQta21wIgoxODU5LCJub3JtYWwiLCJQMiIsIkFsbCIsImVs
aUBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIsIkZJWEVEIiwiSVBPSUIgQ2FuIG1pc3MgYSBj
aGFuZ2UgaW4gZGdpZCI=
--------------010206090600090005000503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------010206090600090005000503--
