From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/6] Add rq inline and bugfixes for hns
Date: Sat, 23 Dec 2017 16:22:16 +0800
Message-ID: <1514017342-91468-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series add rq inline support for hip08 kernel
mode as well as fix some bugs for hip06 and hip08.

Lijun Ou (5):
  RDMA/hns: Add rq inline data support for hip08 RoCE
  RDMA/hns: Update the usage of sr_max and rr_max field
  RDMA/hns: Set access flags of hip08 RoCE
  RDMA/hns: Filter for zero length of sge in hip08 kernel mode
  RDMA/hns: Assign dest_qp when deregistering mr

Yixian Liu (1):
  RDMA/hns: Fix QP state judgement before sending work requests

 drivers/infiniband/hw/hns/hns_roce_device.h |  19 +++
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 176 ++++++++++++++++++++++------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  52 ++++++--
 4 files changed, 207 insertions(+), 41 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
