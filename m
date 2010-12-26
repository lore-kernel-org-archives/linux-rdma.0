From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.3 rc1 is available
Date: Sun, 26 Dec 2010 10:16:14 +0200
Message-ID: <4D16F9CE.9020806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070107030003010408090004"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070107030003010408090004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.3-rc1 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.3/OFED-1.5.3-rc1.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.3

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
           - RedHat EL5 up4        2.6.18-164.el5
           - RedHat EL5 up5        2.6.18-194.el5
           - RedHat EL6            2.6.32-71.el6
           - SLES10 SP3            2.6.16.60-0.54-smp
           - SLES11                2.6.27.19-5-default
           - SLES11 SP1            2.6.32.12-0.7-default
           - Fedora Core12         2.6.31.5-127.fc12    *
           - OpenSuSE 11.2         2.6.31.5-0.1-default *
           - kernel.org            2.6.29 - 2.6.36    *

         * Minimal QA for these versions

Main changes from 1.5.2:
===========================
1. Updated packages:
    dapl-2.0.31.tar.gz
    librdmacm-1.0.14.tar.gz
    ibacm-1.0.4.tar.gz
    ibutils-1.5.6.tar.gz
    libmlx4-1.0-0.15.g4caebef.tar.gz
    libnes-1.1.1.tar.gz
    libsdp-1.1.106-0.5.gd48f6f9.tar.gz
    mstflint-1.4-0.8.gc569a81.tar.gz
    perftest-1.3.0-0.37.gc269d2d.tar.gz
    sdpnetstat-1.60-0.1.g4e0a557.tar.gz

    - MPI
      openmpi-1.4.3-1.src.rpm

2. Added RHEL6 support



--------------070107030003010408090004
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.3-rc1.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.3-rc1.txt"

commit 3435de1377aec61ac76e3a6883d3220beeef2c0f
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 22 14:48:26 2010 +0200

    mlx4_en: lro backports to newer kernels
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9c5f8c362faa341307358f2f2c9ad77d68a05658
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 22 13:33:37 2010 +0200

    Add 2.6.18-*chaos kernels support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c22b4e92823e6959d8d13dbb62f1cde339c426b9
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 21 19:20:11 2010 +0200

    Fix show abi_version on 2.6.3[56]
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 04bb801a31825d1559c4670253e1bea1291a1af8
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 21 13:38:37 2010 +0200

    sdp: move histogram allocation from stack to heap
    
    - Cause a kernel crash when accessing /proc/net/sdpstats on RH6
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 53285ee8153e6cfd1d26934d958907b3d7240eb2
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 21 14:27:06 2010 +0200

    sdp: print error value when ib_umem_get fails
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b10fc96289806ed0881c4793355f4b69ccc4ebc2
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 14:41:12 2010 +0200

    sdp: remove 'reading beyond SKB' warning
    
    This is a good sanity check, but could print a warning when a
    partially used SrcAvail skb is cancelled.
    This should be fixed in a way that will leave the sanity check,
    but need to make minimal changes before the GA.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 03ac18ea88803cfd40767c938fa3a288707c677e
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 21 10:16:52 2010 +0200

    mlx4_en: validating TCP header exists when selecting TX queue
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 80f69dae193f68207e4bcfecca7282dccb9b0426
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 20 14:37:07 2010 +0200

    mlx4_ib: change message from warning to debug
    
    mlx4_bf_alloc() will fail for all kernels not supporting write combining (e.g.
    kernels < 2.6.28) but QP creation will not fail. This causes multiple messages
    for SDP. Change this to debug.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9f51c8714374d0ae42cc872325398a58cab20007
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 19 14:46:07 2010 +0200

    memtrack: remove memtrack_0000_no_proc_owner.patch
    
    The code was updated in-place. So, no patch is required.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3817a18e2b7d4eb9b380789b2a9db4118968c653
Author: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun Dec 19 12:52:47 2010 +0200

    mlx4: bugfix: avoid vunmpa invalid pointer in allocation bad flow
    
    Signed-off-by: Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 733e948a5446292d20042facb291c32e7332f255
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 19 12:38:01 2010 +0200

    memtrack: do not hold module owner
    
    This mechaninsm is not required and removed by the kernel sources.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit de013f83f80aef9190427571052f9561dbe4f952
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 15 11:27:19 2010 +0200

    mlx4: checking copper_passive when reporting transceiver type
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit feba676a06b54d7ea712b2d5d5a8a26dcbc6037d
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 12:32:35 2010 +0200

    Fix backports after 3feadaf
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a2a0be961e4dc78a01213f3ff103738ac64d6b8f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 10:03:20 2010 +0200

    mlx4: move assignemnt before memory barrier
    
    Move assignement to ctrl->ins_vlan before the write memory barrier to ensure it
    is in place before setting the WQE valid.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4289bd20f7fe46229d49c3b62ac99c20e91c59af
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 09:13:39 2010 +0200

    mlx4: Fix memory leak
    
    Failed to free bf->uar when destroying a blue flame.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5595e4b37bec397865a5c2cb4f6c822c9461c4c9
