From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc3 is available
Date: Wed, 04 Aug 2010 10:44:09 +0300
Message-ID: <4C591A49.4000807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000309040705040304030100"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000309040705040304030100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.2-rc3 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.2

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
            - SLES11 SP1 RC1        2.6.32.9-0.5-default *
            - OEL 4 up7             2.6.9-78.ELsmp
            - OEL 4 up8             2.6.9-89.ELsmp
            - CentOS5.3             2.6.18-128.el5
            - CentOS5.4             2.6.18-164.el5
            - Fedora Core12         2.6.31.5-127.fc12    *
            - OpenSuSE 11.2         2.6.31.5-0.1-default *
            - kernel.org            2.6.29, 2.6.30,
                                    2.6.31 and 2.6.32    *

          * Minimal QA for these versions

Main changes from 1.5.2-rc2:
===========================
1. Updated packages:
	libibverbs-1.1.4-0.11.g1541e64.tar.gz
	libmlx4-1.0-0.11.gd213393.tar.gz
	libnes-1.0.1-0.5.g9371546.tar.gz
	compat-dapl-1.2.18.tar.gz
	perftest-1.2.4-0.19.g9e79456.tar.gz
	rds-tools-2.0.3

     - MPI
	mvapich2-1.5-1.src.rpm

2. New features
	ibacm-1.0.1

--------------000309040705040304030100
Content-Type: text/plain;
 name="ofed_kernel-1.5.2-rc2_rc3.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.2-rc2_rc3.log"

commit c77daa4bdb7ac419deea8776abd6c1ac0a473b7d
Author: Ali <ali-mB92+W4/ugp418Cm2XGpyFaTQe2KTcn/@public.gmane.org>
Date:   Fri Jul 30 11:25:07 2010 -0700

    memtrack: added support for 2.6.32.x kernels (backport patch)
    
    Signed-off-by: Ali Ayoub <ali-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e8047441a184d57aed6bf275fc0678e08f837472
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 09:44:39 2010 +0300

    mlx4_en: updated version to 1.5.2
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2f15aea260c117ac1e395fcfd82ab63013698eca
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 26 17:45:38 2010 +0300

     mlx4_en: validate vlan dev existance before accessing it when change tso
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 935aca3d2e73c13ec6ed6dc6dbb5f6f674199cd6
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 09:39:22 2010 +0300

    mlx4: Don't request region for CR space in RH4.
    
    Allows to use MSI-X in these systems.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5dc40962697d4d975ddbcea74eb89ff488d1795c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 26 10:24:05 2010 +0300

    sdp: fix behavior when a skb allocation fails
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9e5159b711668365bd6ec863fbbc2f66bf9f4976
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 22 14:07:43 2010 +0300

    sdp: Add support to kernel 2.6.32
    
    - setsockopt prototype was changed in 2.6.32
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2de4ff64e353b7e63345d42b3682f5032c9a8a4c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 22 12:08:52 2010 +0300

    sdp: some small non-behavioral changes in sdp_dreq_wait_timeout_work()
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7bcbcae1b5e1e6c14456d288d5e1eecfc7c0eca0
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 22 08:03:49 2010 +0300

    sdp: rewrite orphan count logic
    
    orphan count is increased on every call to sdp_common_release and decreased on
    every call to sdp_destruct (just before the socket is freed).
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fff4052e89fd2d9ccf244608571b73589c379f7d
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 21 17:40:45 2010 +0300

    sdp: change socket reference semantics: keepalive != alive
    
    keepalive timer manages a socket reference count regardless to the initial
    socket reference (SOCK_REF_ALIVE).
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7c17282bc0883425322a26722dfe0fa568e8b6f2
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 21 17:05:33 2010 +0300

    sdp: remove unnecessary argument from sdp_connected_handler.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 312d01140c4754b5f0551b65365a227c5e73e423
