From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 for-next 0/4] Support rq and cq record doorbell
Date: Sun, 11 Feb 2018 20:40:49 +0800
Message-ID: <1518352853-80652-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set updates to support rq and cq record doorbell
for the user space and kernel space respectively.

---
v2->v3:
1. Revised according to Jason's comments:
   1) not use BIT in uapi header
   2) aligned to 64 bits for the structures in uapi header file.
v1->v2:
1. Consider the compatibility between the kernel and userspace
   according to Jason's suggestion.
2. Revised some codes according to Leon's comments.

Yixian Liu (4):
  RDMA/hns: Support rq record doorbell for the user space
  RDMA/hns: Support cq record doorbell for the user space
  RDMA/hns: Support rq record doorbell for kernel space
  RDMA/hns: Support cq record doorbell for kernel space

 drivers/infiniband/hw/hns/Makefile          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c     |  57 +++++++-
 drivers/infiniband/hw/hns/hns_roce_db.c     | 207 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_device.h |  59 +++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  70 +++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   3 +
 drivers/infiniband/hw/hns/hns_roce_main.c   |  10 ++
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  68 ++++++++-
 include/uapi/rdma/hns-abi.h                 |  14 ++
 9 files changed, 447 insertions(+), 43 deletions(-)
 create mode 100644 drivers/infiniband/hw/hns/hns_roce_db.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
