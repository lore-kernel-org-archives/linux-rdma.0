From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 1.5 rc6 release is available
Date: Tue, 22 Dec 2009 18:16:34 +0200
Message-ID: <4B30F0E2.6010501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040808000902010602020006"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------040808000902010602020006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,
OFED 1.5-rc6 is available

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5/release/OFED-1.5-rc6.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5

Vladimir & Tziporet

========================================================================


Release information:
--------------------
Linux Operating Systems:
         - RedHat EL4 up7:       2.6.9-78.ELsmp
         - RedHat EL4 up8:       2.6.9-89.ELsmp
         - RedHat EL5 up3:       2.6.18-128.el5
         - RedHat EL5 up4:       2.6.18-164.el5
         - SLES10 SP2:           2.6.16.60-0.21-smp
         - SLES10 SP3:           2.6.16.60-0.54-smp
         - SLES11:               2.6.27.19-5-default
         - OEL 4 up7             2.6.9-78.ELsmp
         - OEL 4 up8             2.6.9-89.ELsmp
         - CentOS5.3             2.6.18-128.el5
         - CentOS5.4             2.6.18-164.el5
         - Fedora Core12         2.6.31.5-127.fc12   *
         - OpenSuSE 11           2.6.25.5-1.1        *
         - kernel.org:           2.6.29, 2.6.30,
                                 2.6.31 and 2.6.32   *

        * Minimal QA for these versions

Systems:
        * x86_64
        * x86
        * ia64
        * ppc64


Main changes from 1.5 rc5:
============================
1. Updated packages:

       - Management packages:
       libibumad-1.3.4_20091214.tar.gz
       libibmad-1.3.4_20091214.tar.gz
       opensm-3.3.4_20091221_033cf4c.tar.gz
       infiniband-diags-1.5.4_20091221_033cf4c.tar.gz
       ibutils-1.5.tar.gz

       - MPI packages
       mvapich-1.2.0-3567.src.rpm

2. Bug fixes
      See attached.





--------------040808000902010602020006
Content-Type: text/plain;
 name="ofed_kernel-1.5-rc5_rc6.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ofed_kernel-1.5-rc5_rc6.log"

commit 1b6ce93a1ccee8d38bc88a7114abd77dae3410be
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 22 15:22:44 2009 +0200

    Revert "mlx4_core: Added CX3 device IDs"
    
    This reverts commit 6b1c739631ecde05bc674d2351e28d93a6c7f8f4.

commit 2dbe8f24fc424a31ceea533558710c6400b42313
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Tue Dec 22 15:22:39 2009 +0200

    Revert "mlx4_en: Added device ids table"
    
    This reverts commit 6617c6af3326dae1363bcba40158e02d19e02143.

commit 8da853924c888e943787ea5646a4173df12fd809
Author: Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Mon Dec 21 16:16:49 2009 +0200

    IPoIB: Clear ipoib_neigh.dgid in ipoib_neigh_alloc()
    
    IPoIB can miss a change in destination GID under some conditions.  The
    problem is caused when ipoib_neigh->dgid contains a stale address.
    The fix is to set ipoib_neigh->dgid to zero in ipoib_neigh_alloc().
    
    This can happen when a system using bonding on its IPoIB interfaces
    has switched its active interface from interface A to B and back to A.
    The system that fails over will not correctly processes the 2nd
    address change, as described below.
    
    When an address has changed neighbor->ha is updated with the new
    address.  Each neighbor has an associated ipoib_neigh.
    ipoib_neigh->dgid also holds a copy of the remote node's hardware
    address.  When an address changes neighbor->ha is updated by the
    network layer (arp code) with the new address.  IPoIB detects this
    change in ipoib_start_xmit() by comparing neighbor->ha with
    ipoib_neigh->dgid.  The bug is that ipoib_neigh->dgid may already
    contain the new address (A) thus the change from B to A is missed by
    ipoib.  Here is the sequence of events:
    
        ipoib_neigh->dgid = A  and  neighbor->ha = A
    
    The address is switched to B (the first switch)
    
        neighbor->ha = B
    
    The change is seen in ipoib_start_xmit() -- neighbor->ha !=
    ipoib_neigh->dgid so ipoib_neigh is released, and a new one is
    allocated.
    
    The allocator may return the same chunk of memory that was just
    released, therefore ipoib_neigh->dgid still contains A at this point.
    
    ipoib_neigh->dgid should be updated in neigh_add_path(), but if the
    following conditions are true dgid is not updated:
    
            1) __path_find() returns a path
            2) path->ah is NULL
    
    The remote system now switches from address B to A, neighbor->ha is
    updated to A.
    
    Now we have again : ipoib_neigh->dgid = A  and  neighbor->ha = A
    Since the addresses are the same ipoib won't process the change in
    address.  Fix this by zeroing out the dgid field when allocating a new
    struct ipoib_neigh.
    
    Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