Merge: c005197 c85c2bf
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 21 16:13:52 2010 +0300

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit c85c2bf99abac53445091fc9166f36c49475e116
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 20 14:43:26 2010 +0300

    sdp: removed extra debug message and comment.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cbc9f111f95a031ee825e66ed96d1a9c413c47e3
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 20 14:32:44 2010 +0300

    sdp: fix for socket refcnt when error is marked while in TCP_TIME_WAIT state
    
    When socket is in TCP_TIME_WAIT state, the next sdp_destroy_work() call will
    put the cma_refcnt, so we should not change the socket state even if there is
    an error.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4d7bef723c9056890ed20c39df4104a5705f605f
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 20 12:45:02 2010 +0300

    sdp: enable support for ib devices that do not support fmr
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c0051974aa522a56abe95b82f440164bcb8165fe
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 19 17:06:23 2010 +0300

    SLES10SP3: Avoid FMODE_EXEC redefinition
    
    FMODE_EXEC definition was added to 2.6.16.60-0.60.1.
    Bug: https://bugs.openfabrics.org/show_bug.cgi?id=2053
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 925292ecc9bfd3c30466879382b14fade8e89599
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 19 16:50:46 2010 +0300

    scst: avoid WARN_ON_ONCE redefinition
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6bcc8f2eb4f005f430ee8f1d6962ba6778d6bbd8
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Jul 16 13:46:56 2010 +0200

    RDMA/nes: corrected link type for nes cards
    
    Now correct interface link type is set for ibv_query_port()
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 24b0729c29a6b4f821213bf3f1242617deec0373
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Jul 16 13:37:34 2010 +0200

    RDMA/nes: corrected firmware version update
    
    Now firmware version is read from correct place
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 0c842405cd3d204b23125836a8749fe7cd40b566
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 14 11:20:19 2010 +0300

    sdp: before activating rx_ring timer, need to check that qp is still active.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1cf9745ae2f26483749079a2bca31ccdfa0b4897
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 14 10:14:14 2010 +0300

    sdp: fix compilation warnings
    
    use %z for size_t in printk's
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5c7c9a75f3cd45b2b440b3fec02b097b7162b7fe
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 14 07:50:43 2010 +0300

    sdp: define SDP_MAX_PAYLOAD as ulong instead of int, to comply with PAGE_SIZE
    
    SDP_MAX_PAYLOAD is compared a lot to PAGE_SIZE by min(), and on some kernels a
    compilation warning of "comparison of distinct pointer types lacks a cast"
    appears.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5ac8bffc6a455ab8cd406b42d46cd64838ba411c
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 14 11:37:34 2010 +0300

    Fix backport for slert 10 sp2
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 222215b0c3f6dcfc08ca260dbf6fdacf66dd957b
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 14 10:27:19 2010 +0300

    mlx4_en: Added QUERY_PORT backport to SLERT10_sp2
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e927620de6dca4421e3e0d8be7efb648c8d9294f
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 13 18:03:18 2010 +0300

    mlx4_en: updated version to 1.5.1.5
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit aebb54bcd271458c99cb247871cf34e71d87a696
Merge: ad73fb2 cd0d53d
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 13 16:04:47 2010 +0300

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit cd0d53da1fdd872425d171d308ae0c9915622bce
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 12 16:18:07 2010 +0300

    sdp: some small non-functional changes.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a96f14a5c0c6f43d691df362dd0b957d4e0fd79a
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 12 15:59:57 2010 +0300

    sdp: enable rx_cq arming when no one polls.
    
    No need to explicitly arm the cq, posts_handler_put will arm it.

commit ad73fb299e74d19194e37c803d450189acc3c703
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 13 15:19:21 2010 +0300

    Added SLERT10SP2 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e0867e5dde8a68d7223229f4a82ea238bf5f466a
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 12 13:24:50 2010 +0300

    mlx4: Fix backports for resulting from previous commit
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1b243e5b47c74ad1d1ac1b0cb37a2039723ce151
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 12 12:35:40 2010 +0300

    mlx4: Call netdev handler only for none NULL dev
    
    When VLAN is supported by the kernel, make sure that we call handle_en_event()
    for VLAN devices that are not NULL.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1646c4243faa55f19b79067095473d39450bd483
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jul 11 12:14:20 2010 +0300

    sdp: before arming cq, need to check if cq was not destroyed already.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 71fc74e51e37124941fc5c690235145b06f4c76c