Merge: e636743 e31c78c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 11:24:55 2010 +0200

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit e31c78ccaf2032ae90a90e4beea31dc7f9aed339
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 08:48:42 2010 +0200

    sdp: RdmaRdCompl not sent sometimes
    
    When SrcAvailCancel is handled after RDMA finshed and before sending
    RdmaRdCompl, RdmaRdCompl won't be sent, and a data corruption will occur.
    Made sure that all sdp_abort_rx_srcavail will send RdmaRdCompl if needed.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 51200a51181a43916b78d48dcf6e39dbf2960721
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 14 09:55:54 2010 +0200

    sdp: make sdp_prf index atomic
    
    Will make sdpprf more reliable - records won't override other records.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e6367438ab54233278929f5120143dfe3d79fec9
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 13 16:56:03 2010 +0200

    mlx4/ib: Fix WARNING: at lib/swiotlb.c:562
    
    mlx4_ib_free_cq_buf should not be called under spin_lock_irq
    as dma_free_coherent() needs irqs enabled
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 365d7f0bcf64bf4d8ebe5ef4e8389dec0c168d22
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Dec 9 17:02:05 2010 +0100

    RDMA/nes: a fix for problem of lack of HW limit checking for MG attach.
    
    Now a HW limits for multicast address attach ro RAW QP are checked.
     the error is returned when application wants attaching more than possible
    multicast groups.
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 2ef2faef1250e87a3b0d2f63a11f7d58d0978f09
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Dec 9 17:01:53 2010 +0100

    RDMA/nes: fix for a problem with non-aligned buffers crash during post_recv
    
    Now the physical adresses of buffers posted to HW is aligned properly
    when the packet content is on boundry of two different pages
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit b6706c20e19a72f496e71118ade1a7ca78654d0e
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Dec 9 17:01:39 2010 +0100

    RDMA/nes: fix for possible crash when RAW QP resources are destroyed
    
    Now there is no possibility to crash system when there is a try of release
    already released resources
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 249a6e354d56aa28b3e9b5fe5c871243fb63791c
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Dec 9 17:01:26 2010 +0100

    RDMA/nes: fix for problem of RAW QP transision state to ERR.
    
    The effect of going into ERR state is flushing all CQEs and return of
    FLUSH_ERR status for each posted entry in both RQ and SQ.
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 139a41e42c495cee8c2d31a2469318312efe830b
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Dec 9 17:01:19 2010 +0100

    RDMA/nes: fix a problem with sending packets with VLAN flag
    
    Now the VLAN tag is set in transmit wqe descriptor correctly.
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 2a7f4bc96f4faff601c80e525c8fdac635d35635
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 12 11:51:32 2010 +0200

    mlx4_en: add support for 2.6.3[56]
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5faa2af918bfe7b9f325051e4110b3cf8acb9add
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 8 16:36:45 2010 +0200

    mlx4_en: fixed query port backport for older kernels
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit da28478d55b72288f19e5cf6bf27aec7b338b70c
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 8 14:48:13 2010 +0200

    mlx4_en: fixed query port backport for RH5.3
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 39270800820cca3236d8587bbdd7934abef623ac
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 7 09:32:50 2010 +0200

    sdp: handle failed RDMA read
    
    When RDMA read is failed, do not report those bytes as read, and
    return error code to user.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit de99c039ae5fb6bfb665ec0ac144337ad83296e4
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 8 09:02:26 2010 +0200

    mlx4: change blue flame warning message
    
    Add details why blue flame in kernel is not supported and change the message
    from err to dbg.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit eae43b36abb011aba585ba2407e8becd8007f514
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 8 08:54:16 2010 +0200

    mlx4: change print from warning to debug
    
    The message that notifies the workaround on the number of blue flame registers.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 67725bf3958e9f069ebe15a205284d72f5e73013
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 7 16:14:46 2010 +0200

    mlx4_en: removed redundant print
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fdcb14a2489a51159ca021830c888f7971d9cebe
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 7 15:53:35 2010 +0200

    mlx4_en: backports for iowrite64_copy
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 07cdd851769fd8ecc0043155ab06c2ecd9ba9ec4
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 6 09:22:52 2010 +0200

    mlx4_en: Blue Flame support
    
    Using blue flame on supported systems, otherwise
    the transmission is done as before.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 14a364b371842ffd9a60f40a34219d97065a7c81
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 17 17:11:08 2010 +0200

    mlx4_en: Fixing vlan operations
    
    Performing FW command from Vid operations causes "scheduling while atomic"
    Executing the commands from the rescheduled task.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9fd9c0d0accb7e9328a8f0b5f219bbb6ed1c1566
Author: Sébastien Dugué <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Date:   Tue Dec 7 08:15:52 2010 +0200

    ofed_kernel/makefile: re-add the .PHONY target
    
    Signed-off-by: Sébastien Dugué <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

