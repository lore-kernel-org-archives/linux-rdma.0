From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.4.1 is available
Date: Tue, 07 Feb 2012 18:49:51 +0200
Message-ID: <4F31562F.10504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020000010908050408020008"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020000010908050408020008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
OFED 1.5.4.1 is available.

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-1.5.4/OFED-1.5.4.1.tgz

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










--------------020000010908050408020008
Content-Type: text/plain;
 name="ofa_kernel.changelog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ofa_kernel.changelog.txt"

commit 967460824529719677d6a1d4600ec3e89a4538ab
Author: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Wed Feb 1 14:27:56 2012 +0200

    IB/mad: Return unsupported for MADs as appropriate
    
    Setup a response with appropriate error status and send
    it for the MADs that are not supported by a specific
    class/version.
    
    Signed-off-by: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit bcd990ffbe4a7558783ee693dbbabfce262c1ab1
Author: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Wed Feb 1 14:25:45 2012 +0200

    IB/mad: Add MAD error codes per IBTA spec
    
    Add appropriate MAD error codes so that they can be used
    while returning appropriate error responses.
    
    Signed-off-by: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

commit 87b9c75bea7d8a2024647b3dbc06a3b34ac93a65
Author: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Jan 31 15:17:23 2012 -0600

    RDMA/nes: Fixes for Sparse Endian related warnings
    
    Fixes for Endian Sparse Warnings introduced with the enhanced MPA patch
    
    Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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

--------------020000010908050408020008
Content-Type: text/plain;
 name="OFED_release_notes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="OFED_release_notes.txt"

	    Open Fabrics Enterprise Distribution (OFED)
	               Version 1.5.4.1
	               Release Notes
	               January 2012


===============================================================================
Table of Contents
===============================================================================
1. Overview, which includes:
	- OFED Distribution Rev 1.5.4.1 Contents
	- Supported Platforms and Operating Systems
	- Supported HCA and RNIC Adapter Cards and Firmware Versions
	- Tested Switch Platforms
	- Third party Test Packages
	- OFED sources
2. Change log
3. Known Issues


===============================================================================
1. Overview
===============================================================================
These are the release notes of OpenFabrics Enterprise Distribution (OFED)
release 1.5.4.1. The OFED software package is composed of several software modules,
and is intended for use on a computer cluster constructed as an InfiniBand
subnet or iWARP network. 

Note: If you plan to upgrade the OFED package on your cluster, please upgrade
all of its nodes to this new version.


1.1 OFED 1.5.4.1 Contents
-----------------------
The OFED package contains the following components:
 - OpenFabrics core and ULPs:
	- IB HCA drivers (mthca, mlx4, qib, ehca)
	- iWARP RNIC driver (cxgb3, cxgb4, nes)
	- core
	- Upper Layer Protocols: IPoIB, SDP, SRP Initiator and target, iSER 
	  Initiator and target, RDS, uDAPL, qlgc_vnic and NFS-RDMA*.
 - OpenFabrics utilities:
	- OpenSM (OSM): InfiniBand Subnet Manager
	- Diagnostic tools
	- Performance tests
 - MPI:
	- OSU MPI stack supporting the InfiniBand and iWARP interface
	- Open MPI stack supporting the InfiniBand and iWARP interface
	- OSU MVAPICH2 stack supporting the InfiniBand and iWARP interface
	- MPI benchmark tests (OSU benchmarks, Intel MPI benchmarks, Presta)
 - Extra packages:
	- ib-bonding: Bonding driver for IPoIB interface
	- infinipath-psm: Performance-Scaled Messaging API, an accelerated 
	  interface to QLogic HCAs
 - Sources of all software modules (under conditions mentioned in the modules'
   LICENSE files)
 - Documentation

Notes:
1. NFS-RDMA are of Beta quality.
2. All other OFED components are of production quality.
3. See release notes for each package in the docs directory.
4. Any Topspin copyright belongs to Cisco Systems, Inc.

