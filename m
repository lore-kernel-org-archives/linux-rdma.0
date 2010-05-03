From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 beta1 is available
Date: Mon, 03 May 2010 10:35:21 +0300
Message-ID: <4BDE7CB9.8020801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050205020508050105060300"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050205020508050105060300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OFED 1.5.2-beta1 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-beta1.tgz

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

Main changes from 1.5.1:
===========================
1. Updated packages:
    - Management
      Using latest daily builds from http://www.openfabrics.org/downloads/management/daily
    - Updated libnes
      libnes-1.0.1-0.1.g89ea0ee.tar.gz
    - Updated libsdp
      libsdp-1.1.101-0.3.gc767eee.tar.gz
    - Updated perftest
      perftest-1.2.4-0.15.g82b7e29.tar.gz
    - Updated mpitests
      mpitests-3.2-923.src.rpm
2. Added RHEL5.5 support
3. Use files under /etc/modprobe.d/ instead of /etc/modprobe.conf
4. Bug fixes







--------------050205020508050105060300
Content-Type: text/plain;
 name="ofed_kernel-1.5.1_1.5.2-beta1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.1_1.5.2-beta1.log"

commit 8986850c7198bf32fc3d87884c72875a272fdb5e
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 2 15:08:03 2010 +0300

    mlx4_en.conf: load mlx4_en when mlx4_core is loaded
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b03fe7f8623c2c4d9a716f90a848ab679d6b10a2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 2 10:33:58 2010 +0300

    ofa_kernel.spec: Stop using depecated /etc/modprobe.conf
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ac488f9096cd4d146f5a99fba48c17f9d4235239
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 29 15:14:49 2010 +0300

    mlx4: Fix layout of QPC.AH
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3aab0ebcfd1bb676b754cf9ca69a9b2609dd847e
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 29 14:36:39 2010 +0300

    rdma_cm: Add default translation from ToS to SL
    
    Add a default translation from for ToS to SL for rdma_cm over RoCE. The default
    translation is dictated by the value of the module paramter, def_prec2sl. Any
    value of ToS will be translated to this value. In the future we will add a more
    generic translation table.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 489dfc902a7b1e8f60ad996fec00113642301225
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Wed Apr 28 16:12:30 2010 -0700

    IB/qib: more fixes for OFED 1.5.2
    
    More serdes tuning changes for interop.
    Fix a MR reference count bug with UC RDMA writes with immediate.
    Fix a deadlock race when registering more than one device with DCA.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 1270cdb8ed5f16079a2cdf83a73bc6e5df9c9333
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Apr 28 16:38:07 2010 +0300

    RDMA/ucma: Add option to manually set IB path
    
    Export rdma_set_ib_paths to user space to allow applications to
    manually set the IB path used for connections.  This allows
    alternative ways for a user space application or library to obtain
    path record information, including retrieving path information
    from cached data, avoiding direct interaction with the IB SA.
    The IB SA is a single, centralized entity that can limit scaling
    on large clusters running MPI applications.
    
    Future changes to the rdma cm can expand on this framework to
    support the full range of features allowed by the IB CM, such as
    separate forward and reverse paths and APM.
    
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e0ed697e60968670d4badfb1c8aa9125065d1823
Merge: e59e4bc 7b1e558
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 27 10:03:13 2010 +0300

    Merge branch 'ofed_kernel_1_5' of git://sofa.openfabrics.org/~ctung/ofed-1.5 into ofed_kernel_1_5

commit e59e4bc5fe76a5a8d9bdfa9407746d5227873bd9
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Mon Apr 26 10:58:37 2010 -0700

    IB/qib: fix qib backport to RHEL 5.5
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 30f0b496eefe781cb098ddfc774ff35b99217042
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Apr 26 14:53:23 2010 +0300

    sdp: fix a leak when ib_post_xxx fail + small fixes
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e3bf1a8d2da1759611f985493e79c61a0311e5d2
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Apr 26 10:48:48 2010 +0300

    sdp: on device removal, ref count taken so that socket won't be destructed
    
    On device removal, socket resources that are based on device are destroyed,
    but the socket itself will be destroyed later, upon user request.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 93bc358d9895e27474c35527188165a4d1188ca5
Merge: 8c94349 6c80f9c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Apr 25 16:13:44 2010 +0300

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 6c80f9ce0605f57c06629b2e4bec81752a78d0e1
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 22 11:26:57 2010 +0300

    sdp: use max number of SGE from HW capabilities
    
    Instead of using hard coded max number of SGE's take
    it from device capabilities.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4bc6920c83fb63a510fa86dec5de95ba6fc6dfa8
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Apr 25 11:55:29 2010 +0300

    sdp: Fix a hang when ib_post_recv is failed
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0d56a06939d7c03091c26bd1deeb689a6cbba2f5
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Apr 25 11:50:44 2010 +0300

    sdp: fix compilation warning on debug prints
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8c94349521f73054bfcb08748f33ad815defd854
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Apr 25 10:41:37 2010 +0300

    Bug fix in counters
    
    Take the port number from qp->port rather than attr->port_num. qp->port is
    update when modifying from reset to init. For special QPs it is updated at
    creation.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b322c88f10bb2212101346e39523e32ce9f71739
