From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5 rc4 release is available
Date: Fri, 11 Dec 2009 20:10:17 +0200
Message-ID: <4B228B09.9030907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090004070804000900050604"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090004070804000900050604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5-rc4 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc4.tgz

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
        - kernel.org <http://kernel.org/>: 2.6.29, 2.6.30 and 2.6.31


      * Minimal QA for these versions

Systems:
      * x86_64
      * x86
      * ia64
      * ppc64


Main changes from 1.5 rc3:
============================
1. Updated packages:
     libnes-1.0.0.tar.gz
     dapl-2.0.25.tar.gz
     compat-dapl-1.2.15.tar.gz

     - Management packages:
       libibumad-1.3.3_20091204_86353ad.tar.gz
       libibmad-1.3.3_20091204_86353ad.tar.gz
       opensm-3.3.3_20091204_86353ad.tar.gz
       infiniband-diags-1.5.3_20091204_86353ad.tar.gz

     - MPI packages:
       mvapich-1.2.0-3562.src.rpm
       openmpi-1.4-1.src.rpm

2. Bug fixes
    See attached.


Limitations:
============
- SLES10 SP3 on IA64 is not supported yet

--------------090004070804000900050604
Content-Type: text/plain;
 name="ofed_kernel-1.5-rc3_rc4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5-rc3_rc4.log"

commit 028c20d5e069a486aa23ef12ab3ff1707cac9cd8
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 10 15:18:22 2009 +0200

    Revert "mlx4_en: Controlling pfc parameters through sysfs interface"
    
    This reverts commit 62df0ecb9442f9c61ad7d1169bf8cba55504d073.

commit 8b554a1e3493e3aeab93b04f2f22fa5a9b4983df
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 10 15:17:19 2009 +0200

    Revert "mlx4_en: fix bug in mlx4_en_init_netdev"
    
    This reverts commit 8b276e57a9eca2f1b3f118db6ec1143cf15d06fe.

commit 003f147a4dce39bfadd10d253c75f3b799ae4142
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 10 10:32:09 2009 +0200

    Fix backports for 2.6.9 kernels
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2dd9441b2784e1d36d3025693f19a950cb1b39b8
Merge: 5f541de... f4996b2...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 10 09:37:56 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://sofa.openfabrics.org/~ctung/ofed-1.5 into ofed_kernel_1_5

commit f4996b2c3b72e2cb4c9b99e59f704adff7baad20
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Dec 9 20:47:19 2009 -0600

    RDMA/nes: udpate backports for RC4
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit ac0fd81fbc830f15e3e76d7b4baa2ceb0bfad7b2
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Dec 9 20:25:58 2009 -0600

    RDMA/nes: update for OFED 1.5 RC4
    
    add:
    
    nes_0019_max_cqe.patch - MAX CQE check on cq create.
    nes_0020_copyright.patch - update copyright
    nes_0021_stale_arp.patch - stale ARP fix
    nes_0022_sync_with_kernel_org.patch - match up with kernel.org content
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 5f541de203009c2bcc13c110f8b70cb976b0e0d2
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Wed Dec 9 12:16:03 2009 -0800

    IB/qib: fix backport patches for RHEL 5
    
    The RHEL 5 backports for the IPoIB device stop deadlock commit had
    a bug where the wrong work queue was being flushed.
    This updates the patches to use the correct flush.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit c4ce6250a52e5a2087bff72ca9ff0de6e57da169
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 9 17:07:17 2009 +0200

    Fix type of trigger_port()
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9662bcf2f8ab7b518b73bb9b2bd0b00646bd7ec7
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 9 16:49:40 2009 +0200

    mlx4_core: Bug fix in error flow
    
    If mlx4_init_port_info() fails, cleanup only the initialized ports.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8b276e57a9eca2f1b3f118db6ec1143cf15d06fe
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 9 16:37:38 2009 +0200

    mlx4_en: fix bug in mlx4_en_init_netdev
    
    device_create_file() returns 0 for success but was interpreted inversely.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e40765d9301e5338b14c47c0e1f03476743cabd4
