From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] OFED 3.18-rc2 release is available
Date: Mon, 13 Apr 2015 19:56:12 +0300
Message-ID: <552BF52C.8040208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
OFED-3.18-rc2 is available at:
https://openfabrics.org/downloads/OFED/ofed-3.18/OFED-3.18-rc2.tgz

To get BUILD_ID run ofed_info

Please report any issues in bugzilla
http://bugs.openfabrics.org/bugzilla/ for OFED 3.18

Release notes: https://www.openfabrics.org/downloads/OFED/release_notes/OFED_3.18-rc2_release_notes

OFED-3.18-rc2 Main Changes from OFED 3.18-rc1
-------------------------------------------------------------------------------
1. Updated packages:
  - dapl-2.1.4
  - libfabric-1.0.0rc4
  - librdmacm-1.0.20

2. Added RHEL7.1 support

3. compat-rdma changes
  - IB/uverbs: Prevent integer overflow in ib_umem_get address arithmetic
  - NFSoRDMA: backport for RHEL 6.5 and 6.6
  - Fixed mlx4 backport
  - Added RHEL7.1 backport patches
  - RDMA/ocrdma: rebasing the upstream sync up patch
  - be2net-ocrdma: Fixing the RH 6.5/6 backport patch
  - be2net-ocrdma: move backport patches to the correct folder
  - Updated XEON-Phi patches
  - Updated compat-rdma.spec for XEON-Phi
  - NFS/RDMA: SLES11SP3 backport

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