commit 3ec1ac0fe3d8643d32a30709241bf54e227d7792
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 6 17:43:01 2010 +0200

    mlx4_ib: Bug fix in post send
    
    If post send fails without handling successfuly a single WQE, we must not stamp
    or pad wraparound as variabales may be uninitialized.
    
    Found and fix proposed by Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8e4b5bfbd1be47b03e04a7373a45752c527c9ef3
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 5 12:46:37 2010 +0200

    ofed_kernel/makefile: Fix depmod command
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7924e813d8f32f0aedcca629f69fbfebfda6ffae
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 5 11:03:30 2010 +0200

    ofed_kernel/makefile: Keep all targets that are to be marked .PHONY in a variable, PHONY
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 67c67198fc63e7c2c613dafb1829e8b8ab81c9a2
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Dec 3 16:53:48 2010 +0100

    RDMA/nes: fix incorrect SFP link status detection on driver init
    
    During iw_nes initialization link status for SFP phy is always detected
    as "up" regardless of real state (cable either connected or disconnected).
    Add SFP phy specific link status detection to iw_nes initialization procedure.
    Use link status recheck for netdev_open to detect delayed state updates.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 8e671dceef774bf1d4387a50b564c8e78dea5683
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Dec 3 16:53:40 2010 +0100

    RDMA/nes: fix SFP link down detection issue with switch port disable
    
    In case of SFP phy link status check at interrupt processing
    happen to give false results. For proper link status change detection
    delayed recheck is needed to give nes registers time to settle.
    Add periodic link status recheck scheduled at interrupt
    to detect potential delayed registers state changes.
    
    This patch fixes openfabrics bugzilla #2117:
    http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2117
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 9dc1359ab44108eac32f6413ebd6fef6664361f4
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Dec 3 16:53:31 2010 +0100

    RDMA/nes: send IB_EVENT_PORT_ERR/PORT_ACTIVE event on link state interrupt
    
    Depending on link state change IB_EVENT_PORT_ERR or IB_EVENT_PORT_ACTIVE
    should be dispatched in processing of mac interrupt.
    Plug in the cable happen to result in series of interrupts
    changing driver's link state for a number of times before finally
    staying at link up (e.g. link up, link down, link up, link down, ..., link up).
    To prevent sending series of redundant IB_EVENT_PORT_ACTIVE
    and IB_EVENT_PORT_ERR events they get filtered out by timer based
    nes_port_ibevent() routine.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 206b1cfb64b69f666d9685eb89377b60d1939c3f
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Dec 3 16:53:24 2010 +0100

    RDMA/nes: enable bonds on iw_nes
    
    Enable configuring bonds on nes devices by adding
    missing support for master net_device to the driver
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit a847b049f4ee69f9b7373e2b75fc2930d96610c2
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 1 18:29:41 2010 +0200

    mlx4_core: Bug fix in blueflame
    
    Used wrong function for freeing WC area.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ceb9034577b12e795374a6f474568e4339e8fa0e
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 30 15:21:08 2010 +0200

    Disable blue flame for kernels without WC
    
    kernels older than 2.6.28 do not support WC so disable blue flame for them.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6e3bb2540f9d1e1ee3e2fee0805ecb006e5a1473
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 30 13:26:06 2010 +0200

    mlx4: Change blue flame to use new kenrel API
    
    As a result, blue flame will be used only in kernels that support this API,
    e.g. 2.6.28 and up.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fae4efc583f2241e53b35e6ad2bb431419cada3b
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 30 14:39:15 2010 +0200

    sdp: fixed bad 2.3.36 backport patch
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b5231ef475c4b2f0cbf8d3916e7ce9a9f7e66a98
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 30 08:48:33 2010 +0200

    sdp: Fix compilation error when SDP_DEBUG_DATA is off
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5f83d097fb3ed53db0e2989f658a689840d8e32c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 28 21:02:53 2010 +0200

    RHEL6: fix ib_uverbs_alloc_event_file porting
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cd68ad3a1e82fb86faf2af1dfe45f2ea59af8503
Author: Chas Williams <chas-vT06rRrALxcmhCb6mdbn6A@public.gmane.org>
Date:   Sun Nov 21 17:35:17 2010 +0200

    ofed/makefile: fix compilation over XEN
    
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2167
    When building for xen kernels, arch/x86/Makefile now modifies LINUXINCLUDE to
    preinclude an extra flag and directory
    
    Signed-off-by: Chas Williams <chas-vT06rRrALxcmhCb6mdbn6A@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ac94d532fb0589d2be11624483f8e904c804447a
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Wed Nov 17 12:27:43 2010 -0600

    cxgb3: Add 7.11 firmware.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 88c8fab6e3d29f45a38b65993b6762c8ec55fc97
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Wed Nov 17 12:24:22 2010 -0600

    cxgb3: pull in upstream bug fixes.
    
    Pull in these fixes:
    
    b1424ed91076db0b19ba4141856150df9b717dde cxgb3: Fix panic in free_tx_desc()
    69dcfc8aad24fa95ae0a0ad1405cf6847e3ec14a cxgb3: fix crash due to manipulating queues before registration
    18edc84cf15cbe114dcdf7e8612ee52586d0aad7 cxgb3: fix device opening error path
    49c37c0334a9b85d30ab3d6b5d1acb05ef2ef6de cxgb3: prevent reading uninitialized stack memory
    55bc3228ccef255041d697fe55dcc7fe4b37feb6 cxgb3: Avoid flush_workqueue() deadlock.
    aa476321022ac6c3cb8ebfd1736555ccf61da276 cxgb3: Leave interrupts for fatal errors asserted in common code.
    e05e6a397c65ac9a31ce799cf85157f2d85f45b7 cxgb3: Set FATALPERREN.
    96e4a387528cfe806fbdf7b022a6c3f103af4ae1 cxgb3: Add register bit definition for Fatal Parity Error.
    7aaaaa1e44b2a4047dfe05f304a5090eb995cf44 cxgb3: do not use PCI resources before pci_enable_device()
    e95ef5d3f6bc60433883e1ef65dac747acd0bf1a cxgb3: Wait longer for control packets on initialization
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 6d3e6da399c66c0895036aeea0e2d88acacdce5b
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 17 15:28:11 2010 +0200

    mlx4: Fix vlan insertion order
    
    We must update the control segment before marking it as valid.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6e61a0adc95498a01df3ff9eb98065775b451457
Merge: 41d73c8 d56b491
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 17 12:49:27 2010 +0200

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit d56b491d072f93bbe55d3eb027708bf8908486d0
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 17 11:03:03 2010 +0200

    sdp: Enable set zcopy threshold to 0 using setsockopt
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 41d73c800d98278cb332b135f73a6128298957a5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 16 11:09:28 2010 +0200

    ibdev2netdev: Improve speed and add more info
    
    Improve speed by not calcualting information if not required by the options.
    Add more info to the device.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c0e8970a593d45d7973bd8703e82936aa2cb48e7
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 16 13:32:14 2010 +0200

    sdp: BUG2161 - hanging sockets are left
    
    When getting DREQ at TCP_CLOSE_WAIT state, CMA ref count is taken
    and not returned. This happens because CMA timer is not started.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d9afb110f6f5cd209906621112ed5d339e148ae3
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 15 09:15:53 2010 +0200

    Add -v option to ibdev2netdev
    
    It is more convenient to see handy information in a single line rather than the
    long list provided by ibdev2netdev.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1ad12c4a00cd2ea6dde31aa13b0097685c155317