Merge: 3662dad 9c9eb18
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 8 18:27:14 2010 +0300

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 9c9eb18cb39558d21ced0c18e2ecb0a6623929c6
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 8 16:37:24 2010 +0300

    sdp: When purging tx_ring, rdma_inflight accountings should be disregarded, so
    the number of skbs to free is just (posted=head-tail).
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d7f622c4a88b741f070fb4a29efeeff44bdcabf7
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 8 16:27:20 2010 +0300

    sdp: tx_ring timer should not be scheduled if the qp is not active anymore.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3662dadd2f5127044e0839b9b4b59f647bea904f
Author: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Thu Jul 8 15:42:14 2010 +0300

    QP type enum in kernel sync
    
    Move RAW_ETH to the end of enumeation as is defined in Roland tree
    and make it equal to '8'.
    
    Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit c0db0353635c2263924db7f88c4cf03f2191f5a9
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 7 18:48:27 2010 +0300

    sdp: if can't recv or send, and the qp is not active, return -EPIPE instead of 0
    
    This fixes an endles loop problem where userspace programs are looping on recv
    or send until all required bytes processed or until an error returned.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6c8192f4d7eb86811f3225765be282e226ad7842
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jul 7 16:03:11 2010 +0300

    sdp: rx completions workqueue should be flushed after qp destruction and before
    the socket is freed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3250469b7ddd0c44cfd33e02276c1462b6f005ab
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 5 14:46:04 2010 +0300

    sdp: rx/tx tasklets should be properly killed when destroying qp.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 48430b667170323d461271200632823148b76e96
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 5 11:38:11 2010 +0300

    sdp: some annoying whitespaces removed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 999b1c658fd3c74e8e86fa01dd83cfb15e35bf9e
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 17 17:17:37 2010 +0300

    mlx4_en: Cancel reseting of transport header
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 019c3027ce07b161460d76d86bc3cc789321546a
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 23 10:22:40 2010 +0300

    mlx4_en: Fixing backports for deffered QUERY_PORT
    
    Accessing port fields should under spinlock instead of mutex,
    As the bonding driver might call it under spinlock.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7870d697e082efab10a14a4fdc58f15c264644b8
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sat Jul 3 19:18:04 2010 -0500

    RDMA/nes: sometimes ifdown command hangs
    
    When ib_unregister_device() is called from netdev stop during ifdown, it
    sometimes hangs.  Changes made to indicate port_err to ib_dispatch_event()
    during netdev stop and port_active during netdev open. The ib_unregister_device()
    is only called during remove of the module.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 5dda48154dc87b076e557187ebb85feb4e0aa77a
Merge: 559735b 4fb7fb3
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jul 5 11:12:31 2010 +0300

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6/ into ofed_kernel_1_5

commit 559735b2bf3423ccdb28dbb724de401e12d814e7
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jul 4 17:15:43 2010 +0300

    sdp: remove white spaces in the end of some lines.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fddafa98cce4b07549a9c8c877b1b4f509d0e798
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jul 4 16:30:43 2010 +0300

    sdp: device_removal_lock should not be a spinlock because module removal takes
    a long time.
    
    In order to prevent a situation that many CPUs are stack with read-spinlock
    waiting for remove-device write-lock to be freed, I replaced the rw-spinlock
    with rw-semaphore. That way the blocked processes goes to sleep and are not
    blocking other processes.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0ad0978f334ba8cd03719fff76ca25280d2ab0c4
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 30 17:38:33 2010 +0300

    sdp: error value for sdp_set_error() should be negative.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9eced9971fe0d240599ca23bcf884d71464608e6
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 24 18:27:46 2010 +0300

    sdp: Fix for deadlock between sdp_connect and sdp_destroy_work.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4fb7fb382cc0dec9f5bb73295e0695b2cde110c9
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Wed Jun 30 13:52:32 2010 -0700

    IB/qib: initialize serdes for mezzanine cards
    
    A number of QLogic mezzanine cards need to know which slot they are
    connected to in order to set the serdes parameters correctly.
    This is because there is no QSFP EEPROM to indicate the trace length
    to the switch. The fix is to use dmidecode to get the blade slot number
    and set the serdes accordingly.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit fd02152ace34bb506e75810e6f0058f0909c7f63
