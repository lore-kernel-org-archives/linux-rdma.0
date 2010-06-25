From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc2 is available
Date: Fri, 25 Jun 2010 10:01:41 +0300
Message-ID: <4C245455.1060405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010906050701010108000309"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010906050701010108000309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.2-rc2 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc2.tgz

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

Main changes from 1.5.2-rc1:
===========================
1. Updated packages:
    libibverbs-1.1.4-0.10.g2f6624c.tar.gz
    librdmacm-1.0.12-0.1.gc9ce9d4.tar.gz
    dapl-2.0.29.tar.gz

    - MPI
    mvapich2-1.5-0.1.rc2.src.rpm

2. New features
    RAW ETH support

--------------010906050701010108000309
Content-Type: text/plain;
 name="ofed_kernel-1.5.2-rc1_rc2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.2-rc1_rc2.log"

commit ccb1c56aa20fa7d68c916b650ec3201ab68b1cf2
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 23 13:43:55 2010 +0300

    sdp: cleanup ssk->rx_sa when aborting incoming SrcAvail
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f0fa91c1c089942ccb31e6d81382b863d3608479
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 23 13:42:39 2010 +0300

    sdp: fix compilation warnings in RH
    
    use %z for size_t in printf's
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 75775355c33e66b89cf7247d188ac0f05be511f2
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 23 11:07:36 2010 +0300

    sdp: sdp_destroy_qp should be protected in destroy work
    
    sdp_destroy_work didn't take a lock before destorying QP
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 430dde60ba3f1037c07384c217657409071b4914
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 22 14:29:31 2010 +0300

    sdp: don't double free fmr
    
    There are flows that try to free ssk->fmr twice.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c31788f272e631838e792120240572063c0fc4fc
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 22 10:45:58 2010 +0300

    sdp: Limit FMR resources
    
    - Make FMR pool size a module parameter and set default value to a
      smaller value (20 FMR's)
    - Fallback to SendSM silently when  can't allocate FMR
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ab47ceeb606f8f8051a2dcb2d677fe8e87fd8b05
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 22 10:40:54 2010 +0300

    sdp: Fix for hangs/crashes in rare cases
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bc376b5664b41eb2bea3b35ab14d10e78bb7d403
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 17 09:57:57 2010 +0300

    sdp: Fix for warning message when receiving with MSG_PEEK flag, and free skb
    that is not needed any more after all data was read from it.
    
    'rx_sa->used', unlike 'offset', was not updated when MSG_PEEK flag was up and
    that lead to the behavior that bytes considered to be available to copy while
    the sequence offset showed that the bytes already consumed.
    The solution is to discard any use of 'rx_sa->used' and use 'offset' instead.
    
    An skb of SDP_MID_SRCAVAIL is not needed anymore when all its inline data was
    consumed and the RDMA operation was canceled (due to MSG_PEEK flag).
    This fix eliminates the warning message: "Trying to read beyond SKB".
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d5d74dca47e9d23ee01c584530398b1e8c21bc96
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 17 10:44:42 2010 +0300

    sdp: On MSG_PEEK, no rdma_rd_complete should be sent.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a31343c3ddcc278b797ca372845b2f3dda5ac2b1
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jun 14 15:49:19 2010 +0300

    sdp: update for sdp_cma_handler() events debug messages.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3f9e200a65e669cf9a2cf5017f72f0e12f0faf52
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 15 08:08:22 2010 +0300

    sdp: fix for handling multi iov's in ZCOPY.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bf852735c4081433c2d85af9e8f262fee531b227
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 16 11:54:11 2010 +0300

    sdp: Fix iperf multistream hanging
    
    When trying to send and no credits available. Sometime coulnd't get
    credit update, because interrupts are turned off by default.
    Added poll RX CQ to fix in this case.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c0905871576dde4f3138c0c89991423a46d3845a
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 16 11:46:56 2010 +0300

    sdp: Fix wrong use of ssk->sdp_disconnect
    
    Due to miss-use of sdp_disconnect rx cq is not armed after disconnect is
    sent
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5e8cc9370813181a5e75f16349e28f27b08a38b6
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 15 16:00:15 2010 +0300

    sdp: protect sdp_auto_moderation from device removal
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e2c8355eeab3d2fd8ea186d5c452bad1e4e2922f
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jun 14 13:03:16 2010 +0300

    sdp: sdp_recvmsg() shouldn't handle SDP_MID_DISCONN when MSG_PEEK flag is up.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4d5ae7a75acfe5fda3efdd065abc0158e876db31
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jun 14 12:01:31 2010 +0300

    sdp: added lock_sock() to sdp_poll()
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e86a0c91e89229f9c299ad5e10e1c238b45523ef
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 13 16:10:29 2010 +0300

    sdp: Cleanedup some commented lines
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8f843c0fdcc38de214c5dab5565f289ebac25523
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 10 11:32:50 2010 +0300

    sdp: Fix bad handling of small rcvbuf size in zcopy
    
    - Do not send RdmaRdComp when no buffers
    - Same for SendSm
    - post at least 3 buffers in RX to have the minimal number of credits
    - make purge_tx_ring ignore WR used by RDMA
    - fixed a typo, to reschedule tx_cq_poll timer according to tx queue and
      not to rx queue (!)
    - Allow credit updates when less than half RX Q is filled
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d110c24d79ac27417642647c21b6c742c5fddd93
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jun 14 13:08:36 2010 +0300

    sdp: fix issues in orphan count
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 266f9dd74208eaa14bc1b66dea245f6f39e2eebb
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 13 15:51:01 2010 +0300

    sdp: protect rx_ring access with a lock
    
    because sdp_poll_rx_cq() is accessed both from interrupt and from user
    context, need to protect it with a lock.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6643e33462c8a7a88c0e506d0210944769f50c57
Author: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Tue Jun 15 16:11:41 2010 +0300

    IB CORE: RAW ETH support
    
    Fix QP type when using iWARP transport.
    
    Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 16bda78b6aa4736148fc4c02c122443ffc05bcc9
Author: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Tue Jun 8 16:54:01 2010 +0300

    RAW_ETH support
    
    This patch will fix existing NES code to support RAW_ETH instead of RAW_ETY type.
    
    Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit a31b55f3ba3fdae8f87e52d316ef0b03e131b3db
Author: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Mon Jun 14 15:40:35 2010 +0300

    MLX: RAW ETH support
    
    This patch add RAW ETH support in mlx4 driver.
    
    Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 25d639fd4264ef911758a567e4df3d2b9d5e1bde
Author: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Mon Jun 14 15:38:48 2010 +0300

    IB CORE: RAW ETH support
    
    This patch add RAW ETH support to IB core.
    
    Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 0837dd77b6735e244ab1ece7ff1e82d97d2932fa
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Sun Jun 13 11:16:52 2010 +0300

    mlx4_ib: Add spinlock to xrc_reg_list changes and scanning in interrupt context.
    
    mlx4_ib_qp_event traverses the xrc_reg_list to distribute XRC_RCV_QP events to
    all processes registered to that QP.  When changing the list (list_add/del) in
    process context, need to have a spinlock so that the event traversal will find
    a stable list.
    
    Fixes FM 85289
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 21d8e77f5cfda1abba93957d08559f1e8384b6f1
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Sun Jun 13 11:15:42 2010 +0300

    mlx4_ib: XRC locking fixes, and prevention of null dereference.
    
    Based on feedback from Roland Dreier in his post (for null deref):
    http://www.spinics.net/lists/linux-rdma/msg03675.html
    (can have a null dereference if the xrc_rcv verbs are invoked for a
     non-xrc_rcv QP by mistake).
    
    Also fixes a kernel Oops seen at a customer site, most likely due to
    insufficient locking on __mlx4_qp_lookup (this is the general QP database).
    (FM 83858).
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 17c3298d08816fa2123891078e4a22b8c878c6ec
Merge: f4a08fc 64c7aba
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 13 13:43:54 2010 +0300

    Merge remote branch 'eli/ofed_kernel_1_5' into ofed_kernel_1_5

commit f4a08fc1b090fe5d1df1d7e890fbf940ec88df98
Author: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed May 26 15:00:58 2010 -0500

    ofa_kernel madeye.c
    
    This is a simple fix. Several of the snoop filters in ./drivers/infiniband/util/madeye.c don't switch the attribute id to host byte order before checking it.
    
    Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 64c7aba292a634b8b6230270106965d07a566ae1
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 13 10:14:41 2010 +0300

    Fix backports for previous commit
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0d5c5a6a2de045911d5d3b17217eb80bc42555e6
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 10 17:17:08 2010 +0300

    mlx4_en: help disperse interrupts workload
    
    make sure that at least once in 1024 completions, the CQ will be armed so an
    EQE will will be issued and eventually an interrupt request. This is necessary
    since the irq balancing code takes effect after the handler is run and we want
    the irq balance daemon configurations to take effect.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f99498779bd4684612c2b322a8e5b5c217070a5e
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Fri Jun 11 15:04:02 2010 +0200

    ib/ehca: bitmaks handling for lock_hcalls
    
    Signed-off-by: ALexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit 362049c6f54667fa5f992a4de6eb6531e94aa3ee
Merge: d080e35 2d390c2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sat Jun 12 17:49:51 2010 +0300

    Merge branch 'ofed_kernel_1_5' of ssh://sofa.openfabrics.org/home/ctung/scm/ofed-1.5 into ofed_kernel_1_5

commit 2d390c24133cc8cda1fd79baf088b88d6236e3f4
Author: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Jun 11 10:48:55 2010 -0500

    RDMA/NES: fix for wrong device name set for ibdev
    
    The problem caused problems with MPI applications. Now nes is used instead
    of eth name
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit d080e35bc5d9494c25d534d4984edc46778d1cd5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jun 10 09:18:29 2010 +0300

    mlx4_ib: Fix failure to set port number
    
    Fix failure to set the port number of a struct gid_entry object causing later
    on crashes due to array bounds overflow.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d9f3ed19d2c6cdef50dd3975cf85781cf8d869c7
Author: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Jun 9 20:04:12 2010 -0500

    RDMA/nes: Added missing mutex during memory registration
    
    Fix for crash problem when multiple processes make a memory registration
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 70f02889ae061264711611989173786fe7d6a2d4
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Jun 9 20:02:17 2010 -0500

    RDMA/nes: get and print eeprom version number
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit ba2b58575e39b3c652c5f919be74223be23426a0
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Jun 9 12:40:23 2010 +0300

    sdp: cleanup skb allocations
    
    - Bad sizing of inline data on send sockets had implications on the
      performance.
    - All sent data is placed on the skb itself (unless accumulated by nagle)
    - Do not count sdp header twice when allocating skb
      added some likely/unlikely
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2df9ff6e04fcb6a7d1cfa1cf172bf6c0aee1fd3a
Merge: b17f431 1423596
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 8 17:09:27 2010 +0300

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 1423596cfc5a6b02b0d4d4f680f95fe43d3ee825
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Jun 7 18:17:59 2010 +0300

    sdp: Reuse buffers in rx ring
    
    To improve latency in small packets - reuse already pinned and allocated
    pages that wasn't used.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b17f431349fce94113360d2279d122948087dd5b
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Mar 12 09:32:14 2009 -0500

    RDS/IW+IB: Set recv ring low water mark to 1/2 full.
    
    Currently the recv ring low water mark is 1/4 the depth.  Performance
    measurements show that this limits iWARP throughput by flow controlling
    the rds-stress senders.  Setting it to 1/2 seems to max the T3
    performance.  I tried even higher levels but that didn't help and it
    started to increase the rds thread cpu utilization.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 2208e58c1d59e6ae1d33421d217dd5209c6f2e9b
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Mar 29 16:50:54 2010 -0700

    RDS: Fix locking in send on m_rs_lock
    
    Do not nest m_rs_lock under c_lock
    
    Disable interrupts in {rdma,atomic}_send_complete
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 2b3d3ebe25139d4e65bc897721fb3545a6ee1cfe
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Fri Feb 19 18:01:41 2010 -0800

    RDS: Rewrite rds_send_drop_to() for clarity
    
    This function has been the source of numerous bugs; it's just
    too complicated. Simplified to nest spinlocks cleanly within
    the second loop body, and kick out early if there are no
    rms to drop.
    
    This will be a little slower because conn lock is grabbed for
    each entry instead of "caching" the lock across rms, but this
    should be entirely irrelevant to fastpath performance.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 7a7699a208de4bb5c4b2b6d207fa38f94a7614d9
Author: Tina Yang <tina.yang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu Apr 1 14:09:00 2010 -0700

    RDS: Fix corrupted rds_mrs
    
    On second look at this bug (OFED #2002), it seems that the
    collision is not with the retransmission queue (packet acked
    by the peer), but with the local send completion.  A theoretical
    sequence of events (from time t0 to t3) is thought to be as
    follows,
    
    Thread #1
    t0:
        sock_release
        rds_release
        rds_send_drop_to /* wait on send completion */
    t2:
        rds_rdma_drop_keys()   /* destroy & free all mrs */
    
    Thread #2
    t1:
        rds_ib_send_cq_comp_handler
        rds_ib_send_unmap_rm
        rds_message_unmapped   /* wake up #1 @ t0 */
    t3:
        rds_message_put
        rds_message_purge
        rds_mr_put   /* memory corruption detected */
    
    The problem with the rds_rdma_drop_keys() is it could
    remove a mr's refcount more than its due (i.e. repeatedly
    as long as it still remains in the tree (mr->r_refcount > 0)).
    Theoretically it should remove only one reference - reference
    by the tree.
    
            /* Release any MRs associated with this socket */
            while ((node = rb_first(&rs->rs_rdma_keys))) {
                    mr = container_of(node, struct rds_mr, r_rb_node);
                    if (mr->r_trans == rs->rs_transport)
                            mr->r_invalidate = 0;
                    rds_mr_put(mr);
            }
    
    I think the correct way of doing it is to remove the mr from
    the tree and rds_destroy_mr it first, then a rds_mr_put()
    to decrement its reference count by one.  Whichever thread
    holds the last reference will free the mr via rds_mr_put().
    
    Signed-off-by: Tina Yang <tina.yang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit bd824b27e7a44ff15a297ab375a5211fef8382d8
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 6 12:23:55 2010 +0300

    sdp: cpu affinity in sdpstats
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e8e93577d56f199cb31d3145dab05da4d16ecd02
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 1 17:04:59 2010 +0300

    sdp: use polling in rx
    
    poll on RX whenever possible, use interrupts only before sleeping,
    during graceful close or in zcopy.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d0f5a79834846b37d86f316844124ebf16ddbfbd
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 6 13:48:32 2010 +0300

    sdp: fix for a bug of lost refcnt in TCP_TIME_WAIT state.
    
    OFED addons break semantics of cancel_delayed_work_sync(), like in SLES 10.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2736caaba79ac27e3e99e1eef7c0609c57c74566
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 6 12:07:59 2010 +0300

    sdp: BUG2038 - transmission goal size won't exceed SDP_MAX_PAYLOAD
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 62d9286df8871081eee8f73759954790c64f4182
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jun 1 11:42:35 2010 +0300

    sdp: SDP_WARN_ON defined to be used instead of WARN_ON, for better compatibility
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------010906050701010108000309
Content-Type: text/csv;
 name="bugs-2010-06-25.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2010-06-25.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxOTY1LCJt
YWpvciIsIlAzIiwiUkhFTCA1IiwieWV2Z2VueXBAbWVsbGFub3guY28uaWwiLCJWRVJJRklF
RCIsIkZJWEVEIiwiQm9uZGluZyBtbHg0X2VuOiBwaW5nIGRvZXMgbm90IHJlc3VtZSBhZnRl
ciBmYWlsb3ZlciBiZXR3ZWVuIDEwRyBwb3J0cyIKMjAzOCwibWFqb3IiLCJQMyIsIkFsbCIs
ImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlJ1bm5pbmcgMyBp
bnN0YW5jZXMgb2YgdHRjcCBiZW5jaG1hcmsgb24gUFBDNjQgbWFjaGluZXMsIHJlc3VsdHMg
aW4gY2xpZW50IG1hY2hpbmUgaGFuZyIKMjA0MCwibWFqb3IiLCJQMyIsIkFsbCIsImFtaXJ2
QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlJ1bm5pbmcgMiBpbnN0YW5j
ZXMgb2YgdHRjcCBiZW5jaG1hcmsgb24gUFBDNjQgbWFjaGluZXMsIHJlc3VsdHMgaW4gY2xp
ZW50IG1hY2hpbmUgaGFuZyIKMjA0OSwiY3JpdGljYWwiLCJQMSIsIlJIRUwgNSIsImFybGlu
LnIuZGF2aXNAaW50ZWwuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk1QSSBhcHBsaWNhdGlv
bnMgdGhhdCB1c2UgZm9yaygpIGhhbmciCjIwNTQsImNyaXRpY2FsIiwiUDMiLCJSSEVMIDQi
LCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJDb21waWxhdGlvbiBv
ZiBPRkVEIDEuNS4yIHJjMSBmYWlsZWQgb24gUkg0IHVwIDciCjIwNTksImNyaXRpY2FsIiwi
UDMiLCJSSEVMIDUiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIs
IkNvbXBpbGF0aW9uIG9uIE9GRUQgMS41LjItcmMxIGZhaWxlZCBvbiBSSDUgdXA1IChBbGwg
cGFja2FnZXMpIg==
--------------010906050701010108000309--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
