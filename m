From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.1 rc3 release is available
Date: Fri, 05 Mar 2010 11:22:19 +0200
Message-ID: <4B90CD4B.1080409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060606050002080809050206"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060606050002080809050206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OFED 1.5.1-rc3 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.1/OFED-1.5.1-rc3.tgz



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

Main changes from 1.5.1-rc2:
===========================
1. Updated packages:
     - ibutils: ibutils-1.5.3
     - libnes: libnes-1.0.1
     - perftest: perftest-1.2.3-0.10.g90b10d8
     - management: taken last release (included in OFED-1.5)
     - MPI:
           openmpi-1.4.1-2ofed
           mvapich2-1.4-4.20100302svn3789
2. Bug fixes







--------------060606050002080809050206
Content-Type: text/plain;
 name="ofed_kernel-1.5.1-rc2_rc3.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.1-rc2_rc3.log"

commit 8ebd395a39dd946c1e511055cd9559155b72aa19
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 4 10:35:48 2010 +0200

    mlx4_en: Querying multicast promisc capability
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6ec163ac88e42c741dea5c5f84c6c2cc0c84e59f
Merge: d2232d6 dfa995a
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Mar 4 10:16:52 2010 +0200

    Merge branch 'ofed_kernel_1_5' of ssh://sofa.openfabrics.org/home/ctung/scm/ofed-1.5 into ofed_kernel_1_5

commit dfa995a5246c4a2eeb7cf04bffdb2ee4e8a5ac38
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Mar 3 11:01:49 2010 -0600

    RDMA/nes: update backports for OFED 1.5.1 rc3
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 71d5375517945d0d7443eefab4160c3469f3c7a3
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Mar 3 10:14:22 2010 -0600

    RDMA/nes: clear stall bit befor destroying nic qp
    
    Clear the stall bit to drop any incoming packets while destroying nic qp.
    This will prevent a chip resource leak.
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit ee8147e700a7ac3c475451e8da0d55cc12ca8387
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Mar 3 09:17:03 2010 -0600

    RDMA/nes: fix CX4 link detection in back-to-back configuration
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 1dc9db9f5bed25f0686a8d23644c7e9a34e65391
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Mar 3 09:09:48 2010 -0600

    RDMA/nes: enhance ethtool stats
    Modified to read hdware registers for rcv/tx errors. Also added
    pbl resources and removed obsolete counters.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 5bae61f79080ee529e6cedc40f3a6924f83c1fc3
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Mar 3 09:07:27 2010 -0600

    RDMA/nes: Set assume_alligned_header bit
    set assume_alligned_header bit set in qp context as requested
    by hardware group.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit d2232d696e228437df456f067fe7b8f4abd5ebe4
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 3 14:57:09 2010 +0200

    mlx4_en: backports for running QUERY_PORT from workqueue
    
    The bonding driver in those kernels checks the slave state under spinlock
    which causes "scheduling while atomic" messages when execuring firmware commands.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e73e49f26a25303cae5bce5eaf3fe93306575b08
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Mar 3 09:59:30 2010 +0200

    mlx4_core: Canceled log_num_vlan module parameter
    
    Always set the VLAN table to the max size supported by HW
    When the table is full, the mlx4_en table reports this with
    debug message.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a6d1ee54bc11e33d64d8e46c6b7c493536134d98
Merge: 9f6cf0f 22f2895
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 2 14:18:59 2010 +0200

    Merge remote branch 'yevgenyp/ofed_kernel_1_5' into ofed_kernel_1_5

commit 9f6cf0f7276994e4aec4ca0de735460856d814cd
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Mar 2 09:27:31 2010 +0200

    mlx4: limit the max mtu for iboe to 2K
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 04fd9d8711b1f6e4fae4cd0f6533faf3ca115274
Merge: 9ee60aa 17961b3
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Mar 1 16:34:55 2010 +0200

    Merge remote branch 'amirv/ofed_kernel_1_5' into ofed_kernel_1_5

commit 17961b3a79b02740325a358400eff02314494b00
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Fri Feb 26 00:50:29 2010 +0200

    sdp: Stop SA Cancel timeout when getting SendSM/RdmaRdCompl
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 204b42b904b403b7b9986b40d244bb8901c5ab3c
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 25 11:43:03 2010 +0200

    sdp: SendSM wasn't sent sometimes after getting SrcAvailCancel
    
    * skb was freed if rx_sa is aborted - preventing SendSM
      to be sent.
    * Didn't update rx_sa->used in case of SrcAvailCancel
      and therefore not sending RdmaRdCompl.
      This also caused the next read to fail because offset
      wasn't updated
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d1697433335eb1e7c5256d4e7d94be6beca3d349
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 24 13:58:35 2010 +0200

    sdp: Send SendSM from recvmsg context and not from interrupt
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6bbc853c3b7fcc51d978030acc7bf4ba38c9f62e
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 24 10:59:31 2010 +0200

    sdp: Fix bug in crossing SrcAvail
    
    * Handle RdmaRdCompl in interrupt, before splitted to two Q's
      This way the handling is sequencial, and no race could occure
      between RdmaRdCompl and SrcAvailCancel
    * Fixed an error when checking that RdmaRdCompl is not for
      old SrcAvail
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ffea34c3e7cca1f01e6f2c966acfb6c6e59046c4
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 24 10:39:54 2010 +0200

    sdp: Add detailed ZCopy aborted send statistics
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9ee60aa56ff3b55e5df3f96cbddf6b2e060f86e0
Author: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Date:   Wed Feb 24 10:13:41 2010 -0600

    nfsrdma: Fix default return code in xs_nospace
    
    The xs_nospace fix I dropped had the wrong default return code.
    
    Signed-of-by: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 22f28959bfa9e54f35bb5818bbb17d0a3ea69929
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Feb 21 17:54:11 2010 +0200

    mlx4_en: updated driver version
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cabd2b9caf0d51331527277dfc0f41316735e3b7
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Feb 21 17:41:51 2010 +0200

    RH5.5 backports
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------060606050002080809050206--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
