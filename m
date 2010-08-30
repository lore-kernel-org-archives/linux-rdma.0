From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc5 is available
Date: Mon, 30 Aug 2010 18:22:25 +0300
Message-ID: <4C7BCCB1.8090105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000603080500030702060206"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000603080500030702060206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.2-rc5 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc5.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.2

Updated schedule:
OFED-1.5.2-rc6 - September 6.
OFED-1.5.2 GA - September 13.

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

Main changes from 1.5.2-rc4:
===========================
1. Updated packages:
	ibacm-1.0.3.tar.gz
	libibverbs-1.1.4-0.12.g0966609.tar.gz
	libmlx4-1.0-0.12.g5f39e7c.tar.gz
	


--------------000603080500030702060206
Content-Type: text/x-log;
 name="ofa_kernel-1.5.2-rc4_rc5.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofa_kernel-1.5.2-rc4_rc5.log"

commit d3a225ba07fdd7bf4eccaab383818dde41231166
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Sat Aug 28 08:07:38 2010 -0500

        RDMA/cxgb3: Remove BUG_ON() on CQ rearm failure
    
        Failure to rearm a CQ means the cxgb3 device is wedged, but we shouldn't
        kill the whole system with a BUG_ON() if this happens.
    
        Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
        Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit f3495ab83c7906ada0fea19867c16c634014e160
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Sat Aug 28 08:02:42 2010 -0500

    RDMA/cxgb3: Don't exceed the max HW CQ depth.
    
    From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
    
    The max depth supported by T3 is 64K entries.
    
    This bug will cause stalls and possibly crashes in large MPI clusters.
    
    Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

commit f4f34f911f498ad3e7a6165f9c9f0f5aca3a16ec
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 26 10:52:21 2010 +0300

    sdp: add support for no recv polling at all
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 670aed5f63aba0c8a216e513605f4422b158f788
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Aug 25 17:22:56 2010 +0300

    mlx4: consmetic change
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 206cd477d3499f98ac4104fd9f2c75487ca07b21
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Aug 24 17:36:14 2010 +0300

    IBoE: Fix eth priority calculation
    
    And some constmetic chages.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 86d4de526579dc2c800636f772181405c64dce94
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Aug 23 11:24:19 2010 -0500

    RDMA/nes: report correct port state if interface is down
    
    With commit cd6860eb03 we no longer remove nes interface on
    ifdown.  On nes_query_port add additional check to net queue
    and report IB_PORT_DOWN if the queue is not running.
    
    This fixes OFED bug 2101:
    https://bugs.openfabrics.org/show_bug.cgi?id=2101
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 71cd4e8aa1d2018b26b3363fdc557654288c45b5
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 22 15:42:13 2010 +0300

    boe: adapt implementation to match kernel
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9cd7bf34682046bd807cb7af7ad2c2225ef4c8c5
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 22 08:21:09 2010 +0300

    sdp: BUG1923 - fix support for MSG_OOB
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e2dc8504e3f16438570d7af429da0a7c3bbf7ee4
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Thu Aug 19 16:25:00 2010 +0300

    sdp: remove unused variables
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4aaf2cbe1031b8f66ff8e61a060bf39ac7814750
Merge: 442a50a 5010336
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 22 14:13:23 2010 +0300

    Merge branch 'ofed_kernel_1_5' of ssh://sofa.openfabrics.org/home/ctung/scm/ofed-1.5 into ofed_kernel_1_5

commit 442a50a8ed35119a887d38f9ee1b58b8c1e5f283
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sat Aug 14 16:05:18 2010 -0500

    RDMA/nes: change state to closing after FIN
    
    When driver receives an AE for FIN receive indication, it closes the connection
    without changing the state of the connection in the hardware to closing. By
    changing the state to closing, hardware will do normal close sequence.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 42d0e154248c2b19ff1120162b0072cabca6184e
Author: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Sat Aug 14 16:05:11 2010 -0500

    RDMA/nes: double CLOSE event indication crash
    
    During a stress testing in a large cluster, multiple close event is detected
    and BUG() is hit in core. The cause is that active node gave up while waitings
    for MPA response from the peer and tried to close the connection by sending RST.
    The passive node driver receives the RST but is waiting for MPA response from
    user. When MPA accept is receives, the driver send offloads the connection and
    sends CLOSE event. The driver get an AE indicating RESET receive and also send
    CLOSE event causing BUG() to hit in the core. RESET handling and sending CLOSE
    events are fixed.
    
    Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 481b097570a37d55fe23cdc3122fd9e5584e2045
Merge: 618919e 8f04055
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 22 14:09:41 2010 +0300

    Merge branch 'ofed_1_5' of ssh://sofa.openfabrics.org/~swise/scm/ofed_kernel into ofed_kernel_1_5

