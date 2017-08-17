From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-next 0/8] mlx5 feature for 4.14
Date: Thu, 17 Aug 2017 15:52:27 +0300
Message-ID: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----------------------------------------------------------------
The mlx5 features for 4.14

1) Software paring from Nos
 * Software parsing (SWP) is a feature that can be used to instruct the
   device to stop using its internal parser and to parse packets on the
   transmit path according to offsets set for each packets.

   Through this feature, the device allows the handling of checksum and
   LSO by the hardware according to the location of IP and TCP/UDP
   headers.

2) Decouple UMR usage from the MR cache from Ilya and fix from Kamal
 * Previously, UMR (HW population of translation entries) was used
   only for MRs allocated from the MR cache.
   This resulted in slow allocations of large MRs,
   and also limited ODP (which relies on UMR) only to cached MRs.

   This series uses UMR for populating translations of any MR,
   regardless of the cache. Consequently, allocation speed of new/large
   MRs is improved considerably.

3) Add support for multi underlay QP from Yishai
 * Set underlay QPN as part of flow rule when it's applicable.

4) Enhanced multi packet WQE from Bodong
 * This feature enables sending multiple various sized packets
   using a single WQE, where each data segment in the posted WQE
   points to a separate packet.

----------------------------------------------------------------
The following changes since commit 89f4e752bf8000621770202d2e9855e187536b6d:

  Documentation: Hardware tag matching (2017-08-17 13:15:13 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-08-17-2

for you to fetch changes up to 4134c95d6b8b81c4ba1965fbb202a946abcd3ac7:

  IB/mlx5: Report mlx5 enhanced multi packet WQE capability (2017-08-17 13:15:38 +0300)

Bodong Wang (2):
      IB/mlx5: Allow posting multi packet send WQEs if hardware supports
      IB/mlx5: Report mlx5 enhanced multi packet WQE capability

Ilya Lesokhin (3):
      IB/mlx5: Enable UMR for MRs created with reg_create
      IB/mlx5: Decouple MR allocation and population flows
      IB/mlx5: Fix integer overflow when page_shift == 31

Kamal Heib (1):
      IB/mlx5: Fix memory leak in clean_mr error path

Noa Osherovich (1):
      IB/mlx5: Expose software parsing for Raw Ethernet QP

Yishai Hadas (1):
      IB/mlx5: Add support for multi underlay QP

 drivers/infiniband/hw/mlx5/main.c    |  80 ++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 121 +++++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/qp.c      |   5 ++
 include/linux/mlx5/driver.h          |   2 +-
 include/linux/mlx5/mlx5_ifc.h        |  12 ++--
 include/uapi/rdma/mlx5-abi.h         |  23 +++++++
 7 files changed, 175 insertions(+), 70 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
