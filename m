From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 0/4] Support rq record doorbell and cq record doorbell
Date: Thu, 18 Jan 2018 10:34:27 +0800
Message-ID: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set updates to support rq record doorbell and
cq record doorbell in the user space and kernel space.

Yixian Liu (4):
  RDMA/hns: Support rq record doorbell for the user space
  RDMA/hns: Support cq record doorbell for the user space
  RDMA/hns: Support rq record doorbell for kernel space
  RDMA/hns: Support cq record doorbell for kernel space

 drivers/infiniband/hw/hns/Makefile          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c     |  44 +++++-
 drivers/infiniband/hw/hns/hns_roce_db.c     | 206 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_device.h |  49 ++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  65 ++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   3 +
 drivers/infiniband/hw/hns/hns_roce_main.c   |  10 ++
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  50 ++++++-
 include/uapi/rdma/hns-abi.h                 |   1 +
 9 files changed, 390 insertions(+), 40 deletions(-)
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_db.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
