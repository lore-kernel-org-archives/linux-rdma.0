From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OFED 1.5 rc1 release is available
Date: Wed, 07 Oct 2009 16:53:03 +0200
Message-ID: <4ACCAB4F.3060807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080003000004010108060102"
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
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080003000004010108060102
Content-Type: multipart/alternative;
	boundary="------------000305000000050608000404"


--------------000305000000050608000404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OFED 1.5-rc1 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc1.tgz


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
       - SLES10 SP2:               2.6.16.60-0.21-smp
       - SLES10 SP3:               2.6.16.60-0.54-smp
       - SLES11:                      2.6.27.19-5-default
       - OEL 4 up7                  2.6.9-78.ELsmp
       - OEL 5 up2                  2.6.18-92.el5
       - CentOS5.2                  2.6.18-92.el5
       - CentOS5.3                  2.6.18-128.el5
       - Fedora Core11           2.6.29                 *
       - OpenSuSE 11             2.6.25.5-1.1        *
       - kernel.org <http://kernel.org/>:                 2.6.29 and 2.6.30


     * Minimal QA for these versions

Systems:
     * x86_64
     * x86
     * ia64
     * ppc64


Main changes from 1.5 beta:
============================
1. Added support for RHEL5.4 and SLES10 SP3
2. Updated packages:
    libibverbs-1.1.2-0.1.g49ac72c.tar.gz
    libcxgb3-1.2.5.tar.gz
    librdmacm-1.0.9.tar.gz
    dapl-2.0.23.tar.gz
    perftest-1.2.1-0.5.g68d9202.tar.gz
3. Bug fixes


Limitations:
============
- mthca does not compile on SLES11 on PPC64
- RDS kernel panic on RHEL 4.x

Changes from OFED-1.4.1
========================
1 General changes
 o Kernel code based on 2.6.30
 o RDS transport (TCP)
 o Added QIB driver

2 SDP
 o Performance improvements

3 uDAPL
 o New library

4 Management
 o OpenSM
   - Mesh Analysis for LASH routing algorithm.
   - Reloadable OpenSM configuration (preliminary implemented)
   - Routing paths sorted balancing (for UpDown and MinHops)
   - Weighted Lid Matrices calculation (for UpDown, MinHop and DOR).
   - I/O nodes connectivity (for FatTree).

5 MPI:
   - For now same versions as in OFED 1.4.1

--------------000305000000050608000404
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
OFED 1.5-rc1 is available<br>
<br>
Notes:<br>
<br>
The tarball is available on:<br>
<a class="moz-txt-link-freetext" href="http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc1.tgz">http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc1.tgz</a><br>
<br>
<br>
To get BUILD_ID run ofed_info<br>
<br>
Please report any issues in bugzilla <a
 href="https://bugs.openfabrics.org/" target="_blank">https://bugs.openfabrics.org/</a>
