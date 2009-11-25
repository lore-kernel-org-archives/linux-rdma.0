From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5 rc3 release is available
Date: Wed, 25 Nov 2009 14:14:06 +0200
Message-ID: <4B0D1F8E.5020809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010507090801010005060907"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------010507090801010005060907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OFED 1.5-rc3 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5

Vladimir & Tziporet

========================================================================


Release information:
--------------------
Linux Operating Systems:
        - RedHat EL4 up6:       2.6.9-67.ELsmp
        - RedHat EL4 up7:       2.6.9-78.ELsmp
        - RedHat EL4 up8:       2.6.9-89.ELsmp
        - RedHat EL5 up2:       2.6.18-92.el5
        - RedHat EL5 up3:       2.6.18-128.el5
        - RedHat EL5 up4:       2.6.18-164.el5
        - SLES10 SP2:           2.6.16.60-0.21-smp
        - SLES10 SP3:           2.6.16.60-0.54-smp
        - SLES11:               2.6.27.19-5-default
        - OEL 4 up7             2.6.9-78.ELsmp
        - OEL 5 up2             2.6.18-92.el5
        - CentOS5.2             2.6.18-92.el5
        - CentOS5.3             2.6.18-128.el5
        - Fedora Core11         2.6.29              *
        - OpenSuSE 11           2.6.25.5-1.1        *
        - kernel.org <http://kernel.org/>: 2.6.29 and 2.6.30


      * Minimal QA for these versions

Systems:
      * x86_64
      * x86
      * ia64
      * ppc64


Main changes from 1.5 rc2:
============================
1. Updated packages:
     libipathverbs-1.2.tar.gz
     ibutils-1.2-0.1.ge8e69b7.tar.gz
     ib-bonding-0.9.0-41.src.rpm
     rnfs-utils-1.1.5-10.OFED.src.rpm

     - Management packages:
     libibumad-1.3.3_20091118_f25da9f.tar.gz
     libibmad-1.3.3_20091118_f25da9f.tar.gz
     opensm-3.3.3_20091118_f25da9f.tar.gz
     infiniband-diags-1.5.3_20091118_f25da9f.tar.gz

     - MPI packages:
     mvapich-1.2.0-3532.src.rpm (Bug fixes)
     mvapich2-1.4-2.src.rpm
     mpitests-3.2-916.src.rpm (Updated IMB and OSU benchmark tests)

2. Bug fixes
    See attached.


Limitations:
============
- SLES10 SP3 on IA64 is not supported yet


--------------010507090801010005060907
Content-Type: text/plain;
 name="ofed_kernel-1.5-rc2_rc3.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5-rc2_rc3.log"

commit bb49143753189b46c195635972e44ee512e5ee5c
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 24 17:14:23 2009 +0200

    From 134e8ba45ac49b773ba912726b4faee6a2839fab Mon Sep 17 00:00:00 2001
    From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Date: Tue, 24 Nov 2009 17:06:35 +0200
    Subject: [PATCH] mlx4: properly mask MGM entry members count
    
    The members_count field size is 24 bits so mask it properly when reading it.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f78229e5764dd2c354adc36c766b166fb21dc24d
Merge: 9b7e7cf... cc39d9d...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 24 13:25:48 2009 +0200

    Merge branch 'ofed_1_5' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/~swise/scm/ofed_kernel into ofed_kernel_1_5

commit 9b7e7cf0b17afbc9aa0844e46338101aed0db032
Merge: 9cf376f... ea2b694...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 24 10:43:47 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~amirv/ofed_1_5 into ofed_kernel_1_5