Merge: 2e8a84a... 70f277e...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 9 10:36:53 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6/ into ofed_kernel_1_5

commit 2e8a84a1da45e8697eac96c6cbd6b6ec647f1a62
Merge: c4fab3c... 7df24af...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 9 10:27:25 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~vu/ofed_1_5 into ofed_kernel_1_5

commit 7df24afd49976f37d65f46107eed8cf97c45e31c
Author: Vu Pham (Mellanox) <vu-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Tue Dec 8 17:20:36 2009 -0800

    srpt: moving to scst svn tree revision 1370, fixing compilation error in rhel

commit 70f277ec61809c15b3352aa6b650882ebef05235
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Tue Dec 8 17:14:43 2009 -0800

    IB/qib: fix IPoIB device stop deadlock
    
    We create our own workqueue mainly because we want to be
    able to flush it when devices are being removed.  We can't
    use schedule_work()/flush_scheduled_work() because both
    unregister_netdev() and linkwatch_event take the rtnl lock,
    so flush_scheduled_work() can deadlock during device removal.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 9e829f8742501afefc49c1b16945322cd6577dfd
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Tue Dec 8 17:12:02 2009 -0800

    IB/qib: serdes changes for QME7342 serdes
    
    Because we now have different values of H1 all over, I redid the h1_vals
    code that we weren't really using, changed it to a single h1_val,
    and initialized for the board types that need different values.
    
    Signed-off-by: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 52cb89d80698f6cfdf7d58f0b0bbef85cd70dc69
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Tue Dec 8 17:11:22 2009 -0800

    IB/qib: added missing code to report if 7322 memory BIST failed
    
    Don't clear the memory built-in-self-test error bit so it gets reported.
    
    Signed-off-by: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 56d291199ea1479a441af974ab3f311b4703c897
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Tue Dec 8 17:10:35 2009 -0800

    IB/qib: improve twsi error messages for human beings
    
    Some people were confused by TWSI, so make messages somewhat clearer.
    
    Signed-off-by: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit c4fab3c6c271ee9058220b635aa06ba56a7cb381
Merge: a313d8c... 84bcab6...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 8 09:26:55 2009 +0200

    Merge branch 'code-drop/20091207' of git://git.openfabrics.org/~agrover/ofed_1_5/linux-2.6 into ofed_kernel_1_5

commit a313d8c8d92a7110fa449ec56bf9d00e43d7c05d
Merge: 1c024d1... a6581ab...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 8 09:23:15 2009 +0200

    Merge branch 'dev' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/home/jon/scm/ofed_kernel-1.5 into ofed_kernel_1_5

commit 1c024d191369acf7fbcb3fcac12c6c9446a87de8
Merge: 5726ece... 2b4ea21...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 8 09:21:25 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6/ into ofed_kernel_1_5

