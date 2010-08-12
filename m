From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc4 is available
Date: Thu, 12 Aug 2010 15:08:43 +0300
Message-ID: <4C63E44B.2070809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040503000006030507080403"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040503000006030507080403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.2-rc4 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc4.tgz

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
             - RedHat EL6 beta       2.6.32-19.el6.x86_64 *
             - SLES10 SP2            2.6.16.60-0.21-smp
             - SLES10 SP3            2.6.16.60-0.54-smp
             - SLES11                2.6.27.19-5-default
             - SLES11 SP1            2.6.32.12-0.7-default *
             - OEL 4 up7             2.6.9-78.ELsmp
             - OEL 4 up8             2.6.9-89.ELsmp
             - CentOS5.3             2.6.18-128.el5
             - CentOS5.4             2.6.18-164.el5
             - Fedora Core12         2.6.31.5-127.fc12    *
             - OpenSuSE 11.2         2.6.31.5-0.1-default *
             - kernel.org            2.6.29, 2.6.30,
                                     2.6.31, 2.6.32 and 2.6.33   *

           * Minimal QA for these versions

Main changes from 1.5.2-rc3:
===========================
1. Updated packages:
	compat-dapl-1.2.19.tar.gz
	dapl-2.0.30.tar.gz
	ibacm-1.0.2.tar.gz
	librdmacm-1.0.13.tar.gz
	libsdp-1.1.102-0.4.g74bf4be.tar.gz
	perftest-1.3.0-0.20.g4b4dc24.tar.gz
	rds-tools-2.0.4.tar.gz

2. Known issues
    CXGB3 and NES drivers' compilation fails on kernel 2.6.33


--------------040503000006030507080403
Content-Type: text/plain;
 name="ofed_kernel-1.5.2-rc3_rc4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5.2-rc3_rc4.log"

commit 56a26bbe3d6effc20f67344b9fda7fd1643f672a
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 9 17:50:04 2010 +0300

    Add 2.6.33 support
    
    TBD: cxgb3 and nes drivers should be ported to 2.6.33
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d55fc087fff7643df767bb8f28adc24e24237a2b
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Aug 5 13:45:24 2010 -0500

    Move genalloc services to iw_cxgb3.
    
    Since iw_cxgb3 is the only module using the genalloc services, move them
    to iw_cxgb3 as static functions.  This resolves bug 767.
    
    Changes:
    
    - Remove genalloc from all backports and ib_core
    
    - Add patch in kernel_fixes/patches to add genalloc to iw_cxgb3 module.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit ddb796af5d484e8089acf24a55936a9788bc2ea0
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 5 10:16:58 2010 +0300

    sdp: properly kill nagle_timer on socket reset
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 18ce41698c16e330ae43069154a6989b92490ee8
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 5 09:31:27 2010 +0300

    sdp: BUG2092 - ib_device field in sdp_sock is reset not in user-context
    
    ib_device field of sdp_sock is NULL after either cases:
    - cma handler resetting the socket
    - device removal
    Both cases are not in user-context.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4b1298791c7d9e52ad7b22504f739fbaba4f0c3c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 5 08:39:58 2010 +0300

    sdp: fix for stopping tx timer/tasklet when socket state is TCP_CLOSE
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 71e57c0b33ce038d59e1a5061fac971014bc44eb
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Aug 3 19:14:59 2010 +0300

    sdp: BUG1403 - last sk_refcnt is called while cma handler is invoked
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0669da697c7779955806ef3dae3db4ecf68618cc
Author: Ralph Campbell (QLogic) <ralphc-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Date:   Wed Aug 4 10:07:43 2010 -0700

    IB/qib: add recent kernel.org fixes
    
    Add the following patches to qib and fix up backports:
    IB/qib: limit the number of packets processed per interrupt
    IB/qib: fix race between qib_error_qp() and receive packet processing
    IB/qib: if qib_init() fails, driver fails to clean up properly
    
    Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit ae37d2ff89f0577fc80c7e2630db3d38b846a884
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 14:19:26 2010 +0300

    sdp: bug fix for a case of no memory to allocate for rx_sa
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6880aff3c23388ff1a871c7dfc55ed9c7cc4f23f
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 2 15:05:12 2010 +0300

    sdp: rx_irq should use tasklet instead of timer due to latency issue
    
    mod_timer(..., 0) measured to add 4ms delay.
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3a8ade4069b6f21b93de30a6007d2247d1b662f6
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 19:16:20 2010 +0300

    sdp: better handling of page-allocation-failure
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 0fef943ed59f0325a68e0fff7baec640c0d65f4a
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 18:46:49 2010 +0300

    sdp: reduce size of sdp_buf to what is really being used
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 776871c940b82cda8f57940f1dd436a2e399dc77
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 18:08:11 2010 +0300

    sdp: remove the relation between qp_active and sdp_free_fmr()
    
    This will fix the warning message from ib_destroy_fmr_pool().
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1119a38b48db5e9e04abcfa2d5bd132aed59d434
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 18:00:11 2010 +0300

    sdp: small fix to support device removal during traffic
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit bd540ec03921ab16bee06c57616c49ca838671b8
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 1 14:30:54 2010 +0300

    sdp: bug fix for a case of no memory to allocate for tx_sa
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 01973aacb2fb806d69f778bbd6707b36231619de
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Aug 3 14:04:54 2010 +0300

    mlx4_ib/mthca: updated version to ofed1.5.2
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------040503000006030507080403--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
