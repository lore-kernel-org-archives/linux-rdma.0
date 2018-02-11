From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 rdma-core 0/2] Support rq and cq record doorbell
Date: Sun, 11 Feb 2018 20:40:32 +0800
Message-ID: <1518352834-80200-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch-set updates to support rq record doorbell and
cq record doorbell in the user space.

---
v2->v3:
1. According to Jason's comments, init resp and cmd to zero.
v1->v2:
1. Consider the compatibility between the kernel and userspace
   according to Jason's suggestion.

Yixian Liu (2):
  libhns: Support rq record doorbell
  libhns: Support cq record doorbell

 providers/hns/CMakeLists.txt     |   1 +
 providers/hns/hns_roce_u.h       |  27 ++++++
 providers/hns/hns_roce_u_abi.h   |   8 ++
 providers/hns/hns_roce_u_db.c    | 191 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_db.h    |   5 +
 providers/hns/hns_roce_u_hw_v2.c |  15 ++-
 providers/hns/hns_roce_u_hw_v2.h |   8 ++
 providers/hns/hns_roce_u_verbs.c |  50 ++++++++--
 8 files changed, 295 insertions(+), 10 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_db.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