&nbsp;for<br>
OFED 1.5<br>
<br>
Vladimir &amp; Tziporet<br>
<br>
========================================================================<br>
<br>
<br>
Release information:<br>
--------------------<br>
Linux Operating Systems:<br>
&nbsp; &nbsp; &nbsp; &nbsp;- RedHat EL4 up6: &nbsp; &nbsp; &nbsp; 2.6.9-67.ELsmp<br>
&nbsp; &nbsp; &nbsp; &nbsp;- RedHat EL4 up7: &nbsp; &nbsp; &nbsp; 2.6.9-78.ELsmp<br>
&nbsp; &nbsp; &nbsp; &nbsp;- RedHat EL4 up8: &nbsp; &nbsp; &nbsp; 2.6.9-89.ELsmp<br>
&nbsp; &nbsp; &nbsp; &nbsp;- RedHat EL5 up2: &nbsp; &nbsp; &nbsp; 2.6.18-92.el5<br>
&nbsp; &nbsp; &nbsp; &nbsp;- RedHat EL5 up3: &nbsp; &nbsp; &nbsp; 2.6.18-128.el5<br>
&nbsp; &nbsp; &nbsp;&nbsp; - RedHat EL5 up4: &nbsp; &nbsp; &nbsp; 2.6.18-164.el5<br>
&nbsp; &nbsp; &nbsp; &nbsp;- SLES10 SP2: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.16.60-0.21-smp<br>
&nbsp; &nbsp; &nbsp;&nbsp; - SLES10 SP3: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.16.60-0.54-smp<br>
&nbsp; &nbsp; &nbsp; &nbsp;- SLES11: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.27.19-5-default<br>
&nbsp; &nbsp; &nbsp; &nbsp;- OEL 4 up7 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.9-78.ELsmp<br>
&nbsp; &nbsp; &nbsp; &nbsp;- OEL 5 up2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-92.el5<br>
&nbsp; &nbsp; &nbsp; &nbsp;- CentOS5.2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-92.el5<br>
&nbsp; &nbsp; &nbsp; &nbsp;- CentOS5.3 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.18-128.el5<br>
&nbsp; &nbsp; &nbsp; &nbsp;- Fedora Core11 &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; 2.6.29 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; *<br>
&nbsp; &nbsp; &nbsp; &nbsp;- OpenSuSE 11 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; 2.6.25.5-1.1 &nbsp; &nbsp; &nbsp; &nbsp;*<br>
&nbsp; &nbsp; &nbsp; &nbsp;- <a href="http://kernel.org/" target="_blank">kernel.org</a>:
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.29 and 2.6.30<br>
<br>
<br>
&nbsp; &nbsp; &nbsp;* Minimal QA for these versions<br>
<br>
Systems:<br>
&nbsp; &nbsp; &nbsp;* x86_64<br>
&nbsp; &nbsp; &nbsp;* x86<br>
&nbsp; &nbsp; &nbsp;* ia64<br>
&nbsp; &nbsp; &nbsp;* ppc64<br>
<br>
<br>
Main changes from 1.5 beta:<br>
============================<br>
1. Added support for RHEL5.4 and SLES10 SP3<br>
2. Updated packages:<br>
&nbsp;&nbsp;&nbsp; libibverbs-1.1.2-0.1.g49ac72c.tar.gz<br>
&nbsp;&nbsp;&nbsp; libcxgb3-1.2.5.tar.gz<br>
&nbsp;&nbsp;&nbsp; librdmacm-1.0.9.tar.gz<br>
&nbsp;&nbsp;&nbsp; dapl-2.0.23.tar.gz<br>
&nbsp;&nbsp;&nbsp; perftest-1.2.1-0.5.g68d9202.tar.gz<br>
3. Bug fixes<br>
<br>
<br>
Limitations:<br>
============<br>
- mthca does not compile on SLES11 on PPC64<br>
- RDS kernel panic on RHEL 4.x<br>
<br>
Changes from OFED-1.4.1<br>
========================<br>
1 General changes<br>
&nbsp;o Kernel code based on 2.6.30<br>
&nbsp;o RDS transport (TCP)<br>
&nbsp;o Added QIB driver<br>
<br>
2 SDP<br>
&nbsp;o Performance improvements<br>
<br>
3 uDAPL<br>
&nbsp;o New library<br>
<br>
4 Management<br>
&nbsp;o OpenSM<br>
&nbsp; &nbsp;- Mesh Analysis for LASH routing algorithm.<br>
&nbsp; &nbsp;- Reloadable OpenSM configuration (preliminary implemented)<br>
&nbsp; &nbsp;- Routing paths sorted balancing (for UpDown and MinHops)<br>
&nbsp; &nbsp;- Weighted Lid Matrices calculation (for UpDown, MinHop and DOR).<br>
&nbsp; &nbsp;- I/O nodes connectivity (for FatTree).<br>
<br>
5 MPI:<br>
&nbsp; &nbsp;- For now same versions as in OFED 1.4.1<br>
</body>
</html>

--------------000305000000050608000404--

--------------080003000004010108060102
Content-Type: text/plain;
 name="ofed_kernel-1.5-beta1_rc1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5-beta1_rc1.log"

commit 686f5c3f25c461863a20151e3668ed21ee0a6746
Merge: b589a2e... e692689...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Oct 6 09:09:55 2009 +0200

    Merge branch 'dev' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/home/jon/scm/ofed_kernel-1.5 into ofed_kernel_1_5