commit 84bcab6dfad5abb320ab01398b9914d1e97b6595
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Dec 7 16:06:53 2009 -0800

    RDS: Do not BUG() on error returned from ib_post_send
    
    BUGging on a runtime error code should be avoided. This
    patch also eliminates all other BUG()s that have no real
    reason to exist.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit a6581ab11513c78c17365ede289b39a607b2674e
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Dec 7 14:26:25 2009 -0600

    Pull NFS lockd fix from OFED 1.4.
    
    This fixes bug 1852.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 5addf35185806d5c469d9dae85381b7922e1a42b
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Fri Dec 4 17:14:15 2009 -0600

    Pull 2.6.30.* NFS fixes and update backports to play nice with fix patches
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 5726ece916d1bfc75d7fc6c14c8e8388ac5d0c40
Author: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Mon Dec 7 18:06:42 2009 +0200

    ipoib: unset IFF_XMIT_DST_RELEASE
    
    IPoIB need skb->dst in its start_xmit() function
    
    Tell dev_hard_start_xmit() to no release it by unsetting  IFF_XMIT_DST_RELEASE
    
    Signed-off-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ce583924b72ef17c2b7c6c43713c3879131b61b5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 7 16:20:17 2009 +0200

    Remove a wrong fix to bug #1172
    
    This bug has been fixed by commit 2767840 and the patch is redundnat.
    Fixes bug #1831
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 02c77c91e64360d7b2fe45e88bcc475f1769f453
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 7 15:47:17 2009 +0200

    ofa_kernel.spec: Create Module.symvers if it was not created by make
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b33f360190beb26b59604e9b31ae156ba51fd1d8
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Dec 7 15:31:58 2009 +0200

    sdp: fix lockup on mthca cards
    
    - rx_irq called sdp_sock_queue_rcv_skb() who calls
      sk->sk_data_ready() == sock_def_readable
    
    - sock_def_readable() can't be called from interrupt context
      because it takes read_lock (the writer to the lock uses
      write_lock_bh)
    
    - moved rx processing to tasklet
    
    sock_def_readable was trying to take read_lock
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 62df0ecb9442f9c61ad7d1169bf8cba55504d073
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 14:46:11 2009 +0200

    mlx4_en: Controlling pfc parameters through sysfs interface
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1505d8649481f95e9411e195475df37a3aca3099
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 13:37:09 2009 +0200

    mlx4_en: Added support to query and modify EEPROM via ethtool interface
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8f6c6c01d9fa99799e5f208714ad9141a1560799
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 13:31:52 2009 +0200

    mlx4_en: Validate port is up prior to transmitting
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1a5f53418ec894a61b422d2f98520067464929c2
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 13:30:50 2009 +0200

    mlx4_en: Reporting Link state events with KERN_INFO flag
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5d1025fb99191ce4208a140f34734c8b80a12b02
Merge: bc9e3a8... 8a5a101...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 6 09:58:51 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~amirv/ofed_1_5 into ofed_kernel_1_5

commit bc9e3a889fad30b18160ee72790c6fdef3e61831
Author: Sven-Thorsten Dietrich <sdietrich-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Date:   Wed Dec 2 17:27:44 2009 +0200

    Add 2.6.31 kernel support
    
    Signed-off-by: Sven-Thorsten Dietrich <sdietrich-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>