commit ea2b694c1a744fb9ece2724dedd43b4b9efc046b
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 24 09:33:53 2009 +0200

    sdp: Fixed annoying warning by memtrack
    
    kzalloc done in sdp_seq_open is freed by the system in a function
    that memtrack can't see. Therefore it printed false warning.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ab7b734e930d22a25f904c47e4f4898718cb150c
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 24 09:32:39 2009 +0200

    sdp: fixed BUG1796 - running out of memory on rx
    
    rcv queue could grow endlessly because minimal RX buffers in QP
    was set to SDP_MIN_TX_CREDITS + 1 - so there always were credits
    available for the sender.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ae23d8839e308cd28f0d75ce98fb7dc247c9459b
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 23 13:29:41 2009 +0200

    sdp: fixed sparse warnings
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cc39d9d3858d37bf45ac58f880a36b9a2f2a8e8d
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Nov 23 11:46:02 2009 -0600

    cxgb3: pull in page unmap fix.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 9cf376f7bad5bf5e52ca9ad0437c94e03115a30e
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 23 18:24:26 2009 +0200

    mlx4_core: Added missing device ID's
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 29fbed919ea2c66a322d2c4c179b39c481292c93
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 23 12:32:58 2009 +0200

    Fixed 'round_jiffies_relative' definition in timer.h backports
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 33518d251b6893262f7946243d5913511f29499e
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 22 15:42:20 2009 +0200

    mlx4_core: Revert commit 2d455685bfb144e60adde8e76737fa820bea9c3c
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c442f6facdb64025a73c44452813f57bb4ef51ef
Author: Brian J. Murrell <brian-xsfywfwIY+M@public.gmane.org>
Date:   Fri Nov 20 13:33:57 2009 -0600

    Fix SLES10sp2 compile issue of ipv6_addr_loopback being redefined
    
    Signed-off-by: Brian J. Murrell <brian-xsfywfwIY+M@public.gmane.org>

commit 750c71bed3b4d22532134958ce853e8808bc6c84
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Fri Nov 20 13:31:25 2009 -0600

    Fix NFS compile warning on SLES11
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 9567e1bfde37ecac308ae28cebd90af6e353761a
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Nov 19 10:07:06 2009 -0600

    Fix build break caused by the 1671 patch not adding the new file
    locations for SLES11_update and SLES10sp3.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 3e1f93df6696c7d07414c6e584a30b3459152061
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 19 16:21:01 2009 +0200

    Fixed workqueue backport for 2.6.18 and 2.6.19 systems
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3097e6ac88b1ae0f2e655bca7e688891a5cf64e4
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 19 10:53:26 2009 +0200

    Fixed workqueue backport for Sles10 systems
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3d459694b83b66b08e6722fbab873a7f78b66bcd
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Wed Nov 18 17:46:30 2009 -0600

    The EADDRNOTAVAIL patch causes more problems than it solves.  Remove it.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit e0d151154a46ce6d77ea39e3a072d621b7e6dabc
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Jul 30 17:41:24 2009 -0500

    Lustre has a requirement to use either the Native OS version of NFS or
    the OFED version of NFS.  When disabling the OFED NFS to use the Native
    NFS, there are headerfile conflicts between what Lustre expects to be
    there and what actually is there.  This patch works around this issue by
    relocating the NFS specific headerfiles to a unique location and only
    references them there if OFED NFS is selected.
    
    This patch resolves bug 1671.
    
    Signed-Off-By: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit f6d607f1d80de11ef9a01fc0517d2ad6e1936a06
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Nov 16 14:08:23 2009 -0600

    Not all of the calls to send_write are properly handling the error case
    and unmapping the outstanding ib_dma_maps when an error is encountered.
    Also, send_write is not returning en error when the connection is closed
    while it is sleeping waiting for free slots on the send queue.  This
    patch corrects the calls to send_write that did not cleanup after
    themselves and now returns an error if the connection is closed in all
    cases.
    
    This fixes bug 1824.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 1d9c4ee11209429a009aa10f6a35b85984a80c26
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Nov 16 13:54:16 2009 -0600

    Undo commit e692689e3b77c0cdd7594bb225c09a0767899693
    
    The change was unneeded and provides no fix for NFSRDMA running over ConnectX.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 064b54f7d9923da072eae74f97e1f695474b7f01
Author: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Date:   Wed Nov 18 13:19:15 2009 +0200

    ofed_scripts: Do not remove slaves before stopping stack
    
    There is no need to unenslave IPoIB interfaces before stopping the stack.
    This can cause a kernel crash as described in
    https://bugs.openfabrics.org/show_bug.cgi?id=1821
    
    Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 2d455685bfb144e60adde8e76737fa820bea9c3c
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 18 10:49:18 2009 +0200

    mlx4_core: Using QUERY_STAT_CFG for port enablement
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6f4b4859c0735de0e2aab4fcdc4efd677b34bf2f
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 18 10:48:44 2009 +0200

    mlx4_core: Added transceiver type to QUERY_PORT
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4e0958d8db84ec233a75d289f7d636f974741d9d
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 17 18:20:22 2009 +0200

    mlx4_core: Updated 'cancel_delayed_work_synch' backport
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 69907e1c6d6d8b5751ec34d4f162bac60f563a2d
Merge: 9fac87d... a9b3185...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 12 10:00:50 2009 +0200

    Merge branch '1822' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/home/jon/scm/ofed_kernel-1.5 into ofed_kernel_1_5

