From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.1 rc4 release is available
Date: Thu, 11 Mar 2010 17:46:40 +0200
Message-ID: <4B991060.3040105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020603000503040003090309"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020603000503040003090309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


OFED 1.5.1-rc4 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.1/OFED-1.5.1-rc4.tgz



To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 1.5.1

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

Main changes from 1.5.1-rc3:
===========================
1. Updated packages:
      - ibutils: ibutils-1.5.4
      - libmlx4: libmlx4-1.0-0.6.g72e73dc
          Bug fix in mlx4_create_ah
      - install.pl:
          Add '--builddir' parameter
          NFSoRDMA will not support SLES10 SPx
      - NFSoRDMA is not supported under SLES10SPx

2. Bug fixes








--------------020603000503040003090309
Content-Type: text/plain;
 name="ofed_kernel-1.5.1-rc3_rc4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.1-rc3_rc4.log"

commit 3e2e26b64187f3d5292653b4df761dfcd1e353ea
Merge: f52992f eada57c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 11 13:01:40 2010 +0200

    Merge remote branch 'vu/ofed_kernel_1_5' into ofed_kernel_1_5

commit eada57cc6dfcd0f779c5254a1fc354702ac41247
Author: Vu Pham (Mellanox) <vu-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Thu Mar 11 02:30:28 2010 -0800

    srp: fixing panic bug happened during manual unload ib_srp module
    
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit f52992f15c05d70d17412ca92e14e6f1bf2c1ac7
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 18:46:55 2010 +0200

    mlx4_en: reconfigure mac address
    
    When the other port removes a mac address that is the same that
    the current port has, the table should be reconfigured.
    fixes bugzilla #1965
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7a1bbb340356e0489e50678f7e6d563f2f0be268
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 11 10:33:52 2010 +0200

    IPoIB: Fix multicast handling
    
    After reverting c124815 it was necessary to modify ipoib_mcast_addr_is_valid()
    so it will not filter out valid ipoib multicast addresses.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5daec886e9a7d7baea848180c3c8dbbc7b249e79
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 11 09:17:21 2010 +0200

    Revert "ipoib/mcast: Fix IPoIB multicast backport"
    
    The reverted comit changes the multicat address that the kernel created causing
    resource leaks and other problems.
    
    This reverts commit c12481586c4ba09cb88dc2090c67fdce7c856cde.

commit efe60c7da58f9bf235eef0381aa4a93c014805aa
Merge: 3df6ee7 0ff7a6e
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 08:12:42 2010 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6/ into ofed_kernel_1_5

commit 3df6ee73e2364080d7ac179d1ecd8c4aaf9a9e43
Merge: 7a227ee 4c29a30
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 08:11:37 2010 +0200

    Merge branch 'ofed_kernel_1_5' of ssh://sofa.openfabrics.org/home/ctung/scm/ofed-1.5 into ofed_kernel_1_5

commit 7a227ee270783b7f1d773939e82343fdc3e69fb4
Merge: a679ae9 8721f26
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 08:06:29 2010 +0200

    Merge branch 'ofed_1_5' of ssh://sofa.openfabrics.org/~swise/scm/ofed_kernel into ofed_kernel_1_5

commit 0ff7a6e94e7e98a8f10d1c01e70c6f26d776c4ee
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Tue Mar 9 16:09:47 2010 -0800

    IB/qib: clear symbol error counters on link UP
    
    Clear symbol error counters on link UP.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 4c29a3078cee40ee9800ade03f6f91c69202f368
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Mar 9 15:59:02 2010 -0600

    RDMA/nes: make nesadapter->phy_lock usage consistent
    
    nes_{read,write}_1G_phy_reg() are using phy_lock while
    nes_{read,write}_10G_phy_reg() leave that to the caller.
    
    Remove phy_lock from 1G routines and leave the locking to the caller.
    Add additional phy_lock calls around 1G read/write.
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit a679ae9a392f4404fd76c82deb436d0a6cf3a2a5
Merge: 4d803f7 5bc17bc
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 9 19:19:26 2010 +0200

    Merge branch 'ofed_1_5' of ssh://69.55.231.68/home/boomer/scm/ofed_kernel into ofed_kernel_1_5

commit 5bc17bc65077ff95a5caaa43df6657b2df41dacd
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Tue Mar 9 10:34:50 2010 -0600

    svcrdma: Fix SQ size calculation when memreg is FRMR
    
    From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
    
    This patch updates the computation to include the worst case situation
    where three FRMR are required to map a single RPC REQ.
    
    Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 8721f2647e96cb33ac7a1a2f3ece39622adba399
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Mar 9 10:19:41 2010 -0600

    cxgb3: update firmware to 7.10.0.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 4d803f721b73c7b9e32a1f7641bc557deeb881fc
Author: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Tue Mar 9 16:54:31 2010 +0200

    ib_core: big LSO support wr opcode for packets larger than 64B
    
    Signed-off-by: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 7fe30cb86bc13b6404785dbc556b2d7f5d925436