commit 8a5a10160d306f20a1c7b047b376f4c60863ab59
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 16:35:51 2009 +0200

    sdp: fix a warning in RH4.0
    
    never del uninitialized timer
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 99c7d4d1db6aaa053904cbedf167cd8ded925af3
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 15:32:03 2009 +0200

    sdp: Fix Hello Ack Header to be according to spec
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fe6c0ef9d9a90063f3274b9883e05432676cc692
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 30 18:56:36 2009 +0200

    mlx4: Turn on FCoE T11 bit in INIT_HCA
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5eb3469180e4a3fc822d09f6dbc4d8fc294bb9e9
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 25 19:38:17 2009 +0200

    Adding patches for mlx4_fc
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d856ed84c63f46aa1ca120cceb03073c35bb5e66
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 25 16:33:24 2009 +0200

    adding kernel_patches/fixes/mlx4_1250_query_steer_cap.patch
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 522415c247f6541086cc2366cd6d45a4f1c50cb7
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 23 17:30:32 2009 +0200

    fixes: rename mlx4 patch
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit adfa42e7a444a7a8671778f5a6b5c5ea5d83289f
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 18 17:58:24 2009 +0200

    kernel_patches: fixes to support mlx4_fc
    
    	Moving from kernel_patches/attic/fixes to kernel_patches/fixes
    
    Signen-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 40610bade37fb3563a19382ce7e9d6be5b784d24
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 18 17:54:27 2009 +0200

    kernel_patches: fixes to support mlx4_fc
    
        mlx4_1030_register_vlan_fix.patch no needed anymore
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit aa66718852a05b8a76b61b50261fb926a5e1d40c
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 2 09:06:37 2009 +0200

    sdp: make /proc/net/sdpprf on only if debug data is on
    
    This way, in performance measurements it is off and on regression
    it is on.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e7fcf0e97dd42ee70285b4efab144638ecbc6166
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 30 17:45:13 2009 +0200

    sdp: Cleanup ZCopy page registrations
    
    - use ib_umem_get instead of get_user_pages
    - Use FMR for RDMA reads
    - ZCopy sender side to use ib_umem
    - send remainder of ZCopy with BCopy
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b9e3b127bc904ef0bd9a3efb77bdf0c66a85f386
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 1 10:27:50 2009 +0200

    mlx4_core: Using selected vector number when setting EQ in cqc
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2b4ea21146db9d57dc2ac496149f8b047b5b6fa5
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Mon Nov 30 14:16:11 2009 -0800

    IB/qib: merge latest driver fixes
    
    This patch fixes several bugs found during testing.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit bbb6332fa221f8acaf30a984625ded6219565f2d
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Mon Nov 30 14:11:37 2009 -0800

    IB/ipath: Remove support for QLogic PCIe QLE devices
    
    The ib_qib driver is replacing the support for QLogic PCIe QLE devices
    and is removed from ib_ipath by this patch. The ib_ipath driver
    only supports the obsolete QLogic Hyper-Transport IB host channel
    adapter (model QHT7140).
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 840bbefeda26d21bffae6b7cdc88e981fcfb0a45
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Mon Nov 30 14:09:34 2009 -0800

    IB/core: allow HCAs to create IB port sysfs files
    
    This patch adds a new function to sysfs.c so that HCAs can
    create files in /sys/class/infiniband/<hca>/ports/<N>/.
    There is no need for an unregister function since the kobject
    reference will go to zero when ib_unregister_device() is called.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 829706f52d9182fdd82fee9b939e7db6b3dfb9cd
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Mon Nov 30 14:06:07 2009 -0800

    backport: export kobject_create_and_add() and kobject_init_and_add()
    
    Export the functions kobject_create_and_add() and kobject_init_and_add()
    so other modules can use them.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 56bfadef0b8fd97cfcd6b202f84d566ce6e9ccd3
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 30 16:14:14 2009 +0200

    sdp: cancel_work_sync on 2.6.22 didn't return a value
    
    Since the return value was used for debug message only,
    gave up this message to make backports easier.
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 108d9abbab4251aa6806b57bf84a8ea63caa73d4
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 30 15:04:05 2009 +0200

    sdp: fix compilation error on kernel 2.6.20
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c842ed79fe5811b2e42c3ea6fa5675125d5b4875
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Nov 30 09:47:45 2009 +0200

    mlx4: Fixed a bug in dynamic completion vector allocation
    
    The cq allocation function would return -EINVAL in case that it
    received MLX4_LEAST_ATTACHED_VECTOR as the vector number.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit ae054922723792dcc041cd920f7d2266573ef9ce
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Nov 29 14:23:58 2009 +0200

    sdp: changed important prints in zcopy to warning instead of debug
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit df44545b339ccee79de1e32c1262fc1fca28dfd3
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 26 17:10:57 2009 +0200

    sdp: flush rx_comp_work before destroying socket + make dreq_wait_timeout_work flushing synced
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f017beef52008747bbddcb520f1d57fe51747d5d
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Nov 26 17:28:58 2009 +0200

    sdp: cleaned up debug prints
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 926a7142d1edec675199066babb80c5c0775fb2e
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Tue Nov 24 15:35:51 2009 -0800

    RDS: Re-add pf/sol access via sysctl
    
    Although RDS has an official PF_RDS value now, existing software
    expects to look for rds sysctls to determine it. We need to maintain
    these for now, for backwards compatibility.
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit 773ff8caf5e1d24e5ada780ac18ac314994cc467
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 25 14:59:46 2009 +0200

    sdp: take a reference during zcopy_send
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bd02799a0716b9f4705376b854137ddaada660b3
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 25 15:06:01 2009 +0200

    sdp: Disable BZcopy + Enable ZCopy
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fda37e499eb8ba947a125a410441dcf3d89e73e1
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Nov 25 10:26:59 2009 +0200

    sdp: changed some warnings into debug prints
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4481a8ad8f83d9194b658f28b48c571f7aa4e921
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Nov 24 11:01:05 2009 +0200

    sdp: fixed BUG1826 part 1 - schedule while atomic
    
    Allocate skb according to context
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------090004070804000900050604
Content-Type: text/csv;
 name="bugs-2009-12-11.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2009-12-11.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxNzk2LCJj
