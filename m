From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5.2 rc7 is available
Date: Thu, 16 Sep 2010 19:04:41 +0200
Message-ID: <4C924E29.8010107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070102030902040209070201"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070102030902040209070201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,
OFED 1.5.2-rc7 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc7.tgz
or
http://69.55.239.13/downloads/OFED/ofed-1.5.2/OFED-1.5.2-rc7.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  (69.55.231.178) for
OFED 1.5.2

Schedule:
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

Main changes from 1.5.2-rc6:
===========================
1. Updated packages:
	libsdp-1.1.103
	mstflint-1.4-0.6.g63179f4
	perftest-1.3.0-0.25.g5556aaa
	mvapich2-1.5.1-1
	



--------------070102030902040209070201
Content-Type: text/x-log;
 name="ofa_kernel-1.5.2-rc6_rc7.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofa_kernel-1.5.2-rc6_rc7.log"

commit 1b5e5349e813f8ea0287ce3646a2ff28f9d7bdc0
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Sep 13 15:20:28 2010 +0200

    sdp: fix keepalive timer setup for server-sockets
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 6f5def83d8d3b199d85c1440f398e222a1e5d190
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Sep 13 15:13:38 2010 +0200

    sdp: fix logarithmic histogram index
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit cfafc147f0ff446f0ecf2c37e942864a797992d7
Author: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Sep 14 17:32:20 2010 +0200

    sdp: fix compilation on ia64 and ppc
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 8370c299575e687ec46889bc0a0551c6bf9bf80f
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Mon Sep 13 17:53:59 2010 +0200

    ibdev2ntedev: fix error messages
    
    When the carrier file is available but is not readable there may be error
    messages. Fix this by redirecting stdrr to /dev/null.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 2c00793438b1ceeace105fdc170c92e9d581d4df
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Sep 12 18:24:35 2010 +0200

    sdp: Some improvements to multistream BW
    
    - Removed almost all locks in data path - using lock_sock only
    - CPU Affinity for SKB handling
    - Don't do any RX proccessing from IRQ/timer
    - recv_poll value in usec instead of msec
    
    Signed-off-by: Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 02b16a6f6f792eb174c1e55a61b1ba1251e4383a
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Sep 12 12:30:02 2010 +0200

    ibdev2netdev: Avoid failures in old kernels
    
    Some old kernels do not export link status in /sys/class/net/$eth/carrier. Add
    a check to find if the file is available before trying to read it.
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 5823b0cdcabf58d071ed085d6bf55a9d3d92c656
Author: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Sep 12 10:30:12 2010 +0200

    Add link state information
    
    Add link state information (Up/Down) to ibdev2netdev
    
    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit befc15e6df177e296d6a6df8318668832e20f9b3
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Sep 7 14:29:21 2010 -0500

    RDMA/nes: correct register write in set TX pause param
    
    Set TX pause param is writing to the wrong register
    location causing the adpater to hang.  Correct the define
    used to write the reigster.  This fixes OFED bug #2116.
    https://bugs.openfabrics.org/show_bug.cgi?id=2116
    
    Reported-by: Shiri Franchi <shirif-smomgflXvOZWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit e909d62d96ef0af8c82886eaa93e3ff3c733a51e
Merge: 15daf14 acb9804
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Sep 7 10:54:45 2010 -0500

    Merge branch 'ofed_kernel_1_5' of git://69.55.239.13/ofed_1_5/linux-2.6 into ofed_kernel_1_5

commit 15daf147c111cb7936c21defb72fc89a988d33ba
Author: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Aug 31 23:03:45 2010 -0500

    RDMA/nes: turn carrier off on ifdown
    
    This enables bonding driver to detect interface down.  This
    fixes OFED bug 2104.
    https://bugs.openfabrics.org/show_bug.cgi?id=2104
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit c85d84f7596c8b3b347040b378912835e464aadd
Author: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Aug 31 22:38:16 2010 -0500

    Merge branches 'ofed_kernel_1_5' and 'ofed_kernel_1_5' of git://git.openfabrics.org/ofed_1_5/linux-2.6 into ofed_kernel_1_5

--------------070102030902040209070201
Content-Type: text/csv;
 name="bugs-2010-09-16.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2010-09-16.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoyMDYzLCJt
YWpvciIsIlAzIiwiQWxsIiwieWV2Z2VueXBAbWVsbGFub3guY28uaWwiLCJWRVJJRklFRCIs
IkZJWEVEIiwibWx4NF9lbjogV2hlbiBkaXNhYmxpbmcgYm90aCBuaWMgcG9ydHMsIGFuZCBl
bmFibGUgb25lIC0gdGhlIGxpbmsgaXMgb3NjaWxsYXRlIgoyMDg1LCJub3JtYWwiLCJQMyIs
Ik90aGVyIiwicGVya2luam9AY3NlLm9oaW8tc3RhdGUuZWR1IiwiUkVTT0xWRUQiLCJGSVhF
RCIsIk9GRUQtMS41LjItMjAxMDA3MTEtMDYwMC0gTVZBUElDSDIgbXBpICBub3QgaW5zdGFs
bGluZyBhbG9uZyB3aXRoIE9GRUQgcGFja2FnZXMgaW4gU0xFUzExLVNQMS1SQzQoNjQgYml0
KSAmIFJIRUw2LjAtQmV0YSg2NCBiaXQpLiIKMjA5NSwibm9ybWFsIiwiUDMiLCJBbGwiLCJi
b3NAcGF0aHNjYWxlLmNvbSIsIlZFUklGSUVEIiwiRklYRUQiLCJFcnJvciBtZXNzYWdlIHdo
ZW4gcmVzdGFydGluZyB0aGUgc3RhY2sgLSBPRkVEIDEuNS4yIFJDMyIKMjA5NiwibWFqb3Ii
LCJQMyIsIk90aGVyIiwiaWRvc0BkZXYubWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJ
WEVEIiwiaWItc2VuZF8qIGFuZCBpYl93cml0ZV8qIG9uIGlhNjQgZG9lcyBub3Qgd29yayBv
biBPRkVEMS41LjIgUkMzIgoyMTE2LCJub3JtYWwiLCJQMyIsIk90aGVyIiwiY2hpZW4udGlu
LnR1bmdAaW50ZWwuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIm1jcmF3IHdpdGggcGF1c2Ug
ZnJhbWUgZGlzYWJsZWQgY2F1c2UgdG8gbWFjaGluZSB0byBodW5nIgoyMTI2LCJibG9ja2Vy
IiwiUDMiLCJSSEVMIDUiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhF
RCIsIkZhaWxlZCB0byBidWlsZCBtcGl0ZXN0cyBSUE0gb24gUkhFTDUuNSI=
--------------070102030902040209070201--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
