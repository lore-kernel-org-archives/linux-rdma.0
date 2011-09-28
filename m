From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4-rc1 is available
Date: Wed, 28 Sep 2011 23:43:56 +0300
Message-ID: <4E83870C.4030702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050101010002090502020806"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050101010002090502020806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4-rc1 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4-rc1.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for OFED 1.5.4

Regards,
Vladimir

Supported Platforms and Operating Systems
---------------------------------------------
   o   CPU architectures:
         - x86_64
         - x86
         - ppc64
         - ia64

   o   Linux Operating Systems:
         - RedHat EL5 up5        2.6.18-194.el5
         - RedHat EL5 up6        2.6.18-238.el5
         - RedHat EL5 up7        2.6.18-274.el5
         - RedHat EL6            2.6.32-71.el6
         - RedHat EL6.1          2.6.32-131.0.15.el6
         - Scientific Linux 6.1  2.6.32-131.0.15.el6
         - SLES10 SP4            2.6.16.60-0.85.1-smp
         - SLES11                2.6.27.19-5-default
         - SLES11 SP1            2.6.32.12-0.7-default
         - kernel.org            2.6.30 - 3.0

Updated packages:
dapl-2.0.33
ibacm-1.0.5
librdmacm-1.0.15
ibutils-1.5.7-0.1.g05a9d1a
infinipath-psm-2.9-926.1005_open
libcxgb3-1.3.0
libcxgb4-1.1.1
perftest-1.3.0-0.50.g30a230a

Management:
libibmad-1.3.8
infiniband-diags-1.5.9
opensm-3.3.11

MPI:
mvapich2-1.7-0.3.rc2


--------------050101010002090502020806
Content-Type: text/plain;
 name="ofa_kernel-changelog-1.5.4-rc1.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="ofa_kernel-changelog-1.5.4-rc1.txt"

commit e82793520f05609fad29c654a09d17971d0fb07f
Merge: 78a8b93 43bc1e7
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 28 22:16:36 2011 +0300

    Merge branch 'ofed_kernel' of git://git.openfabrics.org/~swise/ofed_kernel into ofed_kernel_1_5

commit 78a8b93e427950bdea494ecfa2613f9f75e7495c
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Sep 27 16:43:39 2011 -0500

    RDMA/nes: Backport fixes for PAU
    
    Backport fix for the Packed and Unaligned (PAU) code.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 43bc1e73f2357f38b0b9c73317c0eb7913f2472f
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Wed Sep 28 10:05:20 2011 -0500

    RDSRDMA: Bring OFED up to date with upstream kernel
    
    Pull in commits 52fc50940e73bbb38cf12387db3495664cd57ba4 and
    34b04e253ba8102ec828271565e4c218be4076c8 in OFED. These commits
    fix the PAGE_MASK interpretation and segment unmapping issues
    in RDSRDMA
    
    Signed-off-by: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
    Signed-off-by: Steve Wise <swise-/Yg/VP3ZvrM@public.gmane.org>

commit d80b23789ffb1b90ef42e285ca212cc9f7c835a4
Merge: ef492ff faa71aa
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 27 09:54:24 2011 +0300

    Merge branch 'ofed_1_5_gireesh' of git://git.openfabrics.org/~vipulp/ofed_kernel into ofed_kernel_1_5

commit ef492ffb72250e0c457fb1b97470e5f0cd6aa61c
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Sep 26 17:14:02 2011 -0400

    QLogic: Add support for HP BL685 blades
    
    Add SERDES tunning support for the HP BL685 full-height
    blades which have 3 Mez slots.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 956daab1693ce7d0cc39139d057f6d2e8cf260d3
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Sep 26 13:02:18 2011 -0400

    truescale.cmds: enhance CPU assignment
    
    truescale.cmds is enhanced to make the following changes to
    CPU assignments:
    - use the affinity_hint file if present, otherwise changes as below
    - non-kctx interrupts are assigned to the HCA's first local CPU
    - kctx interrupts are assigned from the second with a potential
      wrap back to the second
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 76094c8ce83af2d8f85d50d7c572a823ff6cc13c
Merge: 7957aae 0e805f1
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Sep 26 16:53:02 2011 +0300

    Merge branch 'ofed_1_5' of git://git.openfabrics.org/~vipulp/ofed_kernel into ofed_kernel_1_5

commit 0e805f17e51bb1d74cb2c60b1e98e9731f8128c0
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Aug 18 18:06:23 2011 +0530

    MPA_v2: Backports for iw_cxgb4, iw_cxgb3 and amso
    
    Adds MPA_v2 backports to support Enhanced RDMA Negotiation.
    For iw_cxgb3 and amso, currently max supported ird/ord values
    are passed upwards.
    Adds support to following kernels:
    -2.6.39
    -2.6.38
    -2.6.37
    -2.6.36
    -2.6.35
    -2.6.34
    -2.6.33
    -2.6.32
    -2.6.32-EL6
    -2.6.32-EL6.1
    -2.6.32_sles11sp1
    -2.6.31
    -2.6.30
    -2.6.18-EL5.7
    -2.6.18-EL5.6
    -2.6.16_sles10sp4
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit b63fc7fe9a5406e0aed55aa2854fc3d2f96236dd
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Aug 18 03:49:42 2011 +0530

    IB/core: Propagate ird/ord values upwards
    
    Updates iw_cm_event to support propagating the ird/ord
    values upwards to the application
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit c1078277b1112b719925f44e4815c50d5086e91a
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Aug 8 16:28:51 2011 +0530

    iw_cxgb4: Add support for MPA V2 Enhanced RDMA Negotiation
    
    The patch adds support for Enhanced RDMA Connection Establishment
    (draft-ietf-storm-mpa-peer-connect-06).
    Details of draft can be obtained from:
    http://www.ietf.org/id/draft-ietf-storm-mpa-peer-connect-06.txt
    
    The patch updates the following functions for initiator perspective:
    -send_mpa_request
    -process_mpa_reply
    -post_terminate for TERM error codes
    -destroy_qp for TERM related change
    -adds layer/etype/ecode to c4iw_qp_attrs for sending with TERM
    -peer_abort for retrying connection attempt with MPA_v1 message
    -added c4iw_reconnect function
    
    The patch updates the following functions for responder perspective:
    -process_mpa_request
    -send_mpa_reply
    -c4iw_accept_cr
    -passes ird/ord to upper layers
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 7957aae129c300d0b5cff8528fba00af8cce8cc3
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sun Sep 25 21:19:06 2011 -0500

    RDMA/nes: Support for Packed And Unaligned fpdus
    
    Support for PAU is needed for interoperability between NES and other non-NES
    nodes. When the NES hardware detects a PAU frame, it will pass it to the
    driver to process the frame. NES driver creates a new frame for each FPDU
    and forwards it to the hardware to be sent to its associated qp.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 729040de6e583e7b1ae1f7f0be808d3e254b9e56
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sun Sep 25 21:18:43 2011 -0500

    RDMA/nes: Support for MPA revision 2
    
    MPA V2 changes are based on an IETF STORM Draft, which will update RFC5043
    and RFC5044. MPA V2 extends the configuration negotiation for RDMA connection
    establishment. For backwards compatibility, MPA V2 enabled driver reverts to
    MPA V1, if the remote node doesn't support MPA V2.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit cd041554521ce46cb443883ceddaa515e71c3736
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sun Sep 25 21:18:31 2011 -0500

    RDMA/nes: Print ip address for critical errors
    
    Prints the IP address of the remote host when critical asynchronous event is
    received.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit cf8cdcc1e6fe328caf3170349409c696f575ebd6
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sun Sep 25 21:15:56 2011 -0500

    RDMA/nes: Fix terminate connection
    
    Fixes a crash that occurs during close when error async event is received.
    Terminate message is not sent to the remote node if already processing close.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit faa71aa633e1e6aa96070d51d03e84a57b29ea4f
