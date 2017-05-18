From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 4.8-rc3 release is available
Date: Thu, 18 May 2017 21:01:57 +0300
Message-ID: <591DE195.50009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-4.8-rc3 is available at:
https://openfabrics.org/downloads/OFED/ofed-4.8/OFED-4.8-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 4.8

Release notes:
http://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-rc3_release_notes

OFED-4.8-rc3 Main Changes from OFED 4.8-rc2
-------------------------------------------------------------------------------
1. compat-rdma:
- iwpmd: Enable the port mapper service for iWarp providers.
- compat-rdma: Add i40iw to openibd
- Interop related fixes for iWarp drivers i40iw and nes
- configure: Fix typo
- compat: Cleanup auto-generated defines

2. Updated packages:
- libfabric-1.4.2
- fabtests-1.4.2

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