commit 9fac87ded0d34d79b82a932a46c63e0c91c33c0c
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 11 10:12:43 2009 +0200

    mlx4: Saving port configuration
    
    Added a list of port configurations per PCI device,
    now when the driver is recovering from catastrophic event
    it will be able to restore its previous configuration.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c0ac820ae29daf121271b0b3a2c9f042ff651b4c
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 10 17:09:32 2009 +0200

    mlx4: Default value for automatic completion vector selection
    
    When the vector number passed to mlx4_cq_alloc is MLX4_LEAST_ATTACHED_VECTOR (0xffffffff),
    the driver selects the completion vector that has the least CQ's attached
    to it and attaches the CQ to the chosen vector.
    IB_CQ_VECTOR_LEAST_ATTACHED is defined in rdma/ib_verbs.h, when mlx4_ib driver,
    recieves this cq vector number, it uses MLX4_LEAST_ATTACHED_VECTOR an CQ creation.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a9b3185fc5fed02ef73219239ba6226bfa6451f0
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Nov 10 14:44:37 2009 -0600

    SLES11 kernels linux-2.6.27.25-0.1 and greater have redefined the
    vm_operations_struct to be different than the one that shipped in SLES11
    GA (linux-2.6.27.19-5).  This breaks compilation on the newer kernels.
    This patch modified NFS to refer to the new definition of that struct.
    
    This patch fixes bug 1822
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 9574afc6c3b78ff20e2041810aa02fedb19c4216
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Nov 10 14:19:03 2009 -0600

    The SLES11 kernel updates have redefined some structs needed by NFS,
    thus causing build breaks on the updated kernels.  Since there is no
    elegant way to differentiate between the versions, a separate backport
    must be made for the updated kernels.
    
    Needed for bug 1822
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 97ea31f3aad9b31d4bf1e2845fe33505b6d08998
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 9 02:25:25 2009 +0200

    mlx4/IB: Add set_4k_mtu module parameter.
    
    It control Infiniband link MTU for all IB ports in a host.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 51df451753f115f271198e14c7df51ada82e2d93
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 8 16:33:35 2009 +0200

    IPoIB: fix crashes when creatig a child interface
    
    In kernels < 2.6.17, netdev_register_sysfs() is called only when rtnl_unlock()
    gets called so we can't add files to sysfs from within ipoib_vlan_add() since
    it hold rtnl lock. The solution is to free it the lock and acquire it again so
    netdev_register_sysfs() gets called. This fixes bug #1770.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2d4234db198f0b2e1f625a400ec98ebab2c2cbf2
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 8 12:32:37 2009 +0200

    IA64/backport: Fix SLES10 SP2/3 backports
    
    Signed-Off-By: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------010507090801010005060907
Content-Type: text/csv;
 name="bugs-2009-11-25.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2009-11-25.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxNzk2LCJj