cml0aWNhbCIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIs
IkZJWEVEIiwiUnVubmluZyBpcGVyZi0yLjAuNCB3aXRoIDFLIGJ1ZmZlciBjb25zdW1lcyB0
b28gbXVjaCBtZW1vcnkgb24gdGhlIHNlcnZlciBtYWNoaW5lIgoxODI2LCJjcml0aWNhbCIs
IlAzIiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQi
LCJJcGVyZiBzZHAgd2l0aCBtb3JlIHRoYW4gNTAgY29ubmVjdGlvbnMgY2F1c2UgdG8gY2Fs
bCB0cmFjZSBvbiBjbGllbnQgc2lkZSAoUkg1IHVwNCkiCjE4NDUsImJsb2NrZXIiLCJQMyIs
IlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIklw
ZXJmIG11bHRpIHN0cmVhbSBaQ29weSBjb3JydXB0IHNlcnZlcidzIG1lbW9yeSIKMTgwNCwi
bWFqb3IiLCJQMyIsIlJIRUwgNSIsImFuZHkuZ3JvdmVyQG9yYWNsZS5jb20iLCJSRVNPTFZF
RCIsIkZJWEVEIiwiUkRTIHBhbmljIgoxNjkxLCJtYWpvciIsIlAzIiwiQWxsIiwiYXJsaW4u
ci5kYXZpc0BpbnRlbC5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiZGFwbC11dGlscyBSUE0g
Y29uZmxpY3RzIHdpdGggY29tcGF0LWRhcGwtdXRpbHMgb24gU0xFUzExIGJ1dCBub3Qgb24g
U0xFUzEwIG9yIFJIRUw1IgoxODMxLCJjcml0aWNhbCIsIlAzIiwiUkhFTCA1IiwiZWxpQG1l
bGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIm9mZWQtMS41cmMyIGNyYXNoZWQg
UkhFTDUuNCBsaW51eCBrZXJuZWwgcnVubmluZyBJUG9JQiBiaS1kaXJlY3Rpb25hbCBVRCB0
ZXN0IgoxNzExLCJub3JtYWwiLCJQMyIsIk90aGVyIiwiamFja21AbWVsbGFub3guY28uaWwi
LCJSRVNPTFZFRCIsIkZJWEVEIiwibmZzcmRtYSBtb3VudCBmYWlsdXJlIG9uIDIuNi4zMC40
Igo2OTcsIm5vcm1hbCIsIlAzIiwiQWxsIiwiamltQG1lbGxhbm94LmNvbSIsIlJFU09MVkVE
IiwiRklYRUQiLCJzZHBuZXRzdGF0IC1hU3AgZG9lcyBub3QgcHJpbnQgcHJvZ3JhbSBuYW1l
IgoxODEwLCJjcml0aWNhbCIsIlAzIiwiUkhFTCA1Iiwiam9uQG9wZW5ncmlkY29tcHV0aW5n
LmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJPRkVELTEuNS0gTkZTb3ZlclJETUEtICIiTG9j
ayB0ZXN0cyIiIG9mIENvbm5lY3RhdGhvbiBmYWlscyB0byBydW4gb24gUkhFTDVVMi0zMiBi
aXQgcGxhdGZvcm0iCjE4MTUsIm1ham9yIiwiUDMiLCJSSEVMIDUiLCJqb25Ab3BlbmdyaWRj
b21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk5GU29SRE1BOiBtb3VudC5ybmZz
IG9uIGNsaWVudCBzaWRlIGRvZXMgbm90IHdvcmsiCjE4NTIsIm5vcm1hbCIsIlAzIiwiQ2Vu
dE9TIDUiLCJqb25Ab3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIs
Ik5GU29SRE1BOiBDYW4ndCByZXN0YXJ0IE5GUyBzZXJ2ZXIiCjE4MjEsIm1ham9yIiwiUDMi
LCJSSEVMIDUiLCJtb25pc0B2b2x0YWlyZS5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiQ3Jh
c2ggaW4gYm9uZGluZyIKMTgzNiwiYmxvY2tlciIsIlAzIiwiT3RoZXIiLCJ5ZXZnZW55cEBt
ZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJFcnJvcnMgbG9hZGluZyBtbHg0
X2liLCByZWdyZXNzaW9uIHNpbmNlIDEuNS1yYzIiCjE4NDksIm1ham9yIiwiUDEiLCJPdGhl
ciIsImVsaUBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJvb3BzIHdoZW4g
Y29ubmVjdGluZyB3aXRoIFJETUEtQ00gb3ZlciBhIGxvb3BiYWNrIgoxMjIxLCJub3JtYWwi
LCJQMiIsIlNMRVMgMTAiLCJKZWZmcmV5LkMuQmVja2VyQG5hc2EuZ292IiwiUkVTT0xWRUQi
LCJGSVhFRCIsIlNMRVMxMCBzcDI6IHJlbW90ZSBsb2dpbnMgdmlhIHNzaCBmYWlsIGR1ZSB0
byBycGNiaW5kIGFuZCBhdXRvbW91bnRlciBmYWlsdXJlcyIKMzksImVuaGFuY2VtZW50Iiwi
UDIiLCJBbGwiLCJqaW1AbWVsbGFub3guY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsImFkZCB6
Y29weSBzdXBwb3J0IHRvIG5vbi1BSU8gU0RQIgoxMDU0LCJub3JtYWwiLCJQMyIsIlJIRUwg
NSIsImVsaUBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIsIkZJWEVEIiwiSVB2NiB1bmFsaWdu
ZWQgYWNjZXNzIG9uIElBNjQgaG9zdHMiCjExNzIsIm1ham9yIiwiUDMiLCJSSEVMIDUiLCJl
bGlAbWVsbGFub3guY28uaWwiLCJDTE9TRUQiLCJGSVhFRCIsInNvZnQgbG9ja3VwIGluIGlw
b2liIGR1cmluZyBodyBkcml2ZXIgdW5sb2FkIgoxNzcwLCJjcml0aWNhbCIsIlAzIiwiUkhF
TCA0IiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJvcGVuaWJkIHJl
c3RhcnQgYWZ0ZXIgY29uZmlndXJlIHBrZXkgb24gUkg0IHVwOCBjYXVzZSB0byBrZXJuZWwg
cGFuaWMiCjE4NDgsIm5vcm1hbCIsIlAzIiwiU0xFUyAxMSIsImVsaUBtZWxsYW5veC5jby5p
bCIsIkNMT1NFRCIsIkZJWEVEIiwiQWZ0ZXIgU0VUX0lQT0lCX0NNPXllcyBhbmQgb3Blbmli
ZCByZXN0YXJ0LCBtb2RlIHN0aWxsIHN0YXlzIGRhdGFncmFtIG9uIHNsZXMxMSIKMTc4Mywi
YmxvY2tlciIsIlAzIiwiT3RoZXIiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwi
RklYRUQiLCJtaXNtYXRjaCBidHdlZW4gZGV2aWNlIG1jYXN0IGxpc3QgYW5kIGlwb2liIG1j
YXN0IGxpc3QiCjE3MjYsIm1ham9yIiwiUDEiLCJSSEVMIDUiLCJtb25pc0B2b2x0YWlyZS5j
b20iLCJDTE9TRUQiLCJGSVhFRCIsIkJvbmRpbmcgZmFpbHVyZSI=
--------------090004070804000900050604--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