Author: Gireesh Nagabhushana <gireesh-4z0guDdWFfNHOSu/evF7xUwdHq8NFSIN@public.gmane.org>
Date:   Mon Sep 26 17:35:59 2011 +0530

    cxgb4: change version to 1.3.0-ofed to differentiate between base and ofed.
    
    Signed-off-by: Gireesh Nagabhushana <gireesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit a7f7c501f9cf0a1454323c5f6f8668be2ddf2b1d
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Sep 23 12:04:24 2011 -0400

    IB/qib: Add logic for affinity hint
    
    Call irq_set_affinity_hint to provide user mode programs
    like irqbalance the information to be able to distribute
    qib interrupts appropriately.
    
    The logic allocates all non-receive interrupts to the first
    CPU local to the HCA.  Receive interrupts are allocated round
    robin starting with the second CPU local to the HCA with
    potential wrap back to the second CPU.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 96ecdac8d78e2d20b32eb4ec50643bcb1c03f828
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Sep 23 11:10:49 2011 -0400

    IB/qib: Add irq name refinements
    
    This patch adds a refinement to the name registered with
    MSIX interrupts so that user level scripts can determine
    the device associated with the IRQs when there are
    multiple HCAs with a potentially different set of
    local CPUs.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit d3d7ea0a142f1545f9bfbcd9e3bd47b7b2f9ce79
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Sep 23 10:59:03 2011 -0400

    IB/qib: remove s_lock around header validation
    
    Observation in qib_ruc_check_hdr() shows that the s_lock is not required
    in the normal case.   The r_lock is held in all cases, and protects
    the qp fields that are read.
    
    The s_lock will be needed to around the call to qib_migrate_qp() to
    insure that the send engine sees a consistent set of fields.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 6aeceea336753dfc6b2987594b228e65b3a46982
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Sep 23 10:46:13 2011 -0400

    IB/qib: memcpy optimizations
    
    The default memcpy used by qib_copy_sge() ends up being a rep movsb on x86_64,
    which is pretty slow.
    
    This fix adds an x86_64 specific routine that 1) probes for X86_FEATURE_REP_GOOD
    and 2) uses an inline asm routine builton rep movsq that testing has shown is
    better than the builtin memcpy for all cases up to 4K.  The probing routine is
    now called when the qib module is loaded to enable the optimization.   When
    X86_FEATURE_REP_GOOD is not set, the routine uses the kernel's unrolled __memcpy
    when the length is more than 64 and the builtin memcpy otherwise.
    
    This patch also adds the cache bypass copies from older releases.  Testing has
    shown that AMD cpus benefit with a 40% improvement in netperf/ipoib.
    
    The cache_bypass_copy module parameter can be used to enable on non-AMD
    CPUs.
    
    The qib_verbs_send_dma() and qib_copy_from_sge are also changed to use the
    memcpy_string_op() to improve packet delivery performance to the
    send engine.
    
    The existing copy as well as a new stub probe routine are maintained as weak
    symbols for other architectures.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 9ecf3abd1d880255e2f9be0e9714dcd49c97fede
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Sep 23 09:44:07 2011 -0400

    IB/qib: precompute timeout jiffies to optimize latency
    
    A new field is added to qib_qp called timeout_jiffies. It
    is initialized upon create and modify.
    
    The field is now used vs. the computation based on qp->timeout.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit b718e7f17cc9fc9d31148ec046bf071bdd2c105d
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 22 14:43:48 2011 -0400

    IB/qib: qpn lookup optimizations
    
    The heavy weight spinlock in qib_lookup_qpn() is replaced with
    the RCU locking mechanism.  The hash list itself is now accessed
    via jhash functions vs. the mod.
    
    The changes should benefit multiple receive contexts in different
    processors by not contending for the lock to just read the hash
    structures.
    
    The patch also adds a lookaside_qp (pointer) and a lookaside_qpn
    in the context.  The interrupt handler will test the current
    packet's qpn against lookaside_qpn if the lookaside_qp pointer
    is non-null.  The pointer is NULL'ed when the interrupt
    handler exits.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit dd2e48e7c02c0925a5e603d1a9752d20b7e15ed3
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 22 11:50:04 2011 -0400

    IB/qib: Eliminate divide/mod in converting idx to egr buf pointer
    
    The context init now saves a shift from rcvegrbufs_perchunk
    rcvegrbufs_perchunk_shift using ilog2.   A BUG_ON protects the
    power of 2 assumption.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 3eef5499db4d04aae5d10580b3735696957cd99d
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 22 11:40:13 2011 -0400

    IB/qib: decode path mtu optimization
    
    Store both the encoded and decoded mtu in the qp structure as a minor
    optimization UC/RC receive routines.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 2871fc8a45df95c52cac9707e886383ec712a20e
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 22 11:24:39 2011 -0400

    IB/qib: Optimize RC/UC code by IB operation
    
    The memset for zeroing the work completion had been unconditional.
    
    This patch removes the memset and moves the zeroing into the work
    completion with a more explicit field by field set.   With this patch,
    non-ONLY/non-LAST packets will avoid the overhead since they will
    not generate a completion.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 828a7f6b95f5c29d3ddc93c8a5e01a83ccffb140