Merge: 6e3b7a6 3cf1e37
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 14 16:05:14 2010 +0200

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 6e3b7a6e966b24af02f105b990504c79d344721f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 14 15:03:33 2010 +0200

    mthca: Fix QP creation
    
    Allow a consumer to request creation of a QP with max inline also for kernel
    consumers. Since inline is not supported in kernel, return 0 in
    max_inline_data, as is done for mlx4.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3cf1e37a9f53fcb44acccedd7362ff8b4e86ef40
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 14 14:57:15 2010 +0200

    sdp: Take into account HW inline capabilities
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7be75726be68c29abc8f7fbf70002fad5625cdda
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 11 15:33:20 2010 +0200

    mlx4: Fix IBoE link state
    
    Make use of netif_carrier_ok() instead of netif_running() which is more
    appropriate to report link state.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 06c3b6afe2f6fcc95b0c7d4c7a0210aa93c146dd
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Mon Nov 8 14:06:55 2010 +0200

    openibd: Fix Openfabrics Bugzilla URL.
    
    url should be: http://bugs.openfabrics.org, not https.
    
    Fixes Bugzilla 2166, but for OFED 1.5.2....
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit d477ac405deca4ee3e12d3dc67f3cf07178fb2c5
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 10 11:26:00 2010 +0200

    openibd: Update script header
    
    Add required lines to the header in order to support insserv and chkconfig
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 66010ff76a8aedf54d44e3ead5b49d5cb005b725
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 8 13:49:12 2010 +0200

    sdp: Send small sends using inline
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2509af2fade8cb8a69c0565bd004be1f5e271f8b
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 9 17:42:13 2010 +0200

    mlx4: bug fix in query dev cap
    
    Returns log bf per page as natural number instead of a log2. This commit is a
    workaround until firmware is fixed.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2666332ec7ca79d3959194b1fff95fe4cc937a3d
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 8 09:55:28 2010 +0200

    Add 2.6.36 support
    
    TBD: Add CXGB3/NES/QIB
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bc64de826da47fc03665fc1bab129fad8e9bc7f2
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 8 17:10:41 2010 +0200

    mlx4: bug fix in kernel blue flame
    
    1. bug in calcualting idx
    2. wanted to do shift but used single '<'
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a612d33b1606182d1f96112e8c65cf59f04986a9
Author: Eli Cohen <eli@eli-u10.(none)>
Date:   Mon Nov 8 12:02:10 2010 +0200

    mlx4_core: reserve UARs for userspace consumers
    
    Do not allow a kernel consumer to allocate a UAR to serve for blue flame if the
    number of available UARs gets below MLX4_NUM_RESERVED_UARS (currently 8). This
    will allow userspace apps to open a device file and run things like
    ibv_devinfo.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f0a5b7e34b862b3fe0842120bf84f95fd4e74f8b
Author: Eli Cohen <eli@eli-u10.(none)>
Date:   Mon Nov 8 12:01:54 2010 +0200

    mlx4_core: maintain available field in bitmap allocator
    
    Add mlx4_bitmap_avail() to give the number of available resources. We want to
    use this as a hint to whether to allocate a resources or not. This patch is
    introduced to be used with allocation blue flame registers.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f7f717a0e11dc6de4bd570352ed73ba6cfd4ac53
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 7 10:03:26 2010 +0200

    Add 2.6.35 kernel support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b778ca0204054dc54dafbacc745ef04b3c173cbe
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 4 15:57:32 2010 +0200

    mlx4: more backports need to export
    
    mlx4_disable_wc and mlx4_enable_wc
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 19109602b1d295bff334a9e8b7a954948261b640
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 3 15:47:01 2010 +0200

    sdp: access socket history from debugfs
    
    Also moved sdpprf to /sys/kernel/debug/sdp - seems to be a better place
    than /proc/net
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a254a7982ba9b80d8e7ffb4d72a793d018796736
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 4 10:08:41 2010 +0200

    sdp: fix compliation warnings
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3fce360cbc94a6f1795fb00e9e68ceab024d8d62
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 2 12:43:21 2010 +0200

    sdp: use a macro to convert ssk into sk
    
    Instead of accessing &ssk->isk.sk cast the sdp socket into
    sock. Do it from a macro sk_ssk(ssk)
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 232aa5e290907b9beb6bd1b9b8faa859341ec0c5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 4 11:24:07 2010 +0200

    mlx4: fix failure to export two functions
    
    mlx4_disable_wc and mlx4_enable_wc
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1ebe2495cb961637bfc09767754efe845ab8828f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 3 11:45:28 2010 +0200

    IPoIB: Fix IPoIB to conform to ethtool definitions
    
    Ethtool documentation states that when once of the parameters,
    rx_coalesce_usecs or rx_max_coalesced_frames are set to zero while the other
    has a none zero value, the none zero parameter should still be operative. For
    example, if rx_max_coalesced_frames is set to zero while rx_coalesce_usecs is >
    0, the rate of events is limited to not exceed (1 / rx_coalesce_usecs). In the
    opposite case, an event is generated only after rx_max_coalesced_frames have
    arrived. The documentation also states that setting both to zero is invalid.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8de190ea8b16af91d213abaa28326cf5fa2918db
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 3 10:44:04 2010 +0200

    Revert "mlx4: fix modify CQ"
    
    This reverts commit 8f44cc036578cef48be7527ed2a7455c228d2121.
    
    It appears that this commits hurts performance on SDP and mlx4_en. A followup
    commit will add this functionality in IPoIB.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 38359a48d672f944f05215d0fb47989fdb39e1fe
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Oct 28 17:47:15 2010 +0200

    mlx4: Add kernel blue flame support
    
    This patch adds both inline and blue flame support. The usage scheme is similat
    to what we have abvailable in userspace: when you create a QP that requires
    inline support, we allow also blue flame support. When you post a send request
    which specifiies inline, and if the message is small enough to fit in a blue
    flame register, it will be send using blue flame.
    
    When QPs requiring inlne are allocaed, we allocate a blue flame register and
    thus a UAR. The QP doorbells are now posted to this UAR instead of the kernel
    globla UAR.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 31b40644212073a4fc39c56c2ef67e093bb9619c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 2 15:29:44 2010 +0200

    ofed/configure: Do not exit on unsupported parameters
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e4367ed509c59a9d4a8d144609bfeef1839c38fb
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 2 15:28:10 2010 +0200

    ofed/makefile: Remove extra include of autoconf.h
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5ba169735c673f0a81696b21747a27f3832681bc
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 31 11:55:25 2010 +0200

    ofa_kernel.spec: Fix depmod command
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1880a0bd378cca9a343cd42cd536e25e962df1e5
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Oct 28 12:04:05 2010 +0200

    OFED/configure: Fix autoconf.h
    
    Kernel configuration should not affect OFED's compilation parameters.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3533dad325fce30368619cd82514665de53a1e7d
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Oct 27 15:56:23 2010 +0200

    sdp: Initialize remote credits when sending Hello
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 13131ca4d4f40b6b3d20625f613a9b272876f954
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Oct 27 14:24:07 2010 +0200

    sdp: BUG2158 - do not send SrcAvail too small
    
    - Shouldn't send SrcAvail with no RDMA payload - could happen when RLIMIT is
      too small.
    
    - Do not crash when getting 2 SrcAvail.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6cf09e2cac2b527baf139d3a412da92877aa1087
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 25 15:02:43 2010 +0200

    sdp: add a sanity check for sg_len
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0f11307effe49dfa32ae0ff0a4ae98d36d6aec7a
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 17:15:06 2010 +0200

    sdp: fix socket_allocated counter
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit db26f49b585f732d36f48fda00b6b63df5ab49eb
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 11:24:27 2010 +0200

    sdp: no point of waiting for data if remote host can't send
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3f6ddbd05c16155e496141f6bf017c8da402034c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 11:19:24 2010 +0200

    sdp: fix support for a case of no locking capabilities
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5c38964ef442709e949bd12fdce95cf745ee7f2e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 11:16:56 2010 +0200

    sdp: if can not allocate memory - no point of waiting
    
    We don't wake up sleeper when we free memory, so mem sleeper will sleep forever.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8c24341df36d723df49d221b000711db487e19ff
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 10:50:08 2010 +0200

    sdp: cosmetics
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ec74f9d04ab9f65345ea38565c7a25b2a39b6783
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Oct 20 17:14:35 2010 +0200

    sdp: fix for CMA reference count
    
    When sdp_destroy_work() is invoked (due to the cma handler),
    but "ssk->cma_timewait_timeout == 0", a socket reference was putted even though
    it was never taken. This can happen in 2 scenarios:
    1. sdp_destroy_work() locked the socket before sdp_close()
    2. sdp_destroy_work() locked the socket after sdp_cma_timewait_timeout_work()
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bf140781f37e1725bfb4f2864413410be7995fee
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Oct 20 17:08:53 2010 +0200

    sdp: add ability to set a maximum memory usage for the entire module
    
    use top_mem_usage module parameter for this.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 02c2faa180b436488b638b20f3cda15bf131b7ba
