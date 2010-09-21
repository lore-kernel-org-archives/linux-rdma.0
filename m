From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED-1.5.2 GA is available
Date: Tue, 21 Sep 2010 19:00:28 +0200
Message-ID: <4C98E4AC.7040308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000604090208090104040607"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000604090208090104040607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I am pleased to announce that OFED-1.5.2 GA release is done

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5.2/release/OFED-1.5.2.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED 1.5.2

Vladimir & Tziporet

========================================================================


Release information:
--------------------
Linux Operating Systems:
         - RedHat EL4 up7        2.6.9-78.ELsmp * (last release of OFED supporting this OS)
         - RedHat EL4 up8        2.6.9-89.ELsmp * (last release of OFED supporting this OS)
         - RedHat EL5 up3        2.6.18-128.el5 * (last release of OFED supporting this OS)
         - RedHat EL5 up4        2.6.18-164.el5
         - RedHat EL5 up5        2.6.18-194.el5
         - SLES10 SP2            2.6.16.60-0.21-smp * (last release of OFED supporting this OS)
         - SLES10 SP3            2.6.16.60-0.54-smp
         - SLES11                2.6.27.19-5-default
         - SLES11 SP1            2.6.32.12-0.7-default
         - OEL 4 up7             2.6.9-78.ELsmp * (last release of OFED supporting this OS)
         - OEL 4 up8             2.6.9-89.ELsmp * (last release of OFED supporting this OS)
         - CentOS5.3             2.6.18-128.el5 * (last release of OFED supporting this OS)
         - CentOS5.4             2.6.18-164.el5
         - CentOS5.5             2.6.18-194.el5
         - Fedora Core12         2.6.31.5-127.fc12    *
         - OpenSuSE 11.2         2.6.31.5-0.1-default *
         - kernel.org            2.6.29, 2.6.30,
                                 2.6.31, 2.6.32 and 2.6.33    *

           * Minimal QA for these versions

Systems:
           * x86_64
           * x86
           * ia64
           * ppc64

Main Changes from OFED 1.5.1
============================
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

8. Bug fixes
         See attached.

Known issues:
- ib_sdp fails to be loaded on 32-bit OSes (will be fixed in OFED-1.5.2-1)



--------------000604090208090104040607
Content-Type: text/plain;
 name="OFED_release_notes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="OFED_release_notes.txt"

	    Open Fabrics Enterprise Distribution (OFED)
	               Version 1.5.2
	               Release Notes
	               September 2010


===============================================================================
Table of Contents
===============================================================================
1. Overview, which includes:
	- OFED Distribution Rev 1.5.2 Contents
	- Supported Platforms and Operating Systems
	- Supported HCA and RNIC Adapter Cards and Firmware Versions
	- Tested Switch Platforms
	- Third party Test Packages
	- OFED sources
2. Main Changes from OFED 1.4.2
3. Main Changes from OFED 1.5
4. Main Changes from OFED 1.5.1
5. Known Issues


===============================================================================
1. Overview
===============================================================================
These are the release notes of OpenFabrics Enterprise Distribution (OFED)
release 1.5.2. The OFED software package is composed of several software modules,
and is intended for use on a computer cluster constructed as an InfiniBand
subnet or iWARP network. 

Note: If you plan to upgrade the OFED package on your cluster, please upgrade
all of its nodes to this new version.


1.1 OFED 1.5.2 Contents
-----------------------
The OFED package contains the following components:
 - OpenFabrics core and ULPs:
	- IB HCA drivers (mthca, mlx4, qib, ehca)
	- iWARP RNIC driver (cxgb3, nes)
	- core
	- Upper Layer Protocols: IPoIB, SDP, SRP Initiator and target, iSER 
	  Initiator and target, RDS, uDAPL, qlgc_vnic and NFS-RDMA.
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
	- open-iscsi: open-iscsi initiator with iSER support
	- ib-bonding: Bonding driver for IPoIB interface
 - Sources of all software modules (under conditions mentioned in the modules'
   LICENSE files)
 - Documentation

