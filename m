From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18-2-rc1 release is available
Date: Tue, 19 Apr 2016 15:00:16 +0300
Message-ID: <57161DD0.2050607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'OpenFabrics EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.18-2-rc1 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.18-2/OFED-3.18-2-rc1.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18

Release notes:
https://www.openfabrics.org/downloads/OFED/release_notes/OFED_3.18-2-rc1_release_notes

OFED-3.18-2-rc1 Main Changes from OFED 3.18-1
-------------------------------------------------------------------------------
1. Updated packages:
   - dapl-2.1.9
   - fabtests-1.3.0
   - ibacm-1.2.1
   - infinipath-psm-3.3-19_g67c0807_open
   - libcxgb4-1.3.6
   - libfabric-1.3.0
   - libocrdma-1.0.7
   - librdmacm-1.1.0
   - mstflint-4.3.0-1.49.g9b9af70
   - perftest-3.0-0.16.gb2f2e82
2. compat-rdma changes
   - xeon-phi: allow full ibscif ud mtu
   - xeon-phi: allow rdma_bind to mic0 device
   - NFSRDMA: RHEL7.2 backport
   - cxgb4: update firmware to 1.4.14.0
   - cxgb4: RHEL7.2 backports
   - cxgb4: fix up bonding.h include paths
   - IB/ipoib: Do not update neigh validity if not resolved yet
   - mlx4_en: Fixed compilation on RHEL6.6
   - makefile: Added distclean target
   - xeon-phi: mlx5_ib bug fix releated to large memory regions registration.
   - RDMA/ocrdma: ocrdma sync up patch series
   - be2net: backport fixes for RHEL 7.2
   - mlx4: Added support for RHEL7.2


Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
