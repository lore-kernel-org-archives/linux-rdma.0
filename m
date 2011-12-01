From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4-rc5 is available
Date: Thu, 01 Dec 2011 16:01:59 +0200
Message-ID: <4ED788D7.6020205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100060909090209010000"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080100060909090209010000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4-rc5 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4-rc5.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 1.5.4

Regards,
Vladimir

Main changes from RC4:
----------------------
Updated packages:
libcxgb4-1.2.0
libnes-1.1.3
mstflint-1.4-1.18.g1adcfbf
perftest-1.3.0-0.56.gd6f6093

MPI:
mvapich2-1.7-5.2011svn5031

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






--------------080100060909090209010000
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.4-rc5.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.4-rc5.txt"

commit 3959e580f185dff9716a40d63c5cf838291ec78b
Author: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Sun Nov 27 21:28:09 2011 +0200

    mlx4_en: fix endianness with blue frame support
    
    The doorbell register was being unconditionally swapped. In x86, that
    meant it was being swapped to BE and written to the descriptor and to
    memory, depending on the case of blue frame support or writing to
    doorbell register. On PPC, this meant it was being swapped to LE and
    then swapped back to BE while writing to the register. But in the blue
    frame case, it was being written as LE to the descriptor.
    
    The fix is not to swap doorbell unconditionally, write it to the
    register as BE and convert it to BE when writing it to the descriptor.
    
    Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
    Reported-by: Richard Hendrickson <richhend-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
    Cc: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
    Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

commit 2455cce2e1356295c8dd90b19348d056b7c41c43
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Nov 28 14:23:38 2011 -0600

    RDMA/nes: Copyright Update
    
    Update Copyright information in the source files.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 2881d935f802e999a711ba93d878f1c1f51ac8cb
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Nov 28 11:18:26 2011 -0800

    NFSRDMA: Pull in patches for 2.6.38
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit aab970796ca78418884127029fd568cdb7351ad8
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Wed Nov 30 13:43:02 2011 +0200

    Revert "backport/2.6.32: Remove err.h to avoid redefinition"
    
    err.h is required by cxgb4 for kernel 2.6.32.12-0.7 (SLES11 SP1)
    Note: this cause redefinition compilation error on 2.6.32.36-0.5.
    
    This reverts commit 5e3a9bafd6033de4040c748fdff3b96559fc7765.

commit 4f413a89c6a8ea80982f434b26c44af583e1d4b7
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Nov 28 18:49:13 2011 +0530

    iw_cxgb4: Fix retry with MPAv1 logic for MPAv2
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit c604062fd2a3915317a4cd7367bb979ffd13040c
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Nov 21 13:58:01 2011 -0600

    RDMA/nes: fix undefine PAU debug flag
    
    Debug flag is not defined for PAU debugging
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 5fb3f55ab1b9bf3d20dc3516c3fed368c672308e
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Wed Nov 16 15:57:10 2011 -0800

    NFSRDMA: Rename 2.6.36 backport patches for proper application order
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 032cd631e0ae94ff932c01370c3443cd1feb56e9
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Nov 15 16:22:33 2011 -0800

    NFSRDMA: add for 2.6.36 - only need to patch net/sunrpc/xprtrdma files
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 1015ba4217752b315365a2acff791f41f5d08969
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Tue Nov 15 16:11:32 2011 -0800

    NFSRDMA: Pull in patches for 2.6.36
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 376c7a97717e3eea306455c63c83532ecd539eac
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Nov 21 17:29:54 2011 -0800

    NFSRDMA: And yet another patch for 2.6.37
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 53907b2eacd1bcf89f5377db582da847a0d1e930
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Nov 21 17:20:15 2011 -0800

    NFSRDMA: forgot a patch for 2.6.37
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 629ccc7d39c63b885716d1e6b867cf66c8e5c079
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Nov 21 17:05:24 2011 -0800

    NFSRDMA: Still a few more patches for 2.6.37
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 81c8a2f6454e87b167ab6f04de58fe8a741e0de1
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Nov 21 16:06:08 2011 -0800

    NFSRDMA: A few more patches for 2.6.37
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit ebe216e43888a7a02f7dac2070727686de7e839e
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Nov 21 11:47:12 2011 -0800

    NFSRDMA: Pull in patches for 2.6.37
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 24df8ec1ded0a084626179d92e6cebe1b53a0992
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Mon Nov 21 18:16:08 2011 +0100

    ehca: backports for RHEL-6.1
    
    Hi Vlad,
    
    please apply the following backport for OFED-1.5.4.
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit 5e3a9bafd6033de4040c748fdff3b96559fc7765
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Nov 24 15:30:13 2011 +0200

    backport/2.6.32: Remove err.h to avoid redefinition
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 8886d41fc20c5219de1dd0fae062cda063a407db
Merge: 0e618ff 344e7a3
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun Nov 20 10:08:49 2011 +0200

    Merge branch 'ofed_1_5_vipul' of git://openfabrics.org/~vipulp/ofed_kernel into ofed_kernel_1_5

commit 344e7a369c28466c51c631fd6878edf970679cd5
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Nov 18 19:59:07 2011 +0530

    cxgb4: Backports for Embed T4 firmware with the driver
    
    Remove already embedded T4 firmware from RHEL5.6, RHEL5.7 and SLES10SP4
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 75e84f0582851f755cb631cac95af19566c8053c
Author: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Fri Nov 18 19:49:00 2011 +0530

    cxgb4: Embed T4 firmware with the driver
    
    Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 0e618ffe6d6917dc024f771c4fc3ea67d8af9770
Author: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Sat Nov 19 00:49:22 2011 +0530

    cxgb4/iw_cxgb4: Use debugfs_remove in RHEL5.6 backport
    
    debugfs_remove_recursive is not available on RHEL5.6 platform.
    Use debugfs_remove instead.
    
    Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

commit 8571ea9cd9cedf1e525c777725896854a39414b6
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Wed Nov 9 14:16:19 2011 -0800

    NFSRDMA: A few more patches for 2.6.35
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 8c69be36661ebe75c16b1cbca4553029dc749a08
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Thu Nov 3 15:17:23 2011 -0700

    NFSRDMA: another patch for 2.6.35
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 922664ba2af4ab1f8bcd5e639b6e90fc05d1b9ee
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Thu Nov 3 14:26:20 2011 -0700

    NFSRDMA: pull in patches for 2.6.35
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit 9df2011694d8bb988c87545a8ac44f01b6f4660b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Sun Nov 13 11:39:31 2011 +0200

    ofa_kernel.spec: Replace deprecated Prereq by Requires
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit b65d82ad6bff55ba88bef025d2ac415d10180031
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Nov 10 14:23:03 2011 +0200

    mlx4: Update driver version
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--------------080100060909090209010000--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
