From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.1 rc5 release is available
Date: Thu, 18 Mar 2010 21:12:12 +0200
Message-ID: <4BA27B0C.6090100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050400020702030906070104"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050400020702030906070104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


OFED 1.5.1-rc5 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.1/OFED-1.5.1-rc5.tgz

The final OFED-1.5.1 release is planned to be on Monday, March 22.

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

Main changes from 1.5.1-rc4:
===========================
1. Updated packages:
       - ibutils: ibutils-1.5.4-0.1.g0464fe6
                  Fixed FC12/OpenSuSE11.2 compilation issue
       - libibverbs: libibverbs-1.1.3-0.6.g932f1a2
                     examples: Add sgid index to address vectors

       - mvapich2: mvapich2-1.4.1-1

2. Bug fixes









--------------050400020702030906070104
Content-Type: text/plain;
 name="ofed_kernel-1.5.1-rc4_rc5.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.1-rc4_rc5.log"

commit dfb9f70b210bb8bd18f256d4c835bf579aaf8644
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 18 13:35:14 2010 +0200

    Fix broken call to to_ib_ah_attr()
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3d646df9f0c9c43b32767ea2c8b3214727a9fdc5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 18 10:45:27 2010 +0200

    mlx4: fix extended dev caps -- again
    
    This commit does just what 803629b intended to do but done nothing.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c84390bf53d0beab828533792f5ab7f576eba404
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 18 12:28:24 2010 +0200

    ofa_kernel.spec: Add scst's Module.symvers for SRP Target kernel module
    
    SRP Target kernel module depends on scst kernel module.
    So, scst's Module.symvers is required to build srpt with correct symbol
    versions.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 69d3d2ec039fe6d9658050fc4e1d5b2d1f5007c5
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Fri Mar 12 16:22:32 2010 -0800

    RDS: Fix BUG_ONs to not fire when in a tasklet
    
    in_interrupt() is true in softirqs. The BUG_ONs are supposed
    to check for if irqs are disabled, so we should use
    BUG_ON(irqs_disabled()) instead, duh.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 51cae8801390bce64dfba72f74a03029e64c547a
Author: Tina Yang <tina.yang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu Mar 11 13:18:42 2010 -0800

    RDS: Enable per-cpu workqueue threads
    
    Create per-cpu workqueue threads instead of a single
    krdsd thread. This is a step towards better scalability.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 9ddd8076cfbf916970dcbd2574e3a333f0443134
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu Mar 11 12:37:05 2010 -0800

    RDS: Do not call set_page_dirty() with irqs off
    
    set_page_dirty() unconditionally re-enables interrupts, so
    if we call it with irqs off, they will be on after the call,
    and that's bad. This patch moves the call after we've re-enabled
    interrupts in send_drop_to(), so it's safe.
    
    Also, add BUG_ONs to let us know if we ever do call set_page_dirty
    with interrupts off.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 0f677e64adf449d6611fb6b5802a1a1c53fe00e4
Author: Sherman Pun <sherman.pun-xsfywfwIY+M@public.gmane.org>
Date:   Tue Mar 9 12:36:19 2010 -0800

    RDS: Properly unmap when getting a remote access error
    
    If the RDMA op has aborted with a remote access error,
    in addition to what we already do (tell userspace it has
    completed with an error) also unmap it and put() the rm.
    
    Otherwise, hangs may occur on arches that track maps and
    will not exit without proper cleanup.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit a13cd6898011cb22fe85795fbdd3ba2db685078f
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Tue Feb 23 17:37:50 2010 -0800

    RDS: only put sockets that have seen congestion on the poll_waitq
    
    rds_poll_waitq's listeners will be awoken if we receive a congestion
    notification. Bad performance may result because *all* polled sockets
    contend for this single lock. However, it should not be necessary to
    wake pollers when a congestion update arrives if they have never
    experienced congestion, and not putting these on the waitq will
    hopefully greatly reduce contention.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 199973c06a2a08aefe522a3a67d00ba2eaa698d9
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 17 16:57:50 2010 +0200

    openibd: Add sleep before configuring IPoIB connected mode
    
    On some servers IPoIB initialisation is still in progress after
    'modprobe ib_ipoib' finished. In this case IPoIB interface will stay in
    datagram mode. Adding sleep 1 resolve this issue.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 803629b96e1ae4b29bc624dff9822f8d542f7107
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 16 15:51:47 2010 +0200

    mlx4: fix extended dev caps
    
    Extend the flag field of struct mlx4_dev_cap from u32 to u64 to contains
    extended flags.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit acb9b055a034de400499b664bb7b19ac14b6b084
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 11:34:48 2010 +0200

    mlx4/backport: Updated backports for kernels <= 2.6.21
    
    mlx4_0060_qp_constants_to_2_6_21.patch was updated following changes made in
    enhanced atomic operations patch
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 58f6499f043eb65d7b31782395ae711e64962f8c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 11:17:27 2010 +0200

    mlx4/IB: Updated enhanced atomic operations patch
    
    The patch chenged to support the new API and following comments in
    http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg02771.html
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a3fc48625483d5ac5e7ba46cb85f958379c9d4e7
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 10 11:07:29 2010 +0200

    IB/core: Update enhanced atomic patch
    
    The patch was changed following comments:
    http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg02769.html
    
    Renamed:
    IB_WR_ATOMIC_MASKED_CMP_AND_SWP -> IB_WR_ATOMIC_MASKED_CMP_AND_SWP
    IB_WR_ATOMIC_MASKED_FETCH_AND_ADD -> IB_WR_ATOMIC_MASKED_FETCH_AND_ADD
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a0247777dd626832624a3a5c2e8abdfa1d694d28
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 16 10:24:49 2010 +0200

    mlx4_core: Fix eq index on init_eq_table error flow
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit eae3f880a41eb17dbf70c8e7b92a0fdc05e3f14e
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Mar 15 10:45:16 2010 +0200

    mlx4,mthca: Change module version to match the version of OFED
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c57a01b9afa87ad4fa58ba96eb991609ea442a72
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 14 18:34:35 2010 +0200

    ibdev2netdev: display correctly mixed port types
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e37d51bf071674a37f76667bb9d495316de86e3a
Merge: 3e2e26b 6daddc8
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Fri Mar 12 19:44:59 2010 +0200

    Merge branch 'ofed_1_5' of ssh://sofa.openfabrics.org/home/boomer/scm/ofed_kernel into ofed_kernel_1_5

commit 6daddc89c2cb3196b3608f70295b176d95ca3eb8
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Fri Mar 12 07:10:21 2010 -0600

    svcrdma: Pull in upstream put patch.
    
    Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>

commit ec67e6c6660a4c27fdb741a46db56706e9ad2dc9
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Thu Mar 11 12:55:04 2010 -0600

    svcrdma: Fix one off error in rdma_read_done
    
    Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>

commit b68154f23eff5f4a71670ff184f0cb4d394b371b
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Thu Mar 11 12:53:58 2010 -0600

    rpcrdma: FRMR invalidate fixes
    
    Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>

commit 217d68a9e4f8cb9c735e1098646f41fb36744ce9
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Thu Mar 11 00:46:13 2010 -0600

    rpcrdma: Various fixes for the RDMA retransmit path
    
    Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>

--------------050400020702030906070104--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