Merge: 6d6ac62 6a54ece
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 22 17:29:08 2010 +0300

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 6d6ac621f1ddec038cd73685fc11c60dff76f706
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 22 16:27:38 2010 +0300

    Update support for enhanced atomic operations
    
    Patches updated with the version committed to the upstream kernel.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6a54ece400371447a383c59597e961cb6d51977a
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 22 10:34:59 2010 +0300

    sdp: sdp_bzcopy_thresh module parameter removal
    
    Field [bzcopy_thresh] inside 'struct sdp_sock' changed to [zcopy_thresh] and
    the ability to disable zcopy per-socket was added.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit aaf5a11f6b1d466b5aaf2c9dd40b43dbe8f389bc
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Tue Apr 20 17:20:16 2010 -0700

    IB/qib: backport fixes for OFED 1.5.2
    
    Update the backport patches for OFED 1.5.2.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit eceda2cf579365ee90fcb9c5c4ca647a16484777
Merge: b35c420 b48db55
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 20 14:57:14 2010 +0300

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6/ into ofed_kernel_1_5

commit b48db55de53486afcdf0422d79684627045731de
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Mon Apr 19 11:35:04 2010 -0700

    IB/qib: fixes for OFED 1.5.2
    
    This updates the QDR HCA serdes settings to improve reliability
    and is needed for the next IB interoperability event.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit b35c4207dce433c1e3b623d9bdd4259f474e38e2
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Apr 18 16:56:03 2010 +0300

    sdp: BUG2017 - better initialization implementation for ssk->nagle_timer
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e79bd3e79785a6974feace5acea1e43fb1b7cd03
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Apr 18 14:34:33 2010 +0300

    sdp: fix for brutal device removing
    
    Kernel always crashed in the following test case:
    user program:	socket+bind+listen+accept. socket accpted.
    shell:		rmmod mlx4_ib
    user program:	close <<< CRASH
    The fix closes any socket that its ib_device is the device being removed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5a9dbaf793268ecf4d44f53fdca42edda0f54e16
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 15 11:57:11 2010 +0300

    sdp: Don't try to allocate FMR larger than RLIMIT_MEMLOCK
    
    During ZCopy. If don't have CAP_IPC_LOCK capability and current
    max number of locked pages is smaller than the buffer size, split
    the send into small fragments.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f988c01bf259206e9575bcc65d3d98e700f10911
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 15 11:52:19 2010 +0300

    sdp: Don't count sdp header twice when calculating size_goal
    
    sizeof(struct sdp_bsdh) is included inside skb->len. Ignore it
    when calculating maximum payload of the skb.
    This mistake caused every BCopy send of 32K (and its multiples) to
    be split and thus got bad performance.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e233ae1662b884deb9bdf77193e7a2b2a0f0b7d3
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 13 13:39:41 2010 +0300

    sdp: timeout for abortive close updated
    
    SDP_FIN_WAIT_TIMEOUT updated from 10[sec] to 60[sec] to comply with TCP
    TCP_FIN_TIMEOUT.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6cac8adf70072d141d403203693af9d94adb0e24
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 15 15:08:13 2010 +0300

    Fix counters for RoCE
    
    counter index is assigned in modify from init to rtr.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e5414cccaa13e6dd80d8d6fc3dafe95355facdef
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Apr 12 15:42:32 2010 +0300

    sdp: module parameter to disable SDP over ROCEE
    
    Since ROCEE added, SDP always try to connect, even
    if link layer of type Ethernet. This make 'both' mode
    in libsdp useless.
    
    Added a module paramter to disable it by default
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9a6ef6793c83b1587984d919a84ed5c2ca19a0c0
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 8 10:09:37 2010 +0300

    sdp: added differentiation between bind failures of sdp.
    
    When bind()ing in mode 'BOTH', bind(sdp_sock) might fail if:
    	1. the IP&port is already bounded.
    	2. the IP is not part of IB network.
    previous implementation returned errno=EADDRINUSE either way.
    
    Only the first case should fail the bind(), the second is legitimate
    because the TCP socket will hanle the connection.
    This fix corresponds to a fix in libsdp.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit feaa7f15f651c35978f8c2a3e08642d2530fce0b
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 18 10:53:56 2010 +0200

    sdp: BUG1727 - there is no point of using zcopy when credits are not available.
    
    if credits are not available, data won't be transferred anyway,
    so it would be better to use bcopy.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8f358b2307d4eaa816fc8bec3dda365399754530
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 31 16:02:03 2010 +0300

    sdp: BUG1992 - enable transmission of credits update when tx_credits == 1
    
    According to spec, if one credit is available, we can only send messages that
    provide additional credits and also do not contain data payload.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2ac23ff8ac947397ad6866cdf215809eb2511e93
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 31 15:27:38 2010 +0300

    sdp: unnecessary 'if' statement canceled.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1c2405885e0e5595cdc531a84400458c4e0c70bb
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 18 13:31:08 2010 +0200

    sdp: BUG1727 - fixed select(2) behavior on a new nonblocking socket.
    
    when calling for select(2) after socket(2) on a nonblocking socket,
    select(2) should return 'writable'.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f9f0b4d008fa53407d9a64a30c2789c6ce4cdf6e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 17 15:24:28 2010 +0200

    sdp: BUG1727 - sdp_destroy_work() and sdp_connect() interfere with each other.
    
    This fix was done in order to make sure that sdp_destroy_work() is done
    before sdp_connect() is active.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 88e95a2bf83596150919a077ea2e371f08812dbb
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 14 16:36:32 2010 +0200

    sdp: support iovlen > 1 in zcopy
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9cb9abb8501c96633d6ab144ccb1ff3880e12f74
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 14 16:35:38 2010 +0200

    sdp: make sdp_socket.h available to user applications
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7d39db269d341c8faf846b4ade0413c5dbb543f0
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 1 10:28:37 2010 +0300

    sdp: enable FMR pool cache
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7b1e5589a307f0783ff0b360a778bc6d32ab710a
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Mar 25 10:33:30 2010 -0500

    RDMA/nes: correct cap.max_inline_data assignment in nes_query_qp
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 888aeb78804be9c0e89acb18622f49ff8cc40073
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Mar 25 09:09:36 2010 -0500

    RDMA/nes: disable dynamic interrupt moderation by default
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 63079c7ac1161a090cdd9feef757118c9d56cc72
Merge: 17badd7 bf34b58
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 25 11:01:55 2010 +0200

    Merge remote branch 'vu/ofed_kernel_1_5' into ofed_kernel_1_5

