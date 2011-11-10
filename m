From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4-rc4 is available
Date: Thu, 10 Nov 2011 16:22:25 +0200
Message-ID: <4EBBDE21.4040107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020507020407090205090103"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020507020407090205090103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4-rc4 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4-rc4.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 1.5.4

Regards,
Vladimir

Main changes from RC3:
----------------------
- NFSRDMA will be installed by default on the supported platforms

Updated packages:
libmlx4-1.0.1-1.20.g6771d22
infiniband-diags-1.5.12
libnes-1.1.2

MPI:
mvapich2-1.7-3.2011svn5008

Supported Platforms and Operating Systems
---------------------------------------------
     o   CPU architectures:
           - x86_64
           - x86
           - ppc64
           - ia64

     o   Linux Operating Systems:
           - RedHat EL5 up6        2.6.18-238.el5
           - RedHat EL5 up7        2.6.18-274.el5
           - RedHat EL6            2.6.32-71.el6
           - RedHat EL6.1          2.6.32-131.0.15.el6
           - Scientific Linux 6.1  2.6.32-131.0.15.el6
           - SLES10 SP4            2.6.16.60-0.85.1-smp
           - SLES11                2.6.27.19-5-default
           - SLES11 SP1            2.6.32.12-0.7-default
           - kernel.org            2.6.30 - 3.0





--------------020507020407090205090103
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.4-rc4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.4-rc4.txt"

commit 2be9290275992ca2c607e4c288777e1b18b481cb
Merge: 2834fa4 2cb4a0d
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Nov 10 11:38:39 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 2834fa487c7f0f136829fd990117d240ec37de8a
Author: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Nov 10 09:55:59 2011 +0200

    ipoib: fix the function that performs dma unmap of memory buffers
    
    Pages that were mapped using ib_dma_map_page() should be unmapped using the
    right function (i.e. ib_dma_unmap_page()).
    
    Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
    Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 165ff66bd9d538a20cdbca541ddcc485d6f839ce
Author: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Nov 10 09:54:34 2011 +0200

    mlx4: Fix the release func to be consistent with the allocation one
    
    Fix the memory release function to be consistent with the memory allocation one
    to prevent problems where the implementation of pci_free_consistent and
    dma_free_coherent are different.
    
    Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
    Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2cb4a0ddcaabc149e9909b2bf64fa5cb414a8fa1
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Nov 9 10:34:54 2011 -0500

    IB/qib: Fix over-scheduling of QSFP work.
    
    Don't over-schedule QSFP work on driver initialization.
    It could end up being run simultaneously on two different
    CPUs resulting in bad EEPROM reads.
    The above, in combination withe setting the physical IB
    link state prior to the IBC being brought out of reset
    can cause the link state machine to start training early
    with wrong settings.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 4778f503c7d9c5e4460d48ea86090709771b5b0c
Merge: 5a94a26 444a49f
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Nov 9 10:24:37 2011 -0500

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/ofed_1_5/linux-2.6 into ofed_kernel_1_5