commit e692689e3b77c0cdd7594bb225c09a0767899693
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Oct 5 14:01:40 2009 -0500

    IB needs IB_ACCESS_LOCAL_WRITE permission on the Fast Reg MR buffer on
    the NFSRDMA server.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit b589a2ef7d6ff0adebeb774f79b742f12680281e
Author: Vu Pham (Mellanox) <vu-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Mon Oct 5 14:10:18 2009 -0700

    srpt: fixing ib_dma_mapping_error usage/parameters
    
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit b85cfe5b0f68fea235948a069438fcc17c203f40
Author: Vu Pham (Mellanox) <vu-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Mon Oct 5 13:47:26 2009 -0700

    srpt: changing to ib_dma APIs
    
    Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 68be2e20f7422e1d14d2617162a59e79334b57b1
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Oct 1 17:01:34 2009 -0500

    When disabling NFSRDMA in the OFED install scripts, CONFIG_SYSCTL will
    be disabled.  Since this option is not only needed by NFS, this causes
    all others who use this option in OFED to be without it.  It should be
    sufficient to enable it if NFS is enabled (given the off-chance that it
    is not enabled by default), and leave it the way it is on the system if
    NFS is not enabled.
    
    This fixes bug 1758.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit a0cb10c6a3be47412bcd197039bb5fb277ddc9c4
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Oct 5 16:24:01 2009 +0200

    Add SLES10 SP3 backports
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fc4f1f38e3272650483f751e3365bd433979856a
Author: Stefan Roscher <ossrosch-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Oct 1 15:04:13 2009 +0200

    ehca: backports for 2.6.16-sles10-sp2
    
    Signed-off-by: Stefan Roschert <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

commit 3795ed3ebdacdf86ef993f81cfdc56ab4bb7225b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Oct 1 16:02:13 2009 +0200

    ofa_kernel.spec: Load mlx4_en module by openibd
    
    mlx4_en module will be loaded by default by openibd script.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 56f74ec672543a66ed191c13e9932fb27640612f
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 30 17:50:22 2009 +0200

    mlx4_en: Adjusted backports to stopping TX during selftest
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2cfa80215bbc0f4a74bd56f3ff7b31040b383885
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 30 17:46:05 2009 +0200

    mlx4_en: Stopping transmit during selftest
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a32d81dcd1d5d338f3f2dab1d0b8ab1393161cbe
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 30 16:56:13 2009 +0200

    mlx4: Added 40Ge device id
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f49992644224adef4fb0bf615b340b139b64e0ab
Author: Stefan Roscher <ossrosch-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Wed Sep 30 14:22:31 2009 +0200

    ehca: backports for 2.6.18-EL5.4
    
    Signed-off-by: Stefan Roschert <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

commit b0baa6fd2ca6613371604c3998c129704f5fba1f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 29 09:08:50 2009 +0200

    From 91856f762d956547d261349e7420ceaf75c0cae2 Mon Sep 17 00:00:00 2001 From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> Date: Sun, 27 Sep 2009 08:44:11 +0200 Subject: [PATCH] mlx4: remove limitation on LSO header size
    
    Current code has a limitation as for the size of an LSO header not allowed to
    cross a 64 byte boundary. This patch removes this limitation by setting the WQE
    RR for large headers thus allowing LSO headers of any size. The extra buffer
    reserved for MLX4_IB_QP_LSO QPs has been doubled, from 64 to 128 bytes,
    assuming this is reasonable upper limit to header length.
    Also, this patch will cause IB_DEVICE_UD_TSO to be set only of FW versions that
    set MLX4_DEV_CAP_FLAG_BLH; e.g. FW version 2.6.000 and higher.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9184e95f1467f5e10bf9df851ceefc91495bc488
Author: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Date:   Tue Sep 29 17:44:41 2009 +0200

    ofed_scripts/openibd: Don't check for gcc version unless it is installed
    
    If gcc is not installed then don't check for gcc version. This prevents error
    messages to be printed on the screen.
    
    Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit cf393ef350245d9d1f1a4fc711a6b9dfc102689c
