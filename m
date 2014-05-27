From: "Rupert Dance" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.12 is available
Date: Tue, 27 May 2014 15:13:21 +0300
Message-ID: <005601cf79a5$0e713a60$2b53af20$@soft-forge.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0057_01CF79BE.33BF83D0"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-us
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_0057_01CF79BE.33BF83D0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

OFED-3.12 is available

The tarball is available at:
https://www.openfabrics.org/downloads/OFED/ofed-3.12/OFED-3.12.tgz 

To get BUILD_ID run ofed_info

Please report any issues in Bugzilla http://bugs.openfabrics.org/bugzilla/
for OFED 3.12

OFED-3.12 Main Changes from OFED 3.5-2
----------------------------------------------------------------------------
--- 
1. Based on linux-3.12 kernel

2. Add support for the OSes
   - RedHat EL6.5

3. New drivers available
   - ocrdma
   - libocrdma-1.0.2
   - mlx5
   - libmlx5-1.0.1

4. Updated packages:
   - dapl-2.0.42
   - ibsim-0.6
   - ibutils-1.5.7-0.2
   - infiniband-diags-1.6.4
   - infinipath-psm-3.2-2
   - libcxgb4-1.3.3
   - libibmad-1.3.11
   - libibumad-1.3.9
   - libipathverbs-1.2.1
   - libmlx4-1.0.5
   - libnes-1.1.4
   - librdmacm-1.0.18.1
   - mstflint-3.6.0-1.8
   - opensm-3.3.17
   - perftest-2.2-0.17
   - srptools-1.0.2

Please see the attached OFED_release_notes and the updated release notes of
each component for additional issues.

Thank you,

Rupert Dance

------=_NextPart_000_0057_01CF79BE.33BF83D0
Content-Type: text/plain;
	name="OFED_release_notes.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="OFED_release_notes.txt"

	    Open Fabrics Enterprise Distribution (OFED)=0A=
	          Version 3.12 Release Notes=0A=
	               	   May 2014=0A=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
Table of Contents=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
1. Overview, which includes:=0A=
	- OFED Distribution Rev 3.12 Contents=0A=
	- Supported Platforms and Operating Systems=0A=
	- Supported HCA and RNIC Adapter Cards and Firmware Versions=0A=
	- Tested Switch Platforms=0A=
	- Third party Test Packages=0A=
	- OFED sources=0A=
2. Change log=0A=
3. Known Issues=0A=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
1. Overview=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
These are the release notes of OpenFabrics Enterprise Distribution (OFED)=0A=
release 3.12. The OFED software package is composed of several software =
modules,=0A=
and is intended for use on a computer cluster constructed as an =
InfiniBand=0A=
Fabric, an iWARP Network or a RoCE Fabric.=0A=
=0A=
Note: If you plan to upgrade the OFED package on your cluster, please =
upgrade=0A=
all of its nodes to this new version.=0A=
=0A=
=0A=
1.1 OFED 3.12 Contents=0A=
-----------------------=0A=
The OFED package contains the following components:=0A=
 - OpenFabrics core and ULPs:=0A=
	- IB HCA drivers (mthca, mlx4, mlx5, qib, ehca)=0A=
	- iWARP RNIC driver (cxgb3, cxgb4, nes)=0A=
	- RoCE drivers (mlx4, ocrdma)=0A=
- ib core=0A=
	- Upper Layer Protocols: IPoIB, SRP Initiator and target, RDS, =0A=
	  uDAPL, qlgc_vnic and NFS-RDMA*.=0A=
 - OpenFabrics utilities:=0A=
	- OpenSM (OSM): InfiniBand Subnet Manager=0A=
	- Diagnostic tools=0A=
	- Performance tests=0A=
 - Extra packages:=0A=
	- infinipath-psm: Performance-Scaled Messaging API, an accelerated=0A=
	  interface to Intel(R) HCAs=0A=
 - Sources of all software modules (under conditions mentioned in the =
modules'=0A=
   LICENSE files)=0A=
 - Documentation=0A=