Author: Jay Lan <jlan-sJ/iWh9BUns@public.gmane.org>
Date:   Wed Oct 27 11:33:21 2010 +0200

    openibd: security fix
    
    The openibd startup script from the OFED rpm includes the following code to
    create a script that it runs in the background:
    
    ...
    cat << EOF >> /tmp/ib_set_node_desc.sh
    ...
    EOF
    
       chmod 755 /tmp/ib_set_node_desc.sh
       /tmp/ib_set_node_desc.sh > /dev/null 2>&1 &
    
    The problems with this startup script are many, but the security issue is that
    the script, while running as root during system startup, writes to a
    predictable file name in /tmp (/tmp/ib_set_node_desc.sh).  If a user creates a
    symlink with that path ahead of time, the next reboot can clobber any file root
    has access to.
    
    There are several fixes, but one is to avoid the use of the temporary file
    altogether.
    
    Signed-off-by: Jay Lan <jlan-sJ/iWh9BUns@public.gmane.org>

commit 912a0972e24b42343e12ef291f33f2e9d9c8ec6a
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 26 14:12:33 2010 +0200

    mlx4_ib: limit GID entries for VLAN
    
    The hardware uses two entries so we have only 126 GIDs for VLAN. Use proper equ
    definition to use the proper number of VLANs.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8db3e2ee46cb1f9c4d3f1192ef7ace434d46b9fe
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 25 18:38:15 2010 +0200

    ib core: fix bug in ib_ud_header_init
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c887424fdddccf64accf449be726b46e7bcdbf54
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 25 16:41:04 2010 +0200

    mlx4_en: Fix out of band array access
    
    When searching for a free entry in either mlx4_register_vlan() or
    mlx4_register_mac(), and there is no free entry, the loop terminates without
    updating the local variable free thus causing out of array bounds access. Fix
    this by adding a proper check outside the loop.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f547cbfff342b68d2c9c6a34cedddedce1912572
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 17:03:49 2010 +0200

    sdp: Accept AF_INET_SDP in address supplied to connect()
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d16327ef60cd6bc4e3c34bbb6815d46d4edb7f81
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 13:32:54 2010 +0200

    mlx4: Fix unneeded return error in eth_link_query_port
    
    eth_link_query_port() returns error if a netdevice was not yet associated with
    the IBoE port. This is not required since we already initialize the link as
    down.  On the other hand, we need other information that the query provides.
    Specifically, this can cause a failure to initilize an IBoE device after this
    commit 5eb620c8, which calls ib_query_port().
    Fix this by always returning success.
    
    Note: commit 5eb620c8 is not yet in ofed, yet this fix is still valid.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 32cba836b5b48d8aeb89f5f5a8863bc67853a04b
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 24 12:33:34 2010 +0200

    mlx4: fix port speed in iboe
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f097078917c91ed9ffd85faf4ceb12f303f4a5ed
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 18 10:48:16 2010 +0200

    sdp: fix RDMA read completion with error
    
    - set socket to error state for all wr_id's
    - no need in sdp_handle_send_comp()
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4b3f3cb221a7cd5b36acafa7e4f0bc625305bbda
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 18 14:20:12 2010 +0200

    sdp: sdp_post_rdma_read() should clean up its mess
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 78cb4ae700881a6f5fd8f6a600a1ec71f0421701
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 19 16:49:53 2010 +0200

    sdp: fix compilation error when compiling without debug flags
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit aa057096b765df3aae8c3b5d961daadfadc433b5
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 19 17:26:34 2010 +0200

    sdp: treat unfinished RDMA operation as a fatal error
    
    mark socket with EIO error code.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0ea502b3072619ca8ae72d8b803ceca88838f050
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 19 16:52:09 2010 +0200

    sdp: fix for race condition with SrcAvailCancel handling
    
    Tx complition resets "rdma_inflight->busy" and wakes up the recvmsg().
    But rx_workqueue might get the lock of the socket before recvmsg(), so
    SrcAvailCancel might be polled from the rx_cq, and since "busy = 0",
    rx_sa wil be freed (w/o freeing umem&fmr).
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cf920e2fd495121c87ba15a42c1a8cfa1ae18867
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 19:48:38 2010 +0200

    sdp: call ib_umem_get with the right access
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit eb18b8919fdb58bb42b1e27dfb77146115df3841
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 19:45:43 2010 +0200

    sdp: Improve the look of packet dump
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 32d69f6bc475b1cc398dbc62e724fc4498b92ab6
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 19:44:06 2010 +0200

    sdp: cosmetics, debug messages, error codes
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 43208d82d50bbc2d3741b12f609d179927542e7e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 19:26:01 2010 +0200

    sdp: SrcAvailCancel should not be processed during RDMA read
    
    fmr should be freed only after tx completion, regardless if SrcAvailCancel arrived.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ba56150f45916b2afe224e39c68975f6f4b7761c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 12:57:38 2010 +0200

    sdp: BUG2082 - fix orphan counter reading
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4156e46f159ff8512cf6e398bf0b39ff3f2b96f6
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 14:55:18 2010 +0200

    IB/cm: Check LAP state before sending an MRA
    
    The following patch was integrated from the upstream:
    
    commit 50a025c69ee749d822c301f9bf63dee13c113680
    Author: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Date:   Wed Jul 21 23:36:52 2010 +0000
    
        IB/cm: Check LAP state before sending an MRA
    
        NULL pointer dereferences in ib_cm_init_qp_attr() were seen by some
        users.  From a crash dump, I determined that we died in
        cm_init_qp_rts_attr() (it's inlined, so it doesn't show up in the
        traceback) on the line labeled below:
    
        static int cm_init_qp_rts_attr(struct cm_id_private *cm_id_priv,
                                       struct ib_qp_attr *qp_attr,
                                       int *qp_attr_mask)
        {
                ........
                if (cm_id_priv->id.lap_state == IB_CM_LAP_UNINIT) {
                        .....
                } else {
                       *qp_attr_mask = IB_QP_ALT_PATH | IB_QP_PATH_MIG_STATE;
                       qp_attr->alt_port_num = cm_id_priv->alt_av.port->port_num; <-die
    
        The problem is that the rdma_cm can call ib_send_cm_mra() after a
        connection has been established.  The ib_cm incorrectly assumes that
        the MRA is in response to a LAP (load alternate path) message, even
        though no LAP message has been received.  The ib_cm needs to check the
        lap_state before sending an MRA if the cm_id state is established.
    
        Reported-by: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
        Reported-by: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
        Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
        Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 96e14c6ccbee120ee5ba5b2e67a4e4b6280f8b27
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 17 14:53:49 2010 +0200

    Renamed cm patch to enable addition for more patches
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d2e736d73e09e1faf85eece0e6636b4a6f957e47
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Oct 14 09:03:01 2010 +0200

    mlx4: vendor ID handling by FW
    
    Forward any vendor ID MADs to firmware for handling.
    Also change the name of the patch to better reflect what it does.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ec99933a7cc3d71d91e78f789ddd047f5bc6e77e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 12 16:06:37 2010 +0200

    sdp: when aborting SrcAvail, should check if it wasn't aborted already
    
    Check is relevant only after sleeping.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a7297eddeeb3a1eed00b32e0f2bfc89ea6bc336f
Merge: 6665336 7597aac
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 12 11:00:34 2010 +0200

    Merge remote branch 'eldad/ofed_kernel_1_5' into ofed_kernel_1_5

commit 7597aac93b611123f84624ba1ed73f81c1dc6475
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 12 10:22:05 2010 +0200

    sdp: ZCopy doesn't support multithreading - warning & kernel panic protection
    
    Correspond to BUG 2147.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6665336ace5b3a5bd07ba4801b8d2252bd400661
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 10 11:10:38 2010 +0200

    sdp: Enable RoCE by default
    
    Could led to long delays when trying to establish connection to ethernet
    peer, and libsdp is set to 'both'. Should be fixed by letting user set
    both/sdp/tcp per interface and not only by subnet/port/process in libsdp.conf.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6817121b2c6ebbb3019cbe8593c4c8c0b3741a61
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 11 17:50:59 2010 +0200

    sdp: SrcAvailCancel should be processed even if SrcAvail was partly processed
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 773bb8f5b6b2484e8ee3fb8de47d6f9c67f6cf5c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 10 11:50:12 2010 +0200

    sdp: BUG2144 - first free rx_sa before sending SendSM
    
    otherwise a new rx_sa might be alloced before the old one is removed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bf40ca417a7e618c8a865351e13e7abe7bc8f883
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 10 11:47:06 2010 +0200

    sdp: fix code readability
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 641badb38034931c86e0f62dd4b1e85aa9735ab1
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Oct 6 11:52:10 2010 +0200

    sdp: BUG2141 - fix refcnt bug
    
    This bug is reproducable when sdpnetstat(1) is run while a socket is being
    destructed. sdp_proc utilities might try to hold a refcnt for a socket that its
    destruction already began. This is possible because sdp_proc utilities uses
    sock_list to scan for sockets, but a socket is removed from that list only
    after all its resourcs are freed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 15b2f28c268eb24c575bec36c0a614ad346f96d9
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Oct 6 09:47:27 2010 +0200

    sdp: refcnt debug tool
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 94bf0bf85635a0bffc8f389d17e6eb3d63382f82
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 5 13:53:34 2010 +0200

    sdp: cosmetics & add/remove warning messages
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f42563b6b2cb31ad1db2e9d459036bd0f60dae77
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 3 11:58:06 2010 +0200

    sdp: extend socket locking scope in dreq timeout function
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f93e33d2e2e0d0d2d776b23ac0de83b50d0cdb6b
Merge: c124196 8f7b426
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 11 10:47:26 2010 +0200

    Merge remote branch 'eli/ofed_kernel_1_5' into ofed_kernel_1_5

commit 8f7b4260bda77fdcf7e336d2b7e3bf2382532968
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 10 17:26:26 2010 +0200

    IB/mlx4: Check correct variable for allocation failure
    
    The intent here is to check the "mfrpl->mapped_page_list" allocation.  We
    checked "mfrpl->ibfrpl.page_list" earlier.
    
    Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0b1d72509f5b41b5ab1f636f8d3e8cba3f8d4f90
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 10 16:12:42 2010 +0200

    mlx4: Add roce counters to those of mlx4_en
    
    This patch adds the conribution of iboe traffic to the mlx4_en counters. This
    way we can see the overall traffic when running ethtool or ifconfig.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c1241961a3f784f124be9555042c5d784feee452
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Oct 10 11:15:02 2010 +0200

    Add 2.6.34 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6a5cdd2ba1f221f6cf0e4bf755dd2b68c50e6f1f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Oct 7 16:07:12 2010 +0200

    mlx4: Limit num of fast reg WRs
    
    Fix the limit of max fast regisreation WRs that can be posted to CX to match
    hardware capabilities.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8f44cc036578cef48be7527ed2a7455c228d2121
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Oct 7 15:41:48 2010 +0200

    mlx4: fix modify CQ
    
    The current implementation will disable the CQ moderation feature if any of the
    values count or usces is zero. This patch work arounds this by putting the MAX
    possible value of 0xffff if the a paramter that is specified as 0, if the other
    is none zero.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1ad60080ca8d9a4e66ad96dddde4f19d2521b6e9
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 5 11:11:58 2010 +0200

    Add support for RHEL6 Beta (Santiago)
    
    Version     : 5.90Server
    Release     : 6.0.0.32.el6
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5243140a63aa6ea66cd36cc9e9e359fd35fde0ce
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 28 13:39:02 2010 +0200

    sdp: sdp_poll() should not excessively poll rx_cq
    
    sdp_poll() might be called before send(), and if there is no data in rx_cq,
    polling rx_cq will waste 700 usec (recv_poll).
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit afc8297d3dee18253972d9ae827b29aba0759614
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 28 13:32:38 2010 +0200

    sdp: postpone rx timer when arming rx_cq
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit aab4e0624b20a549719d3b4f31f4739a26e11227
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 28 13:28:50 2010 +0200

    sdp: fix for timestamping values in debug messages
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ddbc436e76a2de27ce83d1c8fbbb9d2ca6e9cf85
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 28 12:21:58 2010 +0200

    sdp: better sequence-number handling and cosmetic updates
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 39d45baa06ed08c0d7ced229bd490b971183ef51
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Sep 27 10:45:29 2010 +0200

    sdp: add some checking & protection for enum values in debug utilities
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a88423e194b9c48545c1859b0c229d37eabad026
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Mon Sep 27 17:40:26 2010 +0200

    mlx4: propagate node_description changes down to FW.
    
    The Node Description cannot be changed via MADs (it is read-only).
    Until now, it was changed in the driver, and the new Node Description
    was simply overwritten by the driver on MAD responses.
    
    The node description was modified in the driver by openibd via sysfs.
    However, that generated a race condition, where OpenSM could get the
    FW node description rather than the overwritten description if OpenSM
    queried the device before openibd had a chance to enter the new description.
    
    The solution is a new FW command (SET_NODE) which allows passing the
    new node description to FW. When this command is invoked, FW issues
    a 144 trap to OpenSM.  Upon receiving this trap, OpenSM initiates a
    heavy sweep, thus updating the node description properly -- and eliminating
    the race.
    
    This patch works whether or not the new FW command is available.  If SET_NODE
    is not available, things work as before.
    
    Fixes FM82320
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 5be6b4462412a6ae2685b0513f1e1e6795c017e9
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 21 19:21:50 2010 +0200

    sdp: BUG2138 - 32bit hosts can't devide 64bit variables
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------070107030003010408090004
Content-Type: text/csv;
 name="bugs-2010-12-26.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2010-12-26.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9kZXNjIgoyMDMxLCJtYWpvciIs
IlAzIiwiQWxsIiwiZWxkYWR6QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIs
Iktlcm5lbCBidWcgYXQgc29mdGlycSBkdXJpbmcga2lsbGVkIHBvbHlncmFwaCB0ZXN0Igoy
MDgyLCJtYWpvciIsIlAxIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNP
TFZFRCIsIkZJWEVEIiwiU0RQIG1vZHVsZSB1bmxvYWRzIHdpdGggb3JwaGFuIGNvdW50IG1l
c3NhZ2UiCjIwOTIsIm1ham9yIiwiUDEiLCJPdGhlciIsImFtaXJ2QG1lbGxhbm94LmNvLmls
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIktlcm5lbCBQYW5pYyB1bmRlciBsb25nIHJ1biBpcGVy
ZiBzdHJlc3MiCjIxMTIsIm1ham9yIiwiUDEiLCJTTEVTIDExIiwiYW1pcnZAbWVsbGFub3gu
Y28uaWwiLCJSRVNPTFZFRCIsIklOVkFMSUQiLCJTRFAgY2Fubm90IGVzdGFibGlzaCBhIGNv
bm5lY3Rpb24gd2l0aCBSb0NFIgoyMTE5LCJub3JtYWwiLCJQNCIsIlNMRVMgMTAiLCJhbWly
dkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJzZWxlY3RfdGVzdCBjYXVz
ZXMgc2VydmVyIHRvIGhhbmcgKG91dCBvZiBtZW1vcnkpIgoyMTI3LCJtYWpvciIsIlAxIiwi
UkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiU0RQ
IGluIEJYT0ZFRC4gS2VybmVsIFBhbmljIGR1cmluZyBuZXR3b3JrIHN0cmVzcyBvbiBib3Ro
IHBvcnRzIgoyMTMwLCJub3JtYWwiLCJQNCIsIlNMRVMgMTEiLCJhbWlydkBtZWxsYW5veC5j
by5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJsaWJzZHAuc28gaXMgbm90IGxpbmtlZCB0byBs
aWJzZHAuc28uMSIKMjEzMSwiY3JpdGljYWwiLCJQMSIsIk90aGVyIiwic3dpc2VAb3Blbmdy
aWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk5QNjQgZ2F0aGVyIHJ1bnMg
c3RhbGwiCjIxMzIsImNyaXRpY2FsIiwiUDIiLCJPdGhlciIsInN3aXNlQG9wZW5ncmlkY29t
cHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJMYXJnZSBpV0FSUCBNUEkgY2x1c3Rl
cnMgbmVlZCB1Y21hIG1heCBiYWNrbG9nIHNldCB0byAxMDI0IgoyMTM4LCJub3JtYWwiLCJQ
MyIsIlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIs
InVua25vd24gc3ltYm9sIG9uIFJINS41IDMyIGJpdCAtIGRyaXZlciBjYW4ndCBsb2FkIgoy
MTM5LCJtYWpvciIsIlAxIiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09M
VkVEIiwiRklYRUQiLCJLZXJuZWwgUGFuaWMgaW4gT0VMNS41IGR1cmluZyBTRFAgc3RyZXNz
IG9uIGJvdGggcG9ydHMiCjIxNDIsIm1ham9yIiwiUDUiLCJDZW50T1MgNSIsImphY2ttQG1l
bGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsImliX3NlbmRfYncgZG9lc24ndCBz
ZW5kL3JlY2VpdmVkIHRyYWZmaWMiCjIxNDUsIm5vcm1hbCIsIlA1IiwiQWxsIiwiYW1pcnZA
bWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiU2VjdWlydHkgdGhyZWF0IGlu
IGxpYnNkcCIKMjE0NiwiY3JpdGljYWwiLCJQNSIsIlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlNEUCBsYXRlbmN5IGRlZ3JhZGF0aW9uIGZy
b20gT0ZFRDEuNS4yIHJjMyB0byBPRkVEIEdBIgoyMTQ4LCJub3JtYWwiLCJQMyIsIlNMRVMg
MTEiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiSU5WQUxJRCIsIkNhbGwg
VHJhY2UgcHJpbnRlZCB3aGVuIHNzaCB2aWEgU0RQIgoyMTUwLCJtYWpvciIsIlAzIiwiU0xF
UyAxMSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk5ldHBl
cmYgc3R1Y2sgd2l0aCBjYWxsIHRyYWNlIG9uIFNEUCBvdmVyIFJvQ0UiCjIxNjIsIm5vcm1h
bCIsIlA1IiwiQWxsIiwiamFja21AbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVE
IiwiZHJpdmVyIHJlcG9ydHMgd3JvbmcgcmF0ZSB3aXRoIENvbm5lY3RYMiBFTiIKMjE2Nywi
YmxvY2tlciIsIlA1IiwiT3RoZXIiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQi
LCJGSVhFRCIsIlNMRVMxMVNQMSdzIHhlbiA0LjAgcmVxdWlyZXMgbmV3IGJ1aWxkIGRpcmVj
dGl2ZXMgaW4gTElOVVhJTkNMVURFIgoyMTcyLCJtaW5vciIsIlA1IiwiQWxsIiwiaWRvc0Bk
ZXYubWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiaWJfcmVhZF9idyBkb2Vz
IG5vdCB3b3JrIHdpdGggTGVnYWN5IEhDQXMiCjIxNzQsIm5vcm1hbCIsIlA0IiwiT3RoZXIi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiSU5WQUxJRCIsInNkcG5ldHN0
YXQgaW4gbG9vcCB3aGlsZSBydW5uaW5nIHN0cmVzcyB0ZXN0IGxlYXZlcyBzb2NrZXRzIGhh
bmdlZCIKMjE3NSwiY3JpdGljYWwiLCJQNSIsIk90aGVyIiwidmxhZEBtZWxsYW5veC5jby5p
bCIsIlJFU09MVkVEIiwiRklYRUQiLCJDb21waWxhdGlvbiBvZiBkYWlseSBPRkVEMS41LjMg
KDMwLTExLTIwMTApIG9uIFJINiBmYWlscyBkdWUgdG8gbWlzc2luZyBzeXN5c2ZzdXRpbHMt
ZGV2ZWxzZnN1dGlscy1kZXZlbCIKMjE3OCwibWFqb3IiLCJQNSIsIlJIRUwgNSIsInN3aXNl
QG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiSU5WQUxJRCIsIltPRkVELTEu
NS4zLTIwMTAxMjAyLTA2MDBdIDpTZXJ2ZXIgUnggQ291bnRlciBpbiAnbmV0c3RhdCAtaScg
aXMgbm90IGluY3JlbWVudGluZyBmb3Igb25lIHBvcnQgd2hpbGUgcnVubmluZyBpb3pvbmUg
dXNpbmcgTkZTb1JETUEgb24gYm90aCBwb3J0cy4iCjIxODEsIm1pbm9yIiwiUDUiLCJBbGwi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJCb2d1cyBmb3Bl
biBjYWxscyBpbiBzZHBuZXRzdGF0LTEuNjAiCjIxODgsImNyaXRpY2FsIiwiUDUiLCJBbGwi
LCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJ0aHJlc2hvbGRz
X3Rlc3Qgb3ZlciBSb0NFIGNhdXNlcyBzZXJ2ZXIgdG8gaGFuZyI=
--------------070107030003010408090004--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
