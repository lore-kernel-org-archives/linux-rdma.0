From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.3 rc4 is available
Date: Tue, 15 Feb 2011 10:45:15 +0200
Message-ID: <4D5A3D1B.9030106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060002000302070508060403"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060002000302070508060403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.3-rc4 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.3/OFED-1.5.3-rc4.tgz

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

Main changes from 1.5.3-rc3:
===========================
Updated packages:
    dapl-2.0.32

--------------060002000302070508060403
Content-Type: text/csv;
 name="bugs-2011-02-15.csv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bugs-2011-02-15.csv"

bug_id,"bug_severity","priority","op_sys","assigned_to","bug_status","resolution","short_desc"
2222,"major","P3","Other","swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org","CLOSED","FIXED","Compilation of OFA kernel fails after applying krping patch on 2.6.34"
2223,"blocker","P1","Other","swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org","RESOLVED","FIXED","Installation of OFED-1.5.3-rc2 fails on 2.6.35 kernel"
2229,"critical","P2","SLES 11","vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","mmvapich2_gcc-1.6/mvapich2 option is not present while installing OFED on SLES  platforms"
2236,"blocker","P5","RHEL 5","vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org","RESOLVED","FIXED","ofa-kernel build breaks on vanilla 2.6.33 and ppc64 due to missing kernel patch"

--------------060002000302070508060403
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.3-rc4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.3-rc4.txt"

commit 936ed7828b82d5c0f0895da02bb9012b55363bd0
Merge: 71c5e46 35dbff5
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 14 15:05:51 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 71c5e4653c76c0d0244c973a1387f3a5c5c715a3
Author: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Mon Feb 14 10:13:19 2011 +0200

    mlx4_en: Fix promiscuous mode issues
    
    Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit c0c255e3f783a1470de73bffa41d363a77edd300
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Feb 13 10:13:02 2011 +0200

    ppc64/backport: Add workaround for compilation on PPC64 with 2.6.[28-31]
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 35dbff5c916967ec2fb0bec02c5ddd4ec7048d1a
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Thu Feb 10 08:37:56 2011 -0500

    IB/qib: Kernel BUG at include/linux/timer.h:82
    
    The following panic BUG_ON occurs during qib testing:
    
    Kernel BUG at include/linux/timer.h:82
    
    RIP  [<ffffffff881f7109>] :ib_qib:start_timer+0x73/0x89
     RSP <ffffffff80425bd0>
     <0>Kernel panic - not syncing: Fatal exception
     <0>Dumping qib trace buffer from panic
    qib_set_lid INFO: IB0:1 got a lid: 0xf8
    Done dumping qib trace buffer
    BUG: warning at kernel/panic.c:137/panic() (Tainted: G
    
    The flaw is due to a missing state test when processing responses that results
    in an add_timer() call when the same timer is already queued.  This code was
    executing in parallel with a QP destroy on another CPU that had changed the state
    to reset, but the missing test caused to response handling code to run on into
    the panic.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 767fcd6cd95d81ec524b265ab3a9ce02a279adc7
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Feb 9 16:47:00 2011 +0100

    RDMA/code: Fix for problem with closing iWARP connection and DAPL
    
    Now DAPL and nes driver can close connection correctly.
    Corrections in AEQE handling were made.
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit e4acba676b6ef0c5735fa5766ee998787742d704
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 9 18:22:49 2011 +0200

    ppc64/backport: Add workaround for compilation on PPC64 with 2.6.3[3-6]
    
    Add an empty asm/iomap.h under kernel_addons for 2.6.3[3-6]* kernels
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2236
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 815fbe8cd417b8eb3a399edbb7f5da4e50a1ede4
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 7 11:25:56 2011 +0200

    Revert "openibd: Update script header"
    
    This reverts commit d477ac405deca4ee3e12d3dc67f3cf07178fb2c5.
    Reverted commit cause openibd service script to run after the network
    service script on RHEL5.x which affect bonding interface caonfiguration.
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 98a3cc6b7569f96e46a15ac8190d1956bd869a56
Author: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Feb 6 17:38:16 2011 +0200

    IB/core: Control number of retries for SA to leave an	MCG
    
    Add a multicast leave maximum retry setting in sys/module/ib_sa/parameters/mcast_leave_retries.
    Add a debug print when the maximum retry count is reached.
    
    Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Reviewed-by:   Moni Shoua  <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 7aa40774dcf258def9c616bdf0465764210b06fa
Author: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Feb 6 17:34:16 2011 +0200

    IB/ipoib: Leave stale send-only multicast groups
    
    The kernel never leaves send only multicast groups. In addition, IPoIB doesn't
    implement real send only join but it sends the SM a send/receive join request.
    In order to avoid MC group explosion on the switch, a mechanism of garbage
    collection to unused multicast groups is required.
    
    Signed-off-by: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 6c01388c3b972814277372e5aee0e98b12f2d8c1
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Tue Feb 1 11:25:19 2011 -0500

    IPoIB: fix faulty list maintenance in path and neigh list
    
    From: Gary Leshner <gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    
    Added list_del to ipoib_mcast_free() and path_free() to remove the neigh from
    the path's neigh_list link list before freeing the memory it consumes.
    This makes the code consistent with ipoib_cm_handle_tx_wc() and other locations where the list_del() preceeds the call to ipoib_neigh_free().
    
    Similarly, at list_del() now preceeds path_free() to remove the path from
    ipoib_dev_priv's path_list.
    
    Additionally, the fields neigh->ah and neigh->list were not being initialized
    upon allocation.  The patch insures that these two remaining fields are
    initialized correctly.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

--------------060002000302070508060403--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