Merge: 51c4250... 98e1ea6...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 29 18:09:08 2009 +0200

    Merge branch 'dev' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/home/jon/scm/ofed_kernel-1.5 into ofed_kernel_1_5

commit 51c4250a99a3460d16eb288a29601f2ef450ba2d
Author: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Date:   Tue Sep 29 12:44:51 2009 +0200

    kernel_fixes: import from upstream to fix bugzilla 1726
    
    Import commit 5ee95120841fd623c48d7d971182cf58e3b0c8de from Roland's tree to
    fix bugzilla 1726
    
    Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 95dac39f26d052739ef4692d52f5c51c85229945
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 29 12:44:11 2009 +0200

    Add RHEL4 U8 support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit f2f081d0c36c21927642adc25a4ec2ba93a07785
Merge: 10c2e20... 163a79a...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 29 09:56:14 2009 +0200

    Merge branch 'ofed_1_5' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/~swise/scm/ofed_kernel into ofed_kernel_1_5

commit 163a79ad8de850ac727dceedea89d251275676ef
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Sep 28 12:46:06 2009 -0500

    IWCM: Pull in upstream "reject on destroy" fix.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 98e1ea6611b8428fc40b10e2de3b1ec0a5be170c
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Wed Sep 23 22:27:41 2009 -0500

    NFSRDMA on SLES10sp2 crashes with a NULL pointer dereference when
    attempting to walk an NFS path.  This is due to the root dentry d_op's
    pointer not being set.  This patch sets the pointer to the mount points
    dentry d_op pointer.
    
    This fixes bug 1741
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit c64b965f7d03f7d920042c63d5ac529fe243a4ab
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Sep 28 08:59:21 2009 -0500

    cxgb3: pull in ofed-1.4 RHEL4 backport patch.
    
    Missed this one.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 10c2e2060a298f9959470e71e4f7fc8d0085b196
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Sun Sep 27 08:41:08 2009 +0200

    mthca: Fix access to freed memory in catas processing
    
    catas_reset() uses pointer to mthca_dev, but mthca_dev is not valid after
    call __mthca_restart_one().
    
    Based on a similar patch for mlx4 by Vitaliy Gusev <vgusev-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit df2a330385517f18741c139cbc523cf1351675d4
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Fri Sep 25 14:01:00 2009 +0200

    ehca: backports for RHEL5.3
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit 3fe6cd945c1dfe7f340e191ede1f96939b54b90e
Author: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 24 12:08:33 2009 -0700

    backport: RDS: fix build on RHEL5u4
    
    Signed-off-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

