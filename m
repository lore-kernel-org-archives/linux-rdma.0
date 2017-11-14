From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 4.8-1-rc3 release is available
Date: Tue, 14 Nov 2017 18:41:54 +0200
Message-ID: <5A0B1CD2.3070902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-4.8-1-rc3 is available at:
https://openfabrics.org/downloads/OFED/ofed-4.8-1/OFED-4.8-1-rc3.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 4.8-1

Release notes:
https://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-1_rc3-release_notes

OFED-4.8-1-rc3 Main Changes from OFED-4.8-1-rc2
-------------------------------------------------------------------------------
1. compat-rdma
- bnxt_en/bnxt_re: Support ulp_shutdown hook
- bnxt_re: BZ 2655 Fix nfs client hang with a call trace on stress traffic
- bnxt_re: BZ 2654 Fix traffic failure after changing ip address
- bnxt_re: BZ 2656 fix a crash in qp error event processing
- bnxt_en: BZ 2649 Enabling DCB parameter for bnxt_en

2. Updated packages
- rdma-core stable-v15
- libfabric-1.5.2
- fabtests-1.5.2
- mstflint-4.8.0

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