Author: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Tue Mar 9 16:53:55 2010 +0200

    mlx4_core: big LSO support preparation for packets larger than 64B
    
    Signed-off-by: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit f90c487eaf52a96473961f26cd0be36f4dd4eb53
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Mar 9 16:47:28 2010 +0200

    mlx4_ib: fix SRQ initialization per PRM requirements.
    
    Very similar to mthca-memfree SRQ initialization.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit ffbfd4bfcc9f75c4750a63e946f0b2d15f27dc12
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Mar 9 16:46:37 2010 +0200

    mlx4_core: deprecate "bogus CQ" completion event warning to debug.
    
    getting an completion event for a CQ that has been destroyed may happen when
    a QP is transitioned to ERR, then immediately destroyed along with its CQs.
    
    This is legal, so the message should be for debugging only.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 8682ec4e3279eb3284ad4afdad9c7c289eec8296
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 9 14:54:51 2010 +0200

    mlx4: fix allocation type
    
    Since update_ipv6_gids() is called with spinlock acquiree, use GFP_ATOMIC.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 723420321fec93c004e2885abf42ce69272c8154
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 9 12:13:19 2010 +0200

    mlx4: fix phys_state report for IBoE ports
    
    Since physical state follows the active port state, use a proper translation
    function. Also use meaningful values for link width and fix the correct default
    for link speed and link width.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit dcf8ff7e1f905a78395782c6cbd6d6c92afd7246
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 7 16:18:40 2010 +0200

    backports: Fix RHEL5.5 backport patches
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 409027d3cc304d183b8847f13953a49408a0744b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 7 14:05:24 2010 +0200

    get_backport_dir: Add RHEL5.5 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e3d41e72a0ce7f4e956952c28d51e4e9abbfcd08
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Mar 8 08:25:48 2010 +0200

    ipoib: Fix lockup of the tx queue
    
    The ipoib UD QP reports send completions to priv->send_cq which is unarmed
    generally; it only gets armed when the number of outstanding send requests
    (e.g. those for which a completion was not polled yet) reaches the size of the
    tx queue. This arming (done using ib_req_notify_cq()) is done only in the send
    path for the UD QP. However, when sending CM packets, the net queue may be
    stopped for the same reasons but no measures are taken to recover the UD path
    from a lockup.
    Consider this scenario: a host sends high rate of both CM and UD packets.
    Suppose also that the tx queue length is N. If at some time the number of
    outstanding UD packets is more than N/2 and the overall outstanding packets is
    N-1, and now CM sends a packet making the number of outstanding equal N, the tx
    queue will be stopped. When all the CM packets will complete, the number of
    outstanding packets will still be higher than N/2 so the tx queue will not be
    enabled.
    Fix this by calling ib_req_notify_cq() when the queue is stopped in the CM
    path.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c36de74a2987eb0ee78f7f59f18916e1a7096c4b
Merge: 1ab03e6 1e49d72
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 7 12:21:26 2010 +0200

    Merge branch 'ofed_1_5' of ssh://sofa.openfabrics.org/~swise/scm/ofed_kernel into ofed_kernel_1_5

commit 1e49d727e4a6ac012625ceb4f550783c632c11a9
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Mar 4 10:38:48 2010 -0600

    RDMA/cxgb3: wait at least one schedule cycle during device removal.
    
    During a hot-plug LLD removal event or an EEH error event, iw_cxgb3
    must ensure that any/all threads that might be in a cxgb3 exported function
    concurrently must return from the function before iw_cxgb3 returns from
    its event processing. Do this by calling synchronize_net().
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 87581e84b1efa06c41e05b5865ca3b6430f5cac5
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Mar 4 10:35:45 2010 -0600

    cxgb3: fix hot plug removal crash
    
    From: Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
    
    queue restart tasklets need to be stopped after napi handlers are stopped
    since the latter can restart them.  So stop them after stopping napi.
    
    Signed-off-by: Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 1ab03e6a07826382aa59f5a1b919e303ad92979d
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Mar 4 10:24:23 2010 -0600

    RDMA/nes: update backports for RHEL 5.5
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit e0006c0b7cc5e378a210d1f00023a3be60d3c27c
Merge: 590c926 b2f2c1b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 4 15:38:14 2010 +0200

    Merge remote branch 'eli/ofed_kernel_1_5' into ofed_kernel_1_5

commit 590c926eaef8e7dcc589ffa4076767f3fec0ef10
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Mar 4 12:03:22 2010 +0100

    ehca: bump version number
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit b2f2c1b1a7ed0ef8b143ea1e82ff2c59f69470fb
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 4 14:29:31 2010 +0200

    Fix bug in SL/IB inserted in 464df47
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4dffb9bffcf2fefb9ff9bc466e818527df963a55
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 4 12:37:51 2010 +0200

    ib_core: Add link_layer entry to sysfs
    
    Now that the port link layer may be either IB or Ethernet, add this information
    to sysfs. For example, /sys/class/infiniband/mlx4_0/ports/1/link_layer.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------020603000503040003090309--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
