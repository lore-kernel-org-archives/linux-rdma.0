From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] Fix hop-limit for RoCE
Date: Sun,  3 Jan 2016 15:59:09 +0200
Message-ID: <1451829552-32337-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Previously, the hop limit of RoCE packets were set to
IPV6_DEFAULT_HOPLIMIT. This generally works, but RoCE stack needs to
follow the IP stack rules. Therefore, this patch series use
ip4_dst_hoplimit and ip6_dst_hoplimit in order to set the correct
hop limit for RoCE traffic.

The first patch refactors the name of rdma_addr_find_dmac_by_grh to
rdma_addr_find_l2_eth_by_grh while the second one does the actual
change.

Regards,
Matan

Matan Barak (2):
  IB/core: Rename rdma_addr_find_dmac_by_grh
  IB/core: Use hop-limit from IP stack for RoCE

 drivers/infiniband/core/addr.c           | 14 +++++++++++---
 drivers/infiniband/core/cm.c             |  1 +
 drivers/infiniband/core/cma.c            | 12 +++++-------
 drivers/infiniband/core/verbs.c          | 30 ++++++++++++++----------------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  7 ++++---
 include/rdma/ib_addr.h                   |  7 +++++--
 6 files changed, 40 insertions(+), 31 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