1.2 Supported Platforms and Operating Systems
---------------------------------------------
  o   CPU architectures:
	- x86_64
	- x86
	- ppc64
	- ia64
	
  o   Linux Operating Systems:
	- RedHat EL5 up6	2.6.18-238.el5
	- RedHat EL5 up7	2.6.18-274.el5
	- RedHat EL6		2.6.32-71.el6
	- RedHat EL6.1		2.6.32-131.0.15.el6
	- RedHat EL6.2 		2.6.32-220.el6
	- SLES10 SP4 		2.6.16.60-0.85.1-smp  
	- SLES11 		2.6.27.19-5-default
	- SLES11 SP1 		2.6.32.12-0.7-default
	- Scientific Linux 6.1	2.6.32-131.0.15.el6
	- kernel.org		2.6.30 - 3.1    *

      * Minimal QA for these versions.
	
1.3 HCAs and RNICs Supported
----------------------------
This release supports IB HCAs by Mellanox Technologies, Qlogic and IBM as
well as iWARP RNICs by Chelsio Communications and Intel.

  o   Mellanox Technologies HCAs (SDR, DDR and QDR Modes are Supported):
	- ConnectX(R) and ConnectX EN (fw-25408 Rev 2.9.1000)
	- ConnectX-2 (fw-ConnectX2 Rev 2.9.1000)
	- ConnectX-2 EN (fw-ConnectX2 Rev 2.9.1000)
	- ConnectX-3 (fw-ConnectX3 Rev 2.10.0000) 

	For official firmware versions please see:
	http://www.mellanox.com/content/pages.php?pg=firmware_download

  o   Qlogic HCAs:
	- QLogic TrueScale DDR PCIe x8 and x16 HCAs
	- QLogic TrueScale QDR PCIe x8 Gen2 HCAs

  o   IBM HCAs:
	- GX Dual-port SDR 4x IB HCA
	- GX Dual-port SDR 12x IB HCA
	- GX Dual-port DDR 4x IB HCA
	- GX Dual-port DDR 12x IB HCA

  o   Chelsio RNICs:
	- S310/S320 10GbE Storage Accelerators
	- R310/R320 10GbE iWARP Adapters

  o   Intel RNICs:
	- NE020 10Gb iWARP Adapter


1.4 Switches Supported
----------------------
This release was tested with switches and gateways provided by the following
companies:
	- Qlogic
	- Flextronics
	- Oracle (Sun)
	- Mellanox

1.5 Third Party Packages
------------------------
The following third party packages have been tested with OFED 1.5.4.1:
- Intel MPI, Version 3.2.2
- Intel MPI, Version 4.0

1.6 OFED Sources
----------------
All sources are located under git://git.openfabrics.org/
Kernel sources: git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
User level Sources are downloaded from http://www.openfabrics.org/downloads/
as written in the BUILD_ID

The kernel sources are based on Linux 2.6.30 mainline kernel. Its patches
are included in the OFED sources directory.
For details see HOWTO.build_ofed.

The list of maintainers is available under:
http://www.openfabrics.org/downloads/MAINTAINERS

===============================================================================
2. Change log
===============================================================================
OFED-1.5.4.1 Main Changes from OFED 1.5.4
-------------------------------------------------------------------------------
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

OFED-1.5.4 Main Changes from OFED 1.5.3.2
-------------------------------------------------------------------------------
1. Add kernel 3.0 support
2. Add RHEL6.2 support
3. Add NFSRDMA to the list of packages to be installed by default on supported
   platforms
4. Add new InfiniBand link speeds: EDR/FDR/FDR10
5. OFA Kernel: See ofa_kernel.changelog.txt

6. Updated packages:
   libibverbs-1.1.4-1.24.gb89d4d7
   libmlx4-1.0.1-1.20.g6771d22
   libnes-1.1.3
   libcxgb3-1.3.1
   libcxgb4-1.2.0
   dapl-2.0.34
   ibacm-1.0.5
   librdmacm-1.0.15
   infinipath-psm-2.9-926.1005_open
   ibutils-1.5.7-0.1.g05a9d1a
   perftest-1.3.0-0.56.gd6f6093
   mstflint-1.4-1.18.g1adcfbf
   
   Management:
   libibmad-1.3.8
   infiniband-diags-1.5.12
   opensm-3.3.12
   
   MPI:
   mvapich2-1.7-5.2011svn5031