Notes:
1. iSER Target and NFS-RDMA are of Beta quality.
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
	- RedHat EL4 up7	2.6.9-78.ELsmp * (last release of OFED supporting this OS)
	- RedHat EL4 up8	2.6.9-89.ELsmp * (last release of OFED supporting this OS)
	- RedHat EL5 up3	2.6.18-128.el5 * (last release of OFED supporting this OS)
	- RedHat EL5 up4	2.6.18-164.el5
	- RedHat EL5 up5 	2.6.18-194.el5
	- SLES10 SP2 		2.6.16.60-0.21-smp * (last release of OFED supporting this OS)
	- SLES10 SP3 		2.6.16.60-0.54-smp  
	- SLES11 		2.6.27.19-5-default
	- SLES11 SP1 		2.6.32.12-0.7-default
	- OEL 4 up7		2.6.9-78.ELsmp * (last release of OFED supporting this OS)
	- OEL 4 up8		2.6.9-89.ELsmp * (last release of OFED supporting this OS)
	- CentOS5.3     	2.6.18-128.el5 * (last release of OFED supporting this OS)
	- CentOS5.4     	2.6.18-164.el5
	- CentOS5.5     	2.6.18-194.el5
	- Fedora Core12 	2.6.31.5-127.fc12    *
	- OpenSuSE 11.2		2.6.31.5-0.1-default *
	- kernel.org		2.6.29, 2.6.30,
                                2.6.31, 2.6.32 and 2.6.33    *

      * Minimal QA for these versions
	
1.3 HCAs and RNICs Supported
----------------------------
This release supports IB HCAs by Mellanox Technologies, Qlogic and IBM as
well as iWARP RNICs by Chelsio Communications and Intel.

  o   Mellanox Technologies HCAs (SDR, DDR and QDR Modes are Supported):
	- InfiniHost (fw-23108 Rev 3.5.000)
	- InfiniHost III Ex (MemFree: fw-25218 Rev 5.3.000 
	                     with memory: fw-25208 Rev 4.8.200)
	- InfiniHost III Lx (fw-25204 Rev 1.2.000)
	- ConnectX IB (fw-25408 Rev 2.7.700)

	For official firmware versions please see:
	http://www.mellanox.com/content/pages.php?pg=firmware_download

  o   Qlogic HCAs:
	- QHT7140 QLogic InfiniPath SDR HTX HCA
	- QLE7140 QLogic InfiniPath SDR PCIe HCA
	- QLE7240 QLogic InfiniPath DDR x8 PCIe HCA
	- QLE7280 QLogic IniniPath DDR x16 PCIe HCA

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
	- Voltaire
	- Qlogic
	- Flextronics
	- Oracle (Sun)
	- Mellanox

1.5 Third Party Packages
------------------------
The following third party packages have been tested with OFED 1.5.2:
- Intel MPI, Version 3.2.2
- Intel MPI, Version 4.0 beta 

1.6 OFED Sources
----------------
All sources are located under git://git.openfabrics.org/
Kernel sources: git://git.openfabrics.org/ofed_1_5/linux-2.6.git ofed_kernel_1_5
User level Sources are downloaded from http://www.openfabrics.org/downloads/
as written in the BUILD_ID

The kernel sources are based on Linux 2.6.30 mainline kernel. Its patches
are included in the OFED sources directory.
For details see HOWTO.build_ofed.

===============================================================================
2. Main Changes from OFED 1.4.2
===============================================================================
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
3. Main Changes from OFED 1.5
===============================================================================
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


===============================================================================
4. Main Changes from OFED 1.5.1
===============================================================================
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

===============================================================================
5. Known Issues
===============================================================================
The following is a list of general limitations and known issues of the various
components of the OFED 1.5.2 release.

1. When upgrading from an earlier OFED version, the installation script does
   not stop the earlier OFED version prior to uninstalling it. 
   Workaround: Stop the old OFED stack (/etc/init.d/openibd stop) before 
   upgrading to OFED 1.5.2 or reboot the server after OFED installation.
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
11. iSER is supported on kernel.org 2.6.30, 2.6.31 and 2.6.32 only.
    OFED-1.5.2 will not install iSER on other kernels, and the original iSER
    module that comes with the Linux distribution will stop working due to a
    mismatch in the symbols version.