Author: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Sep 22 14:11:33 2011 +0300

    ib_core: Change link_layer string to match mainline kernel
    
    In the mailinline it appears for IB as "InfiniBand" while in ofed it was "IB".
    Change to "InfiniBand".
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3f109aa8414c9d9ae0267c38bec41b597c759ddb
Merge: 9f978fa 6d13d18
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Sep 22 09:12:47 2011 +0300

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 9f978fa3ef3d4826fa36b529d8f216a5bbf21cff
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Sep 21 08:26:51 2011 -0500

    Fedora 15 is calling 3.0 2.6.40 so match that for backports.
    
    Fedora 15 has released a 3.0 kernel but is calling it 2.6.40 to avoid
    compatability issues with components expecting a 2.6.* kernel.
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit 6d13d18acfea76fbfa823b4c7f3bf57a1da2f39e
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Sep 21 12:31:12 2011 -0400

    IB/qib: Correct nfreectxts for multiple HCAs
    
    The code that was recently introduced to report the number
    of free contexts is flawed for multiple HCAs:
    
           /* Return the number of free user ports (contexts) available. */
            return scnprintf(buf, PAGE_SIZE, "%u\n", dd->cfgctxts -
                    dd->first_user_ctxt - (u32)qib_stats.sps_ctxts);
    
    The qib_stats is global to the module, not per HCA, so the code is broken
    for multiple HCAs.
    
    This patch adds a qib_devdata field, freectxts, that reflects the free
    contexts for this HCA.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0c18cc2c5e7d18d637c8b7a6a789976fc25ad947
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Sep 19 18:51:30 2011 +0530

    RDMA/cxgb3: Bring upstream commit b955150ea784af4c193b708a2e8091673bf23004
        When a user QP is marked in error, also mark the CQs in error
    
        The flushing of work requests for user QPs is implemented entirely in
        the user mode library.  The only kernel interaction is to mark the
        user QP object indicating it is in error when the QP exits RTS.  When
        the user QP operations are called by the application (eg: post_send,
        post_recv), the QP in error bit is checked and if set, the library
        flushes the QP.  If, however, the application is not doing IO, but
        rather just polling the CQ, it will never get flushed work requests.
        This breaks some classes of applications.
    
        This patch adds logic to mark user CQs in error when a QP that is bound
        to the CQ is marked in error.  The library poll code can then notice
        the CQ is in error and flush all the in error QPs bound to that CQ.
    
        Design:
    
         - add 1 extra CQE entry to the CQ memory that will be used to indicate
           in error status.
         - return the desired CQ memory size that should be mapped by the library
         - bump the ABI since the create_cq uverbs response changes.
         - detect older libraries and reduce the mmap size accordingly.
           (The ABI bump doesn't break old libraries, since they didn't check
           the ABI field anyway)
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 4c6a5a907d47c1e10f54cf3ff79582c876e6ad84
Merge: a3468d0 8676af5
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 21 07:53:41 2011 +0300

    Merge branch 'ofed_kernel_1_5' of git://openfabrics.org/~moranp/ofed_1_5 into ofed_kernel_1_5

commit a3468d018e949499b6d656d90e0dafbd34b6b94c
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Sep 20 23:26:39 2011 +0300

    NFSRDMA fixes for SLES11 SP1
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 8676af5ef82651fd9d48d2d3160cb20d788ca9b3
Author: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Sep 4 11:55:45 2011 +0300

    sdp: Fix Bug 2283 - Multi connection net_perf causes server to hang
    
    Fix the soft lockup bug by changing the allocation flag in
    sdp_bcopy.c from 0 to gfp.
    
    Reviewed by: Amir Vadai
    
    Signed-off-by: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 501a88d202b9cd962b7473dfbf69332a0a8c25bd
Author: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 1 16:34:19 2011 +0300

    sdp: Fix backport sdp_0090_revert_to_2_6_24.patch
    
    Fix backport sdp_0090_revert_to_2_6_24.patch:
    sk_stream_rmem_schedule(sk, int) => sk_stream_rmem_schedule(sk, skb)
    
    Signed-off-by: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f273be716d08aa1c8df081f477bb17901cd44947
Author: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jul 24 16:12:07 2011 +0300

    sdp: Add "#include_next <net/sock.h>" to kernel_addons /net/sock.h
    
    Added "#include_next <net/sock.h>" to kernel_addons /net/sock.h
        in kernels 2.6.22 to fix compilation error
    
    Signed-off-by: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 18de1beb0952781459e41fdd0d4cfd6232656817