commit c5edf35d2baa2ba8169856be56fd6830c5946abe
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 13:07:49 2009 +0200

    kernel_addons: for fcoe RH5.3
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 9f3ae03fc7f7994ebfcfda0f614a95baf5e8bcb2
Merge: d427319... 85aba0b...
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 13:44:27 2009 +0200

    Merge branch 'ofed_kernel_1_5' of git://git.openfabrics.org/~amirv/ofed_1_5 into ofed_kernel_1_5

commit 85aba0b72f16ad16c55bae1f1c8fd5ca485a4882
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 13:23:28 2009 +0200

    sdp: fixed compilation warning
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit 84ebd9f8515b5eca679e5baa9ea460d85cc9ac09
Author: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 11:45:37 2009 +0200

    sdp: ZCopy SrcAvail payload size limit fixed + fix ZCopy rx for small packets
    
    Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

commit d4273197d3002e3ba6001e8392acdc86cd73fdbc
Author: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date:   Sun Dec 20 10:22:27 2009 +0200

    kernel_addons: for fcoe SLES11
    
    Signed-off-by: Ella Podvalny <ella-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

--------------040808000902010602020006
Content-Type: text/csv;
 name="bugs-2009-12-22.csv"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bugs-2009-12-22.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgoxODQ2LCJt
YWpvciIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJ
WEVEIiwiTWVtb3J5IGxlYWsgaW4gZXJzL2luZmluaWJhbmQvdWxwL3NkcC9zZHBfcnguYyIK
MTgwNiwibm9ybWFsIiwiUDMiLCJPdGhlciIsImphY2ttQG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIklCX0NRX1ZFQ1RPUl9MRUFTVF9BVFRBQ0hFRCBub3QgZGVmaW5l
ZCIKMTYxOCwibm9ybWFsIiwiUDMiLCJSSEVMIDUiLCJvcmVua0BkZXYubWVsbGFub3guY28u
aWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiaWJkaWFnbmV0IC1yIHNlZyBmYXVsdCIKMTg0OSwi
bWFqb3IiLCJQMSIsIk90aGVyIiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJG
SVhFRCIsIm9vcHMgd2hlbiBjb25uZWN0aW5nIHdpdGggUkRNQS1DTSBvdmVyIGEgbG9vcGJh
Y2siCjE4NTksIm5vcm1hbCIsIlAyIiwiQWxsIiwiZWxpQG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIklQT0lCIENhbiBtaXNzIGEgY2hhbmdlIGluIGRnaWQiCjE4MjMs
Im1ham9yIiwiUDIiLCJTTEVTIDExIiwidnVAbWVsbGFub3guY29tIiwiUkVTT0xWRUQiLCJG
SVhFRCIsIk9GRUQtMS41LXJjMiBvcGVuc20gZmFpbHMgdG8gZGlzY292ZXIgU1JQIGRpcmVj
dCBjb25uZWN0IHRhcmdldHMiCjE4MDIsIm1ham9yIiwiUDEiLCJTTEVTIDExIiwiZWxpQG1l
bGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJJQiBtdWx0aWNhc3QgYXR0YWNoIGNh
dXNlIGtlcm5lbCBvb3BzIChmcm9tIHVzZXIva2VybmVsKSI=
--------------040808000902010602020006--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