12. On SLES10 SP3, the kernel 2.6.16.60-0.54.5 should be updated to
    2.6.16.60-0.59.1 or later. The original kernel may cause kernel panic
    during '/etc/init.d/openibd restart'.

Note: See the release notes of each component for additional issues.


--------------000604090208090104040607
Content-Type: text/csv;
 name="bugs-2010-09-21.csv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bugs-2010-09-21.csv"

YnVnX2lkLCJidWdfc2V2ZXJpdHkiLCJwcmlvcml0eSIsIm9wX3N5cyIsImFzc2lnbmVkX3Rv
IiwiYnVnX3N0YXR1cyIsInJlc29sdXRpb24iLCJzaG9ydF9zaG9ydF9kZXNjIgo1OTIsIm5v
cm1hbCIsIlAzIiwiT3RoZXIiLCJqaW1AbWVsbGFub3guY29tIiwiQ0xPU0VEIiwiRklYRUQi
LCJsaWJzZHAgbWVtb3J5IGxlYWsiCjc2NywibWFqb3IiLCJQMyIsIk90aGVyIiwic3dpc2VA
b3BlbmdyaWRjb21wdXRpbmcuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIsIk5vbiBiYWNrcG9y
dCBLZXJuZWxzIHRoYXQgZG9uJ3QgYnVpbGQgaW4gZ2VuYWxsb2MgY2F1c2UgY29tcGlsZSBl
cnJvcnMgZm9yIGN4Z2IzIgo4MzMsIm5vcm1hbCIsIlAzIiwiT3RoZXIiLCJqYWNrbUBkZXYu
bWVsbGFub3guY28uaWwiLCJDTE9TRUQiLCJGSVhFRCIsIklQb2liIGhhbmdvdXQgd2hpbGUg
cnVubmluZyBzZHAgd2l0aCBtdWx0aXBsZSIKOTc3LCJub3JtYWwiLCJQMyIsIkFsbCIsImpp
bUBtZWxsYW5veC5jb20iLCJDTE9TRUQiLCJGSVhFRCIsImJpbmRpbmcgMiBzb2NrZXRzIHRv
IHRoZSBzYW1lIGFkZHJlc3MgZmFpbHMgd2l0aCB0aGUgd3JvbmcgZXJybm8iCjE0MDMsIm1p
bm9yIiwiUDMiLCJSSEVMIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
RklYRUQiLCJiYWQgc29ja19wdXQoUkVTRVQpIHdoaWxlIGFib3J0aW5nICBwb2x5Z3JhcGgi
CjE0MjIsIm5vcm1hbCIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNP
TFZFRCIsIkZJWEVEIiwiUnVubmluZyBuZXRfcGVyZiBhZnRlciBvdGhlciBTRFAgdGVzdHMg
cmVzdWx0cyBpbiBCYWRuZXNzIGluIHNkcF9yZXNldF9zayBhbmQgc2RwX2Rlc3Ryb3lfc2si
CjE0MjcsIm5vcm1hbCIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJDTE9T
RUQiLCJGSVhFRCIsInJ1bm5pbmcgbmV0cGVyZiBvbiBwcGM2NCwgcmVzdWx0cyBpbiBwcmVs
b2FkIGVycm9yIGFuZCBjYXVzZXMgdGhlIGNsaWVudCBtYWNoaW5lIHRvIGhhbmciCjE1MDIs
Im5vcm1hbCIsIlAzIiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIs
IkZJWEVEIiwiMi42LjE2LjQ2LTAuMTItU0xFUlQtMTAtMTU6IHNjaGVkdWxpbmcgd2hpbGUg
YXRvbWljIgoxNjEyLCJub3JtYWwiLCJQMyIsIlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94LmNv
LmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJraWxsaW5nIHN0cmVzc19jb25uZWN0IHRlc3QgcmVz
dWx0cyBpbiBLZXJuZWwgQlVHIG9uIHBwYzY0IG1hY2hpbmUiCjE2ODIsIm5vcm1hbCIsIlAz
IiwiT3RoZXIiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIsIkZJWEVEIiwiTG93
IHBlcmZvcm1hbmNlIG9uIG9mZWQtMS41IgoxNzI3LCJub3JtYWwiLCJQMyIsIlNMRVMgMTEi
LCJlbGRhZHpAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiU2VsZWN0IGZh
aWxzIGFmdGVyIGNvbm5lY3QgdG8gaW52YWxpZCBhZGRyZXNzIgoxNzMwLCJub3JtYWwiLCJQ
MyIsIlNMRVMgMTEiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQi
LCJnZXRzb2Nrb3B0IHJlcG9ydHMgZXJyb3IgYWZ0ZXIgcmVjdiB3YXMgc3VjY2VlZCBhbmQg
dGhlIGNsaWVudCBzb2NrZXQgd2FzIGNsb3NlZC4iCjE4NDcsIm5vcm1hbCIsIlAzIiwiQWxs
IiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiemNvcHkgc2Vu
ZCB3aXRoIGlvdmxlbiA+IDEgaXMgbm90IHN1cHBvcnRlZCIKMTg3Miwibm9ybWFsIiwiUDMi
LCJBbGwiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJmYWls
ZWQgdG8gc2VuZCBwYWNrZXRzIGxlc3MgdGhhbiA0MDgwIGJ5dGUgYnkgemNvcHkiCjE4ODgs
Im5vcm1hbCIsIlAyIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIs
IkZJWEVEIiwidGhlIHNlcnZlciBzdWNjZWVkIHRvIHNlbmQgcGFja2V0cyBhZnRlciBmaWxs
aW5nIGNsaWVudCdzIGJ1ZmZlcnMuIgoxOTA2LCJub3JtYWwiLCJQMyIsIk90aGVyIiwiYW1p
cnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiQ3Jhc2ggd2hpbGUgcnVu
bmluZyBpcGVyZiIKMTkwOSwibm9ybWFsIiwiUDMiLCJBbGwiLCJhbWlydkBtZWxsYW5veC5j
by5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJFbmFibGUgYSB0cml2aWFsIHdheSB0byBpbmNs
dWRlIHNkcF9zb2NrZXQuaCIKMTkyMywibm9ybWFsIiwiUDQiLCJBbGwiLCJhbWlydkBtZWxs
YW5veC5jby5pbCIsIlJFU09MVkVEIiwiRklYRUQiLCJTZW5kICYgcmVjZWl2ZSBvdXQtb2Yt
YmFuZCBkYXRhIGZhaWxlZCIKMTk1OCwibm9ybWFsIiwiUDMiLCJPdGhlciIsInN3aXNlQG9w
ZW5ncmlkY29tcHV0aW5nLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJbT0ZFRC0xLjUuMV0g
LSBVbmFibGUgdG8gcmVjb21waWxlIE9GQSBrZXJuZWwgLTEuNS4xIGFmdGVyIGFwcGx5aW5n
IGtycGluZyBwYXRjaCAgb24gMi42LjMyIGtlcm5lbCIKMTk2NSwibWFqb3IiLCJQMyIsIlJI
RUwgNSIsInlldmdlbnlwQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIkJv
bmRpbmcgbWx4NF9lbjogcGluZyBkb2VzIG5vdCByZXN1bWUgYWZ0ZXIgZmFpbG92ZXIgYmV0
d2VlbiAxMEcgcG9ydHMiCjE5NzcsIm5vcm1hbCIsIlAzIiwiUkhFTCA0IiwiYW1pcnZAbWVs
bGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiU0RQIG1lbW9yeSBsZWFrIgoxOTg0
LCJub3JtYWwiLCJQMyIsIkFsbCIsImVsZGFkekBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVE
IiwiRklYRUQiLCJCdWcgaW4gYWNjZXB0KCkiCjE5ODgsIm1ham9yIiwiUDIiLCJBbGwiLCJz
d2lzZUBvcGVuZ3JpZGNvbXB1dGluZy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiW09GRUQt
MS41LjEtcmM0XSAtIFNvZnRpcnEgc2VlbiBvbiBvbmUgb2YgdGhlIG5vZGVzIGFmdGVyIH40
OCBob3VycyB3aGlsZSBydW5uaW5nIDIgaW5zdGFuY2VzIGVhY2ggb2YgSU1CLU1QSTErIE9T
VStQcmVzdGEgdGVzdCB0b2dldGhlciBvbiA2NCBiaXQgcGxhdGZvcm1zIgoxOTk5LCJub3Jt
YWwiLCJQMyIsIk90aGVyIiwiZWxkYWR6QG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJG
SVhFRCIsImliX21vZGlmeV9jcSBpcyBjYWxsZWQgYWZ0ZXIgc29ja2V0IGlzIGNsb3NlZCIK
MjAxNSwibm9ybWFsIiwiUDMiLCJPdGhlciIsImFuZHkuZ3JvdmVyQG9yYWNsZS5jb20iLCJS
RVNPTFZFRCIsIkZJWEVEIiwicmRzLXN0cmVzcyBpbnRlcm1pdHRlbnRseSBmYWlscyB0byBj
b25uZWN0IHdpdGggRUFERFJOT1RBVkFJTCIKMjAxNywibm9ybWFsIiwiUDMiLCJSSEVMIDQi
LCJlbGRhZHpAbWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwic29fZXJyb3Jf
dGVzdCAgY2FzZSAxMCBjYXVzZXMgZXJyb3JzIGluIC92YXIvbG9nL21lc3NhZ2VzIgoyMDIx
LCJub3JtYWwiLCJQMyIsIk90aGVyIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNPTFZF
RCIsIkZJWEVEIiwiS2VybmVsIGNyYXNoIGR1ZSB0byBzb2Z0IGxvY2t1cCB3aGlsZSBzdG9w
cGluZyBvcGVuaWJkIgoyMDI2LCJtYWpvciIsIlAyIiwiU0xFUyAxMCIsImFybGluLnIuZGF2
aXNAaW50ZWwuY29tIiwiQ0xPU0VEIiwiRklYRUQiLCJXaGF0J3MgdGhlIGN1cnJlbnQgdGFy
Z2V0IHJlbGVhc2UgZGF0ZSBmb3IgT0ZFRCAxLjUuMiA/IgoyMDI3LCJub3JtYWwiLCJQMyIs
IlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJTRFAg
bm90IHJlc3BlY3RpbmcgIyBTR0VzIGFzIHJlcG9ydGVkIGZyb20gSFciCjIwMzUsIm5vcm1h
bCIsIlAzIiwiQ2VudE9TIDUiLCJhbWlydkBtZWxsYW5veC5jby5pbCIsIlJFU09MVkVEIiwi
RklYRUQiLCJJbnRlcm1pdHRlbnQgZmFicmljIGVycm9ycyB0cmlnZ2VycyBidWdzIGluIFNE
UCB3L3plcm8tY29weSBlbmFibGVkIgoyMDM4LCJtYWpvciIsIlAzIiwiQWxsIiwiYW1pcnZA
bWVsbGFub3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiUnVubmluZyAzIGluc3RhbmNl
cyBvZiB0dGNwIGJlbmNobWFyayBvbiBQUEM2NCBtYWNoaW5lcywgcmVzdWx0cyBpbiBjbGll
bnQgbWFjaGluZSBoYW5nIgoyMDQwLCJtYWpvciIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFu
b3guY28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiUnVubmluZyAyIGluc3RhbmNlcyBvZiB0
dGNwIGJlbmNobWFyayBvbiBQUEM2NCBtYWNoaW5lcywgcmVzdWx0cyBpbiBjbGllbnQgbWFj
aGluZSBoYW5nIgoyMDQxLCJub3JtYWwiLCJQMyIsIk90aGVyIiwiamVyZW15LmJyb3duQHFs
b2dpYy5jb20iLCJSRVNPTFZFRCIsIkZJWEVEIiwiUUlCIGNvbXBpbGF0aW9uIGZhaWxzIG9u
IFJIRUw1LjUiCjIwNDMsIm5vcm1hbCIsIlA0IiwiUkhFTCA1IiwiZWxpQG1lbGxhbm94LmNv
LmlsIiwiQ0xPU0VEIiwiRklYRUQiLCJPRkVEIDEuNS4xIGNyYXNoZXMgYWZ0ZXIgcnVubmlu
ZyBNY2FzdCBvdmVyIFJvQ0UgKGNhdXNlZCBieSBzZW5kX2xhdCBiZW5jaG1hcmspIgoyMDQ0
LCJibG9ja2VyIiwiUDMiLCJPdGhlciIsImphY2ttQG1lbGxhbm94LmNvLmlsIiwiQ0xPU0VE
IiwiRklYRUQiLCJvZmFfa2VybmVsIGRvZXNuJ3QgYnVpbGQgb24gUkhFTCA2IGR1ZSB0byBz
cGVjIGZpbGUgcHJvYmxlbSAocGF0Y2ggaW5jbHVkZWQpIgoyMDQ5LCJjcml0aWNhbCIsIlAx
IiwiUkhFTCA1IiwiYXJsaW4uci5kYXZpc0BpbnRlbC5jb20iLCJSRVNPTFZFRCIsIkZJWEVE
IiwiTVBJIGFwcGxpY2F0aW9ucyB0aGF0IHVzZSBmb3JrKCkgaGFuZyIKMjA1Miwibm9ybWFs
IiwiUDMiLCJPdGhlciIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhF
RCIsIlZlcnkgaGlnaCBsYXRlbmN5IHdpdGggbmV0cGVyZiBTRFAgd2l0aCBtc2cgc2l6ZSA2
NWsiCjIwNTMsImJsb2NrZXIiLCJQMSIsIlNMRVMgMTAiLCJ2bGFkQG1lbGxhbm94LmNvLmls
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIkZNT0RFX0VYRUMgcmVkZWZpbmVkIgoyMDU0LCJjcml0
aWNhbCIsIlAzIiwiUkhFTCA0IiwidmxhZEBtZWxsYW5veC5jby5pbCIsIkNMT1NFRCIsIkZJ
WEVEIiwiQ29tcGlsYXRpb24gb2YgT0ZFRCAxLjUuMiByYzEgZmFpbGVkIG9uIFJINCB1cCA3
IgoyMDU2LCJtYWpvciIsIlAzIiwiQWxsIiwiYW1pcnZAbWVsbGFub3guY28uaWwiLCJSRVNP
TFZFRCIsIkZJWEVEIiwiU2RwIHNvY2tldHMgZG9lc24ndCBjbG9zZSBhZnRlciBhcHBsaWNh
dGlvbnMgZW5kIgoyMDU4LCJtYWpvciIsIlAxIiwiUkhFTCA1IiwiYW1pcnZAbWVsbGFub3gu
Y28uaWwiLCJSRVNPTFZFRCIsIkZJWEVEIiwiS2VybmVsIFBhbmljIHdoZW4gcnVubmluZyBi
aWRpcmVjdGlvbmFsIG5ldHBlcmYiCjIwNTksImNyaXRpY2FsIiwiUDMiLCJSSEVMIDUiLCJ2
bGFkQG1lbGxhbm94LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIkNvbXBpbGF0aW9uIG9u
IE9GRUQgMS41LjItcmMxIGZhaWxlZCBvbiBSSDUgdXA1IChBbGwgcGFja2FnZXMpIgoyMDYz
LCJtYWpvciIsIlAzIiwiQWxsIiwieWV2Z2VueXBAbWVsbGFub3guY28uaWwiLCJWRVJJRklF
RCIsIkZJWEVEIiwibWx4NF9lbjogV2hlbiBkaXNhYmxpbmcgYm90aCBuaWMgcG9ydHMsIGFu
ZCBlbmFibGUgb25lIC0gdGhlIGxpbmsgaXMgb3NjaWxsYXRlIgoyMDY4LCJub3JtYWwiLCJQ
MyIsIk90aGVyIiwiYW5keS5ncm92ZXJAb3JhY2xlLmNvbSIsIlJFU09MVkVEIiwiRklYRUQi
LCJyZHMtc3RyZXNzIHZlcnNpb24gMS41IGlzIG1pc3NpbmcgZGF0YSBvbiB0aGUgYXZlcmFn
ZXMgbGluZSIKMjA3MCwiY3JpdGljYWwiLCJQMyIsIlNMRVMgMTEiLCJ2bGFkQG1lbGxhbm94
LmNvLmlsIiwiVkVSSUZJRUQiLCJGSVhFRCIsIkZhaWxlZCB0byBjb21waWxlIE9GRUQxLjUu
Mi1SQzIgb24gc2xlczExIHNwMSAtIG9wZW4taXNjc2kgZmFpbGVkIgoyMDczLCJibG9ja2Vy
IiwiUDMiLCJSSEVMIDUiLCJwZXJraW5qb0Bjc2Uub2hpby1zdGF0ZS5lZHUiLCJSRVNPTFZF
RCIsIkZJWEVEIiwiT0ZFRC0xLjUuMi0yMDEwMDcwNS0wNjAwIDogTXZhcGljaDIgcnBtIGZh
aWxzIHRvIGluc3RhbGwgd2l0aCBvZmVkLTEuNS4yIHBhY2thZ2VzLiIKMjA4MSwibWFqb3Ii
LCJQMSIsIlNMRVMgMTAiLCJtaXRrb0BxbG9naWMuY29tIiwiUkVTT0xWRUQiLCJGSVhFRCIs
ImluZmluaXBhdGgtcHNtIFJQTSBpbnN0YWxsYXRpb24gZmFpbHMgb24gU0xFUzEwIFNQMiIK
MjA4MiwibWFqb3IiLCJQMSIsIlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIlNEUCBtb2R1bGUgdW5sb2FkcyB3aXRoIG9ycGhhbiBjb3VudCBt
ZXNzYWdlIgoyMDg1LCJub3JtYWwiLCJQMyIsIk90aGVyIiwicGVya2luam9AY3NlLm9oaW8t
c3RhdGUuZWR1IiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LjItMjAxMDA3MTEtMDYw
MC0gTVZBUElDSDIgbXBpICBub3QgaW5zdGFsbGluZyBhbG9uZyB3aXRoIE9GRUQgcGFja2Fn
ZXMgaW4gU0xFUzExLVNQMS1SQzQoNjQgYml0KSAmIFJIRUw2LjAtQmV0YSg2NCBiaXQpLiIK
MjA4NiwibWlub3IiLCJQMyIsIk90aGVyIiwic3dpc2VAb3BlbmdyaWRjb21wdXRpbmcuY29t
IiwiUkVTT0xWRUQiLCJGSVhFRCIsIk9GRUQtMS41LjItMjAxMDA3MTUtNjAwIDogT0ZFRCBr
ZXJuZWwgZmFpbHMgdG8gY29tcGlsZSBmb3IgcmRtYV9rcnBpbmcgbW9kdWxlIG9uIFJIRUw2
LjAtQkVUQSg2NCBiaXQgKSAmIFNMRVMxMS1TUDEtUkM0KDY0IGJpdCApIHBsYXRmb3JtLiIK
MjA5MCwibWFqb3IiLCJQMSIsIlJIRUwgNSIsImFtaXJ2QG1lbGxhbm94LmNvLmlsIiwiUkVT
T0xWRUQiLCJGSVhFRCIsIlNEUCBjb25uZWN0aW9uIGZhaWxzIHdpdGgga2VybmVsIGFzc2Vy
dGlvbiBlcnJyb3MiCjIwOTIsIm1ham9yIiwiUDEiLCJPdGhlciIsImFtaXJ2QG1lbGxhbm94
LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsIktlcm5lbCBQYW5pYyB1bmRlciBsb25nIHJ1
biBpcGVyZiBzdHJlc3MiCjIwOTUsIm5vcm1hbCIsIlAzIiwiQWxsIiwiYm9zQHBhdGhzY2Fs
ZS5jb20iLCJWRVJJRklFRCIsIkZJWEVEIiwiRXJyb3IgbWVzc2FnZSB3aGVuIHJlc3RhcnRp
bmcgdGhlIHN0YWNrIC0gT0ZFRCAxLjUuMiBSQzMiCjIwOTYsIm1ham9yIiwiUDMiLCJPdGhl
ciIsImlkb3NAZGV2Lm1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhFRCIsImliLXNl
bmRfKiBhbmQgaWJfd3JpdGVfKiBvbiBpYTY0IGRvZXMgbm90IHdvcmsgb24gT0ZFRDEuNS4y
IFJDMyIKMjEwMCwibm9ybWFsIiwiUDMiLCJSSEVMIDUiLCJhbWlydkBtZWxsYW5veC5jby5p
bCIsIlJFU09MVkVEIiwiRklYRUQiLCJWZXJ5IGxvdyBidyBvdmVyIFNEUCB3aXRoIG1zZyAg
aGlnaGVyIHRoZW4gNjVrIgoyMTAxLCJtYWpvciIsIlAzIiwiT3RoZXIiLCJjaGllbi50aW4u
dHVuZ0BpbnRlbC5jb20iLCJWRVJJRklFRCIsIkZJWEVEIiwiIiJpZmNvbmZpZyBldGgyIGRv
d24iIiBjb21tYW5kIGRvZXMgbm90IHJlbW92ZSBhIE5FUyBkZXZpY2UgZnJvbSBpYnZfZGV2
aW5mbyIKMjEwNCwibWFqb3IiLCJQMyIsIlNMRVMgMTEiLCJrcnp5c3p0b2Yuc3ByemFjemtv
d3NraUBpbnRlbC5jb20iLCJWRVJJRklFRCIsIkZJWEVEIiwiYm9uZGluZyBkb2Vzbid0IGRl
dGVjdCBwb3J0IGZhaWx1cmUgd2l0aCBOZXRFZmZlY3QiCjIxMDUsIm1ham9yIiwiUDMiLCJS
SEVMIDUiLCJzZWFuLmhlZnR5QGludGVsLmNvbSIsIlJFU09MVkVEIiwiRklYRUQiLCJPRkVE
LTEuNS4yLTIwMTAwODIzLTA2MDAgZmFpbHMgdG8gaW5zdGFsbCB1bmRlciBSZWRIYXQ1LjR4
ODYiCjIxMTYsIm5vcm1hbCIsIlAzIiwiT3RoZXIiLCJjaGllbi50aW4udHVuZ0BpbnRlbC5j
b20iLCJSRVNPTFZFRCIsIkZJWEVEIiwibWNyYXcgd2l0aCBwYXVzZSBmcmFtZSBkaXNhYmxl
ZCBjYXVzZSB0byBtYWNoaW5lIHRvIGh1bmciCjIxMTgsIm5vcm1hbCIsIlAzIiwiUmVkSGF0
IEZlZG9yYSBDb3JlIDUiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwiUkVTT0xWRUQiLCJGSVhF
RCIsIkZhaWxlZCB0byBidWlsZCBsaWJtbHg0IFJQTSBmb3IgT0ZFRC0xLjUuMiBvbiBSSEVM
IgoyMTI2LCJibG9ja2VyIiwiUDMiLCJSSEVMIDUiLCJ2bGFkQG1lbGxhbm94LmNvLmlsIiwi
UkVTT0xWRUQiLCJGSVhFRCIsIkZhaWxlZCB0byBidWlsZCBtcGl0ZXN0cyBSUE0gb24gUkhF
TDUuNSIKMjEyOCwibm9ybWFsIiwiUDMiLCJPdGhlciIsImVsaUBtZWxsYW5veC5jby5pbCIs
IlJFU09MVkVEIiwiRklYRUQiLCJVRCBpbmxpbmUgcGFja2V0cyB3aXRoIG1lc3NhZSBzaXpl
ID4gODg0QiBmYWlscyAoYW5kIGRvZXMgbm90IGFubm91bmNlIGZhaWx1cmUpLiI=
--------------000604090208090104040607--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
