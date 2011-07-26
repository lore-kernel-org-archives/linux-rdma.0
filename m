From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] OFED-1.5.3.2 GA is available
Date: Tue, 26 Jul 2011 07:48:55 -0700
Message-ID: <382A478CAD40FA4FB46605CF81FE39F4FD32CFDD@orsmsx507.amr.corp.intel.com>
References: <4E2DE274.8080804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E2DE274.8080804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi List,

I just noticed a small bug in the release notes. It says that the code was tested with Intel MPI 4.0 beta and 
in fact I tested it with Intel MPI 4.0.2 GA version. Sorry for the error.

woody

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Vladimir Sokolovsky
Sent: Monday, July 25, 2011 2:39 PM
To: OpenFabrics EWG
Cc: linux-rdma
Subject: [ANNOUNCE] OFED-1.5.3.2 GA is available

Hi,
I am pleased to announce that OFED-1.5.3.2 GA release is done

Notes:

The tarball is available on:
http://www.openfabrics.org/builds/ofed-1.5.3/release/OFED-1.5.3.2.tgz


To get BUILD_ID run ofed_info

Please report any issues in bugzilla http://bugs.openfabrics.org/  for
OFED 1.5.3.2

Regards,
Vladimir

========================================================================
Release information:
--------------------
Linux Operating Systems:

         - RedHat EL5 up5        2.6.18-194.el5
         - RedHat EL5 up6        2.6.18-238.el5
         - RedHat EL5 up7        2.6.18-274.el5
         - RedHat EL6            2.6.32-71.el6
         - RedHat EL6.1          2.6.32-131.0.15.el6
         - SLES10 SP3            2.6.16.60-0.54-smp
         - SLES10 SP4            2.6.16.60-0.85.1-smp
         - SLES11                2.6.27.19-5-default
         - SLES11 SP1            2.6.32.12-0.7-default
         - CentOS5.5             2.6.18-194.el5
         - OpenSuSE 11.2         2.6.31.5-0.1-default *
         - kernel.org            2.6.29 - 2.6.39    *

       * Minimal QA for these versions

CPU architectures:
          - x86_64
          - x86
          - ppc64
          - ia64

Main Changes from OFED 1.5.3.1
==============================
1. Add RHEL5.7 support
2. Add RHEL6.1 support
3. Add kernel.org 2.6.37 - 2.6.39 support
4. ib-bonding-0.9.0-43 (SLES10 SP4 support)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
