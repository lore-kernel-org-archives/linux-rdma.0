From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OFED-RDMAoE-1.5 GA is available
Date: Tue, 12 Jan 2010 18:04:18 +0200
Message-ID: <20100112160418.GA29479@mtls03>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
I am pleased to announce that OFED-RDMAoE-1.5 GA release is done

Notes:

The tarball is available on:
http://www.openfabrics.org/downloads/OFED/ofed-rdmaoe-1.5/OFED-RDMAoE-1.5.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla https://bugs.openfabrics.org/  for
OFED-RDMAoE 1.5

Eli

========================================================================


Release information:
--------------------
Linux Operating Systems:
         - RedHat EL4 up7        2.6.9-78.ELsmp
         - RedHat EL4 up8        2.6.9-89.ELsmp
         - RedHat EL5 up3        2.6.18-128.el5
         - RedHat EL5 up4        2.6.18-164.el5
         - SLES10 SP2            2.6.16.60-0.21-smp
         - SLES10 SP3            2.6.16.60-0.54-smp
         - SLES11                2.6.27.19-5-default
         - OEL 4 up7             2.6.9-78.ELsmp
         - OEL 4 up8             2.6.9-89.ELsmp
         - CentOS5.3             2.6.18-128.el5
         - CentOS5.4             2.6.18-164.el5
         - Fedora Core12         2.6.31.5-127.fc12    *
         - OpenSuSE 11.2         2.6.31.5-0.1-default *
         - kernel.org            2.6.29, 2.6.30,
                                 2.6.31 and 2.6.32    *

        * Minimal QA for these versions

Systems:
        * x86_64
        * x86
        * ia64
        * ppc64



Main Changes from OFED-1.5
============================
Added RDMAoE support.

See attached readme file for usage information.

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="RDMAOE_REAME.txt"

===============================================================================
                      OFED-1.5 with RDMAoE Support 
		       README for OFED-RDMAOE-1.5
			   
			    January 2010
===============================================================================

Contents:
=========
1. Overview
2. Software Dependencies
3. User Guidelines
4. Ported Applications
5. Firmware Requirements
6. Known Issues


1. Overview
===========

RDMAoE allows InfiniBand (IB) transport over Ethernet networks. It encapsulates
IB transport and GRH headers in Ethernet packets bearing a dedicated ether type.
While the use of GRH is optional within IB subnets, it is mandatory when using
RDMAoE. Verbs applications written over IB verbs should work seamlessly, but
they require provisioning of GRH information when creating address vectors. The
library and driver are modified to provide for mapping from GID to MAC
addresses required by the hardware.

2. Software Dependencies
========================
In order to use RDMAoE over Mellanox ConnectX(R) hardware, the mlx4_en driver
must be loaded. Please refer to MLNX_EN_README.txt for further details.


3. User Guidelines
==================
Since RDMAoE encapsulates InfiniBand traffic in Ethernet frames, the
corresponding net device must be up and running. In case of Mellanox
hardware, mlx4_en must be loaded and the corresponding interface configured.
- Make sure mlx4_en.ko is loaded
- Make sure an IP address has been configured to this interface
- Run "ibv_devinfo". There is a new field named "link_layer" which can be
  either "Ethernet" or "IB". If the value is IB, then you need to use
  connectx_port_config to change the ConnectX ports designation to eth (see
  mlx4_release_notes.txt for details)
- Configure the IP address of the interface so that the link will become
  active
- All IB verbs applications which run over IB verbs should work on RDMAoE
  links as long as they use GRH headers (that is, as long as they specify use
  of GRH in their address vector)


4. Ported Applications
======================

- ibv_*_pingpong examples have been ported too. The user must specify the GID
  of the remote peer using the new '-g' option. The GID has the same format as
  that in /sys/class/infiniband/mlx4_0/ports/1/gids/0

- Note: Care should be taken when using ibv_ud_pingpong. The default message
  size is 2K, which is likely to exceed the MTU of the RDMAoE link. Use 
  ibv_devinfo to inspect the link MTU and specify an appropriate message size

- All rdma_cm applications should work seamlessly without any change

- libsdp works without any change

- Performance tests have been ported


5. Firmware Requirements
========================

RDMAoE requires ConnectX firmware version 2.7.000 or newer. Some features
require newer, not yet released firmware versions. For example, loopback
support is available in firmware versions 2.7.624 and later.


6. Known Issues
===============

- PowerPC and ia64 architectures are not supported. x32 architectures were
  not tested.

- SRP is not supported.



--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--vtzGhvizbBRQ85DL--