Author: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 21 11:35:16 2011 +0300

    sdp: Add "#include_next <net/sock.h>" to kernel_addons /net/sock.h
    
    Added "#include_next <net/sock.h>" to kernel_addons /net/sock.h
    in kernels 2.6.20/21/22_slert10_sp2/23/24 to fix compilation error
    
    Signed-off-by: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit dc95af16b0aa1cdfc73f63274f5b800088865bcd
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Jun 26 18:52:37 2011 +0300

    ib_sdp.conf: load ib_sdp when using AF_INET6_SDP address family
    
    The ib_sdp module is loaded in two cases:
    1. In /etc/infiniband/openib.conf:  “LOAD_SDP=yes”
    2. AF_INET_SDP address family socket creation is called.
    
    The AF_INET_SDP cause the installing of the ib_sdp because in file
    /ofed_scripts/ib_sdp.conf we have:
    alias net-pf-27 ib_sdp
    
    So, the issue is that on AF_INET6_SDP socket creation the ib_sdp module is not created.
    This patch add net-pf-28 to ib_sdp.conf
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 54744953b6e19d642b92c1aed2a871eb0ebc7248
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 26 17:02:23 2011 +0300

    sdp: Fix backports
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0eb29400267d2ddeb6946068c9c2ec84a076c9b8
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 26 12:38:03 2011 +0300

    sdp: RDMA read timeout is too big - set it to 5 secs
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 82c1d5c8ed34a1f77abcb7d01ac8f172340ffe8e
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 26 12:35:59 2011 +0300

    sdp: dump traffic to sdpprf only on demand
    
    When setting 2nd bit of sdp_data_debug
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 185d7ee5b767157a9c8c74fefe4d528526b59eff
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 26 12:31:42 2011 +0300

    sdp: fix backports
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cc1c2131541a1ad270d7370a84a1e7f5fa465ae0
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 21 13:55:55 2011 +0300

    sdp: changed memory accounting warning into debug
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 46a1f4a7cef36d1ed2b057579e521a2b5651a1ad
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 14 14:27:43 2011 +0300

    sdp: Fix issues in sdpprf
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ac7920be63880abdfd24794eb385d3abae15a6ff
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 12 17:40:07 2011 +0300

    sdp: Remove protection before sleep on RX
    
    No need for this protection, it was needed because of a bug previously fixed.
    Credit update could be sent even when credit reaches 2.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d4f584c527b5e9cdfc6fbda4f4f87464b1b38711
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Apr 5 10:58:56 2011 +0300

    sdp: Fixed some coverity issues
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0aa494046a76188cff182c0707473bc24845aece
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 24 10:46:06 2011 +0200

    sdp: Fixed compilation error on 2.6.18 RH5.5
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2932a78033503cc64c9408dc975b6b24fe69bea2
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 22 16:20:34 2011 +0200

    sdp: fix memory leak. sockets_allocated wasn't freed
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b650e167d8d1418a5c80e8101e3a65bc7f1a3be4
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 20 18:37:16 2011 +0200

    sdp: Removed spaces and tabs at end of lines
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ca88c554ad95dfb2256aebd41f6497be7974a3e4
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 20 18:32:23 2011 +0200

    sdp: fix sdpprf
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e0d7ffb18bbf6a78835a7aeab805a058040db293
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 20 17:25:02 2011 +0200

    sdp: Fixed bcopy statistics
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 368b9ce64a30a267db0d1527f3e47cf49e459cee
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 20 15:34:33 2011 +0200

    sdp: Bad behaviour when setting low rcvbuf size
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ed219923b83bc454ef6897e16f3ff76225fff659
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 9 10:35:15 2011 +0200

    sdp: Fixed a typo
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 00568d86c0af49e00709e73d7190f502b7726389
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 8 18:15:59 2011 +0200

    sdp: removed unneeded backport
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9655fe088ae2ee57e8b32e329020fb6a5c503c57
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 8 13:49:36 2011 +0200

    sdp: fix backports
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 16f5aab43113bbec3a66804a57a39f3b57c59d41
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 8 10:25:35 2011 +0200

    sdp: Limit total memory consumed by rcvbuf
    
    rcvbuf is already limited by the payload in the queue. But also need to limit
    total memory consumption of it, since small packets received might have a very
    large overhead to the payload.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 84f9af7a7b5a314027e0d7abb6029ed582956380
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 8 10:23:24 2011 +0200

    sdp: fix "sdpprf empty after a long run"
    
    sdpprf_log_count gets to a negative value after a long run.
    This is only a quick fix - still might loose logs sometimes.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4dddc02bb39d0feb9618f82e5af9f8e66777ff29
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Mar 7 13:11:59 2011 +0200

    sdp: make SDP_RX_SIZE a module parameter
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 212eacaea83a1985550ecd2f0ef3d0430b9cce54
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 14:38:08 2011 +0200

    sdp: Rollback credit limit during ZCopy transaction.
    
    This limit was added at commit 2574b53 ("Abort rx SrcAvail when out of
    credits")
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0e73ab4abc246719417885c3ecc52fbec1f027fb
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 15:09:24 2011 +0200

    sdp: get per socket memory statistics at socket's sysfs file
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 780584abc16afb48468970cec53719815218e70a
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 14:33:00 2011 +0200

    sdp: fix a hole in rx memory limit
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d3646ade754a7d39eec5276eade083517a563f25
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 14:31:27 2011 +0200

    sdp: make sure memory is reclaimed
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit af46b8597cc9e4589abbc11dea6d891189d2a3ba
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 14:27:57 2011 +0200

    sdp: send packets without payload when credits=1
    
    This according to the SPEC, and prevent a deadlock in ZCopy. SrcAvailCancel
    wasn't acked when credits got low.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 83dd284cdc2510d5bb45d5fde7d8033c9cd52313
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 14:21:14 2011 +0200

    sdp: removed some prints to sdpprf
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 104d9d250fe4bbae217ab174448417cebef60df9
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 6 14:19:26 2011 +0200

    sdp: remove unused rcvbuf_scale module parameter
    
    Was used when in slow start mechanism.
    Not needed till having slow start again.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 08368100e254d01bb19fdacf4b9f07ea0f258c11
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 28 11:57:18 2011 +0200

    sdp: fix memory socket accounting
    
    skb->truesize - total bytes allocated by skb, including fragments
    
    Specific socket accounting:
    * sk->sk_wmem_queued - send bytes currently in TX queue
    * RX queue accounting is done by using seq
    * sk->sk_rmem_alloc - bytes consumed by RX
    
    Protocol accounting:
    * sk->sk_forward_alloc - bytes that are available to be consumed
    * prot->memory_allocated - bytes consumed by TX/RX
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 329c1e5b4b4ea4b14cd31aeb8462ab2216f7de54
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 28 11:33:58 2011 +0200

    sdp: fix sdp_sendmsg counters in sdpstats
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 071041de8ba8d9ee34f7d9e50fc1d79dde707824
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Sep 12 21:07:48 2011 +0300

    Remove carriage returns from DOS formatted patches so they can apply
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit e688148a96b3b54898ccf9aa0cf192e0133f90f2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Sep 12 19:54:26 2011 +0300

    ofa_kernel.spec: Fix %files macro
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fb272719c859197931289ad12d311b639d3a0d02
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Sep 6 12:42:58 2011 -0700

    NFSRDMA: fixes for 2.6.32
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 09518cdc0eb04ca9a9adeb538c114eb8211ad543
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Sep 7 15:14:44 2011 -0400

    IB/qib: Change driver default for wc_pat to 2 to work around any inconsistency
            of the PAT1 configuration across all CPUs.
    
    The fix for this problem has been committed by Suresh Siddha of Intel to 2.6.38.3
    (https://lkml.org/lkml/2011/4/13/232) but there could be kernels without the patch
    backported. This patch works around this bug without any intervention by the
    customer or our support.
    
    Signed-off-by: Ramkrishna Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 6aebbfc7b7f837223715b7b667837e2434c1d46c
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sun Aug 28 14:15:15 2011 +0530

    iw_cxgb4: Add 2.6.16_sles10_sp4 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 22d4ebec611954c65fd08155c0b4557e3aa983f0
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Sep 2 11:57:11 2011 +0530

    cxgb4: Updates to SLES10SP4 backport
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit c4bb4a6565fe15ffe6da16afeba0aae1fb6a48ab
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Sep 2 11:24:44 2011 +0530

    cxgb4: Add backport patches for SLES10SP4
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 98456d970a44e7990033d4df87bbaf537d1d1866
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sun Aug 28 13:58:37 2011 +0530

    backports: Add sles10_sp4 backport.
    
    Adds most of backport files from sles10_sp3 into sles10_sp4.
    Also, adds support in get_backport.sh script for sles10_sp4.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 5790e624dd074e55cdaa680a74a1e2724bfff35e
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Thu Aug 25 12:28:55 2011 -0500

    Drop ethtool.h from the 3.0 backports
    
    ethtool_phys_id_state is already included in 3.0 so drop this patch
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit 5d249db40dc8daa233153d5c6b229b889a3129b5
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Sun Aug 28 11:11:12 2011 +0300

    Remove carriage returns from DOS formatted patches.
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit bd205b390d800e788ce0b394d74f370681e9b3dc
Merge: 7c9d10b 6128a5d
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 25 19:26:02 2011 +0300

    Merge branch 'ofed_1_5' of git://git.openfabrics.org/~vipulp/ofed_kernel into ofed_kernel_1_5

commit 6128a5d33674df915a196f6deb3b741706b8f7c0
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sat Aug 27 12:15:49 2011 +0530

    iw_cxgb4/cxgb4: Add SLES11sp1 backport
    
    Also, adds support in ofed_script/get_backport.sh for sles11sp1
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 515c1fdec3c88f559abae6b41e0044b23fe6c3e9
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sun Aug 7 12:03:17 2011 +0530

    iw_cxgb4: Add 2.6.30 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit be4af96779aca48bba3473be3b894e4bd11d0987
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Aug 4 18:04:00 2011 +0530

    Adding patches for 2.6.30 kernel for cxgb4 driver.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 262799f93ca7395807e2a983655c1bfc44d30e9b
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Aug 8 12:34:22 2011 +0530

    iw_cxgb4: Add 2.6.18-EL5.6 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit b428d6aec7163cc88da4a464c1b4ec596db712f8
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Tue Aug 9 19:26:21 2011 +0530

    Adding patches for RHEL5.6 for cxgb4 driver.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 6b4bc39de10f584b1f4ff8687e90cdd308385cd2
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sun Aug 7 14:29:33 2011 +0530

    iw_cxgb4: Add 2.6.18-EL5.7 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit be062eb4d43c80744db15fedf53c105e46cdd143
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sat Aug 6 18:38:53 2011 +0530

    Adding patches for RHEL5.7 for cxgb4 driver.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 7c9d10b0a1da56b9c4c487a59d51cf2592129383
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Aug 24 10:13:43 2011 +0300

    makefile: Set the default value for INSTALL_MOD_DIR
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5f745a059a7e14f4722bf0a7551610d2d1d2df4a
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 18 17:45:52 2011 +0300

    Add kernel 3.0 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8680bf169d1fdd9fd8ef2b0b176dc5eceb2be457
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 18 18:07:01 2011 +0300

    cxgb3: Add RHEL6.1 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ee1f65184bde2ff21ed878dc32e7364fdf29f54e
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 18 17:35:52 2011 +0300

    get_backport_dir.sh: Add 2.6.32-71.18.2.1chaos.ch5.x86_64 kernel support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3d5076d0954cdbf0eb2b30cb649b21eb3dfaf84b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 18 15:36:50 2011 +0300

    Simplify RPM spec and makefile
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a005b31e772d294834336e14f08df6b9cfffdccd
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Fri Aug 12 15:52:34 2011 -0700

    NFSRDMA: remove a patch that does not apply Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 21d85f665e08231a8a7c46d3e21ed6a5776f323c
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Fri Aug 12 15:27:26 2011 -0700

    NFSRDMA: remove patch that does not apply Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit ea984fa4aa3019291b5ed35e50968d9101f454c4
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Fri Aug 12 14:27:39 2011 -0700

    NFSRDMA: bring patches up to date with upstream kernel Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 24315d7028e58d0d457809539830eb048cc9e3fc
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Aug 8 12:28:43 2011 +0530

    iw_cxgb3: Correct Makefile to fix build errors
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 9efe93de87e4cf0ccabc58ebcd43ffccbe8859c3
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Aug 4 09:05:05 2011 +0530

    iw_cxgb4: Add 2.6.31 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit f1d81fde3e21ae58cb9598a6848c899e0e59127f
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Aug 4 14:27:16 2011 +0530

    Adding patches for 2.6.31 kernel for cxgb4 driver.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 612f0b519e1644301930d2cc5eb38f83e05cf114
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Aug 5 14:35:08 2011 +0530

    iw_cxgb4 : Add 2.6.32-EL6.1 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit fd2f51115e6061798bfabd48be838f26c75d9ad0
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Aug 5 14:31:58 2011 +0530

    cxgb4: Add 2.6.32-EL6.1 backport
    
    Also, adds support to ofed script for 2.6.32-EL6.1.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit e6b03350e5f88b5718c6792fe61c186ffce2b38e
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Aug 4 06:54:43 2011 +0530

    iw_cxgb4: Add 2.6.32-EL6 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit d923453a1d0cc0d1f07c4995a58ba79a923ebbba
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Aug 5 11:21:58 2011 +0530

    cxgb4: Add 2.6.32-EL6 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit facbbf761f214f7bb07bc41b33bc0e46fe38735c
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Aug 3 06:23:25 2011 +0530

    iw_cxbg4: Add 2.6.32 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit ea11038fd5c87f8682759ad6d99734547a743c87
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Aug 3 17:24:07 2011 +0530

    Adding patches for 2.6.32 kernel for cxgb4 driver.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 57b69aa666858516f745e89c7ad8ffc2c64a00c0
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Aug 1 02:18:38 2011 +0530

    iw_cxgb4: Add 2.6.33 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 3d19890a6692898d73ae7a2bf5f6105417ffb8a6
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Tue Aug 2 11:33:28 2011 +0530

    Adding backport patches for 2.6.33 kernel for cxgb4 driver.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 3689cdebf7695469e5e94299c05341453e86bfe8
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sun Jul 31 13:57:43 2011 +0530

    iw_cxgb4: Add 2.6.34 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 1ca28482af8297fe2b054e2d01da096115b2c038
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Aug 3 03:30:48 2011 +0530

    cxgb4: Updates to 2.6.34 backport
    
    Uses dev->real_num_tx_queues since netif_set_real_num_tx_queues is
    not available in 2.6.34.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 78fe65116880406058ac28d692c20d765f41ae96
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Aug 1 18:46:16 2011 +0530

    cxgb4: Add 2.6.34 backport
    
    Based on earlier backports.
    Backports ethtool.h, netdevice.h, skbuff.h and pci_regs.h to 2.6.34.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 88bfe7ef260c44e78acec0bde47432a27921635e
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sun Jul 31 12:06:07 2011 +0530

    iw_cxgb4: Add 2.6.35 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 9f2bfe48c13f2967b7505b383df22c85a974ca56
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sat Jul 30 20:40:34 2011 +0530

    cxgb4: Adding 2.6.35 backport
    
    Based on earlier backports.
    Backports ethtool.h, netdevice.h and skbuff.h
    
    The patch also removes additional functions from ethtool_ops
    structure, and also removes additional functions from
    struct net_device_ops.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 6232cb9bcb057a0db0d33e2be8fe3b25a007a7b3
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Jul 28 08:11:25 2011 +0530

    iw_cxgb4: Add 2.6.36 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit f3dbb00523c16346eab4b388c3663feeebf93c14
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Jul 27 05:31:14 2011 +0530

    cxgb4: Add 2.6.36 backport
    
    Includes ethtool, netdevice and sk_buff related changes
    Backports ethtool.h, netdevice.h and skbuff.h to 2.6.36
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 138164e031fe6edbb0e1261eb366b07672ad7dc6
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Jul 28 05:43:53 2011 +0530

    iw_cxgb4: Add 2.6.37 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 9e025ca96ca12c7f4d8505ee42a2be0b63b8559b
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Tue Jul 26 08:04:49 2011 +0530

    cxgb4: Add 2.6.37 backport
    
    Includes ethtool and netdevice related changes.
    Backports ethtool.h and netdevice.h to 2.6.37.
    Also, a change related to missing definition of inline function
    netdev_queue_numa_node_read.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit f1d5e4df3efb6a840e2c39fd238549a4b153e5e9
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Jul 28 03:04:58 2011 +0530

    iw_cxgb4: Add 2.6.38 backport
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 5fdd7c5e5be5029cf35fee72d642dd5f9cb97f0b
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Jul 28 02:37:49 2011 +0530

    cxgb4: Add 2.6.38 backport netdevice related changes
    
    Reverts netdevice changes introduced by the mainline
    commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 9bb553e1f31d82a23acb78daf9dd515aa5ba45f3
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Jul 25 11:51:06 2011 +0530

    cxgb4: Add 2.6.38 backport ethtool.h related changes
    
    Backport ethtool.h and related change in cxgb4 driver
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 26333b82adda24ca956df48acc7b88fb0f980e89
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Aug 1 09:32:35 2011 +0530

    cxgb4: Corrections in 2.6.39 backport
    
    Correction to create the ethtool.h backport file directly in
    the kernel_addons directory.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 1b41d736efa870a62fdfe3643e95913bc08d8066
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Sun Jul 31 10:38:31 2011 +0300

    Remove rnfs_fs.patch from backport directories as it no longer applies
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 6345bce892e00d48479b240ef31677c748b1f3b1
Merge: 74a041b e29d1be
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 28 18:36:15 2011 +0300

    Merge branch 'ofed_1_5' of git://git.openfabrics.org/~vipulp/ofed_kernel into ofed_kernel_1_5

commit 74a041bbed802c193007f9fa3e2c75ae0424e625
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jul 27 15:05:29 2011 -0400

    IB/qib: Remove backport hunk from in the future
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 08bb16a8da0890e6c6bb8e29f809b5d3c4fcaedc
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jul 27 15:02:10 2011 -0400

    IB/qib: Remove backport hunk from in the future
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit e483e5e780f59b3cb9458d487f954424e59aac48
Author: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jul 27 14:13:01 2011 -0400

    IB/qib: Adjust to use cpumask_weight() and cpumask_first()
    
    The cpus_weight macro doesn't work correctly when the
    CONFIG_CPUMASK_OFFSTACK is chosen.
    
    The macro can walk run off the end of the valid bits in the
    mask because NR_CPUS is much larger than the actual number of bits.
    
    This patch adjusts the code to use the APIs that were added
    for kernels >= 2.6.30.  Backport adjustments will need to be
    made for older kernels.
    
    An equivalent patch was also submitted submitted externally by
    KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit f002850c98dbb0632188f551bcaae98bedc022a6
Author: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jul 27 13:59:38 2011 -0400

    IB/qib: add sysfs interface to read free contexts
    
    Indicate the number of free user contexts via the sysfs file
    /sys/class/infiniband/qib0/nfreectxts as required for PSM.
    
    Signed-off-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 8c9fabd5e1431143effc6cf861e4bc47f0fa0971
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Jul 27 13:48:51 2011 -0400

    IB/qib: Update active link width
    
    Update the active link width on QLE7220 chips when
    link goes down if chip width does not match shadowed
    width.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit e29d1be853e7daf5a870cb363614c6cc38b8aebb
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Tue Jul 26 10:12:34 2011 +0530

    Add 2.6.39 backport for Chelsio T4 iWarp (iw_cxgb4) driver
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit cb0b9543e679fc1bdc17913a2bc1e4fcc6770a91
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Jul 21 10:26:36 2011 +0530

    Add 2.6.39 backport for Chelsio cxgb4 driver
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 13ccee4368f6bd6b71fe3e83bb6fd0a52ba1b8b4
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Tue Jul 19 09:12:00 2011 +0530

    Add Chelsio T4 (cxgb4) and iWarp (iw_cxgb4) drivers.
    Also, add support in ofed scripts to build these drivers.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 497149794a7aae2000bbac604988fbff59969463
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 26 17:21:10 2011 +0300

    Remove backports for unsupported OSes
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4a10a3fb6683747f81130a8a1ebf6c976987a82d
Merge: 1a1f18b a2837c4
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Jul 26 16:48:15 2011 +0300

    Merge branch 'ofed_kernel_1_5_3_2' into ofed_kernel_1_5

commit 1a1f18bc88264effef6439e1703f8d063d5058bf
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Jul 26 16:14:00 2011 +0300

    Remove SUNRPC patch that no longer applies.
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit bd5baae8d097a5acf475a680414cadf24d3c8233
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Jul 26 16:13:05 2011 +0300

    Since OFED only builds sunrpc/xprtrdma/* (instead of all of NFS), remove
    patches that no longer apply.
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 706cc61e3b90d88555c7008371e70d8a248bbae9
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Jul 26 16:08:31 2011 +0300

    Patch was formatted as DOS and did not apply - convert to UNIX format
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 7b50dcf01c0010fcaca5f91d80dc694295ba6b99
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Jul 26 16:05:24 2011 +0300

    Remove NFS patch (we don't check out NFS).
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit f009c232fda48636c9f321e172b0d09c11fa94c9
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Jul 26 16:01:44 2011 +0300

    NFSRDMA cleanup: only checkout and build xprtrdma modules
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit d1fe1e2ffb7e55b9b32b0f568892a4138a0d7a54
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jul 25 15:33:56 2011 -0400

    IB/qib: Unwind code incorrrect in qlogic_ib_init()
    
    If the init for the trace does fail the driver will attempt to destroy work
    queues that were never created.  The destroy calls don't test for
    this being NULL.
    
    Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: Gary Leshner <gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 5f675786d95583277d58d691464eede03c7ae8f0
Author: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jul 25 12:49:09 2011 -0400

    IB/qib: Fix potential deadlock with link down interrupt
    
    There is a possibility of a deadlock due to the way locks are acquired and
    released in qib_set_uevent_bits(). The function qib_set_uevent_bits() is called
    in process context calling spin_lock() and spin_unlock() while this same lock
    is acquired/released in interrupt context which can lead to a deadlock when
    running on the same cpu.
    
    The fix is to replace spin_lock() and spin_unlock() with spin_lock_irqsave()
    and spin_unlock_irqrestore() respectively in qib_set_uevent_bits().
    
    Signed-off-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 218de1f4fb977f716df805d9718c4f4c49d99afa
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jul 25 12:29:44 2011 -0400

    IB/qib: Ensure that LOS and DFE are being turned off
    
    Due to timing, it is possible for the LOS and DFE to remain
    on. This is due to the link progressing to LinkUP prior to
    the driver getting the first Status Changed interrupt.
    By expanding the conditions under which LOS is turned off
    and DFE timeout is being set, timing is no longer an issue.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0c1ce2603d0913620ab3f277dc844594405d6e63
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jul 25 12:00:50 2011 -0400

    IB/qib: defer hca error events to tasklet
    
    With ib_qib options as follows:
    
    options ib_qib krcvqs=1 pcie_caps=0x51 rcvhdrcnt=4096 singleport=1 ibmtu=4
    
    A run of ib_write_bw -a yields the following:
    
    ------------------------------------------------------------------
     #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]
     1048576   5000           2910.64            229.80
    ------------------------------------------------------------------
    
    The top cpu use in a profile is:
    
    CPU: Intel Architectural Perfmon, speed 2400.15 MHz (estimated)
    Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask
    of 0x00 (No unit mask) count 1002300
    Counted LLC_MISSES events (Last level cache demand requests from this core that
    missed the LLC) with a unit mask of 0x41 (No unit mask) count 10000
    samples  %        samples  %        app name                 symbol name
    15237    29.2642  964      17.1195  ib_qib.ko                qib_7322intr
    12320    23.6618  1040     18.4692  ib_qib.ko                handle_7322_errors
    4106      7.8860  0              0  vmlinux                  vsnprintf
    
    Analysis of the stats, profile, the code, and the annotated profile indicate:
    - All of the overflow interrupts (one per packet overflow) are serviced
      on CPU0 with no mitigation on the frequency.
    - All of the receive interrupts are being serviced by CPU0.  (That is the way
      truescale.cmds statically allocates the kctx IRQs to CPU.)
    - The code is spending all of its time servicing QIB_I_C_ERROR RcvEgrFullErr
      interrupts on CPU0, starving the packet receive processing
    - The decode_err routine is very inefficient, using a printf variant to format
      a "%s" and continues to loop when the errs mask has been cleared
    - Both qib_7322intr and handle_7322_errors read pci registers, which is very
      inefficient.
    
    The fix does the following:
    - Adds a tasklet to service the QIB_I_C_ERROR
    - replaces the very inefficient scnprintf() with a memcpy().  A field is added
      to qib_hwerror_msgs to save the sizeof("string") at compile time so that a
      strlen is not needed during err_decode().
    - The most frequent errors (Overflows) are serviced first to exit the loop as
      early as possible
    - The loop now exits as soon as the errs mask is clear rather than fruitlessly
      looping through the msp array
    
    With this fix the performance changes to:
    
    ------------------------------------------------------------------
     #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]
     1048576   5000           2990.64            2941.35
    ------------------------------------------------------------------
    
    During testing of the error handling overflow patch, it was determined
    that some CPU's were slower when servicing both overflow
    and receive interrupts on CPU0 with different MSI interrupt vectors.
    
    This patch adds an option (krcvq01_no_msi) to not use a dedicated MSI
    interrupt for kctx's < 2 and to service them on the default
    interrupt.  For some CPUs, the cost of the interrupt enter/exit is
    more costly than then the additional PCI read in the default handler.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 3ff7b432701918ba887ab3970334e51c52b2983e
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jul 25 10:52:34 2011 -0400

    IB/qib: Prevent driver hang with unprogrammed boards
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 7341011f3cee528b51f91050006a940abaeedd1f
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Jul 7 14:41:45 2011 +0300

    ipoib: Fix malformed patch ipoib_0610_set_dev_id.patch
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d6f7b51698999fac29ffd16e193f3507b2d3df35
Author: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Wed Jun 29 12:03:08 2011 +0300

    add upstream change log to some ofed ipoib patches (fwd)
    
    ---------- Forwarded message ----------
    Date: Wed, 29 Jun 2011 11:51:19 +0300 (IDT)
    From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    To: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Subject: [PATCH] add upstream change log to some ofed ipoib patches
    
    Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 156898a0d65cb4c4a020750a80f19881411b3410
Author: Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Jun 23 17:58:42 2011 +0300

    IB/ipoib: Add support to TSO status query
    
    This will allow ethtool to query the status of TSO and will prevent
    the following error message when executing 'ethtool -k <I/F>':
    Cannot get device tcp segmentation offload settings: Operation not supported
    
    Signed-off-by: Dotan Barak <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9d4a0bdf8098973f4a1665c8083028cd983eaedf
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 22 11:43:24 2011 +0300

    backports: Add 2.6.24.7-149 RT kernel support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 72d7875b68f722a779bb97cba4c8b9c71b8831d4
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed May 4 16:47:21 2011 +0300

    mlx4: Sensing port only when supported by HW
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 76c0889ade3dcb94d4a2869b8ea640cb7ba35fb2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 1 18:14:34 2011 +0300

    openibd: drop stderror from bonding's workaround
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 303d19aa19365a999a4191855044bddc765cacc6
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 1 16:04:51 2011 +0300

    openibd: drop IPoIB interfaces' configuration warnings
    
    On RHEL6.0 'ifup ib<N>' ifconfig prints the following messages:
    
    Ifconfig uses the ioctl access method to get the full address information, which limits hardware addresses to 8 bytes.
    Because Infiniband address has 20 bytes, only the first 8 bytes are displayed correctly.
    Ifconfig is obsolete! For replacement check ip.
    
    This commit drops it to /dev/null
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit dabb2e19fb30e969f4de3768143614c79aca02f3
Author: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun May 1 11:52:33 2011 +0300

    openibd: Add workaround for bonding over IPoIB issue
    
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2259
    
    Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 04226d645a6f0e8259414fd4575463bb166fcfff
Author: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Date:   Thu Apr 7 16:17:32 2011 +0300

    IPoIB: Set pkt_type correctly for multicast packets (fix IGMP breakage)
    
    IGMP processing is broken because the IPOIB does not set the
    skb->pkt_type the right way for multicast traffic.  All incoming
    packets are set to PACKET_HOST which means that igmp_recv() will
    ignore the IGMP broadcasts/multicasts.
    
    This in turn means that the IGMP timers are firing and are sending
    information about multicast subscriptions unnecessarily.  In a large
    private network this can cause traffic spikes.
    
    Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit a711966cb3f7c0874bd93caf3f93dc5d1e16f79f
Author: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Apr 7 15:51:13 2011 +0300

    IPoIB: Allow disabling/enabling TSO on the fly through ethtool
    
    Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit 0c42d37d6f2a873353eecb037b9c3298c1f271d6
Author: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Apr 7 15:07:16 2011 +0300

    IPoIB: Remove TX moderation settings from ethtool support
    
    As of commit f56bcd8 ("IPoIB: Use separate CQ for UD send
    completions"), there are no TX interrupts.  Change the ethtool code
    not to report TX moderation settings, so users will not be misled to
    think they can control TX interrupt moderation.  Pointed out by Alex
    Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    
    Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit ea307a2d2441f51037e99de080a7b987479ed1fa
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Apr 7 16:13:56 2011 +0300

    mlx4: Debug messages when cannot perform SENSE_PORT
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f7dfaad0e266afc16620b72a07b7fa134033d733
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Apr 4 11:15:30 2011 +0300

    mlx4: Sensing port at initialization
    
    Doing this to bring the corfrect port type from start and avoid
    port change later.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d75f0c32a08d157fab7395e6573d46227d8a96ed
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Mar 28 14:35:12 2011 +0200

    mlx4: Consider reserved_cqs
    
    When creting an EQ, we should reduce number of reserved cqs from the number
    of entries we create.
    Otherwise the buffer size is twice the size it should be.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 148545b7d01dc1ef6833fb6eb3077edc964b5809
Author: Nir Muchtar <nirmu-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Mar 27 17:01:15 2011 +0200

    mlx4_en: Fix high priority attach
    
    The problem occurs on certain conditions, when a high priority attach is the
    first attach on its hash bucket, it results in a low priority attach instead
    of the requested high priority attach.
    
    Signed-off-by: Nir Muchtar <nirmu-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 787265508b5d83c7b3fb124d3c7d9546ff702d0a
Author: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Sun Mar 27 10:16:53 2011 +0200

    IB/uverbs: Fix return of PTR_ERR() of wrong pointer in ib_uverbs_get_context()
    
    Signed-off-by: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

--------------050101010002090502020806--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
