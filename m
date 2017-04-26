From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 4.8-rc2 release is available
Date: Wed, 26 Apr 2017 15:46:45 +0300
Message-ID: <590096B5.3090501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-4.8-rc2 is available at:
http://openfabrics.org/downloads/OFED/ofed-4.8/OFED-4.8-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 4.8

Release notes:
https://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-rc2_release_notes

OFED-4.8-rc2 Main Changes from OFED 4.8-rc1
-------------------------------------------------------------------------------
1. compat-rdma:
- iw_cxgb4: Guard against null cm_id in dump_ep/qp
- Xeon Phi updates
- Fixes for i40iw which have been included in kernels > 4.8
- Updated 0003-add-the-ibp-client-and-server-drivers.patch

2. Updated packages:
- rdma-core v13
- libfabric-1.4.1
- fabtests-1.4.1
- libibscif-1.1.3

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