commit af52f3c8477cc4f924da616acfc7180c0dff12e3
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Sep 24 14:31:54 2009 +0200

    ehca: backports for 2.6.27
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit 59eadcec2f1acb8c3ea27262dc87a4609d91cfa5
Author: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Date:   Thu Sep 24 15:46:56 2009 +0300

    IB/mad: Fix lock-lock-timer deadlock in RMPP code
    
    Holding agent->lock across cancel_delayed_work() (which does
    del_timer_sync()) in ib_cancel_rmpp_recvs() leads to lockdep reports of
    possible lock-timer deadlocks if a consumer ever does something that
    connects agent->lock to a lock taken in IRQ context (cf
    http://marc.info/?l=linux-rdma&m=125243699026045).
    
    Fix this by changing the list items to a new state "CANCELING" while
    holding the lock, and then canceling the delayed work without holding
    the lock.  If the delayed work runs after the lock is dropped, it will
    see the state is CANCELING and return immediately, so the list will
    stay stable while we traverse it with the lock not held.
    
    Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit d64dd604c8f3e4784c317ea9fb204f8cf385780a
Author: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Date:   Wed Sep 23 17:57:17 2009 +0300

    kernel_fixes: import a patch to fix bugzilla 1664
    
    Add commit 5e47596bee12597824a3b5b21e20f80b61e58a35 to kernel fixes.
    This will fix https://bugs.openfabrics.org/show_bug.cgi?id=1664.
    
    Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit f9516bcebc3b55082f80f2b3799b4b6ca410222b
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Sep 24 10:45:14 2009 +0300

    openibd: Add rds_rdma and rds_tcp modules support
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cbd7fff59bbbcb2541e897b74eee83ccf9642ed5
Merge: 9ae2f04... 1be7f9b...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 22 18:09:32 2009 +0300

    Merge branch 'dev' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/home/jon/scm/ofed_kernel-1.5 into ofed_kernel_1_5

commit 1be7f9bfbd96057d7ef01444ac243e65fcb01e01
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Sep 21 14:36:24 2009 -0500

    Non-x86 archs will break when compiling NFSRDMA due to _node_to_cpumask_ptr not
    being defined.  This is due to that function only being defined in
    include/asm-x86/topology.h.  This patch removes the reference to that function
    to something more generic which exists on all other archs.
    
    This fixes bug 1746.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 9ae2f045daf2800c54db53d9af6f650c008def28
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 22 17:34:45 2009 +0300

    backports: sles10.2: fix for bugzilla 1707
    
    Driver installation fails on PPC arch because smp_mb is not defined.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit b88b7e32f41b957fecba76c85a02c517e062358b
Author: Vitaliy Gusev <vgusev-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Date:   Mon Sep 21 10:20:21 2009 +0300

    mlx4: Fix access to freed memory
    
    catas_reset() uses pointer to mlx4_priv, but mlx4_priv is not valid after
    call mlx4_restart_one().
    
    Signed-off-by: Vitaliy Gusev <vgusev-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

commit 4358c9af58adb37b0c996a7fa37dfb3902cb2f42
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Sep 21 11:23:19 2009 -0500

    cxgb4: RH5.4 backports.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit d1d73ed051de1f25b6890ce0258d2e7e8c0d79fd
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Sep 17 16:53:01 2009 +0200

    ehca: fixes for OFED-1.5
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit ed3574bd61bbe07fcf88045c2d5de9eb07c4e470
Author: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Sep 16 15:59:15 2009 +0300

    mlx4_en: Setting the correct value to MAX_TX_RINGS
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1eefbe57401cfac6d7641bd281e81e750d5de723
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Wed Sep 16 10:29:28 2009 +0300

    backports: RHEL5.4: sdp: take patches from 5.3 backport.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 615695f72ada61b0edc3d4ba1208756f5a5c9838
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Wed Sep 16 10:22:42 2009 +0300

    backports: RHEL5.4: ipoib: take patches from 5.3
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 80ef0b27fd9563341e3c34ffe20b25f704f5454b
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Wed Sep 16 10:16:31 2009 +0300

    backports: RHEL5.4: mlx4_en: more patch files from 5.3 backport.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit e7c93c68d6ee77bcf3af8c5d6c7660add0babb6d
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Sep 15 14:30:51 2009 -0500

    RDMA/nes: add backport for RHEL5U4
    
    Copy iw_nes backport patches from RHEL5U3 to RHEL5U4.
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 4ca1cfd3b93b9434556fa5f850f6d6a201164b3f
Author: John Gregor <johng-l+PWtdWbHAsw9UJmpNzN63xStJ4P+DSV@public.gmane.org>
Date:   Wed Sep 16 09:36:10 2009 +0300

    ofa_kernel/makefile: Avoid duplicate 'make kernel'
    
    Signed-off-by: John Gregor <johng-l+PWtdWbHAsw9UJmpNzN63xStJ4P+DSV@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit b231f5f7bedfd2920e4591d820df8c6e07d76c23
Author: John Gregor <johng-l+PWtdWbHAsw9UJmpNzN63xStJ4P+DSV@public.gmane.org>
Date:   Tue Sep 15 17:54:30 2009 -0700

    IB/qib: add 2.6.18-EL5.4 support for qib
    
    Added backport 2.6.18-EL5.4 patches for qib.
    
    Signed-off-by: John Gregor <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 0af7ad87398ab8362c19cd989026a5078755dc92
Author: John Gregor <johng-l+PWtdWbHAsw9UJmpNzN63xStJ4P+DSV@public.gmane.org>
Date:   Tue Sep 15 16:15:03 2009 -0700

    ofed_scripts: fix typo in ofed_patch.sh
    
    Invokation of get_backport_dir.sh in help was missing the '.sh'.
    
    Signed-off-by: John Gregor <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 8c08fe2a6ec6324d34bcd1a09840ec10d43573ae
Author: John Gregor <johng-l+PWtdWbHAsw9UJmpNzN63xStJ4P+DSV@public.gmane.org>
Date:   Tue Sep 15 16:11:01 2009 -0700

    ofed_scripts: clean up quilt permissions
    
    Quilt leaves some files in .pc with no permissions, so updated
    ofed_patch.sh to add minimum permissions for the owner.
    
    Signed-off-by: John Gregor <john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 847bd0797fb48eebfa4b40b72cda28963865dda2
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 15 18:32:54 2009 +0300

    backport: RHEL5.4: uverbs.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 597c46496e1a5de1ca7ae1608f866acdc09348be
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 15 18:32:24 2009 +0300

    backport: RHEL5.4: mthca.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit fc438d32a26e5270511eedfdbdbb449971242c21
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 15 18:31:35 2009 +0300

    backports: RHEL5.4: mlx4 patches.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit dbbba37c2a9ba98da83c75c61165b7e2a352bb5d
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 15 18:29:55 2009 +0300

    backport: RHEL5.4: ib core backport patches.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 0643536fadf76f88da01e0ea7d6ad8dc8d3f8b09
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 15 10:58:16 2009 +0300

    backports: mlx4: Fix attempts to use kmalloc on overly large allocations in RedHat backports.
    
    Based on Doug Ledford's patch for mthca in RedHat backports.
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 084f0ece4bbacb97c9e6f2463fabf3b56e6d4e88
Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue Sep 15 10:56:06 2009 +0300

    backports: mthca: Fix attempts to use kmalloc on overly large allocations in RedHat backports.
    
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

commit fa01cdd33439f7e660bd02942b77ac9067a452fd
Author: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Sep 15 10:43:55 2009 +0300

    backports:  Added Andy Grover's 2.6.28 rds backport patch to 2.6.29 backports.
    
    Acked-by: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    
    Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 29a589f15b7e2008f6eee7ee60775224723f2746
Author: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Sun Sep 13 15:48:26 2009 +0300

    Fix sles11 backports
    
    Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

commit b49f2112e8f0cd643431984df3a1a74b5fe8409b
Merge: 96791a6... 4fc3bd2...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Sep 13 14:12:13 2009 +0300

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~ralphc/linux-2.6/ into ofed_kernel_1_5

commit 96791a6cd5f60e808bf3504d10109e6e0d42ae7a
Merge: ec80ecd... a97fff0...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Sep 13 13:42:15 2009 +0300

    Merge branch 'dev' of ssh://vlad-xbvoi9bjaTMTY57ZBjEdqWD2FQJk+8+b@public.gmane.org/home/jon/scm/ofed_kernel-1.5 into ofed_kernel_1_5

commit 4fc3bd26b6bca72cdc1c06c326ead7aa61aa240d
Author: Ralph Campbell (QLogic) <ralphc-7c6Ix4kHDaQbbOeZqR+qftTWuKd1BNJ1@public.gmane.org>
Date:   Fri Sep 11 10:54:29 2009 -0700

    IB/qib: update driver with latest fixes
    
    This patch updates the QIB driver with the latest bug fixes
    and updates the backport patches to match.
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit a97fff09690799120a17b1de3e2e342d8facb4b8
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Sep 8 15:17:25 2009 -0500

    Fix handling of EADDRNOTAVAIL in client side socket transport switch
    
    This fixes bug 1713
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 943a5de67ade825020ea8d4eab35bbec581c8876
Author: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Tue Sep 8 11:06:59 2009 -0500

    Undo the modification of the fs/nfs/dir.c file done in
    091a83059bd8cf3a8d0400395579bebe18ffebfd and make the relevant changes
    in the backport patch files.
    
    Signed-off-by: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--------------080003000004010108060102
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------080003000004010108060102--