OFED-1.5.3.2 Main Changes from OFED 1.5.3.1
-------------------------------------------------------------------------------
1. Add RHEL5.7 support
2. Add RHEL6.1 support
3. Add kernel.org 2.6.37 - 2.6.39 support
4. ib-bonding-0.9.0-43 (SLES10 SP4 support)

OFED-1.5.3.1 Main Changes from OFED 1.5.3
-------------------------------------------------------------------------------
1. Fix QIB support on SLES10 SP3

OFED-1.5.3 Main Changes from OFED 1.5.2
-------------------------------------------------------------------------------
1. Updated packages:
   dapl-2.0.32
   librdmacm-1.0.14.1
   ibacm-1.0.4
   libibmad-1.3.7
   libibumad-1.3.7
   infiniband-diags-1.5.8
   opensm-3.3.9
   ibutils-1.5.7
   libibverbs-1.1.4-1.22.g7257cd3.tar.gz
   libmlx4-1.0.1-1.18.gb810a27.tar.gz
   libnes-1.1.1
   infinipath-psm-1.14
   libsdp-1.1.108-0.15.gd7fdb72
   mstflint-1.4-0.9.gc683022
   sdpnetstat-1.60-0.3.gb6e7425
   perftest-1.3.0-0.42.gf350d3d

   - MPI
     openmpi-1.4.3-1
     mvapich2-1.6-2

2. Added RHEL6 support
3. Added RHEL5.6 support
4. Improved RAW Ethernet QP support (requires ConnectX/ConnectX2 FW >= 2.8.0600)
5. NFSoRDMA was removed from the list of packages in the install script to
   prevent its installation by default.
   To force NFSoRDMA installation, add the following lines to the ofed.conf:
   nfsrdma=y
   rnfs-utils=y
   
   To get ofed.conf, run 
   # ./install.pl -p
   
   After adding the lines above to ofed.conf, to install OFED run 
   # ./install.pl -c ofed.conf

OFED-1.5.2 Main Changes from OFED 1.5.1
-------------------------------------------------------------------------------
1. Added RHEL5.5, SLES11 SP1 and kernel 2.6.33 support
2. /etc/modprobe.conf deprecated
   ib_ipoib use /etc/modprobe.d/ib_ipoib.conf
   ib_sdp use /etc/modprobe.d/ib_sdp.conf
   mlx4_en use /etc/modprobe.d/mlx4_en.conf
3. Added RAW Ethernet QP support in libibverbs
4. Added multicast support in perftest
5. Added new package: ibacm. See ibacm_release_notes.txt
6. Added new package infinipath-psm.
7. Updated packages:
        libibverbs to rev 1.1.4-0.14.gb6c138b
        libehca to rev 1.2.2-0.1.g69e1a88
        libmlx4 to rev 1.0-0.13.g4e5c43f
        libnes to rev 1.1.0
        librdmacm to rev 1.0.13
        dapl to rev 2.0.30
        compat-depl to rev 1.2.19
        libsdp to rev 1.1.103
        mstflint to rev 1.4-0.6.g63179f4
        perftest to rev 1.3.0-0.27
        rds-tools to rev 2.0.4
        Management:
            opensm to rev 3.3.7
            libibmad to rev 1.3.6
            libibumad to rev 1.3.6
            infiniband-diags to rev 1.5.7
        MPI:
            openmpi to rev 1.4.2-1
            mvapich2 to rev 1.5.1-2.p1
            mpitests to rev 3.2-923

OFED-1.5.1 Main Changes from OFED 1.5
-------------------------------------------------------------------------------
1. Added RoCEE support - see RoCEE_README.txt
2. Added enhanced atomic operations to ConnectX (kernel only).
   See mlx4_release_notes.txt.
3. Updated Open MPI to rev 1.4.1-2ofed
4. Updated MVAPICH2 to rev 1.4.1
5. Updated DAPL to rev 2.0.27
6. Updated libnes to rev 1.0.1
7. Updated librdmacm to rev 1.0.11
8. Removed tvflash RPM
9. NFS-RDMA is not supported on SLES10 SP3
10. Fixed IPv6 support and IPv4 routing corner cases for RDMA CM
11. Bug fixes

