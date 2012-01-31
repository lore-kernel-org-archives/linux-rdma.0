From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4.1-rc2 is available
Date: Tue, 31 Jan 2012 17:32:16 +0200
Message-ID: <4F280980.2070700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080004060306090108050609"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080004060306090108050609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4.1-rc2 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4.1-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/ for OFED 1.5.4.1

Regards,
Vladimir

OFED-1.5.4.1 Main Changes from OFED 1.5.4
-----------------------------------------
1. Add kernel 3.1 support (NES and RDS are not supported on kernel 3.1)
2. NES bug fixes
3. OFA Kernel: See ofa_kernel.changelog.txt

4. Updated packages:
     perftest-1.3.0-0.58.g8f82435

     Management:
     infiniband-diags-1.5.13
     opensm-3.3.13

     MPI:
     mvapich2-1.7-6.2012svn5140

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
              - kernel.org            2.6.30 - 3.1 *

       * Minimal QA for these versions.









--------------080004060306090108050609
Content-Type: text/plain;
 name="ofa_kernel.changelog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofa_kernel.changelog.txt"

commit f18080e6ee62b25030886c37b7120eb93746e5c9
Author: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Sun Jan 29 18:16:53 2012 +0200

    IB/mlx4: fix wrong info returned when querying IBoE ports
    
    To issue port query, use the QUERY_(Ethernet)_PORT command instead of
    MAD_IFC command as the latter attempts to query the firmware IB SMA agent,
    which is irrelevant for IBoE ports. This allows to support both 10Gb/s and
    40Gb/s rates (e.g in sysfs), using QDR speed (10Gb/s) and width of 1X or 4X.
    
    Signed-off-by: Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Marcel Apfelbaum <marcela-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 91290f5b55984cc71e0ac3896d27c2e7fb5ce51f
Author: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Sun Jan 29 18:13:39 2012 +0200

    IB/core: fix wrong display of rate in sysfs
    
    commit "IB: Add new InfiniBand link speeds" introduced a bug under
    which the rate for IB SDR/4X links was displayed as 8.5Gbs
    instead of 10Gbs, fix that.
    
    Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 9aa07c16ba7164823c96e19a18c287c00248958a
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Jan 27 11:00:06 2012 -0500

    IB/qib: correct memcpy optimization
    
    qib_0700_memcpy_optimizations.patch was pushed
    with a discrepancy vs. our internal qualified
    code.
    
    This patch corrects that issu.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 5eebbdb0c6084fa9c995201d7a2dee39ff8d2188
Author: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date:   Fri Jan 27 10:59:02 2012 -0500

    IB/qib: correct rc flush panic patch
    
    This migrates the kernel.org code that was included in
    3.2.
    
    That version has significantly more test time.
    
    Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

commit 4500690e2518cb8e6ad46aea00bb0ec1a27cc8cd
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Jan 17 10:18:56 2012 -0600

    RDMA/nes: Fix for sending MPA reject frame
    
    Set a reject flag, when sending MPA reject message to inform the peer
    that the application has rejected the connection.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit b23de4ef8c30c54fb87cbdb2864b0b9f9f48d534
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Jan 6 18:19:28 2012 -0600

    RDMA/nes: Fix for fast memory registration opcode
    
    Fixes fast memory registration incorrect opcode for local
    invalidate completion.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Donald Wood <Donald.E.Wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 58b4dede2f13e638903ba3775af55309a500228d
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Jan 6 18:18:30 2012 -0600

    RDMA/nes: Fix for fast memory registration length
    
    Zero high order word of fast memory registration (FMR) length field.
    FMR length field is 32 bits, so high word should always be zero.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Donald Wood <Donald.E.Wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 182092b5581c5be2fdb3debc8e4e6f5b62145679
Author: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Jan 2 17:58:38 2012 +0200

    Fix RDS backports
    
    Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

commit 4b819d5f2c764950874c417e447719e0bbcffeb6
Author: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Date:   Mon Dec 5 16:09:59 2011 -0800

    NFSRDMA: Increasing RPCRDMA_MAX_DATA_SEGS sometimes causes NFS mount to hang.
    
    Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

commit dc262fc04a2fbb234823435e76ae224f5baa6025
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Dec 7 16:05:48 2011 -0600

    RDMA/nes: Fixes for Sparse generated warnings
    
    Fix source code warnings generated by Sparse
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 19bc287a4186dbe15cb5ba07370986b14d00d5ab
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed Dec 7 16:06:32 2011 -0600

    RDMA/nes: Change for phy SFP+ clock divisor
    
    Change phy SFP+ clock divisor
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 2decbba06572d440a2e197e2031009c1a14834f9
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Dec 7 18:56:55 2011 -0600

    include linux/ip.h for ip_hdr()
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit 28884acfb71ab4e261db6bcf0cd5e5b52c8cc2a4
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Dec 7 18:56:54 2011 -0600

    mlx4_en: backport mlx4 do vlan cleanup
    
    The mlx4_en_0280_change_vlan_managing_scheme.patch conflicts with
    kernel.org commit f1b553fbe73bfad38f41269d1c7a7ce3176d9539 "mlx4: do
    vlan cleanup".  This drops the
    mlx4_en_0280_change_vlan_managing_scheme.patch and backports
    f1b553fbe73bfad38f41269d1c7a7ce3176d9539.
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit f745264b39c20dda3f91235be8b16badd616914c
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Dec 7 18:56:53 2011 -0600

    mlx4_en: drop lro and add gro support from upstream
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit d70f86bebd493e05872674d1202d2804327ea938
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Dec 7 18:56:52 2011 -0600

    checkout_files: Remove socket.h
    
    Commit 4f095a7a1e8ad90756cf2071582e74f15a00fa06 "checkout_files: add
    rds.h and socket.h" added socket.h to the list of checkout_files and it
    is unclear why.  The modules should build against socket.h provided by
    the running kernel.
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit f0b0ffc730b126e8393c1b54437d1cd14b017280
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Dec 7 18:56:51 2011 -0600

    Backport dst->neighbour access helpers from 3.1
    
    Backport upstream commits
    
    69cce1d1404968f78b177a0314f5822d5afdbbfb
    'net: Abstract dst->neighbour accesses behind helpers.'
    22cfb0bf6721bb1f865f67bc21e3c36c272faf36
    'IPoIB: Fix possible NULL dereference in ipoib_start_xmit()'
    580da35a31f91a594f3090b7a2c39b85cb051a12
    'IB: Fix RCU lockdep splats'
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit 14e0f6e203db16f1de338a8b089f957c3b2f5b17
Author: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Date:   Wed Dec 7 18:56:50 2011 -0600

    Add 3.1 kernel support
    
    Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>

commit a8761eee2639f64b1b1eebab5cdd360fffd7443d
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Dec 5 10:52:59 2011 -0600

    RDMA/nes: Fix terminate during fatal AE
    
    Fix for reset which happens right after sending a terminate message.
    Terminate timer is not deleted when the connection is closed.
    
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--------------080004060306090108050609--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
