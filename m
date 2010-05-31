From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc1 is available
Date: Mon, 31 May 2010 23:10:42 +0300
Message-ID: <4C0417C2.8050204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000504040307050706050308"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000504040307050706050308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.2-rc1 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc1.tgz

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
    libibverbs-1.1.3-0.8.g4d733f4.tar
    libehca-1.2.2-0.1.g69e1a88.tar.gz
    libnes-1.0.1-0.3.g8d69734.tar.gz
    compat-dapl-1.2.17.tar.gz
    librdmacm-1.0.12.tar.gz
    dapl-2.0.28.tar.gz

    - Management
      infiniband-diags-1.5.6.tar.gz
      libibmad-1.3.5.tar.gz
      libibumad-1.3.5.tar.gz
      opensm-3.3.6.tar.gz

    - MPI
      openmpi-1.4.2-1.src.rpm

2. Added RHEL 6 beta support


Known issues:
=============
librdmacm-1.0.12 compilation fails on RHEL4.x




--------------000504040307050706050308
Content-Type: text/plain;
 name="ofed_kernel-1.5.2-beta1_rc1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.2-beta1_rc1.log"

commit b2f53cd53d470604bc002699ba905ee23892fa17
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 23 11:40:02 2010 +0300

    sdp: new debug function added, minor debug message change.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 41cc7a8a7805a6ce8ce8028fc8d9742867b0506c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 30 14:03:43 2010 +0300

    sdp: device removal rewritten for a stability improvement.
    
    main changes:
    1. device_removal_lock is better used.
    2. sdp_dev is marked NULL in order to prevent new sockets born to the removed
       device.
    3. new timeout functionality used when a reference count was taken for the CMA
       to return, but the CMA won't be invoked because rdma_id was destroyed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d96f1205fd59992c82fc64b63d3fcaa328976794
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 18 13:35:56 2010 +0300

    sdp: unnecessary local variable removed, 'const' declarations added
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9ad5e04ed192cf5daae49864cf4da54b89701900
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 18 13:32:27 2010 +0300

    sdp: tx timer is deleted when sockets goes to TCP_CLOSE
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 314569eb0bf4cf8fb40af7b5e82cbc362d001858
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 18 11:48:54 2010 +0300

    sdp: canceled a call to sdp_desroy_work() on send completion with error
    
    No need to destroy resources after send completion with error.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ba9dbc39149fb34fab383b190ca03c6d1017a92d
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 18 11:34:28 2010 +0300

    sdp: unnecessary wait-queue removed from sdp_sock structure.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit edda276773fd8f68d374990c2d1e91545ad2a5c0
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu May 27 11:06:19 2010 +0300

    Backport: Add missing dev_id sysfs file
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit dcfc4bb33fa2b8f5498fb6e1966af8731a28b6f7
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu May 27 09:59:15 2010 +0300

    Backport dev_id to 2.6.9
    
    Since dev_id does not exsist as a member of struct net_device in kernel 2.6.9,
    avoid using it in mlx4_en. I will add means to read dev_id in subsequent
    patches.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 977323bd115b8737604393fcf1af144fcc205507
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu May 27 09:02:02 2010 +0300

    mlx4_en: use net_device dev_id to indicate port number
    
    Today, there are no means to know which port of a hardware device a netdev
    interface uses. struct net_device conatins a field, dev_id, that can be used
    for that. Use this field to save the port number in ConnectX that is being used
    by the net device; port numbers are zero based.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 769f61e91bb6b02bd4608c960aef5fd13a6f8616
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu May 27 15:34:54 2010 -0500

    core: fix ib_detach_mcast to use rdma_node_get_transport
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 465f773a7c5d6747662c695812c32344ee027f3d
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu May 27 13:43:16 2010 +0300

    Fix bug from 369cd4c
    
    switch statement made on node type but case was made on node transport.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3049b4d808c185a127fd0ed44fd4e953929bafaf
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue May 25 13:14:03 2010 -0500

    RDMA/nes: fix incorrect unlock in nes_process_mac_intr
    
    commit ce6e74f2 introduced a problem where unlock took place only
    within an if statement.
    
    sparse warning:
    
    drivers/infiniband/hw/nes/nes_hw.c:2643:9: warning: context imbalance
    in 'nes_process_mac_intr' - different lock contexts for basic block
    
    Reported-by: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 780924cd294b8f65eb363c956f25670097eab2e2
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun May 23 12:45:55 2010 +0300

    Fix backports after 1081970
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit aad1ccb727c5bfbcdee7bec16199a4585f371f3a
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu May 20 15:29:06 2010 +0300

    mlx4: Use a simple definition for mac
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 67784413a873fedb365e00484b37944013102b6b
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon May 17 17:48:05 2010 +0300

    mlx4_ib: Fix GID table population
    
    When the MAC address of the corresponding ethernet interfaces changes we need
    to change the GID table to reflect that. This patch fixes this.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d6069614f7c1d0691268909e6d9964bcc73e9976
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri May 21 16:55:08 2010 -0500

    RDMA/nes: AE for closed QP causes crash
    
    modify_qp() closes qp and AE handling also attempts to close qp
    causing system to crash. Now we check the state of QP before
    processing the AE.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 1749f944f4abaace6b83e369cdc538295135707a
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri May 21 11:00:21 2010 -0500

    RDMA/nes: add missing include linux/vmalloc.h
    
    This will fix compilation errors on ia64 and ppc64.
    Also corrected copyright in nes_ud.c
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit c775d90d2c3708e36676c0abd4ae2a45987d9c70
Author: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed May 19 15:56:28 2010 -0500

    RDMA/nes: update backports
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit e59d19d08fe556e6fa45ff088f81b6d5dde69ede
Author: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed May 19 15:46:05 2010 -0500

    RDMA/nes: add support of iWARP multicast acceleration over
            IB_QPT_RAW_ETY QP type
    
    This patch implements iWarp multicast acceleration (IMA)
    over IB_QPT_RAW_ETY QP type in nes driver.
    
    Application creates a raw eth QP (IBV_QPT_RAW_ETH in user-space) and
    manages the multicast via ibv_attach_mcast and ibv_detach_mcast calls.
    
    Calling ibv_attach_mcast/ibv_datach_mcast has an effect of
    enabling/disabling L2 MAC address filters in HW.
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 369cd4cbcbabf2b3e640f6bdda92dc68cd814a03
Author: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed May 19 15:41:41 2010 -0500

    RDMA/core: add support for iWarp multicast acceleration over IB_QPT_RAW_ETY QP type
    
    The patch enables usage of attach_mcast()/detach_mcast driver
    specific verbs for iWARP devices.
    
    IB path is unchanged.
    iWARP path adds checking for raw ethernet QP type
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 4e2942978a2b1e87c21dc9df7cae6a0bb50cd0f7
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon May 17 16:13:29 2010 +0300

    mlx4_en: Reset transport header before accessing it in queue selection
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 47915c0dfe39ff480119be2f0ee9a2b4f2b6578b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon May 10 18:18:35 2010 +0300

    ofa_kernel.spec: Fix changelog
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ec2637db5c5f82cbc6697a51c2373723cf175e5b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon May 10 10:22:52 2010 +0300

    ofa_kernel: Support %install macro that removes RPM_BUILD_ROOT
    
    See,
    https://bugs.openfabrics.org/show_bug.cgi?id=2044
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c559c00f2fabd28ef9014422c3fb1866b9981a7b
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu May 6 17:16:18 2010 +0300

    mlx4: fix catching netdev events
    
    Avoid initializing in iboe->netdevs[port] in mlx4_ib_add. This is needed so the
    norifier callback will catch the change and update the GID table.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 60b02f41bcbd52921261740bdb4c0498d6940500
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 4 12:11:04 2010 +0300

    sdp: unnecessary local variable removed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2af1762d33356e45108eb3602ce895a242c669ae
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 4 12:05:56 2010 +0300

    sdp: debug message for reference count changed from CM_TW to CMA
    
    This debug message marks that the sdp_cma_handler() is expected to be invoked.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2a771281ee3bd9a1ad6a5012edc77b5630af3af4
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 4 11:43:29 2010 +0300

    sdp: BUG2031 - sdp_cma_handler() won't be invoked after last ref count removed
    
    rdma_id will be destructed in cases where the sdp_cma_handler() is not required any more.
    This will disable asynchronous-events handling after the last reference count removed.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 07640472e878c0baab88bfcff7eebff286bf4f94
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue May 4 14:44:52 2010 +0300

    mlx4: Fix invalidation of counter index
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e5fa8aa4ed5b08dfcc7d4f7035964ccbe9d21cfd
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon May 3 21:30:34 2010 +0300

    [PATCH] mlx4: Fix chunk sg list overflow in mlx4_alloc_icm()
    
      If the number of sg entries in the ICM chunk reaches MLX4_ICM_CHUNK_LEN,
    we must set chunk = NULL __even__ for coherent mappings (as is done for
    mthca). Otherwise we may overflow the sg list.
    
    Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

commit ce70b2380b09171152f3a827f18aff6523947555
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon May 3 14:33:49 2010 +0300

    mthca: update ib_ud_header_init parameters
    
    split mthca part of mlx4_1310_Add-support-for-RoCEE-address-resolution.patch
    and mlx4_1360_Add-vlan-support-to-IBoE.patch
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------000504040307050706050308--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