commit 444a49f25bed444563e20872be0d8464ea5fcf9a
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 18:03:51 2011 +0530

    cxgb4/iw_cxgb4: backports for DB drop recovery
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 3935ae5864c37078545bfa2bee6f3212817ccd4f
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 15:10:27 2011 +0530

    iw_cxgb4: Add query_qp support in driver to query the qp state before flushing.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 55bffeabd0d76bf7eac4c608c695440946ec43b1
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 15:08:24 2011 +0530

    iw_cxgb4: remove kfifo usage
    
    Using kfifos for ID management was limiting the number of QPs and
    preventing NP384 MPI jobs.  So replace it with a simple bitmap
    allocator.
    
    Remove IDs from the IDR tables before deallocating them. This bug was
    causing the BUG_ON() in insert_handle() to fire because the ID was
    getting reused before being removed from the IDR table.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 7842203dacede520f4571cce053ac1ecea73dfa0
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 15:05:37 2011 +0530

    iw_cxgb4: Use vmalloc for debugfs qp dump.
    
    vmalloc allows dumping thousands of qps.
    
    Log active open failures of interest.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 639a8228e39623fd9dc9258209ec2f0b987eff57
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 15:03:31 2011 +0530

    iw_cxgb4: DB Drop Recovery for RDMA and LLD queues.
    
    - add module option db_fc_threshold which is the count of active QPs
    that trigger automatic db flow control mode.
    
    - automatically transition to/from flow control mode when the active qp
    count crosses db_fc_theshold.
    
    - add more db debugfs stats
    
    - on DB DROP event from the LLD, recover all the iwarp queues.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit a32a5b9ddf10494b897a99a0c661d821dfb7340c
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 14:59:50 2011 +0530

    iw_cxgb4: disable interrupts in c4iw_ev_dispatch().
    
    Use GFP_ATOMIC in _insert_handle() if ints are disabled.
    
    Don't panic if we get an abort with no endpoint found. Just log a
    warning.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 63b77ea2ba9e9e4f3fcb948b0db3aea3abd2c0d3
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 14:57:30 2011 +0530

    iw_cxgb4: Add DB Overflow Avoidance.
    
    - get FULL/EMPTY/DROP events from LLD
    
    - on FULL event, disable normal user mode DB rings.
    
    - add modify_qp semantics to allow user processes to call into
    the kernel to ring doobells without overflowing.
    
    Add DB Full/Empty/Drop stats.
    
    Mark queues when created indicating the doorbell state.
    
    If we're in the middle of db overflow avoidance, then newly created
    queues should start out in this mode.
    
    Bump the C4IW_UVERBS_ABI_VERSION to 2 so the user mode library can
    know if the driver supports the kernel mode db ringing.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit cac2f1cf7b37e7f5dce0f4bb825dbac25ca2eaa2
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 14:55:12 2011 +0530

    iw_cxgb4: Add debugfs rdma memory stats
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 25e987ea1273ecaf6f2bdd9c8065e0688eed92f2
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 14:50:58 2011 +0530

    cxgb4: DB Drop Recovery for RDMA and LLD queues.
    
    - recover LLD EQs for DB drop interrupts.  This includes adding a new
    db_lock, a spin lock disabling BH too, used by the recovery thread and
    the ring_tx_db() paths to allow db drop recovery.
    
    - cleaned up initial db avoidance code.
    
    - add read_eq_indices() - allows the LLD to use the pcie mw to efficiently
    read hw eq contexts.
    
    - add cxgb4_sync_txq_pidx() - called by iw_cxgb4 to sync up the sw/hw pidx
    value.
    
    - add flush_eq_cache() and cxgb4_flush_eq_cache().  This allows iw_cxgb4
    to flush the sge eq context cache before beginning db drop recovery.
    
    - add module parameter, dbfoifo_int_thresh, to allow tuning the db
    interrupt threshold value.
    
    - add dbfifo_int_thresh to cxgb4_lld_info so iw_cxgb4 knows the threshold.
    
    - add module parameter, dbfoifo_drain_delay, to allow tuning the amount
    of time delay between DB FULL and EMPTY upcalls to iw_cxgb4.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 3d1f7fbd230eba72ad01dd083836f89e8fbcbf54
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 14:47:52 2011 +0530

    cxgb4: Common platform specific changes for DB Drop Recovery
    
    - Add platform-specific callback functions for interrupts.  This is
    needed to do a single read-clear of the CAUSE register and then call
    out to platform specific functions for DB threshold interrupts and DB
    drop interrupts.
    
    - Add t4_mem_win_read_len() - mem-window reads for arbitrary lengths.
    This is used to read the CIDX/PIDX values from EC contexts during DB
    drop recovery.
    
    - Add t4_fwaddrspace_write() - sends addrspace write cmds to the fw.
    Needed to flush the sge eq context cache.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 4e7348d68824a5ef00adb064c6f79d5e5ae43c65
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 14:45:30 2011 +0530

    cxgb4: Detect DB FULL events and notify RDMA ULD.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit ac00593b245b861c2cb3934ac796525122afe02f
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Thu Nov 3 20:31:05 2011 +0530

    iw_cxgb4: Bring upstream commit 9efe10a1e1a1ab1dba0af0f520e0697f6e81ebf1
    
    Fail RDMA initialization for unsupported cards
    
    The iw_cxgb4 module crashes at init time if the T4 card does not
    support RDMA.  So clean up the init logic to correctly deal with
    non-RDMA cards.
    
     - If any RDMA resources are not available, then fail the initialization
       logging an info message.
     - Clean up properly on initialization failures.
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 0771d27ed6315505e359c2fb269c8f5302ffcd82
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Fri Nov 4 09:08:28 2011 -0700

    NFSRDMA: patches for 2.6.34
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 5a94a269b2710c952ab06bbc56b181e36b4944e6
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Oct 28 13:24:40 2011 -0400

    IB/qib: Fix panic in RC error flushing logic
    
    From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    
    The following panic can occur when flushing a QP:
    
    RIP: 0010:[<ffffffffa0168e8b>]
    [<ffffffffa0168e8b>] qib_send_complete+0x3b/0x190 [ib_qib]
    RSP: 0018:ffff8803cdc6fc90  EFLAGS: 00010046
    RAX: 0000000000000000 RBX: ffff8803d84ba000 RCX: 0000000000000000
    RDX: 0000000000000005 RSI: ffffc90015a53430 RDI: ffff8803d84ba000
    RBP: ffff8803cdc6fce0 R08: ffff8803cdc6fc90 R09: 0000000000000001
    R10: 00000000ffffffff R11: 0000000000000000 R12: ffff8803d84ba0c0
    R13: ffff8803d84ba5cc R14: 0000000000000800 R15: 0000000000000246
    FS:  0000000000000000(0000) GS:ffff880036600000(0000)
    knlGS:0000000000000000
    CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
    CR2: 0000000000000034 CR3: 00000003e44f9000 CR4: 00000000000406f0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process qib/0 (pid: 1350, threadinfo ffff8803cdc6e000, task ffff88042728a100)
    Stack:
    53544c5553455201 0000000100000005
    0000000000000000 ffff8803d84ba000
    <0> 0000000000000000 0000000000000000 0000000000000000 0000000000000000
    <0> 0000000000000000 0000000000000001 ffff8803cdc6fd30 ffffffffa0165d7a
    Call Trace:
    [<ffffffffa0165d7a>] qib_make_rc_req+0x36a/0xe80 [ib_qib]
    [<ffffffffa0165a10>] ?  qib_make_rc_req+0x0/0xe80 [ib_qib]
    [<ffffffffa01698b3>] qib_do_send+0xf3/0xb60 [ib_qib]
    [<ffffffff814db757>] ? thread_return+0x4e/0x777
    [<ffffffffa01697c0>] ? qib_do_send+0x0/0xb60 [ib_qib]
    [<ffffffff81088bf0>] worker_thread+0x170/0x2a0
    [<ffffffff8108e530>] ?  autoremove_wake_function+0x0/0x40
    [<ffffffff81088a80>] ? worker_thread+0x0/0x2a0
    [<ffffffff8108e1c6>] kthread+0x96/0xa0
    [<ffffffff8100c1ca>] child_rip+0xa/0x20
    [<ffffffff8108e130>] ? kthread+0x0/0xa0
    [<ffffffff8100c1c0>] ? child_rip+0x0/0x20
    RIP  [<ffffffffa0168e8b>] qib_send_complete+0x3b/0x190 [ib_qib]
    
    The RC error state flush logic in qib_make_rc_req() could return all of the
    acked wqes and potentially have emptied the queue.  It would then unconditionally try
    return a flush completion via qib_send_complete() for an invalid wqe, or worse
    a valid one that is not queued. The panic results when the completion code
    tries to maintain an MR reference count for a NULL MR.
    
    This fix modifies logic to only send one completion per qib_make_rc_req()
    call and vary the completion status as appropriate.
    
    The outer loop will call as many times as necessary.
    
    Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

--------------020507020407090205090103--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