=0A=
=0A=
1.2 Supported Platforms and Operating Systems=0A=
---------------------------------------------=0A=
  o   CPU architectures:=0A=
	- x86_64=0A=
	- x86=0A=
	- ppc64=0A=
=0A=
  o   Linux Operating Systems:=0A=
	- RedHat EL6.4 		2.6.32-358.el6=0A=
	- RedHat EL6.5 		2.6.32-431.el6=0A=
	- SLES11 SP3		3.0.76-0.9.1=0A=
	- kernel.org		3.12    *=0A=
=0A=
      * Minimal QA for these versions.=0A=
=0A=
1.3 HCAs and RNICs Supported=0A=
----------------------------=0A=
This release supports IB HCAs by IBM, Intel and Mellanox Technologies, =
iWARP RNICs by Chelsio Communications and Intel and RoCE adapters by =
Emulex, IBM and Mellanox.=0A=
=0A=
InfiniBand Adapters=0A=
  o   IBM HCAs:=0A=
	- GX Dual-port SDR 4x IB HCA=0A=
	- GX Dual-port SDR 12x IB HCA=0A=
	- GX Dual-port DDR 4x IB HCA=0A=
	- GX Dual-port DDR 12x IB HCA=0A=
=0A=
  o   Intel (formerly QLogic) HCAs:=0A=
	- Intel(R) True Scale DDR PCIe x8 and x16 HCAs=0A=
	- Intel(R) True Scale QDR PCIe x8 Gen2 HCAs=0A=
=0A=
  o   Mellanox Technologies HCAs (SDR, DDR and QDR Modes are Supported):=0A=
	- ConnectX(R) and ConnectX EN (Rev 2.9.1000)=0A=
	- ConnectX=C2=AE-2 (Rev 2.9.1200 and above)=0A=
=0A=
  o   Mellanox Technologies HCAs (FDR and FDR10 Modes are Supported):=0A=
	- ConnectX=C2=AE-3 (Rev 2.31.5050 and above)=0A=
	- ConnectX=C2=AE-3 Pro (Rev 2.31.5050 and above)=0A=
=0A=
  o   Mellanox Technologies HCAs (FDR and FDR10 Modes are Supported):=0A=
	- Connect-IB=C2=AE (Rev 10.10.3000 and above)=0A=
=0A=
	For official firmware versions please see:=0A=
	http://www.mellanox.com/content/pages.php?pg=3Dfirmware_download=0A=
=0A=
iWARP Adapters=0A=
  o   Chelsio RNICs:=0A=
	- S310/S320 10GbE Storage Accelerators=0A=
	- R310/R320 10GbE iWARP Adapters=0A=
	- T4: T420-CR, T440-CR, T422-CR, T404-BT, T440-LP-CR, T420-LL-CR, =
T420-CX=0A=
	- T5: T502-BT, T580-CR, T580-LP-CR, T520-LL-CR, T520-CR, T522-CR, =
T540-CR=0A=
=0A=
  o   Intel RNICs:=0A=
	- NE020 10Gb iWARP Adapter=0A=
=0A=
RoCE Adapters=0A=
 o   Emulex - using ocrdma=0A=
	- Emulex OCe14102 2-port 10 GbE RoCE=0A=
	- Emulex OCe14401 1-port 40 GbE RoCE=0A=
=0A=
 o   IBM=0A=
	- IBM Flex System EN4132 2-port 10 GbE RoCE=0A=
	- IBM EL27 PCIe LP 2-Port 10GbE RoCE SFP+ adapter=0A=
	- IBM EC28 PCIe 2-Port 10GbE RoCE SFP+ adapter=0A=
=0A=
  o   Mellanox=0A=
	- ConnectX-2 EN (Rev 2.9.1200 and above)=0A=
	- ConnectX-3 EN (Rev 2.31.5050 and above)=0A=
