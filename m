From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5 rc5 release is available
Date: Fri, 18 Dec 2009 00:16:34 +0200
Message-ID: <4B2AADC2.4040409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000302050200030007070700"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000302050200030007070700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5-rc5 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc5.tgz

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
         - kernel.org <http://kernel.org/>: 2.6.29, 2.6.30, 2.6.31 and 2.6.32


       * Minimal QA for these versions

Systems:
       * x86_64
       * x86
       * ia64
       * ppc64


Main changes from 1.5 rc4:
============================
1. Updated packages:
    perftest-1.2.3-0.8.g196d994.tar.gz

      - Management packages:
	infiniband-diags-1.5.4.tar.gz
	libibmad-1.3.4.tar.gz
	libibumad-1.3.4.tar.gz
	opensm-3.3.4.tar.gz

2. Bug fixes
     See attached.




--------------000302050200030007070700
Content-Type: text/csv;
 name="bugs-2009-12-17.csv"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bugs-2009-12-17.csv"

bug_id,"bug_severity","priority","op_sys","assigned_to","bug_status","resolution","short_short_desc"
1729,"normal","P3","All","amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","Driver restart, after running sdp tests, results in kernel panic"
1800,"critical","P3","RHEL 5","amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","iperf sdp on ppc cause to client machine to dead lock"
1852,"normal","P3","CentOS 5","jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org","RESOLVED","FIXED","NFSoRDMA: Can't restart NFS server"
1849,"major","P1","Other","eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","oops when connecting with RDMA-CM over a loopback"
1867,"blocker","P1","Other","vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","IPoIB exports lro_flush_all() which conflicts with igb on RHEL 4 U8"
1812,"critical","P2","SLES 11","amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","SDP fails during init_qp"
1756,"major","P2","SLES 10","Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org","RESOLVED","FIXED","NFS Inode reference error"
1802,"major","P1","SLES 11","eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","CLOSED","FIXED","IB multicast attach cause kernel oops (from user/kernel)"

--------------000302050200030007070700
Content-Type: text/plain;
 name="ofed_kernel-1.5-rc4_rc5.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5-rc4_rc5.log"

commit c4b755ced0d5b60191ec4f00289cd4272866c65b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 17 12:04:15 2009 +0200

    Add 2.6.32 kernel support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c97e720ff5c252d3f1ccbc7d4ebdc02b79cac618
Merge: 890154b... 47542fd...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 17 08:18:49 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6 into ofed_kernel_1_5

commit 890154bcad6cea2a0884fdb8a9398a4d2f83c6ca
Merge: 6617c6a... 71bf534...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 17 08:16:59 2009 +0200

    Merge branch 'code-drop/20091216' of git://git.openfabrics.org/~agrover/ofed_1_5/linux-2.6 into ofed_kernel_1_5

commit 47542fd9bd8a6893a465a553209674d83f3f661e
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Wed Dec 16 17:19:55 2009 -0800

    IB/qib: fix RHEL 4 U8 backport for /dev/ipath
    
    The /dev/ipath* files were not being created by udev because
    a "dev" file in /sys/class/ipath/... was not created. Newer versions
    of udev don't seem to have this requirement. Also, vmalloc_to_page()
    doesn't seem to check for zero and panics the system so fix that too.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 52bda772f225ec11a011f05c61ca97d85e6024db
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Wed Dec 16 17:18:22 2009 -0800

    IB/qib: set serdes parameters based on QSFP data and attenuation
    
    The code to set the serdes parameters was rather ad-hoc and based
    on early releases of vendor's cables before the full QSFP data was
    programmed. This patch makes the process more robust and uses the
    attenuation field if available.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 6617c6af3326dae1363bcba40158e02d19e02143
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 16 20:15:33 2009 +0200

    mlx4_en: Added device ids table
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6b1c739631ecde05bc674d2351e28d93a6c7f8f4
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 16 20:14:13 2009 +0200

    mlx4_core: Added CX3 device IDs
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 71bf5340293416a450b7602a2974767ee0d2e1f2
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Dec 14 14:38:56 2009 -0800

    RDS: sendmsg() should check sndtimeo, not rcvtimeo
    
    Most likely cut n paste error - sendmsg() was checking sock_rcvtimeo.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit f44833d17d7d3aa46f8cc9633e4322193a2fdc79
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 15:43:14 2009 +0200

    ipoib: remove RH4.8 backport
    LRO backport is not required on RH4.8
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c148e3b2719aa7b1aeeb29f31c3eabb97192804f
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 15:08:05 2009 +0200

    mlx4_en: Updated driver version and date
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 274d7d19e99f6c7cf3920db57657dcb44ede3707
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 14:46:01 2009 +0200

    mlx4_en: Compilation warning fix on 32 bit systems
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c03011092215ec5b686e56caad419c4f9ba1b27a
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 14:17:34 2009 +0200

    mlx4_core: Cleanup for port type configuration
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 806ede537437fedff7cb5e6eca19d7b01d2b3f34
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 13:37:53 2009 +0200

     mlx4_en: Fix a crash with prioritiesed vlan packets
    
    Ensure that packets are assigned to rings according to
    priorities only when pfcrx is enabled, otherwise, go through
    the "regular" hash mechanism
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7a754bf9bde2cc2891b959f54044dfd3c2657293
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 10:10:58 2009 +0200

    Revert "rdma/cm: Fixup IPv6 support and IPv4 routing corner cases for RDMA CM"
    
    This reverts commit 430a426e24df958ea0a89cdf22030b4ba2da5bfb.

commit f5807d0d3b6bce6a6351b8a328eeb927977d0363
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 15 10:10:51 2009 +0200

    Revert "Backport patches for rdma cm"
    
    This reverts commit 87e6436fbeb514e97b02e0364854c010e1f4ac5c.

commit 262d44220b10172f3de9b04a55e5a19735f4eb40
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Dec 14 09:57:41 2009 +0200

    nfsrdma: Fix NFS Inode reference error
    https://bugs.openfabrics.org/show_bug.cgi?id=1756
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit f68fb1fba76137a61dd81d74104166737b72aaec
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 10 19:15:43 2009 +0200

    kernel_addons: for fcoe RH5.4
    
    if_ether.h: adding print_mac inline
    compiler.h: adding maybe_unused define for if_ether above
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 87e6436fbeb514e97b02e0364854c010e1f4ac5c
Author: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Sun Dec 13 17:29:07 2009 +0200

    Backport patches for rdma cm
    
    Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 430a426e24df958ea0a89cdf22030b4ba2da5bfb
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 12:25:04 2009 +0200

    rdma/cm: Fixup IPv6 support and IPv4 routing corner cases for RDMA CM
    
    Signed-off-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-of-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4683b8715524fd1a8360a792ee6674ef7aced112
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 13 09:52:16 2009 +0200

    sdp: small spec compliancy fixes in code
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------000302050200030007070700
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------000302050200030007070700--
