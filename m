From: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/2] ODP performance improvements
Date: Thu, 16 Apr 2015 16:11:01 +0300
Message-ID: <1429189863-16460-1-git-send-email-guysh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset contains small changes that improve the performance of memory
map updates.

The patches reduce the execution time of ib_umem_odp_unmap_dma_pages when
invalidating 4MB of memory from 46us to 13us. This amounts to a reduction of
about 30% in the total execution time of the invalidation flow. As this flow is
called from the mmu_notifier hooks, this optimization can have a system-wide
performance impact.

v1: Apply review comment by Sagi Grimberg

Guy Shapiro (2):
  IB/core: dma map/unmap locking optimizations
  IB/core: dma unmap optimizations

 drivers/infiniband/core/umem_odp.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