=0A=
1.4 Switches Supported=0A=
----------------------=0A=
This release was tested with switches and gateways provided by the =
following=0A=
companies:=0A=
InfiniBand Switches=0A=
  o   Flextronics=0A=
	- F-X430044=0A=
  o   Intel (formerly QLogic)=0A=
	- 12200=0A=
  o   Mellanox=0A=
	- MLNX-OS=C2=AE MSX6036/SX6025 w/w MLNX-OS=C2=AE version 3.3.4304=0A=
	- Grid Director=E2=84=A2 4036 w/w Grid Director=E2=84=A2 version =
3.9.2-992=0A=
	- FabricIT=E2=84=A2 EFM IS5035 w/w FabricIT EFM version 1.1.3000=0A=
	- FabricIT=E2=84=A2 BXM MBX5020 w/w FabricIT BXM version 2.1.2000=0A=
=0A=
iWARP Switches=0A=
  o   Fujitsu=0A=
	- XG2000C 10Gb Ethernet Switch=0A=
=0A=
RoCE Switches=0A=
  o   Arista=0A=
  o   BLADE Network Technologies (BNT)=0A=
  o   Mellanox=0A=
	- SX1036=0A=
	- SX1024=0A=
	- SX1016=0A=
=0A=
1.5 Third Party Packages=0A=
------------------------=0A=
The following third party packages have been tested with OFED 3.12:=0A=
- Open MPI - 1.8=0A=
- Intel MPI 4.1.3=0A=
- MVAPICH2 =0A=
=0A=
1.6 OFED Sources=0A=
----------------=0A=
All sources are located under git://git.openfabrics.org/=0A=
=0A=
Linux:=0A=
------=0A=
URL: git://git.openfabrics.org/compat-rdma/linux-3.12.git=0A=
Branch: master=0A=
=0A=
- Linux kernel sub-tree that includes files relevant for the OFED =
project only.=0A=
  Based on v3.12. Used to shorten git clone time.=0A=
  Note: the regular Linux git tree can be used as well.=0A=