Author: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jun 23 14:31:31 2010 -0700

    ofed_scripts: add iw_cm to the list of modules to unload
    
    The list of Infiniband modules to unload when stopping the driver
    didn't include iw_cm. This can cause other modules to fail to unload.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit dcf46324da0b1cc28a34fc78dce32ed2e0340646
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Wed Jun 23 14:12:58 2010 -0700

    IB/qib: sync 2.6.35 kernel.org qib changes for OFED 1.5.2
    
    This patch adds the following from linux-rdma.
    
    IB/qib: clear eager buffer memory for each new process
    IB/qib: avoid a rare 7322 chip problem by not marking VL15 bufs as WC
    IB/qib: mask hardware error during link reset
    IB/qib: allow PSM to select from multiple port assignment algorithms
    IB/qib: turn off IB latency mode
    IB/qib: completion queue callback needs to be single threaded
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

--------------000309040705040304030100
Content-Type: text/csv;
 name="bugs-2010-08-04.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2010-08-04.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoyMDU2LCJt
YWpvciIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJ
WEVEIiwiU2RwIHNvY2tldHMgZG9lc24ndCBjbG9zZSBhZnRlciBhcHBsaWNhdGlvbnMgZW5k
IgoyMDU4LCJtYWpvciIsIlAxIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJS
RVNPTFZFRCIsIkZJWEVEIiwiS2VybmVsIFBhbmljIHdoZW4gcnVubmluZyBiaWRpcmVjdGlv
bmFsIG5ldHBlcmYiCjIwNzAsImNyaXRpY2FsIiwiUDMiLCJTTEVTIDExIiwidmxhZEBtZWxs
YW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJGYWlsZWQgdG8gY29tcGlsZSBPRkVE
MS41LjItUkMyIG9uIHNsZXMxMSBzcDEgLSBvcGVuLWlzY3NpIGZhaWxlZCIKMjA3MywiYmxv
Y2tlciIsIlAzIiwiUkhFTCA1IiwicGVya2luam9AY3NlLm9oaW8tc3RhdGUuZWR1IiwiUkVT
T0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LjItMjAxMDA3MDUtMDYwMCA6IE12YXBpY2gyIHJw
bSBmYWlscyB0byBpbnN0YWxsIHdpdGggb2ZlZC0xLjUuMiBwYWNrYWdlcy4iCjIwODEsIm1h
am9yIiwiUDEiLCJTTEVTIDEwIiwibWl0a29AcWxvZ2ljLmNvbSIsIlJFU09MVkVEIiwiRklY
RUQiLCJpbmZpbmlwYXRoLXBzbSBSUE0gaW5zdGFsbGF0aW9uIGZhaWxzIG9uIFNMRVMxMCBT
UDIiCjIwODIsIm1ham9yIiwiUDEiLCJSSEVMIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIs
IlJFU09MVkVEIiwiRklYRUQiLCJTRFAgbW9kdWxlIHVubG9hZHMgd2l0aCBvcnBoYW4gY291
bnQgbWVzc2FnZSIKMjA4NiwibWlub3IiLCJQMyIsIk90aGVyIiwic3dpc2VAb3BlbmdyaWRj
b21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LjItMjAxMDA3MTUt
NjAwIDogT0ZFRCBrZXJuZWwgZmFpbHMgdG8gY29tcGlsZSBmb3IgcmRtYV9rcnBpbmcgbW9k
dWxlIG9uIFJIRUw2LjAtQkVUQSg2NCBiaXQgKSAmIFNMRVMxMS1TUDEtUkM0KDY0IGJpdCAp
IHBsYXRmb3JtLiI=
--------------000309040705040304030100--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