commit 618919eb711b53fdda3aca2484328da2b8179449
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Wed Aug 18 16:32:15 2010 +0300

    mlx4: Extend log_mtts_per_seg range
    
    This is to allow to register more memory by consuming less MTT segments.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5010336fa51f5c5e7539145a53ceb26bd2864e4d
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Aug 16 10:32:11 2010 -0500

    RDMA/nes: add forward port for 2.6.33
    
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 5ea3ff71cf3fd64b6eadef86e1ff2e2c96f5ee3c
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 15 11:21:59 2010 +0300

    sdp: fixed for error code in sendmsg-BZCopy
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 3b4577ca1110c3c678511369b74857486c08571e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 15 11:11:03 2010 +0300

    sdp: fixed skbs-control-queue memory leak
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8e93f6e52370a755a17fe650f79468350ceae518
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 15 10:48:05 2010 +0300

    sdp: fixed device removal issues
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit fd19905010b8cfbb4b81d7c58957425f6277423f
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 15 10:40:02 2010 +0300

    sdp: added the ability to use sdpprf for any debug message
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 7cff0a4be5aee9cd763cc4b6bd8369040969029e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 15 10:17:42 2010 +0300

    sdp: fixed a deadlock when tx_timer calls sdp_reset that tries to del the timer
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit e1b4031256846a7c93019225ae6a81fba6513664
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Aug 15 10:05:40 2010 +0300

    sdp: fixed SrcAvail memory leak
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 4e35fa9fd0b408c5fa67811c1c093dcd8384c0e1
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 9 17:11:35 2010 +0300

    sdp: removed unnecessary variable 'vm_wait'
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 34b1141033c92a38c4df0e46c387409685a79e6e
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Aug 9 17:05:44 2010 +0300

    sdp: stability improvements for ZCopy
    
    - beter handling of ZCopy errors and SrcAvailCancel requests
    - fixed SrcAvailCancel sequence number handling
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8f040557c07606541e61d46e4d8dc5bdbc783b3c
Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date:   Thu Aug 12 15:26:56 2010 -0500

    RDMA/cxgb3: Add 2.6.33 backport.

--------------000603080500030702060206
Content-Type: text/csv;
 name="bugs-2010-08-04.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2010-08-04.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoyMDU2LCJt
YWpvciIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJ
WEVEIiwiU2RwIHNvY2tldHMgZG9lc24ndCBjbG9zZSBhZnRlciBhcHBsaWNhdGlvbnMgZW5k
IgoyMDU4LCJtYWpvciIsIlAxIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJS
RVNPTFZFRCIsIkZJWEVEIiwiS2VybmVsIFBhbmljIHdoZW4gcnVubmluZyBiaWRpcmVjdGlv
bmFsIG5ldHBlcmYiCjIwNzAsImNyaXRpY2FsIiwiUDMiLCJTTEVTIDExIiwidmxhZEBtZWxs
YW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJGYWlsZWQgdG8gY29tcGlsZSBPRkVE
MS41LjItUkMyIG9uIHNsZXMxMSBzcDEgLSBvcGVuLWlzY3NpIGZhaWxlZCIKMjA3MywiYmxv
Y2tlciIsIlAzIiwiUkhFTCA1IiwicGVya2luam9AY3NlLm9oaW8tc3RhdGUuZWR1IiwiUkVT
T0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LjItMjAxMDA3MDUtMDYwMCA6IE12YXBpY2gyIHJw
bSBmYWlscyB0byBpbnN0YWxsIHdpdGggb2ZlZC0xLjUuMiBwYWNrYWdlcy4iCjIwODEsIm1h
am9yIiwiUDEiLCJTTEVTIDEwIiwibWl0a29AcWxvZ2ljLmNvbSIsIlJFU09MVkVEIiwiRklY
RUQiLCJpbmZpbmlwYXRoLXBzbSBSUE0gaW5zdGFsbGF0aW9uIGZhaWxzIG9uIFNMRVMxMCBT
UDIiCjIwODIsIm1ham9yIiwiUDEiLCJSSEVMIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIs
IlJFU09MVkVEIiwiRklYRUQiLCJTRFAgbW9kdWxlIHVubG9hZHMgd2l0aCBvcnBoYW4gY291
bnQgbWVzc2FnZSIKMjA4NiwibWlub3IiLCJQMyIsIk90aGVyIiwic3dpc2VAb3BlbmdyaWRj
b21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LjItMjAxMDA3MTUt
NjAwIDogT0ZFRCBrZXJuZWwgZmFpbHMgdG8gY29tcGlsZSBmb3IgcmRtYV9rcnBpbmcgbW9k
dWxlIG9uIFJIRUw2LjAtQkVUQSg2NCBiaXQgKSAmIFNMRVMxMS1TUDEtUkM0KDY0IGJpdCAp
IHBsYXRmb3JtLiI=
--------------000603080500030702060206--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