OFED-1.5 Main Changes from OFED 1.4.2
-------------------------------------------------------------------------------
Note: For details regarding the various changes,  please see the release notes
for each package in the docs directory.

    2.1 General changes
	o Kernel code based on 2.6.30
	o libraries location - all userspace libraries can be downloaded from
	  http://www.openfabrics.org/downloads/
	  See BUILD_ID for exact locations
	o Qlogic moved the low level driver from ipath to qib.

    2.2 SDP
	o Performance improvements
	o Zero copy in beta level

    2.3 uDAPL
	o New UCM provider (ofa-v2-mlx4_0-1u) with IB UD-based CM per process.
          It is more scalable than rdma_cm (cma) or socket cm (scm). 
	o Common code base with WinOF 2.1
	o Bug fixes


    2.4 perftest
	o Renamed tests:
	  ib_rdma_bw  -> rdma_bw
	  ib_rdma_lat -> rdma_lat

    2.5 Management 
	o OpenSM
	  - Support for Mesh Analysis for LASH routing algorithm
          - Reloadable OpenSM configuration (preliminary implementation)
          - Routing paths sorted balancing (for UpDown and MinHops)
          - Weighted LID matrices calculation (for UpDown, MinHop and DOR)
          - I/O nodes connectivity (for FatTree)

    2.6 MPI:
	a. OSU MVAPICH 1.2.0
	b. Open MPI 1.4
	c. OSU MVAPICH2 1.4
	d. MPI tests 3.2

    2.7 iSER:
	o Available on:
          - kernel.org: 2.6.30 and higher
          - RHEL5.4

    2.8 NFS-RDMA
	o Added support for RHEL5.4, SLES10 SP3, kernel.org 2.6.25 and 2.6.30.
	  Kernels 2.6.26 and 2.6.27 are not supported
	o NFS-RDMA is in Beta level

===============================================================================
3. Known Issues
===============================================================================
The following is a list of general limitations and known issues of the various
components of the OFED 1.5.4.1 release.

1. When upgrading from an earlier OFED version, the installation script does
   not stop the earlier OFED version prior to uninstalling it. 
   Workaround: Stop the old OFED stack (/etc/init.d/openibd stop) before 
   upgrading to OFED 1.5.3 or reboot the server after OFED installation.
2. Memory registration by the user is limited according to administrator
   setting. See "Pinning (Locking) User Memory Pages" in OFED_tips.txt for
   system configuration.
3. Fork support from kernel 2.6.12 and above is available provided
   that applications do not use threads. fork() is supported as long as the
   parent process does not run before the child exits or calls exec().
   The former can be achieved by calling wait(childpid), and the latter can be
   achieved by application specific means.  The Posix system() call is
   supported.
4. The qib driver is supported only on 64-bit platforms.
5. When installing OFED on OpenSuse or Ubuntu, use the --without-depcheck
   option of the install.pl script.
6. IPoIB: brctl utilities do not work on IPoIB interfaces. The reason for that
   is that these utilities support devices of type Ethernet only.
7.  "openibd stop" can sometime fail with the error: 
        Unloading ib_cm                                            [FAILED]
        ERROR: Module ib_cm is in use by ib_ipoib 
    Workaround: run "openibd stop" again or remove ib_ipoib aliases from 
                /etc/modprobe.d/ib_ipoib.conf.
8. When working with ISCSI over IPoIB or mlx4_en, you must disable LRO (even
   if IPoIB is set to connected mode). This is due to a bug in older kernels
   which causes a kernel panic.
9. On SLES11, and in case uninstall is failing, check the error log and remove
   the remaining RPMs manually using 'rpm -e <rpms list>'.
10. On SLES11, set allow_unsupported_modules parameter to 1 in file:
    /etc/modprobe.d/unsupported-modules. Without this the modules will not
    load.
11. Kernel 3.1 is not officially suported.

Note: See the release notes of each component for additional issues.


--------------020000010908050408020008--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
