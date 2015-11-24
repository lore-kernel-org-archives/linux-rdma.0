From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18-1 release is available
Date: Tue, 24 Nov 2015 16:12:49 +0200
Message-ID: <56547061.5040704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'OpenFabrics EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.18-1 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.18-1/OFED-3.18-1.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18-1

Release notes:
https://openfabrics.org/downloads/OFED/release_notes/OFED_3.18-1_release_notes

OFED-3.18-1 Main Changes from OFED 3.18
-------------------------------------------------------------------------------
1. Updated packages:
   - libocrdma-1.0.6
   - perftest-3.0-0.12
   - dapl-2.1.7
   - infiniband-diags-1.6.6
   - infinipath-psm-3.3-7_g05f6f14_open
   - libiwpm-1.0.3
   - libfabric-1.1.1
   - fabtests-1.1.1
   - ibacm-1.1.0
   - mstflint-4.1.0-1.45.g1d75d01

2. compat-rdma changes
   - xeon-phi: ibscif bug 2575: Allow xeon-phi support for Knights Landing
   - xeon-phi: ibscif bug 2570: correction to communitate between host 
and card
   - Added RHEL7.1 support on ppc64le

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