cml0aWNhbCIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIs
IkZJWEVEIiwiUnVubmluZyBpcGVyZi0yLjAuNCB3aXRoIDFLIGJ1ZmZlciBjb25zdW1lcyB0
b28gbXVjaCBtZW1vcnkgb24gdGhlIHNlcnZlciBtYWNoaW5lIgoxNzcwLCJjcml0aWNhbCIs
IlAzIiwiUkhFTCA0IiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIs
Im9wZW5pYmQgcmVzdGFydCBhZnRlciBjb25maWd1cmUgcGtleSBvbiBSSDQgdXA4IGNhdXNl
IHRvIGtlcm5lbCBwYW5pYyIKMTgzMiwibWFqb3IiLCJQMyIsIlNMRVMgMTEiLCJlbGlAbWVs
bGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwic2FxdWVyeSBmYWlscyBpbiBSRE1B
b0Ugc3RhY2siCjE3MDksIm1ham9yIiwiUDMiLCJTTEVTIDExIiwiamFja21AbWVsbGFub3gu
Y28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwia2VybmVsIHBhbmljIGFmdGVyIHJ1bm5pbmcg
ZGQgdHJhZmZpYyBvdmVyIGEgbmZzLXJkbWEgdm9sdW1lLiIKMTgxMCwiY3JpdGljYWwiLCJQ
MyIsIlJIRUwgNSIsImpvbkBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJSRVNPTFZFRCIsIkZJ
WEVEIiwiT0ZFRC0xLjUtIE5GU292ZXJSRE1BLSAiIkxvY2sgdGVzdHMiIiBvZiBDb25uZWN0
YXRob24gZmFpbHMgdG8gcnVuIG9uIFJIRUw1VTItMzIgYml0IHBsYXRmb3JtIgoxODIyLCJu
b3JtYWwiLCJQMyIsIlNMRVMgMTEiLCJqb25Ab3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIkNvbXBpbGF0aW9uIGVycm9yIGJ1aWxkaW5nIG9mYV9rZXJuZWwt
MS41L2ZzL25mcy9maWxlLmMiCjE4MjQsIm1ham9yIiwiUDMiLCJSSEVMIDUiLCJqb25Ab3Bl
bmdyaWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIkNhbGwgdHJhY2Ugb24g
TkZTb1JETUEgc2VydmVyIgoxODI1LCJjcml0aWNhbCIsIlAzIiwiUkhFTCA0Iiwiam9uQG9w
ZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJJbnN0YWxsYXRpb24g
b24gUkg0IHVwNiBzaG91bGQgaWdub3JlIHJuZnNfdXRpbHMgd2hpbGUgcm5mc191dGlscz15
ZXMiCjE2NDUsIm1pbm9yIiwiUDMiLCJTTEVTIDExIiwibW9uaXNAdm9sdGFpcmUuY29tIiwi
UkVTT0xWRUQiLCJGSVhFRCIsIkFkZCAiImliLWJvbmRpbmcgbm90IHN1cHBvcnRlZCBvbiBT
TEVTMTEiIiB0byBSLk4iCjE4MjEsIm1ham9yIiwiUDMiLCJSSEVMIDUiLCJtb25pc0B2b2x0
YWlyZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiQ3Jhc2ggaW4gYm9uZGluZyIKMTY2Mywi
YmxvY2tlciIsIlAzIiwiUkhFTCA1Iiwib3JlbmtAZGV2Lm1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIm1zdGZsaW50IGNyYXNoaW5nIG9uIEhQIGdlbjYgaG9zdHMgcnVu
bmluZyBSSEVMIDUgLSBIQ0FzIGNhbm5vdCBiZSB1c2VkIGF0IGFsbC4iCjE3ODEsImJsb2Nr
ZXIiLCJQMyIsIk90aGVyIiwidmxhZEBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklY
RUQiLCJGYWlsZWQgY28gY29tcGlsZSBPRkVEMS41IFJDMSBvbiBpYTY0IHdpdGggc2xlczEw
IHNwMyIKMTgzNiwiYmxvY2tlciIsIlAzIiwiT3RoZXIiLCJ5ZXZnZW55cEBtZWxsYW5veC5j
by5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJFcnJvcnMgbG9hZGluZyBtbHg0X2liLCByZWdy
ZXNzaW9uIHNpbmNlIDEuNS1yYzIiCjE2NzEsImJsb2NrZXIiLCJQMSIsIk90aGVyIiwiam9u
QG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJORlNSRE1BIGJh
Y2twb3J0IGhlYWRlcnMgYmVpbmcgdXNlZCBldmVuIHdoZW4gTkZTUkRNQSBpcyBub3QgYmVp
bmcgdXNlZCIKMTgzOCwiYmxvY2tlciIsIlAxIiwiT3RoZXIiLCJqb25Ab3BlbmdyaWRjb21w
dXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIltSRUddT0ZFRC0xLjUgOiBPRkVELTEu
NS0yMDA5MTExOS0wOTE1IGluc3RhbGx0aW9uIGZhaWxzIHdoaWxlIGluc3RhbGxpbmcgcm5m
cy11dGlscyBSUE0uIgoxODI5LCJibG9ja2VyIiwiUDEiLCJSSEVMIDUiLCJrbGl0ZXluQG1l
bGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIltSRUddT0ZFRC0xLjUgLU9GRUQt
MS41LTIwMDkxMTE2LTA2MDAgaW5zdGFsbGF0aW9uIGZhaWxzIHdoaWxlIGJ1aWxkaW5nIGli
dXRpbHMgUlBNIG9uIFJIRWwgNXUzIDY0IGJpdCIKMTgzMCwiYmxvY2tlciIsIlAxIiwiUkhF
TCA1IiwicGVya2luam9AY3NlLm9oaW8tc3RhdGUuZWR1IiwiUkVTT0xWRUQiLCJGSVhFRCIs
IlJFR11PRkVELTEuNSAtT0ZFRC0xLjUtMjAwOTExMTUtMDYwMCBpbnN0YWxsdGlvbiBmYWls
cyB3aGlsZSBidWlsZGluZyBtdmFwaWNoMl9nY2MtMS40IFJQTSBvbiBSSEVsIDV1MyA2NCBi
aXQiCjE3NTgsIm5vcm1hbCIsIlAyIiwiT3RoZXIiLCJKZWZmcmV5LkMuQmVja2VyQG5hc2Eu
Z292IiwiUkVTT0xWRUQiLCJGSVhFRCIsIkhhbmcgaW4gYWRkcl9yZXNvbHZlX2xvY2FsKCkg
d2l0aCBpcHY2IGFkZHJlc3MuIgo1MDQsIm5vcm1hbCIsIlAyIiwiUkhFTCA0Iiwic2FzaGFr
QHZvbHRhaXJlLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJQbGVhc2UgLCB1bmlmb3JtaXpl
ICh1bmljYXN0KSBsaWRzIGRpc3BsYXkgaW4gZGlhZ3Mgb3V0cHV0IgoxODIwLCJibG9ja2Vy
IiwiUDUiLCJTTEVTIDEwIiwiam9uQG9wZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVE
IiwiRklYRUQiLCJPRkVELTEuNS1ORlNvdmVyUkRNQS1VbmFibGUgdG8gbW91bnQgdGhlIE5G
U292ZXJSRE1BIHNoYXJlZCBkaXJlY3Rvcnkgd2l0aCBORlMgQ2xpZW50IGFzIFNMRVMxMFNQ
Mi14ODYgYml0IGFuZCBORlMgU2VydmVyIGFzIFJIRUwtNXUzLXg4NiBiaXQgcGxhdGZvcm0i
CjE3NjIsImNyaXRpY2FsIiwiUDMiLCJPdGhlciIsInZsYWRAbWVsbGFub3guY28uaWwiLCJW
RVJJRklFRCIsIkZJWEVEIiwiRmFpbGVkIHRvIGNvbXBpbGUgZGFpbHkgb2ZlZCAoNC0xMC0w
OSkgb24gc2xlczEwIHNwMyIKMTc3NiwiY3JpdGljYWwiLCJQMyIsIlNMRVMgMTEiLCJ2bGFk
QG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIkFmdGVyIGluc3RhbGxpbmcg
T0ZFRDEuNSBSQzEgd2l0aCBjdXN0b21pemUgdG8gbG9hZCBNTFg0X0VOIG9wZW5pYmQgcmVz
dGFydCBmYWlsZWQiCjE3ODIsImJsb2NrZXIiLCJQMyIsIk90aGVyIiwidmxhZEBtZWxsYW5v
eC5jby5pbCIsIlZFUklGSUVEIiwiRklYRUQiLCJGYWlsZWQgdG8gY29tcGlsZSBPRkVEMS41
IFJDMSBvbiBwcGMgd2l0aCBzbGVzMTAgc3AzIgoxNzgzLCJibG9ja2VyIiwiUDMiLCJPdGhl
ciIsInZsYWRAbWVsbGFub3guY28uaWwiLCJWRVJJRklFRCIsIkZJWEVEIiwibWlzbWF0Y2gg
YnR3ZWVuIGRldmljZSBtY2FzdCBsaXN0IGFuZCBpcG9pYiBtY2FzdCBsaXN0IgoxNDc4LCJu
b3JtYWwiLCJQMyIsIk90aGVyIiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklY
RUQiLCJEbWVzZyBlcnJvciAiIm11bHRpY2FzdCBqb2luIGZhaWxlZCIiICBhZnRlciByZXN0
YXJ0aW5nIHRoZSBzdGFjayI=
--------------010507090801010005060907--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
