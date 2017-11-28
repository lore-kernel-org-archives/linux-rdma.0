From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 rdma-rc 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 15:10:25 +0800
Message-ID: <1511853028-35191-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobo.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set introduces three patches to fix the memory related
issues. one fixes DMA operation failure when smmu is enabled.
the other two patches fixes incorrect usage of dma API that may
cause coherency problems.

Wei Hu (Xavier) (3):
  RDMA/hns: Fix the issue of IOVA not page continuous in hip08
  RDMA/hns: Get rid of virt_to_page and vmap calls after
    dma_alloc_coherent
  RDMA/hns: Get rid of page operation after dma_alloc_coherent

 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 23 -----------------------
 drivers/infiniband/hw/hns/hns_roce_device.h |  4 +---
 drivers/infiniband/hw/hns/hns_roce_hem.c    | 25 +++++++++++++------------
 drivers/infiniband/hw/hns/hns_roce_hem.h    |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 22 +++++++++++++++-------
 5 files changed, 30 insertions(+), 45 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