commit bf34b58acf19fdbef467aa9bb70b37d840f3bdc7
Author: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date:   Wed Mar 24 16:36:53 2010 -0700

    srp: solving dead_lock issue during unload/reboot system
    
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--------------050205020508050105060300
Content-Type: text/csv;
 name="bugs-2010-05-03.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2010-05-03.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxNzI3LCJu
b3JtYWwiLCJQMyIsIlNMRVMgMTEiLCJlbGRhZHpAbWVsbGFub3guY28uaWwiLCJSRVNPTFZF
RCIsIkZJWEVEIiwiU2VsZWN0IGZhaWxzIGFmdGVyIGNvbm5lY3QgdG8gaW52YWxpZCBhZGRy
ZXNzIgoxODQ3LCJub3JtYWwiLCJQMyIsIkFsbCIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwi
UkVTT0xWRUQiLCJGSVhFRCIsInpjb3B5IHNlbmQgd2l0aCBpb3ZsZW4gPiAxIGlzIG5vdCBz
dXBwb3J0ZWQiCjE4NzIsIm5vcm1hbCIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28u
aWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiZmFpbGVkIHRvIHNlbmQgcGFja2V0cyBsZXNzIHRo
YW4gNDA4MCBieXRlIGJ5IHpjb3B5IgoxOTA5LCJub3JtYWwiLCJQMyIsIkFsbCIsImFtaXJ2
QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkVuYWJsZSBhIHRyaXZpYWwg
d2F5IHRvIGluY2x1ZGUgc2RwX3NvY2tldC5oIgoxOTY1LCJtYWpvciIsIlAzIiwiUkhFTCA1
IiwieWV2Z2VueXBAbWVsbGFub3guY28uaWwiLCJDTE9TRUQiLCJGSVhFRCIsIkJvbmRpbmcg
bWx4NF9lbjogcGluZyBkb2VzIG5vdCByZXN1bWUgYWZ0ZXIgZmFpbG92ZXIgYmV0d2VlbiAx
MEcgcG9ydHMiCjE5ODQsIm5vcm1hbCIsIlAzIiwiQWxsIiwiZWxkYWR6QG1lbGxhbm94LmNv
LmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkJ1ZyBpbiBhY2NlcHQoKSIKMTk4OCwibWFqb3Ii
LCJQMiIsIkFsbCIsInN3aXNlQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwi
RklYRUQiLCJbT0ZFRC0xLjUuMS1yYzRdIC0gU29mdGlycSBzZWVuIG9uIG9uZSBvZiB0aGUg
bm9kZXMgYWZ0ZXIgfjQ4IGhvdXJzIHdoaWxlIHJ1bm5pbmcgMiBpbnN0YW5jZXMgZWFjaCBv
ZiBJTUItTVBJMSsgT1NVK1ByZXN0YSB0ZXN0IHRvZ2V0aGVyIG9uIDY0IGJpdCBwbGF0Zm9y
bXMiCjIwMjcsIm5vcm1hbCIsIlAzIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwi
LCJDTE9TRUQiLCJGSVhFRCIsIlNEUCBub3QgcmVzcGVjdGluZyAjIFNHRXMgYXMgcmVwb3J0
ZWQgZnJvbSBIVyIKMjA0MSwibm9ybWFsIiwiUDMiLCJPdGhlciIsImplcmVteS5icm93bkBx
bG9naWMuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIlFJQiBjb21waWxhdGlvbiBmYWlscyBv
biBSSEVMNS41Ig==
--------------050205020508050105060300--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
