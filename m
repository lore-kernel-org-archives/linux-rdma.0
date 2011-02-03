From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.3 rc3 is available
Date: Thu, 03 Feb 2011 15:53:12 +0200
Message-ID: <4D4AB348.3080604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080607060808020809090403"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080607060808020809090403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.3-rc3 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.3/OFED-1.5.3-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.3

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
           - RedHat EL5 up4        2.6.18-164.el5
           - RedHat EL5 up5        2.6.18-194.el5
           - RedHat EL5 up6        2.6.18-238.el5
           - RedHat EL6            2.6.32-71.el6
           - SLES10 SP3            2.6.16.60-0.54-smp
           - SLES11                2.6.27.19-5-default
           - SLES11 SP1            2.6.32.12-0.7-default
           - Fedora Core12         2.6.31.5-127.fc12    *
           - OpenSuSE 11.2         2.6.31.5-0.1-default *
           - kernel.org            2.6.29 - 2.6.36    *

         * Minimal QA for these versions

Main changes from 1.5.3-rc2:
===========================
1. Updated packages:
    libibverbs-1.1.4-0.16.g40a8247.tar.gz
    libmlx4-1.0-0.16.g677fa61.tar.gz
    libsdp-1.1.108-0.15.gd7fdb72.tar.gz

2. Better support for RAW Eth QP in mlx4 and verbs

3. cxgb3 support for 2.6.3[56]

--------------080607060808020809090403
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.3-rc3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.3-rc3.txt"

commit 0baab660dea3417c6e20d3aa99769e21f93b53cd
Merge: 53cddbf b56ea15
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Feb 3 10:16:26 2011 +0200

    Merge branch 'ofed_1_5' of git://git.openfabrics.org/~swise/ofed_kernel into ofed_kernel_1_5

commit b56ea1597bcc9baf0f538a974aa6c50ca72e83a4
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Wed Feb 2 16:01:55 2011 -0600

    cxgb3: 2.6.35 backports.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 53cddbfdbaee57ed68006e61de9255bf9bcc9317
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 2 15:36:37 2011 +0200

    Fix backports for 2.6.3[4-6]
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 33128acf1abd0b1fdcb27eb579a38f73b125fa28
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 2 14:49:20 2011 +0200

    mlx4_en: Fix backport patches
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit db2d245e415835d76597a117b037a18f1874a94d
Author: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Thu Jan 20 15:45:35 2011 +0200

    mlx4_en: Add an ability to attach to QPs to GIDS by priority.
    
    The basic flow: Upon receiving a high priority attach request,
    Make sure that it is put before all other low priority entries in the same
    MGM hash bucket. if a low priority entry already exists for the given GID,
    we'll have two entries with the same GID, which means that the low priority
    entry will be ignored.
    
    Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 2c15c3894d7152e9ef132d4e68e8aafd8deac110
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Dec 2 14:33:21 2010 +0200

    mlx4_en: fix backport patches for kernels <= 2.6.28
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 1f20b8ea336e016b31ce3170b6fd32b693d3e3e3
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 1 11:51:31 2010 +0200

    mlx4_ib: Set port number in the multicast gid
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8a3f3887205c3a5aae4bc6bbdb617862d42fa1ef
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Dec 1 11:50:42 2010 +0200

    mlx4_en: new steering model
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 21beaae06cea6cb10a3e8c626089b53d8ee6d5f6
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Mon Jan 31 12:32:34 2011 -0600

    cxgb3: 2.6.36 backports.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit 3caeec77957191a4528139ffe752badf205c3df0
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Jan 27 16:10:54 2011 +0100

    RDMA/nes: fix hazard of sending ibevent for unregistered device
    
    nes_port_ibevent() should not be called when nes IB device is not registered with IB core.
    Add missing checks of of_device_registered flag.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--------------080607060808020809090403
Content-Type: text/csv;
 name="bugs-2011-02-03.csv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bugs-2011-02-03.csv"

"bug_id,""bug_severity"",""priority"",""op_sys"",""assigned_to"",""bug_status"",""resolution"",""short_desc""";;;;;;;;;;;;;;
"2197,""minor"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""CLOSED"",""FIXED"",""ttcp";"fails";"opening";"connection";"while";"traffic";"directed";"via";"SDP";"only";;"errno=97"""
"2206,""critical"",""P5"",""RHEL";"5"",""swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org"",""RESOLVED"",""FIXED"",""[OFED-1.5.3-rc1]";":";"Installation";"of";"OFED-1.5.3";"fails";"on";"2.6.36";"(";32;"bit)";"kernel.""";;
"2211,""normal"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""CLOSED"",""FIXED"",""Each";"shell";"command";"execution";"(while";"SDP";"enabled)";"followed";"by";"JUNK";"screen";"output"""
"2214,""critical"",""P5"",""RHEL";"5"",""vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""Compilation";"of";"daily";"build";"OFED";"1.5.3";"in";"RHEL";5.5;"fails""";;;;
"2217,""minor"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""CLOSED"",""FIXED"",""BXOFED-LAG-1.5.2-1.3.9-1150";":";"sdpstats";"counters";"->";"negative";"and";"decreasing";"values""";;;
"2226,""major"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""HA";"without";"bonding";"error";0;"cma_query_handler";"failed";"to";"get";"alternate";"path";"record"""
"2227,""major"",""P5"",""Other"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""APM";0;"kernel";"panic:";"cm_send_lap";"is";"called";"after";"cm";"id";"destroyed""";;;;

--------------080607060808020809090403--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
