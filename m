From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.3 rc5 is available
Date: Tue, 22 Feb 2011 17:35:12 +0200
Message-ID: <4D63D7B0.1090903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030804030700040704020706"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------030804030700040704020706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.3-rc5 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.3/OFED-1.5.3-rc5.tgz

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

Main changes from 1.5.3-rc4:
===========================
Updated packages:
     infiniband-diags-1.5.8
     libibmad-1.3.7
     libibumad-1.3.7
     libibverbs-1.1.4-0.18.g387c870
     librdmacm-1.0.14.1
     mstflint-1.4-0.9.gc683022

Bug fixes (see attached).

--------------030804030700040704020706
Content-Type: text/plain;
 name="ofed_kernel_changelog-1.5.3-rc5.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="ofed_kernel_changelog-1.5.3-rc5.txt"

commit 6b81e91a49f817faef3d27cf99a77741c0e8f46c
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Feb 22 11:27:23 2011 +0200

    makefile: fix compilation on Fedora 14
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 262a121211795100916c625e54918ee3cb280ad0
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Feb 21 14:34:45 2011 +0200

    ipoib/mcast: Fix IPoIB multicast backport
    
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2000
    
    Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 021593529a906d860c76bbd315ff872912dbbece
Author: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Feb 20 17:04:36 2011 +0200

    mlx4_en: Fix unicast attach + promisuous mode
    
    BUG: http://bugs.openfabrics.org/bugzilla/show_bug.cgi?id=2237
    
    Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>

commit 92ea1319b62efdd5c0ec77a211bd57e3788fab50
Author: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Feb 18 17:20:27 2011 +0100

    RDMA/nes: Corrected AEQE operation
    
    Fixed incompatibility  problems between nes and various MPIs
    
    Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 03032d57818d4d6daa80eb7a34c629befa799bba
Merge: cb7d2c2 4fe0731
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Feb 20 12:26:35 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 4fe073148673e630a9aba9608ee9bd6d7f745345
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Feb 18 07:07:28 2011 -0500

    QLogic: Add support for the BL465c blade type in truescale.cmds
    
    Insure link comes up between BL465c and switch.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 49a1610b503ea82f10e090378c1aeb624a3d222d
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Feb 18 06:59:02 2011 -0500

    IB/qib: Return correct MAD when setting link width to 255
    
    Fix a bug which cause the driver to return incorrect MADs
    as a response to Set(PortInfo) which sets the link width
    to 0xFF or link speed to 0xF.
    
    Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit d7ab4d979720b8bd49c8e81f223d20f4466de6b0
Merge: 99efe8a 0012f25
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 16 17:57:11 2011 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~mmarciniszyn/linux-2.6.to_ofed into ofed_kernel_1_5

commit 0012f25501856cf0f47397fbb57e26bf46b11b99
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Wed Feb 16 09:47:41 2011 -0500

    IB/qib: Prevent double completions after a timeout or RNR error
    
    From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    
    There is a double completion associated with error handling
    for RC QP's.
    
    The sequence is:
    - The do_rc_ack() routine fields an RNR nack and there are 0 rnr_retries
    configured on the QP.
    - qib_error_qp() stops the pending timer
    - qib_rc_send_complete() is called from sdma_complete()
    - qib_rc_send_complete() starts the timer because the msb of the psn just
    completed says and ack is needed.
    - a bunch of flushes occur as ipoib posts wqe's to an error'ed qp
    - rc_timeout() calls qib_restart_rc()
    - qib_restart_rc() calls qib_send_complete() with a IB_WC_RETRY_EXC_ERR on a
    wqe that has already been completed in the past
    
    The fix avoids starting the timer since another packet will never
    arrive.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 99efe8a1ad888400b38ab931f1cf35859f8bd6f3
Author: Sébastien Dugué <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Date:   Wed Feb 16 15:50:45 2011 +0200

    mlx4_ib XRC RCV: Fix mlx4_ib_reg_xrc_rcv_qp() locking
    
    In mlx4_ib_reg_xrc_rcv_qp(), we need to take the xrc_reg_list_lock spinlock
    when walking the xrc_reg_list.
    
    Also, I guess spin_lock_irqsave() could be replaced by spin_lock_irq() in
    that function as we know for sure we're in process context.
    
    Signed-off-by: Sébastien Dugué <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

commit 78ee7b0da9341964673464b8d2728f668bb16380
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Feb 15 16:47:06 2011 +0200

    Fix backports for 2.6.18-chaos
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit a0350813dfef194826680c7b50b1334d785f14cd
Author: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Date:   Tue Feb 15 12:14:03 2011 +0200

    IB/ipoib: send creation parameters with send-only join requests
    
    When IPoiB joins to a MC group as send only it doesn't send creation parameters
    to the SM and if the group does not exis it won't be created. This is typical
    when a gateway sperates ETH receivers from IPoIB senders.
    This patch fixes bug #1153 in bugzilla.
    
    Signed-off-by: Yossi Etigin <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Reviewd-by:    Moni Shoua   <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    
    --

commit 9b1f7069d37152cc1c1243bfeaa7bb9f0e64949e
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Feb 13 12:08:24 2011 +0200

    sdp: make retry count a module parameter
    
    Setting a lower value means faster path migration in APM
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit c83e7a9ed73aa7dbb9ae47d4cadc0b178aff4d88
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Feb 9 13:06:23 2011 +0200

    sdp: BUG2217 - fix sdpstats negative values
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------030804030700040704020706
Content-Type: text/csv;
 name="bugs-2011-02-22.csv"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bugs-2011-02-22.csv"

"bug_id,""bug_severity"",""priority"",""op_sys"",""assigned_to"",""bug_status"",""resolution"",""short_desc""";;;;;;;;;;;;;
"2000,""critical"",""P3"",""Other"",""eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""Multicast";;"over";"IPoIB";0;"doesn't";"leave";"MC";"group";"when";"MC";"server";"ends""";
"2208,""major"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""SDP";0;"libsdp.conf";"parameters";"parsing";"Err:510";"symbol";"lookup";"error""";;
"2225,""major"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""HA";"with";"bonding";"error";"->";"SDP";":";"Unexpected";"CMA";"event:";"14"""
"2228,""major"",""P5"",""RedHat";"Fedora";"Core";"5"",""amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""Kernel";"oops+panic";"vs.";"machine";"crash";"while";"performing";"port";"Up/Down";"(BXOFED-1.5.2-1.3.9100)""";
"2230,""major"",""P2"",""RHEL";"5"",""swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org"",""CLOSED"",""FIXED"",""Rping";"stalls";"after";"finishing";"its";"transactions.""";;;;;;;
"2237,""critical"",""P5"",""All"",""yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""Driver";"Hangs";"in";"unicast";"attach";0;"promisuous";"mode""";;;;;;
"2238,""normal"",""P5"",""Other"",""vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org"",""RESOLVED"",""FIXED"",""Cannot";"install";"kernel-ib";"on";"Fedora";"Core";"13""";;;;;;;

--------------030804030700040704020706--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