=0A=
compat:=0A=
-------=0A=
URL: git://git.openfabrics.org/compat-rdma/compat.git=0A=
Branch: ofed=0A=
=0A=
- Based on compat project (https://github.com/mcgrof/compat). The compat =
module=0A=
  provides functionality introduced in newer kernels to older kernels =
through a=0A=
  set of header files and exported symbols.=0A=
  See https://github.com/mcgrof/compat/wiki for details.=0A=
- Used to replace kernel_addons in the previous OFED kernel tree.=0A=
=0A=
compat-rdma:=0A=
------------=0A=
URL: git://git.openfabrics.org/compat-rdma/compat-rdma.git=0A=
Branch: master=0A=
=0A=
User level Sources are downloaded from =
http://www.openfabrics.org/downloads/=0A=
as written in the BUILD_ID=0A=
=0A=
The kernel sources are based on Linux 3.12 mainline kernel. Its patches=0A=
are included in the OFED sources directory.=0A=
For details see HOWTO.build_ofed.=0A=
=0A=
The list of maintainers is available under:=0A=
http://www.openfabrics.org/downloads/MAINTAINERS=0A=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
2. Change log=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
OFED-3.12-rc3 Main Changes from OFED 3.12-rc2=0A=
-------------------------------------------------------------------------=
------=0A=
1. Updated packages:=0A=
   - perftest-2.2-0.17=0A=
2. Bugs solved=0A=
=0A=
OFED-3.12-rc2 Main Changes from OFED 3.12-rc1=0A=
-------------------------------------------------------------------------=
------=0A=
1. Updated packages:=0A=
   - dapl-2.0.42=0A=
   - ibutils-1.5.7-0.2.gbd7e502.tar.gz=0A=
   - libcxgb4-1.3.3=0A=
   - mstflint-3.6.0-1.8=0A=
   - perftest-2.2-0.16.g8406133.tar.gz=0A=
=0A=
OFED-3.12-rc1 Main Changes from OFED 3.5-2=0A=
-------------------------------------------------------------------------=
------=0A=
1. Add support for the OSes=0A=
   - RedHat EL6.5=0A=
2. New drivers available=0A=
   - ocrdma=0A=
   - libocrdma-1.0.2=0A=
   - mlx5=0A=
   - libmlx5-1.0.1=0A=
3. Updated packages:=0A=
   - dapl-2.0.40=0A=
   - ibsim-0.6=0A=
   - infiniband-diags-1.6.4=0A=
   - infinipath-psm-3.2-2_ga8c3e3e_open=0A=
   - libcxgb4-1.3.2=0A=
   - libibmad-1.3.11=0A=
   - libibumad-1.3.9=0A=
   - libipathverbs-1.2.1=0A=
   - libmlx4-1.0.5=0A=
   - libnes-1.1.4=0A=
   - librdmacm-1.0.18.1=0A=
   - mstflint-3.5.0=0A=
   - opensm-3.3.17=0A=
   - perftest-2.0-0.80.g54c73c6=0A=
   - srptools-1.0.2=0A=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
3. Known Issues=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
The following is a list of general limitations and known issues of the =
various=0A=
components of the OFED 3.12-rc2 release.=0A=
=0A=
01. When upgrading from an earlier OFED version, the installation script =
does=0A=
    not stop the earlier OFED version prior to uninstalling it.=0A=
    Workaround: Stop the old OFED stack (/etc/init.d/openibd stop) before=0A=
    upgrading to OFED 3.12 or reboot the server after OFED installation.=0A=
02. Memory registration by the user is limited according to administrator=0A=
    setting. See "Pinning (Locking) User Memory Pages" in OFED_tips.txt =
for=0A=
    system configuration.=0A=
03. Fork support from kernel 2.6.12 and above is available provided=0A=
    that applications do not use threads. fork() is supported as long as =
the=0A=
    parent process does not run before the child exits or calls exec().=0A=
    The former can be achieved by calling wait(childpid), and the latter =
can be=0A=
    achieved by application specific means.  The Posix system() call is=0A=
    supported.=0A=
04. The qib driver is supported only on 64-bit platforms.=0A=
05. IPoIB: brctl utilities do not work on IPoIB interfaces. The reason =
for that=0A=
    is that these utilities support devices of type Ethernet only.=0A=
06. In case uninstall is failing, check the error log and remove=0A=
    the remaining RPMs manually using 'rpm -e <rpms list>'.=0A=
07. On SLES11.x, set allow_unsupported_modules parameter to 1 in file:=0A=
    /etc/modprobe.d/unsupported-modules. Without this the modules will =
not=0A=
    load.=0A=
08. RDS is supported only on kernel.org 3.5 and not on any distro OS.=0A=
09. There is an issue with NFSoRDMA when running on Power PC. This will =
be=0A=
    resolved in OFED 3.12-1 - see Bug 2449=0A=
10. There are known issues with iWARP using Chelsio adapters which will =
be=0A=
    resolved in OFED 3.12-1 See Bugs 2482, 2485 and 2487=0A=
11. There are some issues with NFSoRDMA and there are some pending =
patches on kernel.org. These will be=0A=
    resolved in OFED 3.12-1 - see Bugs 2489 and 2490=0A=
12. Newer SLES or RHEL patch kernels that are updates to the original =
kernel that is included in the=0A=
    original SLES or RHEL distibutions may not work with OFED-3.12. The =
list of kernels that are supported are listed in=0A=
    section 1.2.=0A=
=0A=
Note: See the release notes of each component for additional issues.=0A=
=0A=

------=_NextPart_000_0057_01CF79BE.33BF83D0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/mailman/listinfo/ewg
------=_NextPart_000_0057_01CF79BE.33BF83D0--
