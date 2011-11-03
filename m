From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4-rc3 is available
Date: Thu, 03 Nov 2011 19:19:13 +0200
Message-ID: <4EB2CD11.1000106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070203090107030202000303"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070203090107030202000303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4-rc3 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 1.5.4

Regards,
Vladimir

Main changes from RC2:
----------------------
Add new InfiniBand link speeds: EDR/FDR/FDR10

Updated packages:
libibverbs-1.1.4-1.24.gb89d4d7 (Add support for extended speeds)
opensm-3.3.12
infiniband-diags-1.5.11
dapl-2.0.34
mstflint-1.4-1.15.gdd62ac0
perftest-1.3.0-0.54.ge7b1832

MPI:
mvapich2-1.7-2.2011svn4978


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




--------------070203090107030202000303
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.4-rc3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.4-rc3.txt"

commit 3726b96ac402ea827f657b04f714604f15d3aec9
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Nov 2 15:34:06 2011 +0530

    iw_cxgb3: Bring upstream commit f7cc25d018f1e9af6767ee7774bbe83452e9fdf4
    
    Brings in upstream commit f7cc25d018f1e9af6767ee7774bbe83452e9fdf4
    (RDMA/cxgb3: Serialize calls to CQ's comp_handler)
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 3fdf450f54479b856282cbfaa8ec063f080ba109
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Nov 2 14:07:16 2011 +0530

    iw_cxgb4: Bring upstream commit d32ae393dbf0daf778f9e33b0bc6591cd102391e
    
    Brings in upstream commit d32ae393dbf0daf778f9e33b0bc6591cd102391e
    (RDMA/cxgb4: Mark QP in error before disabling the queue in firmware)
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 08ece10d89c5e4d77f32e6e0b5fb95c55b5ebfa1
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Wed Nov 2 13:53:43 2011 +0530

    iw_cxgb4: Bring upstream commit 581bbe2cd0694a935e0c3ccd7f011e10094f1df6
    
    Brings upstream commit 581bbe2cd0694a935e0c3ccd7f011e10094f1df6
    (RDMA/cxgb4: Serialize calls to CQ's comp_handler)
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 15b44c7266465fce8331109b32bb9e341830d51e
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Oct 31 11:39:05 2011 -0700

    NFSRDMA: forgot a patch for 2.6.33
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 672c06c6b4f077f4d8959aa27686139a40a63d5c
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Thu Oct 27 14:44:04 2011 -0700

    NFSRDMA: pull in patches for 2.6.33
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 8d0256647672bd29e19b8a0214eee6156d7da555
Merge: f4316c8 d4c3875
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 1 14:37:32 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~moranp/ofed_1_5 into ofed_kernel_1_5

commit f4316c83778f331719a62915648e5761482280a0
Author: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Mon Oct 31 21:02:38 2011 +0200

    Add new InfiniBand link speeds: EDR/FDR/FDR10
    
    Add a set of 4 patches that adds support to new speeds:
    
        FDR-10: a Mellanox proprietary link speed which is 10.3125 Gbps with
                64b/66b encoding rather than 8b/10b encoding.
        FDR:    IBA extended speed 14.0625 Gbps.
        EDR:    IBA extended speed 25.78125 Gbps.
    
    Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
    Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
    Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit d4c3875e82bc4e1c7426ee359492cdf4ba463db2
Author: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 18 13:34:44 2011 +0200

    sdp: Fix bug - sk_rmem_schedule prototype on SLES11sp1 - added new patch
    
    Added new patch that reverting
    sk_rmem_schedule prototype from (..., size) to (...,skb)
    as it is in SLES11sp1
    
    Reviewed by: Amir Vadai
    
    Signed-off-by: Moran Perets <moranp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5e929d0f8923909d2ba30e38a319f82d917595b0
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 25 23:42:44 2011 +0200

    Fix DOS formatted patches
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 634392ba843e000cf723843e6fdd6e07b8916eb6
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 25 20:51:33 2011 +0200

    Remove backport directories for unsupported kernels
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 284010f8b362bafaae49ff78216ece1fd46842ec
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Oct 24 21:33:36 2011 +0530

    cxgb4/iw_cxgb4/cxgb3/iw_cxgb3: Build fixes on 3.0 kernel
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit f3355da326c8c3c515579ab5d7d81e1840ac6a90
Merge: d78ef80 4f5f736
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 25 09:34:12 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 4f5f73682f4ee3e0f01f87b146c4a7993066867a
Author: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Mon Oct 24 15:27:53 2011 -0400

    IB/qib: Fix kernel panic on QME7342 boards
    
    Fix a kernel panic on QME7342 (and any Mezz boards without
    QSFP connectors) caused by scheduling work on uninitialized
    workqueue.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit d78ef801fbb0ff6c730badc1e243aae7f94e18f7
Author: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
Date:   Mon Oct 24 13:15:43 2011 -0500

    RDMA/cxgb4: Pull in upstream CQE flush fixes.
    
    Bring in changes fixing iw_cxgb4 cqe logic into OFED.
    These changes fix RQ QID / SQ QID mixups in insert/count
    functions in the t4_cqe.
    
    This fixes RDS crashes using iw_cxgb4.
    
    Signed-off by: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
    Signed-off by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit b3934a2f394968a17c3e1ad616d88040466c3a7c
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Oct 24 13:14:33 2011 -0500

    RDMA/cxgb3: Don't post zero-bye read if endpoint is going away.
    
    tx_ack() wasn't checking the endpoint state and consequently would
    attempt to post the p2p 0B read on an endpoint/qp that is closing
    or aborting.  This causes a null ptr dereference crash.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit d210814696b172e74429894146faaed14b836666
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Wed Oct 19 16:03:09 2011 -0700

    NFSRDMA: forgot a few patches for RHEL6.1 Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 1a6a3ce37e4abb80931511c062aeee68c93ecd27
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Oct 11 11:59:11 2011 -0700

    NFSRDMA: pull in more patches for RHEL6.1 - builds successfully Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit bf875708fd802abf5752d553344bc47720fe6888
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Oct 11 11:14:13 2011 -0700

    NFSRDMA: pull some patches for RHEL6.1 Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit e6aea89795cda479b5dc138d95b28d425a01174d
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Sun Oct 23 13:47:46 2011 +0200

    RHEL6.1: remove carriage returns from DOS-formatted patches
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit c05033a8d23010081fc2da9948fb9753a6b271c4
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Oct 21 18:25:27 2011 +0530

    iw_cxgb4: Use NIPQUAD in RHEL5.6/RHEL5.7 backports
    
    %pI4 is not available on rhel56/rhel57 so, use NIPQUAD instead.
    Also fix few build warnings.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

--------------070203090107030202000303--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
